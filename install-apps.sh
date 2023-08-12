#!/usr/bin/env bash

set -e
SCRIPTPATH="$( cd -- "$(dirname "$0")" >/dev/null 2>&1; pwd -P )"
cd "$SCRIPTPATH"

# log
function log() {
  color="\033[0;32m" # Green color
  echo -e "$color[INFO]\\033[0m $@"  
}

function warn() {
  color="\033[1;33m" # Yellow color  
  echo -e "$color[WARN]\\033[0m $@"
}

# set LANG
set_lang() {
  log "setting LANG"
  apt-get -qq -y install locales

  HAS_UTF8=$(locale -a | grep 'en_US.utf8' && echo true || echo false)
  if [ "$HAS_UTF8" = false ]; then
    localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8
  fi
}

# install basic pkgs
install_basic_pkgs() {
  log "installing basic pkgs"
  pkgs=(
    apt-utils
    bat
    binutils
    cron
    curl
    exa
    fd-find
    fzf
    gcc
    git
    iputils-ping
    iredis
    jq
    lsb-release
    lsof
    make
    mycli
    net-tools
    pandoc
    ripgrep
    silversearcher-ag
    sudo
    tar
    telnet
    tmux
    tree
    unzip
    zip
  )
  for pkg in "${pkgs[@]}"; do
    log "* installing $pkg"
    apt-get -qq -y install "$pkg"
  done
}

# install sshd
function install_sshd() {
  log "installing sshd"
  apt-get -qq -y install openssh-server
  mkdir -p /run/sshd
}

# install zsh
function install_zsh() {
  log "installing zsh"
  apt-get -qq -y install zsh

  log "* set default shell to zsh"
  chsh -s $(which zsh)

  # install omz
  log "* installing omz"
  if [ ! -d "$HOME/.oh-my-zsh" ]; then
    curl -sL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh | bash
  else
    warn "* installing omz: skip"
  fi

  # install omz plugins
  log "* installing omz plugins"
  log "  * installing zsh-autosuggestions"
  if [ ! -d "$HOME/.oh-my-zsh/custom/plugins/zsh-autosuggestions" ]; then
    git clone -q --depth 1 https://github.com/zsh-users/zsh-autosuggestions \
      ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions
  else
    warn "  * installing zsh-autosuggestions: skip"
  fi

  log "  * installing zsh-syntax-highlighting"
  if [ ! -d "$HOME/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting" ]; then
    git clone -q --depth 1 https://github.com/zsh-users/zsh-syntax-highlighting.git \
      ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting
  else
    warn "  * installing zsh-syntax-highlighting: skip"
  fi
}

# install go
function install_go() {
  log "installing go"
  log "* installing gvm"
  if [ ! -d "$HOME/.gvm" ]; then
    curl -sL https://raw.githubusercontent.com/moovweb/gvm/master/binscripts/gvm-installer | bash
    apt-get -qq -y install bison
  else
    warn "* installing gvm: skip"
  fi

  log "* installing go by gvm"
  source ~/.gvm/scripts/gvm && \
    gvm install go1.18.10 -B && \
    gvm use go1.18.10 && \
    gvm install go1.20.5 && \
    gvm use go1.20.5 --default

  # install grpc
  log "* installing grpc"
  source ~/.gvm/scripts/gvm && \
    go install google.golang.org/protobuf/cmd/protoc-gen-go@v1.28 && \
    go install google.golang.org/grpc/cmd/protoc-gen-go-grpc@v1.2
}

# install java
function install_java() {
  log "installing java"
  log "* installing jabba"
  JABBA_VERSION=0.11.2 curl -sL https://github.com/shyiko/jabba/raw/master/install.sh | bash

  log "* installing java by jabba"
  source ~/.jabba/jabba.sh && \
    JAVA_VERSION=1.17.0 && \
    jabba install openjdk@$JAVA_VERSION && \
    jabba alias default openjdk@$JAVA_VERSION && \
    jabba install openjdk-ri@1.8.41
}

# install node.js
function install_nodejs() {
  log "installing node.js"
  log "* installing nvm"
  curl -sL https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.3/install.sh | bash

  log "* installing node.js by nvm"
  source ~/.nvm/nvm.sh && \
    nvm install --lts && \
    nvm install-latest-npm

  # install node packags
  log "* installing node pkgs"
  source ~/.nvm/nvm.sh && \
    npm i -g nodemon
}

# install pyenv, python
function install_python() {
  log "installing python"
  log "* installing pyenv"
  if [ ! -d "$HOME/.pyenv" ]; then
    curl -sL https://pyenv.run | bash
  else
    warn "* installing pyenv: skip"
  fi

  log "* installing python by pyenv"
  pkgs=(
    build-essential
    libssl-dev
    zlib1g-dev
    libbz2-dev
    libreadline-dev
    libsqlite3-dev
    llvm
    libncursesw5-dev
    xz-utils
    tk-dev
    libxml2-dev
    libxmlsec1-dev
    libffi-dev
    liblzma-dev
  )
  apt-get -qq -qq -y install "${pkgs[@]}"
  export PATH="~/.pyenv/bin:$PATH" && \
    eval "$(pyenv init -)" && \
    pyenv install -s 3.11.1 && \
    pyenv global 3.11.1
}

# install nvim
function install_nvim() {
  log "installing nvim"
  log "* installing dependences"
  apt-get -qq -y install ninja-build gettext cmake unzip curl universal-ctags

  log "* cloning nvim"
  if [ ! -d "/tmp/neovim" ]; then
    git clone -q https://github.com/neovim/neovim /tmp/neovim
  else
    warn "* cloning nvim: skip"
  fi

  log "* building"
  cd /tmp/neovim && git checkout stable
  make CMAKE_BUILD_TYPE=RelWithDebInfo

  log "* installing"
  make install
  cd -
}

# install nvchad
function install_nvchad() {
  log "installing nvchad"
  if [ ! -d "$HOME/.config/nvim" ]; then
    git clone --depth 1 https://github.com/NvChad/NvChad ~/.config/nvim
  else
    warn "installing nvchad: skip"
  fi
}

# install nvim lazy plugins
function install_nvim_lazy_plugins() {
  log "installing nvim lazy plugins"
  go install github.com/jstemmer/gotags@master
}

# install nvim
function install_nvim_v1() {
  log "installing nvim"
  apt-get -qq -y install universal-ctags

  curl -sLo- \
    https://github.com/neovim/neovim/releases/latest/download/nvim-linux64.tar.gz | \
    tar xzf - && \
    cp nvim-linux64/bin/nvim /usr/bin/

  log "* installing python pkg for nvim"
  export PATH="~/.pyenv/bin:$PATH" && \
    eval "$(pyenv init -)" && \
    pip install autopep8 pylint pynvim

  log "* installing node pkg for nvim"
  source ~/.nvm/nvm.sh && \
    npm i -g neovim

  # install vim-plug and vim plugins
  log "* installing vim-plug"
  curl -sfLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

  log "* installing vim plugs"
  nvim +PlugInstall +qall

  # install vim-go dependences
  log "* installing vim-go dependences"
  source ~/.gvm/scripts/gvm && \
    go install github.com/klauspost/asmfmt/cmd/asmfmt@latest && \
    go install github.com/go-delve/delve/cmd/dlv@latest && \
    go install github.com/kisielk/errcheck@latest && \
    go install github.com/davidrjenni/reftools/cmd/fillstruct@master && \
    go install github.com/rogpeppe/godef@latest && \
    go install golang.org/x/tools/cmd/goimports@master && \
    go install github.com/mgechev/revive@latest && \
    go install golang.org/x/tools/gopls@latest && \
    go install github.com/golangci/golangci-lint/cmd/golangci-lint@latest && \
    go install honnef.co/go/tools/cmd/staticcheck@latest && \
    go install github.com/fatih/gomodifytags@latest && \
    go install golang.org/x/tools/cmd/gorename@master && \
    go install github.com/jstemmer/gotags@master && \
    go install golang.org/x/tools/cmd/guru@master && \
    go install github.com/josharian/impl@master && \
    go install honnef.co/go/tools/cmd/keyify@master && \
    go install github.com/fatih/motion@latest

  # install coc extensions
  log "* installing coc extensions"
  source ~/.nvm/nvm.sh && \
    EXT_PATH=~/.config/coc/extensions/ && \
    mkdir -p $EXT_PATH && \
    cd $EXT_PATH && \
    npm i \
    coc-css \
    coc-docker \
    coc-go \
    coc-html \
    coc-java \
    coc-json \
    coc-prettier \
    coc-pyright \
    coc-sh \
    coc-sql \
    coc-tsserver \
    coc-qq -yaml
}

# install GitHub CLI
function install_github_cli() {
  log "installing github cli"
  curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | \
    dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg
  chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg && \
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" \
    | tee /etc/apt/sources.list.d/github-cli.list
    apt-get -qq -y update && \
      apt-get -qq -y install gh
}

apt-get -qq -y update
install_basic_pkgs
set_lang
install_sshd
install_zsh
install_go
install_nodejs
install_python
install_nvim
install_nvchad
install_github_cli
# exit now if running on linux
[ "$OSTYPE"=="linux-gnu"* ] && exit

# install homebrew
echo -n "installing homebrew: "
if command -v brew >> /dev/null; then
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
  font-jetbrains-mono-nerd-font
  font-noto-nerd-font
)
brew_install_casks "${casks[@]}"

# install casks
# basic tools
echo; echo "installing system tools..."
casks=(
  adrive
  rectangle
  shottr
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
formulaes=(
  watch
)
brew_install_casks "${formulaes[@]}"

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
  google-chrome
  safari-technology-preview
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
