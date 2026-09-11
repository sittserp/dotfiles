# dotfiles

Personal config for macOS. The repo is checked out at **`~/dotfiles`**, and
everything in it reaches its real location as a symlink — nothing is read from the
repo path directly.

Anything under [`home/`](home/) is mirrored into `$HOME` by
[`install.sh`](install.sh), keeping its relative path: `home/.zshrc` becomes
`~/.zshrc`, and `home/.config/mise/config.toml` becomes `~/.config/mise/config.toml`.
That is the path to add new config on. `nvim/` predates the convention and is linked
to `~/.config/nvim` by hand.

## Layout

| Path | Links to | What it is |
| --- | --- | --- |
| `nvim/` | `~/.config/nvim` *(linked manually)* | Neovim config — lazy.nvim, native LSP, telescope, harpoon |
| `home/.zshrc` | `~/.zshrc` | Shell: mise activation, PATH, aliases |
| `home/.config/mise/config.toml` | `~/.config/mise/config.toml` | mise: global runtime versions + settings |
| `home/.gitconfig` | `~/.gitconfig` | Git identity, aliases, `insteadOf` SSH rewrites |
| `home/.hammerspoon/init.lua` | `~/.hammerspoon/init.lua` | Hammerspoon keyboard remapping + debounce |
| `home/Library/LaunchAgents/com.local.KeyRemapping.plist` | `~/Library/LaunchAgents/…` | LaunchAgent applying the HID key remaps at login |
| `Brewfile` | — | Homebrew formulae + casks |

## Install

```
git clone git@github.com:sittserp/dotfiles.git ~/dotfiles
cd ~/dotfiles
./install.sh --dry-run   # see exactly what it will touch
./install.sh
brew bundle install --file Brewfile
ln -s ~/dotfiles/nvim ~/.config/nvim
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

## Language runtimes (mise)

[mise](https://mise.jdx.dev) is the only runtime manager here. It replaces rbenv,
nvm, pyenv, and direnv, and `.zshrc` activates it with `mise activate zsh`.

Activation installs a shell hook, not shims on `PATH`: on every `cd`, mise resolves
which versions apply to that directory and swaps `ruby`, `node`, `python`, and `go`
accordingly. Versions come from the nearest config walking up from `$PWD`:

1. a project's `mise.toml` or `.tool-versions`
2. a project's `.ruby-version` or `.nvmrc` — only because
   `idiomatic_version_file_enable_tools` is set in the global config; mise ignores
   these files by default
3. `~/.config/mise/config.toml` (the global fallback in this repo)

Day to day:

```
mise ls                      # installed versions + which config chose each one
mise current                 # what's active in this directory, and why
mise install                 # install everything this project's config asks for
mise use ruby@4.0.2          # pin a version in ./mise.toml (project-local)
mise use -g node@24          # pin a version globally
mise outdated                # what has a newer release
mise doctor                  # diagnose activation / PATH problems
```

`mise install` with no arguments is the one to reach for in a new checkout: it reads
whatever the project pins and fetches exactly that — a prebuilt binary where one
exists for the version and platform, otherwise a source build that can take several
minutes.

Env vars per project are `[env]` in `mise.toml`, which is what removes the need for
direnv:

```toml
[env]
RAILS_ENV = "development"
```

## Neovim plugins (lazy.nvim)

Plugins are declared in [`nvim/lua/perry/lazy.lua`](nvim/lua/perry/lazy.lua) and
managed by [lazy.nvim](https://lazy.folke.io), which replaced packer (archived
upstream in Aug 2023). lazy bootstraps itself on first launch, so a fresh machine
needs no install step beyond opening `nvim`.

```
:Lazy           status UI — install, update, profile startup
:Lazy sync      make the installed set match lazy.lua, then update
:Lazy restore   roll every plugin back to lazy-lock.json
```

`nvim/lazy-lock.json` pins the exact commit of every plugin and **is committed** —
that is what makes the setup reproducible. Commit it whenever you `:Lazy sync`.

LSP uses Neovim's native `vim.lsp.config` / `vim.lsp.enable` API (0.11+), wired up in
[`nvim/after/plugin/lsp.lua`](nvim/after/plugin/lsp.lua). Servers are installed by
mason; add one to `ensure_installed` there and restart. There is deliberately no
lsp-zero: it is deprecated, and it called the removed `require('lspconfig')`
framework internally.

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
