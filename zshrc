# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"
export PATH=$PATH:$HOME/.bin
export PATH=$PATH:$HOME/.cargo/bin
export PATH=$PATH:/usr/local/go/bin
export PATH=$HOME/bin:/usr/local/bin:$PATH
export PATH="$HOME/.local/bin:$PATH" # cause python sucks
export PATH="$PATH:$(go env GOPATH)/bin"
export PATH="$HOME/.emacs.d/bin:$PATH"
export DOTNET_CLI_TELEMETRY_OPTOUT="true"
export GIT_EDITOR=nvim
export AWS_CONFIGURE_SSO_DEFAULT_SSO_START_URL=https://some-org.awsapps.com/start#/
export AWS_CONFIGURE_SSO_DEFAULT_SSO_REGION=eu-west-1

ZSH_THEME="powerlevel10k/powerlevel10k"

plugins=(git)

source $ZSH/oh-my-zsh.sh

alias speedtest="speedtest-cli --secure"
alias c="xclip -selection c"
alias ldl="lsd -l"
alias ldla="lsd -la"
alias btm="btm --color gruvbox"
alias jiramy="jira issue list -q 'project = SRE AND issuetype != Support AND assignee = currentUser() AND status != Done AND status != \"Done / Ready for release\"'"
alias jiratodo="jira issue list -sClarify --order-by priority"
alias jirasupport="jira issue list -q 'project = SRE AND issuetype = Support AND status !=  Done' --order-by created"
alias jira180="jira issue list -q 'project = SRE AND status in (Review, Done, Clarify) AND updated >= -180d AND assignee in (currentUser()) and type != Support ' --order-by updated"
alias jirac="jira issue create"
alias confnvim="cd $HOME/.config/nvim/lua/ && nvim ."

function jiraq () {
  jira issue list -q "$1"
}
function aws_login_populate_all() {
	aws-sso-util configure populate --sep _ --components account_id,role_name --region eu-west-1 --no-credential-process
}

function aws_login_all() {
	aws-sso-util login --all
}

function hist() {
	print -z $( ([ -n "ZSH_NAME" ] && fc -l 1 || history) | fzf +s --tac | sed 's/ *[0-9]* *//')
}

function jump-to-git-root {
  local _root_dir="$(git rev-parse --show-toplevel 2>/dev/null)"
  if [[ $? -gt 0 ]]; then
    >&2 echo 'Not a Git repo!'
    exit 1
  fi
  local _pwd=$(pwd)
  if [[ $_pwd = $_root_dir ]]; then
    # Handle submodules:
    # If parent dir is also managed under Git then we are in a submodule.
    # If so, cd to nearest Git parent project.
    _root_dir="$(git -C $(dirname $_pwd) rev-parse --show-toplevel 2>/dev/null)"
    if [[ $? -gt 0 ]]; then
      echo "Already at Git repo root."
      return 0
    fi
  fi
  # Make `cd -` work.
  OLDPWD=$_pwd
  echo "Git repo root: $_root_dir"
  cd $_root_dir
}

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
export PATH="$HOME/.tgenv/bin:$PATH"
export PATH="$HOME/.tfenv/bin:$PATH"

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
