#!/usr/bin/env bash

echo "installing dotfiles..."

[ -d ~/.dotfiles ] && rm -rf ~/.dotfiles
git clone --depth=1 git@github.com:prchann/dotfiles.git ~/.dotfiles
cp -R ~/.dotfiles/dotfiles/. ~/

echo "dotfiles installed"
