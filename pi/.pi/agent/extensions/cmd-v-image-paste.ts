/**
 * Cmd+V image paste on macOS (workaround for upstream issue #4332).
 *
 * Upstream pi binds image paste to `app.clipboard.pasteImage` = Ctrl+V. A native
 * Cmd+V never reaches pi as a keybinding: the terminal owns it and, for an
 * image-only clipboard, forwards either
 *
 *   - an exact empty bracketed paste `ESC[200~ESC[201~` (VS Code terminal, iTerm2), or
 *   - a Kitty-protocol `super+v` key event (Ghostty, Kitty, WezTerm, recent iTerm2).
 *
 * pi's editor drops empty pastes (`if (pasteContent.length > 0)`) and has no
 * super+v binding, so both signals are silently ignored. This editor subclass
 * routes them to the same `onPasteImage` handler Ctrl+V already uses, which is
 * wired to the built-in clipboard reader (native AppKit pasteboard -> temp .png ->
 * path inserted into the draft).
 *
 * Known limit: Apple Terminal.app sends no PTY event at all for image-only Cmd+V,
 * so nothing can be routed there. Ctrl+V remains the shortcut in that terminal.
 */

import { CustomEditor, type ExtensionAPI } from "@earendil-works/pi-coding-agent";
import { isKeyRepeat, matchesKey } from "@earendil-works/pi-tui";

const EMPTY_BRACKETED_PASTE = "\x1b[200~\x1b[201~";

/** True when `data` is a macOS Cmd+V delivery that should be treated as image paste. */
function isCmdVPasteSignal(data: string): boolean {
    if (process.platform !== "darwin") {
        return false;
    }
    // Exact equality is intentional: embedded or partial sequences are ordinary
    // input, and a looser match would swallow adjacent typed text.
    return data === EMPTY_BRACKETED_PASTE || matchesKey(data, "super+v");
}

class CmdVImagePasteEditor extends CustomEditor {
    handleInput(data: string): void {
        if (isCmdVPasteSignal(data)) {
            // Ghostty and friends can emit Kitty repeat events while the key is
            // held. Consume repeats so one press pastes one image.
            if (!isKeyRepeat(data)) {
                this.onPasteImage?.();
            }
            return;
        }
        super.handleInput(data);
    }
}

export default function (pi: ExtensionAPI) {
    pi.on("session_start", (_event, ctx) => {
        ctx.ui.setEditorComponent((tui, theme, keybindings) => new CmdVImagePasteEditor(tui, theme, keybindings));
    });
}
