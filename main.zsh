# Files on the custom/ directory will be automatically loaded by the init
# script, in alphabetical order.

# Send unmatched globs (e.g. *foo* or HEAD^) to the command, instead of erroring out
# See https://github.com/ohmyzsh/ohmyzsh/issues/449
setopt NO_NOMATCH

alias l='ls -lAhF'
alias ll='ls -lAhF'
alias la='ls -lAhF'

alias pd="pushd"
alias ppd="popd"

alias pssh="ssh -o PreferredAuthentications=keyboard-interactive,password -o PubkeyAuthentication=no"
alias pscp="scp -o PreferredAuthentications=keyboard-interactive,password -o PubkeyAuthentication=no"

alias v="vim -O"
alias vi="vim -O"
alias vim="vim -O"
alias im="vim -O"
alias vc="vim -O --clean"

alias h="history | less +G"

alias c=clear

alias gr="git rebase"
alias grm="git rebase origin/master"
alias grma="git rebase origin/main"

alias gch="git checkout"
alias gco="git clone"
alias gf="git fetch -p --all"
alias gl="git log"
alias gp="git pull"
alias gs="git status"
alias grc="git rebase --continue"
alias gra="git rebase --abort"
alias grs="git rebase --skip"

alias dcu='docker compose up'
alias dcd='docker compose down'
alias dcp='docker compose ps'

# Search hidden files, but obey ignored files
alias ag='ag --hidden'

alias standby='while true; do echo -n . && sleep 15; done'
alias chompifeof="perl -pi -e 'chomp if eof'"

alias rl='realpath --canonicalize-existing'

export VISUAL=vim
export EDITOR="$VISUAL"

# (zsh-vi-mode plugin) Disable the cursor style feature.
# Does not work well across vi, zsh, tmux, iterm2
ZVM_CURSOR_STYLE_ENABLED=false
# (zsh-vi-mode plugin) Always start with insert mode for each command line
ZVM_LINE_INIT_MODE="${ZVM_MODE_INSERT}"

# fd uses .gitignore files to filter file results
export FZF_DEFAULT_COMMAND='fd'


# Set the namespace of the current k8s context
kns() {
    local ns="${1}"
    kubectl config set-context --current --namespace="${ns}"
}

# Get ip addresses of docker container
dip() {
    docker inspect --format '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' "$@"
}

# Outputs file names of specified revision (defaults to HEAD)
unalias gdt # Remove conflict with ohmyzsh git plugin
gdt() {
    if [[ "$#" == 0 ]]; then
        set -- HEAD
    fi
    git diff-tree --name-only --no-commit-id -r "$@"
}

# Pushes to dev branch on downstream remote
# Uses origin remote if downstream not available
unalias gpd
gpd() {
    if git remote | grep downstream; then
        git push -f downstream HEAD:dev
    else
        git push -f origin HEAD:dev
    fi
}

vf() {
    vim $(fzf)
}

vfm() {
    vim $(fzf -m)
}

# Format json file using jq
# See https://github.com/stedolan/jq/issues/105
jqf() {
    local jqf_dir="$(mktemp -d /tmp/jqf-dir-XXXXXXXXX)"
    for f in "$@"; do
        local base="$(basename "${f}")"
        local jqf_file="${jqf_dir}/${base}"
        cat "${f}" | jq > "${jqf_file}"
        mv "${jqf_file}" "${f}"
    done
    rm -rf "${jqf_dir}"
}

mdcd() {
  mkdir -p $@ && cd ${@:$#}
}

# Convert leetcode problem name to file name, without the extension
# Example:
# > lcfname "1421. NPV Queries"
# 1421_npv_queries
#
lcfname() {
  echo "$@" | tr '[:upper:]' '[:lower:]' | tr ' ' '_' | tr '-' '_' | tr -d '.'
}

# Reset the SSH auth sock to the latest
# Assumes SSH auth socks are in /tmp/ssh-*
ras() {
  local sock_prefix="/tmp/ssh-"
  local latest_sock

  if ! latest_sock="$(ls -t "${sock_prefix}"*/* | head -n 1)" || [[ -z "${latest_sock}" ]]; then
    echo "Did not find auth sock in ${sock_prefix}*" 1>&2
    return 1
  fi

  export SSH_AUTH_SOCK="${latest_sock}"
}

# When using history expansion commands such as "!$",
# run the command when using <enter>. Do not just expand it.
# See https://superuser.com/questions/1276224/oh-my-zsh-history-expansion-on-space-or-tab-but-not-enter
unsetopt HIST_VERIFY

# Some tools (e.g. bazel) are installed here
export PATH="$PATH:$HOME/bin"
# Some tools (e.g. shfmt) are installed here
export PATH="$PATH:$HOME/go/bin"

# Include go installation
export PATH="/opt/go/bin:${PATH}"

# From nvm git install instructions
# See https://github.com/nvm-sh/nvm#git-install
export NVM_DIR="$HOME/gh/nvm-sh/nvm"

loadnvm() {
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
  [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
}
