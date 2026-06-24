import contextlib
from curses import window
import os
import socket
import logging
import json
from enum import Enum, auto
from typing import override
from collections import defaultdict

logger = logging.getLogger("custom.niri.socket.handler")
logging.basicConfig(
        format="%(levelname)s: %(message)s",
        level=logging.DEBUG
)

class NiriEventBase(str, Enum):
    @staticmethod
    @override
    def _generate_next_value_(name: str, start: int, count: int, last_values: list[str]) -> str:
        in_camel_case = "".join(map(str.title, name.split("_"))) 
        return in_camel_case 


class NiriEvents(NiriEventBase):
    OK = auto()
    EVENT_STREAM = auto() 
    WORKSPACES_CHANGED = auto() # contains info about the current workspaces, things like which monitor the workspace is on.
    WINDOWS_CHANGED = auto() # contains info about the windows themselves, workspace is "workspace_id"
    KEYBOARD_LAYOUTS_CHANGED = auto()
    OVERVIEW_OPENED_OR_CLOSED = auto()
    WORKSPACE_ACTIVE_WINDOW_CHANGED = auto()
    WINDOW_OPENED_OR_CHANGED = auto()
    WINDOW_FOCUS_CHANGED = auto()
    WINDOW_CLOSED = auto() # only cantains the id of the window


NIRI_SOCKET: str | None = os.getenv("NIRI_SOCKET", None)

if NIRI_SOCKET is None:
    logger.critical("NIRI_SOCKET env not defined")
    exit(1)

WORKSPACES = defaultdict(set)
WORKSPACES_TO_DISPLAY_MAPPING = defaultdict(str)

# we need the set window action because currently there is no way to get the state of the window
# so if we use MAXIMIZE_COLUMN_ACTION, a window that is already at max will get reverted
SET_WINDOW_FULL_WIDTH_ACTION = '{"Action":{"SetWindowWidth":{"id":null,"change":{"SetProportion":100.0}}}}'
MAXIMIZE_COLUMN_ACTION = '{"Action":{"MaximizeColumn":{}}}'


def send_action(action: str) -> None:
    with socket.socket(socket.AF_UNIX, socket.SOCK_STREAM) as client:
        client.connect(NIRI_SOCKET)
        client.sendall(f"{action}\n".encode())

def log_event(event, event_data) -> None:
    logger.debug(event)
    logger.debug(json.dumps(event_data, indent=2))

def process_event(json_data: dict[str, dict]) -> None:
    event_name: str
    event_data: dict | str
    event_name, event_data = next(iter(json_data.items())) 

    try:
        event = NiriEvents(event_name)
    except ValueError:
        logger.debug(f"{event_name} is currently not handled")
        return
    log_event(event, event_data)
    match event:
        case NiriEvents.WORKSPACES_CHANGED:
            for workspace in event_data.get("workspaces"):
                _id = workspace.get("id")
                monitor = workspace.get("output")
                WORKSPACES_TO_DISPLAY_MAPPING[_id] = monitor
        case NiriEvents.WINDOWS_CHANGED:
            WORKSPACES.clear()
            for window in event_data.get("windows", []):
                _id = window.get("_id")
                workspace_id = window.get("window")
                WORKSPACES[workspace_id].add(_id)
        case NiriEvents.WINDOW_OPENED_OR_CHANGED:
            window: dict = event_data.get("window")
            _id: int = window.get("id")
            workspace_id: int = window.get("workspace_id")
            
            if WORKSPACES_TO_DISPLAY_MAPPING[workspace_id] == "HDMI-A-1":
               send_action(SET_WINDOW_FULL_WIDTH_ACTION)

        case _:
            pass
logger.debug(f"Trying to connect to {NIRI_SOCKET}")
with socket.socket(socket.AF_UNIX, socket.SOCK_STREAM) as niri_socket_client:
    niri_socket_client.connect(NIRI_SOCKET)
    if (send_resp := niri_socket_client.sendall(b"\"EventStream\"\n")) is not None:
        logger.error(send_resp)

    while True:
        try:
            data = niri_socket_client.recv(1024 * 10)
            if len(data) > 0:
                with contextlib.suppress(json.JSONDecodeError):
                    data_list = data.decode().split("\n")
                    for data in data_list:
                        process_event(json.loads(data))
        except KeyboardInterrupt:
            logger.info("\nExiting....")
            break
        
