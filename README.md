# .dotfiles
Did I ever tell you the definition of insanity?

One branch (`main`), many machines. Each top-level directory is a GNU stow
package that mirrors `$HOME`; everything machine-specific lives under
`hosts/`. No per-machine branches — every machine pulls `main`.

## Setup on a machine

```sh
git clone git@github.com:MagneticNeedle/.dotfiles.git ~/dotfiles
cd ~/dotfiles
./install.sh -n         # dry run: show what would change
./install.sh            # guesses the host; or ./install.sh <host>
```

`install.sh` stows two layers into `$HOME`:

1. the shared packages listed in `hosts/<host>/shared`
2. every package directory under `hosts/<host>/` (host-specific files)

It always stows with `--no-folding`, so directories like `~/.local/bin`
stay real directories and only individual files become symlinks. That way
installers (uv, pipx, cargo) write their binaries onto the machine, not
into this repo.

## Hosts

Hosts are named `<user>-<os>`:

| host                    | machine                  | notes                        |
|-------------------------|--------------------------|------------------------------|
| `magnetic-needle-linux` | Linux desktop            | niri, waybar, full setup     |
| `bb-linux`              | Linux, user `bb`         | 4-space nvim indent, vert monitor |
| `bb-mac`                | MacBook, user `bb`       | no niri/waybar               |
| `magnetic-needle-mac`   | Mac, user `magnetic-needle` | no niri/waybar            |

`install.sh` guesses the host as `$(id -un)-<mac|linux>`; pass the name
explicitly to override.

## How to track things

### A config every machine shares

Put it in a shared package and list that package in each host's
`shared` file. Example: `lazygit/.config/lazygit/config.yml`.

```sh
mkdir -p foo/.config/foo
mv ~/.config/foo/config.toml foo/.config/foo/
echo foo >> hosts/bb-mac/shared      # repeat for each host that wants it
./install.sh -n          # preview
./install.sh             # replaces the real file with a symlink
```

### A config only some OSes / machines use

Nothing special — a package is only stowed where it's listed. Linux-only
packages (`niri`, `waybar`, `mako`, `rofi`, `satty`, `systemd`, `openrgb`)
are simply absent from `hosts/bb-mac/shared`. A future mac-only package
(e.g. `aerospace`, `karabiner`) would be listed only there.

### A config that exists everywhere but differs per machine

Pick one, in order of preference:

1. **The tool has an include mechanism — use it.** Keep the shared part in
   the shared package and the differing part in a host package:
   - *alacritty*: each host owns `alacritty.toml` (font, size, shell,
     window) and imports the shared `base.toml` from the alacritty
     package. The importing file wins on conflicts.
   - *nvim*: shared `init.lua` ends with `pcall(require, 'host')`; a host
     package may provide `.config/nvim/lua/host.lua` (see `bb-linux`,
     which sets 4-space indent there).
   - *zsh*: each host's `.zshrc` sets its overrides (`ZSH_THEME`, `plugins`,
     `HISTFILE`), sources the shared `~/.zsh/base.zsh` from the `zsh`
     package, then adds host-only aliases/paths after it. The macs keep
     their `.zshrc` in `hosts/<name>/zsh/`; the linux hosts are identical
     to each other, so theirs lives once in the `zsh-linux` package.
   - *zellij*: layouts have no include mechanism, so the shared `dev.kdl`
     runs `ai` — a shim in the `bin` package that execs `$AI_CLI`
     (default `pi`). A host picks its CLI by exporting `AI_CLI` in its
     `.zshrc` (see `bb-mac`, which sets `claude`).
   - *git*, if ever needed: `[include] path = ~/.gitconfig.local`.

2. **The file is irreconcilably different — give each host its own.**
   niri's `config.kdl` (outputs, workspaces, absolute home paths) lives in
   `hosts/<name>/niri/.config/niri/config.kdl`; the shared `niri` package
   keeps only what's identical (scripts, bin).

Host packages layer cleanly on top of shared ones because of
`--no-folding`: both can contribute files to the same directory, e.g. a host
package can drop extra scripts into `~/.local/bin` next to the shared `bin`
package's `zj`.

### Configs a tool must read in place (not stowed)

`raycast/` is not a stow package: Raycast doesn't index script commands that
are symlinks, so its scripts can't be stowed into `$HOME`. Instead, point
Raycast at the repo directory itself — Settings → Extensions → Script
Commands → Add Directories → `~/dotfiles/raycast/scripts`.

### OS differences inside a shared file

Prefer runtime detection over forking the file:

```sh
# zsh
[[ "$OSTYPE" == darwin* ]] && eval "$(/opt/homebrew/bin/brew shellenv)"
```

```lua
-- nvim
if vim.fn.has('mac') == 1 then ... end
```

Fork into a host package only when the file would become mostly branches.

## Adding a machine

1. `mkdir hosts/<user>-<os>` (e.g. `magnetic-needle-mac`) and write its
   `shared` list (start by copying the closest existing host's).
2. Add host-specific packages under `hosts/<name>/` as needed (at minimum
   `alacritty/` if it runs alacritty).
3. Run `./install.sh` on the machine — the host name is derived from the
   username and OS, so a correctly named directory is found automatically.
4. If stow complains about existing
   files, they're the machine's old real configs — move them into the
   repo (shared or host package) and rerun.

## Gotchas

- Never let an installer target a stowed bin dir symlink; `--no-folding`
  prevents the classic failure where `uv`'s 63M binary lands in the repo.
  The `.gitignore` also blocks `uv`/`uvx`/`python3*` under any
  `.local/bin` as a backstop.
- `keeb/latest.vil` is not a stow package — it's the Vial keyboard layout,
  loaded manually.
- After changing files here, `./install.sh` is idempotent (`--restow`);
  rerun it whenever files are added or moved.
