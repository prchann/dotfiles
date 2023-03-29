FROM debian:testing

WORKDIR /root

RUN apt-get -qq update && \
    apt-get -qq -y install \
        curl \
        git \
    && rm -rf /var/lib/apt/lists/*

# set LANG
RUN apt-get -qq update && \
    apt-get -qq -y install \
        locales \
    && rm -rf /var/lib/apt/lists/*
RUN localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8
ENV LANG en_US.utf8

# install zsh
RUN apt-get -qq update && \
    apt-get -qq -y install \
        zsh \
    && rm -rf /var/lib/apt/lists/*
RUN chsh -s $(which zsh)
# install omz and plugins
RUN curl -sL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh | bash
RUN /bin/bash -c '\
  git clone --depth 1 https://github.com/zsh-users/zsh-autosuggestions \
    ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions && \
  git clone --depth 1 https://github.com/zsh-users/zsh-syntax-highlighting.git \
    ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting \
  '

# install jabba, java
# RUN JABBA_VERSION=0.11.2 curl -sL https://github.com/shyiko/jabba/raw/master/install.sh | bash
# RUN /bin/bash -c '\
#   source ~/.jabba/jabba.sh && \
#   JAVA_VERSION=1.17.0 && \
#   jabba install openjdk@$JAVA_VERSION && \
#   jabba alias default openjdk@$JAVA_VERSION && \
#   jabba install openjdk-ri@1.8.41 \
#   '

# install pyenv, python
RUN curl -sL https://pyenv.run | bash
RUN apt-get -qq update && \
    apt-get -qq -y install \
        build-essential \
        libssl-dev \
        zlib1g-dev \
        libbz2-dev \
        libreadline-dev \
        libsqlite3-dev \
        curl \
        llvm \
        libncursesw5-dev \
        xz-utils \
        tk-dev \
        libxml2-dev \
        libxmlsec1-dev \
        libffi-dev \
        liblzma-dev \
    && rm -rf /var/lib/apt/lists/*
RUN /bin/bash -c '\
  export PATH="~/.pyenv/bin:$PATH" && \
  eval "$(pyenv init -)" && \
  pyenv install 3.11.1 && \
  pyenv global 3.11.1 \
  '

# install nvm, node.js
RUN curl -sL https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.3/install.sh | bash
RUN /bin/bash -c '\
  source ~/.nvm/nvm.sh && \
  nvm install --lts && \
  nvm install-latest-npm \
  '
RUN /bin/bash -c '\
  source ~/.nvm/nvm.sh && \
  npm i -g \
    nodemon \
  '

# install gvm, go
RUN curl -sL https://raw.githubusercontent.com/moovweb/gvm/master/binscripts/gvm-installer | bash
RUN apt-get -qq update && \
    apt-get -qq -y install \
        bison \
    && rm -rf /var/lib/apt/lists/*
RUN /bin/bash -c '\
  source ~/.gvm/scripts/gvm && \
  gvm install go1.17.13 -B && \
  gvm use go1.17.13 && \
  gvm install go1.20.2 && \
  gvm use go1.20.2 --default \
  '

# install grpc
RUN /bin/bash -c '\
  source ~/.gvm/scripts/gvm && \
  go install google.golang.org/protobuf/cmd/protoc-gen-go@v1.28 && \
  go install google.golang.org/grpc/cmd/protoc-gen-go-grpc@v1.2 \
  '

# install dotfiles
RUN curl -sL https://raw.githubusercontent.com/prchann/dotfiles/main/install-dotfiles.sh | bash
COPY docker-entrypoint.sh ./

# install neovim
RUN apt-get -qq update && \
    apt-get -qq -y install \
        universal-ctags \
        neovim \
    && rm -rf /var/lib/apt/lists/*
RUN /bin/bash -c '\
  export PATH="~/.pyenv/bin:$PATH" && \
  eval "$(pyenv init -)" && \
  pip install pynvim \
  '
RUN /bin/bash -c '\
  source ~/.nvm/nvm.sh && \
  npm i -g neovim \
  '
# install vim-plug and vim plugins
RUN /bin/bash -c '\
  curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim && \
  nvim +PlugInstall +qall \
  '

# install vim-go dependences
RUN /bin/bash -c '\
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
  go install github.com/fatih/motion@latest && \
  go install github.com/koron/iferr@master \
  '
# install coc extensions
RUN /bin/bash -c '\
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
    coc-jedi \
    coc-json \
    coc-prettier \
    coc-sh \
    coc-sql \
    coc-tsserver \
    coc-yaml \
  '

# install ssh
RUN apt-get -qq update && \
    apt-get -qq -y install \
        openssh-server \
    && rm -rf /var/lib/apt/lists/*
EXPOSE 22/tcp
ENTRYPOINT ["./docker-entrypoint.sh"]

# install GitHub CLI
RUN curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg \
  | dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg \
  && chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg \
  && echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" \
  | tee /etc/apt/sources.list.d/github-cli.list > /dev/null \
  && apt-get -qq update \
  && apt-get -qq -y install gh \
  && rm -rf /var/lib/apt/lists/*

# install pkgs
RUN apt-get -qq update && \
    apt-get -qq -y install \
        bat \
        binutils \
        exa \
        fzf \
        iputils-ping \
        iredis \
        jq \
        lsb-release \
        lsof \
        mycli \
        net-tools \
        pandoc \
        silversearcher-ag \
        sudo \
        telnet \
        tmux \
        tree \
        unzip \
        zip \
    && rm -rf /var/lib/apt/lists/*

CMD ["zsh"]
