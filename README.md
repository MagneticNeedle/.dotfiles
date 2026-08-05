# .dotfiles
Did I ever tell you the definition of insanity?

One branch (`main`), many machines. Each top-level directory is a GNU stow
package mirroring `$HOME`; machine differences live under `hosts/`.

## Setup on a machine

```sh
git clone <this repo> ~/dotfiles
cd ~/dotfiles
./install.sh            # guesses the host; or ./install.sh <host>
```

## Layout

- `alacritty/`, `zsh/`, `nvim/`, `niri/`, ... — shared stow packages.
- `hosts/<name>/packages` — which shared packages that machine stows.
- `hosts/<name>/<package>/` — host-specific stow packages layered on top,
  for files that genuinely differ per machine:
  - `alacritty.toml` is per-host (font, size, shell); it imports the shared
    `base.toml` from the alacritty package.
  - niri's `config.kdl` is per-host (outputs, workspaces, home paths).
  - nvim reads an optional `lua/host.lua` for per-host overrides.
  - the shared `zsh/.zshrc` sources `~/.zshrc.local` if present; the mac
    tracks its own `.zshrc` instead.

Hosts: `magnetic-needle` (Linux desktop), `bb-linux` (Linux, user bb),
`mac` (MacBook, user bb).

## Adding a machine

1. `mkdir hosts/<name>` and write a `packages` list.
2. Add host-specific packages next to it as needed.
3. Teach the guess in `install.sh` (or always pass the name explicitly).

`install.sh` stows with `--no-folding` so `~/.local/bin` and friends stay
real directories — installers like uv won't write binaries into this repo.
