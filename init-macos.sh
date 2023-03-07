#!/usr/bin/env bash

# connect proxy server
read -p "Proxy server is started? (Y/n): " confirm && [[ $confirm == [yY] || $confirm == [yY][eE][sS] ]] || exit 1
echo;
export http_proxy=http://127.0.0.1:1087; export https_proxy=http://127.0.0.1:1087;

# check zsh
if ! command -v zsh &> /dev/null; then
  echo "can not found zsh, please install it at first"
  exit 1
fi

# install omz and plugins
echo -n "installing omz: "
if [ -d $HOME/.oh-my-zsh ]; then
  echo "skip"
else
  curl -sL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh | bash
  echo "OK"
fi

echo -n "installing zsh-autosuggestions: "
if [ -d ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions ]; then
  echo "skip"
else
  git clone --depth 1 https://github.com/zsh-users/zsh-autosuggestions ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions
  echo "OK"
fi

echo -n "installing zsh-syntax-highlighting: "
if [ -d ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting ]; then
  echo "skip"
else
  git clone --depth 1 https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting
  echo "OK"
fi

# install homebrew
echo -n "installing homebrew: "
if command -v brew &> /dev/null; then
  echo "skip"
else
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  # source brew shell
  [ -d /home/linuxbrew ] && eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
  [ -f /opt/homebrew/bin/brew ] && eval "$(/opt/homebrew/bin/brew shellenv)"
  # homebrew index
  brew update -q
  echo "OK"
fi

export HOMEBREW_NO_AUTO_UPDATE=1

function brew_install_casks () {
  for i in "$@"; do
    read -p "install $i? (Y/n)" confirm && [[ $confirm == [yY] || $confirm == [yY][eE][sS] ]] || continue
    echo -n "installing $i: "
    brew install -q --cask "$i"
    echo "OK"
  done
}

function brew_install () {
  for i in "$@"; do
    echo -n "installing $i: "
    brew install -q "$i"
    echo "OK"
  done
}

# install fonts
echo; echo "installing fonts..."
brew tap homebrew/cask-fonts
casks=(
  font-jetbrains-mono
  font-noto-nerd-font
)
brew_install_casks "${casks[@]}"

# install casks
# basic tools
echo; echo "installing system tools..."
casks=(
  adrive
  rectangle
  jietu
  karabiner-elements
  monitorcontrol
  the-unarchiver
  keycastr
  appcleaner
)
brew_install_casks "${casks[@]}"

# dev tools
echo; echo "installing dev tools..."
casks=(
  iterm2
  visual-studio-code
  switchhosts
  docker
  insomnia
  postman
)
brew_install_casks "${casks[@]}"

echo; echo "installing more dev tools..."
casks=(
  goland
  pycharm
  intellij-idea
  mysqlworkbench
  figma
  charles
  royal-tsx
)
brew_install_casks "${casks[@]}"
formulaes=(
  pandoc
)
brew_install_casks "${formulaes[@]}"

# work apps
echo; echo "installing work apps..."
casks=(
  safari-technology-preview
  google-chrome-dev
  wechat
  wechatwork
  tencent-meeting
  microsoft-office
)
brew_install_casks "${casks[@]}"

# entertainment apps
echo; echo "installing entertainment apps..."
casks=(
  iina
  qqmusic
  qqlive
)
brew_install_casks "${casks[@]}"
