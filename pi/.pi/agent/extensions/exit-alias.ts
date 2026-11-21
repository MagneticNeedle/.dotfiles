/**
 * `/exit` as an alias for the built-in `/quit`.
 *
 * Pi has no alias mechanism for built-in slash commands, so this registers a
 * separate command that calls ctx.shutdown() (the same graceful exit /quit uses).
 */

import type { ExtensionAPI } from "@earendil-works/pi-coding-agent";

export default function (pi: ExtensionAPI) {
	pi.registerCommand("exit", {
		description: "Quit Pi (alias for /quit)",
		handler: async (_args, ctx) => {
			ctx.shutdown();
		},
	});
}
