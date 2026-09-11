# dotfiles

Personal config for macOS. The repo is checked out **in place at `~/.config`**, so
everything that naturally lives under `~/.config` (nvim, …) is tracked directly with
no linking step.

Files that live at the top of `$HOME` can't work that way, so they live under
[`home/`](home/) and are symlinked into place by [`install.sh`](install.sh).

## Layout

| Path | Links to | What it is |
| --- | --- | --- |
| `nvim/` | *(in place)* | Neovim config — packer, LSP, telescope, harpoon |
| `home/.zshrc` | `~/.zshrc` | Shell: rbenv, nvm, direnv, PATH, aliases |
| `home/.gitconfig` | `~/.gitconfig` | Git identity, aliases, `insteadOf` SSH rewrites |
| `home/.hammerspoon/init.lua` | `~/.hammerspoon/init.lua` | Hammerspoon keyboard remapping + debounce |
| `home/Library/LaunchAgents/com.local.KeyRemapping.plist` | `~/Library/LaunchAgents/…` | LaunchAgent applying the HID key remaps at login |
| `Brewfile` | — | Homebrew formulae + casks |

## Install

```
git clone git@github.com:sittserp/dotfiles.git ~/.config
cd ~/.config
./install.sh --dry-run   # see exactly what it will touch
./install.sh
brew bundle install --file Brewfile
```

`install.sh` mirrors the `home/` tree into `$HOME` as symlinks. It never deletes
anything: an existing real file is moved to `<name>.backup.<timestamp>` first, and a
symlink that already points at the right target is left alone. Re-running it is safe.

After installing, load the LaunchAgent and reload Hammerspoon's config from its menu
bar icon:

```
launchctl unload ~/Library/LaunchAgents/com.local.KeyRemapping.plist
launchctl load   ~/Library/LaunchAgents/com.local.KeyRemapping.plist
```

## Secrets and machine-specific settings

**Nothing secret goes in this repo.** Two untracked files, seeded by `install.sh` and
ignored via the `*.local` rule in `.gitignore`, hold anything that shouldn't be
committed or that differs per machine:

- `~/.zshrc.local` — sourced at the end of `.zshrc`. Tokens, work-only exports.
- `~/.gitconfig.local` — `include`d by `.gitconfig`. Work email, per-machine helpers.

Example `~/.zshrc.local`:

```sh
export GITHUB_TOKEN="…"
```

Example `~/.gitconfig.local`:

```
[user]
  email = you@work.example
```

## Refreshing the Brewfile

```
brew bundle dump --file Brewfile --force
```
