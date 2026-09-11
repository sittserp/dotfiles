# ---------------------------------------------------------------------------
# Tracked in the dotfiles repo. Machine-specific values and anything secret
# belong in ~/.zshrc.local, which is never committed. See README.md.
# ---------------------------------------------------------------------------

# --- version managers ------------------------------------------------------
export PATH="$HOME/.rbenv/bin:$PATH"
eval "$(rbenv init -)"

export NVM_DIR="$HOME/.nvm"
[ -s "/usr/local/opt/nvm/nvm.sh" ] && . "/usr/local/opt/nvm/nvm.sh"
[ -s "/usr/local/opt/nvm/etc/bash_completion.d/nvm" ] && . "/usr/local/opt/nvm/etc/bash_completion.d/nvm"
nvm use default --silent  # activate the default node on every shell

eval "$(direnv hook zsh)"

# --- path ------------------------------------------------------------------
export PATH="$PATH:/.local/share/nvim/site/pack/packer/start/postgres_lsp"
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
