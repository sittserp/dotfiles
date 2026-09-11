# ---------------------------------------------------------------------------
# Tracked in the dotfiles repo. Machine-specific values and anything secret
# belong in ~/.zshrc.local, which is never committed. See README.md.
# ---------------------------------------------------------------------------

# --- version managers ------------------------------------------------------
# mise replaces rbenv/nvm/pyenv/direnv: one tool for every language runtime,
# plus per-project env vars. Global defaults live in ~/.config/mise/config.toml;
# a project overrides them with its own mise.toml, .ruby-version, or .nvmrc.
# Guarded so a machine without mise yet gets a working shell, not an error.
if command -v mise >/dev/null 2>&1; then
  eval "$(mise activate zsh)"
fi

# --- path ------------------------------------------------------------------
export PATH="$PATH:/Applications/Visual Studio Code.app/Contents/Resources/app/bin"

# --- aliases ---------------------------------------------------------------
alias a="aws sso login --profile Primary"
alias vpn="open -a /Applications/FortiClient.app"
alias sc="source $HOME/.zshrc"
alias killpuma="lsof -i :3000 -t | xargs kill -9"

# Generated for envman. Do not edit.
[ -s "$HOME/.config/envman/load.sh" ] && source "$HOME/.config/envman/load.sh"

# --- local overrides (untracked: tokens, work-only settings) ---------------
[ -s "$HOME/.zshrc.local" ] && source "$HOME/.zshrc.local"
