# Needs:
# Fisher https://github.com/jorgebucaran/Fisher
#
# with plugins installed:
# jorgebucaran/fisher
# ilancosman/tide@v5
# reitzig/sdkman-for-fish@v2.1.0
#
# Install also:
# fzf
# ripgrep
# aws-sso-util
# eza
# sparkline
# lolcat
# jiracli
# git-tui


if status is-interactive
    # Commands to run in interactive sessions can go here
    # bind \e\cE edit_command_buffer
    bind \cE edit_command_buffer
end

# Tide colors
set -U tide_pwd_color_dirs 98971a
set -U tide_pwd_color_anchors b8bb26
set -U tide_pwd_bg_color 3c3836
set -U tide_time_color 98971a
set -U tide_time_bg_color 3c3836

# Editor setting
set -Ux GIT_EDITOR nvim
set -Ux VISUAL nvim

fish_add_path /Users/(whoami)/nvim-macos/bin
fish_add_path $HOME/.pkenv/bin/
fish_add_path $HOME/.bin/
fish_add_path /usr/local/lib/python3.11/site-packages/
fish_add_path $HOME/.apache-maven/bin

set -Ux AWS_CONFIGURE_SSO_DEFAULT_SSO_START_URL "https://blabla"
set -Ux AWS_CONFIGURE_SSO_DEFAULT_SSO_REGION eu-west-1
set -Ux DOTNET_CLI_TELEMETRY_OPTOUT true
set -gx GITLAB_TOKEN blabla
set -gx GITEA_ACCESS_TOKEN blabla
set -gx PAGERDUTY_TOKEN "blabla"
set -gx JIRA_API_TOKEN "blabla"
set -gx VAULT_TOKEN "blabla"
set -Ux JIRA_AUTH_TYPE basic

set -Ux MONGODB_ATLAS_USERNAME blabla
set -Ux MONGODB_ATLAS_API_KEY blabla
set -Ux MONGODB_ATLAS_PUBLIC_KEY $MONGODB_ATLAS_USERNAME
set -Ux MONGODB_ATLAS_PRIVATE_KEY $MONGODB_ATLAS_API_KEY


alias sre="cd $HOME/GITrepos/sre/"
alias speedtest="speedtest-cli --secure"
alias kouknout="qlmanage -p"
alias weather="curl http://wttr.in"
alias jiramy="jira issue list -q 'project = BLABLA AND issuetype != Support AND assignee = currentUser() AND status != Done AND status != \"Done / Ready for release\"'"
alias jiratodo="jira sprint list --current"
alias jiraready="jira issue list -s'Ready To Pull' --order-by priority"
alias jirasupport="jira issue list -q 'project = BLABLA AND issuetype in (Support, \'Tenant Request\') AND status !=  Done\u002fClosed' --order-by created"
alias jira180="jira issue list -q 'project = BLABLA AND status in (Review, Done, Clarify) AND updated >= -180d AND assignee in (currentUser()) and type != Support ' --order-by updated"
alias jirac="jira issue create"
alias epics="jira epic list"
alias vpnon="globalprotect connect -p vpn.blabla.com"
alias vpnoff="globalprotect disconnect -p vpn.blabla.com"
alias confnvim="cd $HOME/.config/nvim/lua/ && nvim ."
alias confish="nvim $HOME/.config/fish/config.fish"
alias sourcefish="source $HOME/.config/fish/config.fish"
alias confyabai="nvim $HOME/.config/yabai/yabairc"
alias confskhd="nvim $HOME/.config/skhd/skhdrc"
alias cl="clear"
alias vault_login='VAULT_ADDR="https://vault.blabla.com" vault login -method=oidc mount=blabla_internal/ port=8250'

# brew install eza
if type -q eza
    alias ls "eza --icons"
    abbr --add ll eza -l
    abbr --add la eza -la
    abbr --add llt eza -l --tree --level=2
    abbr --add llta eza -la --tree --level=2
    abbr --add ltest ll --tree --level=3
end

function fish_title
    # `prompt_pwd` shortens the title. This helps prevent tabs from becoming very wide.
    echo $argv[1] (prompt_pwd)
    pwd
end

function fish_greeting
  if type -q sparkline and type -q lolcat
    # pip install sparklines
    # brew install lolcat
    fish -c "for i in (seq (tput cols)); random; end" | sparklines | lolcat
  else
    echo "\
    Starting MS-DOS(R) Version 4.01 ..."
  end
end

function aws_login_populate_all
    aws-sso-util configure populate --sep _ --components account_id,role_name --region eu-west-1 --no-credential-process
end

function aws_login_all
    aws-sso-util login --all
end

function jump-to-git-root
    set ROOT_DIR (git rev-parse --show-toplevel 2> /dev/null)
    if test $status -gt 0
        set ROOT_DIR ""
        echo "Not a git repo"
    end
    set CURRENT (pwd)
    if test $CURRENT = $ROOT_DIR
        set ROOT_DIR (git -C $(dirname $CURRENT) rev-parse --show-toplevel 2>/dev/null)
        if test $status -gt 0
            echo "Already at git repo root"
            return 0
        end
    end
    if [ -n $ROOT_DIR ]
        cd $ROOT_DIR
    end
end

function notes --argument-names notename
    # brew install bat fzf
    set notes_path ~/.notes/
    if test -n "$notename"
        echo $notename
        $EDITOR "$notes_path$notename".md -c 'cd %:p:h'
    else
        eza $notes_path | fzf --preview="bat --color=always $notes_path{}" --preview-window=right:70%:wrap | xargs -I {} $EDITOR "$notes_path{}" -c 'cd %:p:h'
    end
end

function ripg
    # rg --color=always --line-number --with-filename . | fzf --ansi \
    rg --color=always --line-number . | fzf --ansi \
        --color "hl:-1:underline,hl+:-1:underline:reverse" \
        --delimiter : \
        --preview 'bat --color=always {1} --highlight-line {2}' \
        --preview-window 'up,60%,border-bottom,+{2}+3/3,~3' \
        --bind 'enter:become(nvim {1} +{2})'
end

function clear_tg_cache
    find . -type d -name ".terragrunt-cache" -exec rm -rf "{}" \;
end

function clear_tg_lock
    find . -type f -name ".terraform.lock.hcl" -exec rm -rf "{}" \;
end

function update_curr_branch
    set CURR_BRANCH (git rev-parse --abbrev-ref HEAD)
    echo "Pulling latest changes from remote: origin/$CURR_BRANCH"
    git pull origin $CURR_BRANCH
end

function glog
    if type -q git-tui
        git-tui log
    else
        echo "git-tui is not installed, please install"
    end
end
# zoxide init fish | source
