#!/usr/bin/env bash

set -e
SCRIPTPATH="$( cd -- "$(dirname "$0")" >/dev/null 2>&1; pwd -P )"
cd "$SCRIPTPATH"

REPO_PATH="/tmp/dotfiles"
FROM_BASE="$REPO_PATH/dotfiles"

# log
function log() {
  color="\033[0;32m" # Green color
  echo -e "$color[INFO]\\033[0m $@"  
}

function warn() {
  color="\033[1;33m" # Yellow color  
  echo -e "$color[WARN]\\033[0m $@"
}

# clone dotfiles repo
function clone_dotfiles() {
  log "cloning dotfiles repo"
  [ -d "$REPO_PATH" ] && rm -rf $REPO_PATH
  git clone -q --depth=1 https://github.com/prchann/dotfiles.git $REPO_PATH
  # cp -r "/data/ide" "$REPO_PATH"
}

# config iterm2
function config_iterm2() {
  log "configuring iterm2"
  if [ ! -f "$HOME/.iterm2_shell_integration.zsh" ]; then
    curl -sL https://iterm2.com/shell_integration/zsh \
      -o $HOME/.iterm2_shell_integration.zsh
  else
    warn "configuring iterm2: skip"
  fi
}

function copy_files () {
  replace_msg=$( [[ "$REPLACE" = true ]] && echo ' (and replace)' ||  echo '' )
  log "copying files$replace_msg"
  for f in "$@"; do
    log "* copying $f"
    base=$(basename "$f")
    dir=$(dirname "$f")
    from="$FROM_BASE/$f"
    to="$HOME/$dir"

    [ "$REPLACE" = false ] && [ -f "$to/$base" ] && warn "* copying $f: skip" && continue

    [ -d "$to" ] || mkdir -p "$to"
    [ -f "$to/$base" ] && rm "$to/$base"
    cp -r "$from" "$to"
  done
}

# set REPO_PATH from enviroment variable
if [ "$1" == "" ]; then
  clone_dotfiles
else
  REPO_PATH="$1"
fi

config_iterm2

files=(
  .config/nvim/lua/custom
  # .config/nvim/init.vim
  # .config/nvim/coc-settings.json
  .tmux.conf
  # .vimrc
  .zshrc
)
REPLACE=true
copy_files "${files[@]}"

files=(
  .ssh/config
  .gitconfig
)
REPLACE=false
copy_files "${files[@]}"

# config docker
# cp $FROM_BASE/docker/daemon.json /etc/docker/
# sudo systemctl restart docker
