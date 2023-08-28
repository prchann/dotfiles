FROM debian:12 as lang

WORKDIR /root

RUN apt-get -qq -y update && \
    apt-get -qq -y install locales

RUN localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8


FROM lang as sshd

RUN apt-get -qq -y update && \
    apt-get -qq -y install openssh-server

RUN mkdir -p /run/sshd

COPY docker-entrypoint.sh ./

EXPOSE 22/tcp

ENTRYPOINT ["./docker-entrypoint.sh"]


FROM sshd as pkgs

RUN apt-get -qq -y update && \
    apt-get -qq -y install \
        apt-utils \
        bat \
        binutils \
        cron \
        curl \
        exa \
        fd-find \
        fzf \
        gcc \
        git \
        iputils-ping \
        iredis \
        jq \
        lsb-release \
        lsof \
        make \
        mycli \
        net-tools \
        pandoc \
        ripgrep \
        silversearcher-ag \
        sudo \
        tar \
        telnet \
        tmux \
        tree \
        unzip \
        zip


FROM pkgs as zsh

RUN apt-get -qq -y update && \
    apt-get -qq -y install zsh

RUN chsh -s $(which zsh)

RUN curl -sL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh | bash
RUN git clone -q --depth 1 https://github.com/zsh-users/zsh-autosuggestions ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions
RUN git clone -q --depth 1 https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting

CMD ["zsh"]


FROM zsh as vi

RUN apt-get -qq -y update && \
    apt-get -qq -y install \
    ninja-build \
    gettext \
    cmake \
    unzip \
    curl \
    universal-ctags

RUN git clone -q https://github.com/neovim/neovim /tmp/neovim

RUN cd /tmp/neovim && \
    git checkout stable && \
    make CMAKE_BUILD_TYPE=RelWithDebInfo && \
    make install && \
    cd -

RUN git clone -q --depth 1 https://github.com/NvChad/NvChad ~/.config/nvim


FROM vi as gh

RUN curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg

RUN chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg && echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | tee /etc/apt/sources.list.d/github-cli.list

RUN apt-get -qq -y update && \
    apt-get -qq -y install gh


FROM gh as python

RUN curl -sL https://pyenv.run | bash

RUN apt-get -qq -y update && \
    apt-get -qq -qq -y install \
        build-essential \
        libssl-dev \
        zlib1g-dev \
        libbz2-dev \
        libreadline-dev \
        libsqlite3-dev \
        llvm \
        libncursesw5-dev \
        xz-utils \
        tk-dev \
        libxml2-dev \
        libxmlsec1-dev \
        libffi-dev \
        liblzma-dev

RUN bash -c 'export PATH="~/.pyenv/bin:$PATH" && \
    eval "$(pyenv init -)" && \
    pyenv install -s 3.11.1 && \
    pyenv global 3.11.1'


FROM python as nodejs

RUN curl -sL https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.3/install.sh | bash

RUN bash -c 'source ~/.nvm/nvm.sh && \
    nvm install --lts && \
    nvm install-latest-npm'

RUN bash -c 'source ~/.nvm/nvm.sh && \
    npm i -g nodemon'


FROM nodejs as java

RUN JABBA_VERSION=0.11.2 curl -sL https://github.com/shyiko/jabba/raw/master/install.sh | bash

RUN bash -c 'source ~/.jabba/jabba.sh && \
   JAVA_VERSION=1.17.0 && \
   jabba install openjdk@$JAVA_VERSION && \
   jabba alias default openjdk@$JAVA_VERSION && \
   jabba install openjdk-ri@1.8.41'


FROM java as golang

RUN apt-get -qq -y update && \
    apt-get -qq -y install \
    bison \
    bsdmainutils
RUN curl -sL https://raw.githubusercontent.com/moovweb/gvm/master/binscripts/gvm-installer | bash

RUN bash -c 'source ~/.gvm/scripts/gvm && \
    gvm install go1.18.10 -B && \
    gvm use go1.18.10 --default'

RUN bash -c 'source ~/.gvm/scripts/gvm && \
    gvm install go1.21.0 && \
    gvm use go1.21.0 --default'

RUN bash -c 'source ~/.gvm/scripts/gvm && \
    go install google.golang.org/protobuf/cmd/protoc-gen-go@v1.28 && \
    go install google.golang.org/grpc/cmd/protoc-gen-go-grpc@v1.2'


FROM golang as dotfiles

COPY install-dotfiles.sh /tmp/dotfiles/
COPY dotfiles /tmp/dotfiles/dotfiles

RUN bash /tmp/dotfiles/install-dotfiles.sh /tmp/dotfiles
