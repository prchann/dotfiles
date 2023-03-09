#!/bin/bash

# config iterm2
f=".iterm2_shell_integration.zsh"
echo -n "$f: "
if [ -f $HOME/$f ]; then
    echo "skip"
else
    curl -sL https://iterm2.com/shell_integration/zsh -o $HOME/.iterm2_shell_integration.zsh
    echo "OK"; echo;
fi

# clone dotfiles repo
REPO_PATH="$HOME/.dotfiles"
FROM_BASE="$REPO_PATH/dotfiles"
[ -d "$REPO_PATH" ] && rm -rf $REPO_PATH
git clone -q --depth=1 https://github.com/prchann/dotfiles.git $REPO_PATH

REPLACE=false
function copy_files () {
    for f in "$@"; do
        echo -n "$f: "
        base=$(basename "$f")
        dir=$(dirname "$f")
        from="$FROM_BASE/$f"
        to="$HOME/$dir"

        if [ $REPLACE = false ]; then
            [ -f "$to/$base" ] && echo "skip" && continue
        fi

        [ -d "$to" ] || mkdir -p "$to"
        [ -f "$to/$base" ] && rm "$to/$base"
        cp "$from" "$to"
        echo "OK"
    done
}

# cp dotfiles: replace if exist
declare -a files=(
    .config/nvim/init.vim
    .tmux.conf
    .vimrc
    .zshrc
)
REPLACE=true; copy_files "${files[@]}"

# cp dotfiles: cancel if exist
files=(
    .ssh/config
    .gitconfig
)
REPLACE=false; copy_files "${files[@]}"

# config docker
# cp $FROM_BASE/docker/daemon.json /etc/docker/
# sudo systemctl restart docker

# clear
rm -rf $REPO_PATH
