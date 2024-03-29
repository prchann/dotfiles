# iterm2
export ITERM_ENABLE_SHELL_INTEGRATION_WITH_TMUX=YES
ITERM2_PATH=~/.iterm2_shell_integration.zsh
[ -f $ITERM2_PATH ] && source $ITERM2_PATH

# fzf
FZF_PATH=~/.fzf.zsh
if [ -f $FZF_PATH ]; then
  source $FZF_PATH
  export FZF_DEFAULT_COMMAND='ag --hidden --ignore="*.git/*" -l -g ""'
fi

# gvm
GVM_PATH=~/.gvm/scripts/gvm
[ -s $GVM_PATH ] && source $GVM_PATH

# jabba
# JABBA_PATH=~/.jabba/jabba.sh
# [ -f $JABBA_PATH ] && source $JABBA_PATH

# pyenv
PYENV_ROOT=~/.pyenv
if [ -d $PYENV_ROOT ]; then
  export PYENV_ROOT=$PYENV_ROOT
  export PATH="$PYENV_ROOT/bin:$PATH"
  eval "$(pyenv init --path)"
fi
alias vpy='eval "$(pyenv virtualenv-init -)"'

# fix virtualenv problem in nvim
# https://vi.stackexchange.com/questions/7644/use-vim-with-virtualenv/34996#34996
function nvimvenv {
  if [[ -e "$VIRTUAL_ENV" && -f "$VIRTUAL_ENV/bin/activate" ]]; then
    source "$VIRTUAL_ENV/bin/activate"
    command nvim "$@"
    deactivate
  else
    command nvim "$@"
  fi
}

command -v nvim >/dev/null && alias vi=nvimvenv
command -v vi >/dev/null && export EDITOR=vi
command -v vim >/dev/null && export EDITOR=vim
command -v nvim >/dev/null && export EDITOR=nvim

# omz
plugins=(
  brew
  docker
  git
  gitignore
  iterm2
  kubectl
  nvm
  ssh-agent
  zsh-autosuggestions
  zsh-syntax-highlighting
)
command -v fzf >/dev/null && plugins+=(fzf)
command -v tmux >/dev/null && plugins+=(tmux)
ZSH_THEME="ys" 
export ZSH=~/.oh-my-zsh
source $ZSH/oh-my-zsh.sh


# export
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

export MICRO_REGISTRY="etcd"
export ETCD_USERNAME=
export ETCD_PASSWORD=
export MICRO_REGISTRY_ADDRESS="etcd:2379"
export MICRO_TRANSPORT="grpc"
export MICRO_CLIENT="grpc"
export MICRO_SERVER="grpc"


# alias
command -v exa >/dev/null && alias ls="exa"
command -v batcat >/dev/null && alias bat="batcat"

function psoa() {
    ps aux | grep -i '[i]oa' | awk -v ORS=' ' '{print $2}'

}
function killoa() {
    pids=($(ps aux | grep -i '[i]oa' | awk -v ORS=' ' '{print $2}'))
    for pid in ${pids[@]}; do
        sudo kill -9 $pid
    done

}

alias ss='function _f() { ssh -t $@ "tmux -CC new -A -s main" }; _f'
alias ch='function _f() { curl "cht.sh/$1" }; _f'
# gen a password
function genpwd() {
    [ -z "$1" ] && LEN=16 || LEN=$1;
    tr -dc 'A-Za-z0-9!#$%&()*+,-./:;<=>?@[\]^_`{|}~' </dev/urandom | head -c $LEN; echo
}

function proxy() {
  export http_proxy="http://127.0.0.1:1087"
  export https_proxy="http://127.0.0.1:1087"

  # set proxy in container
  if [ -f "/.dockerenv" ]; then
    export http_proxy="http://host.docker.internal:1087"
    export https_proxy="http://host.docker.internal:1087" 
  fi
}

function ioaproxy() {
  export http_proxy="http://127.0.0.1:12639"
  export https_proxy="http://127.0.0.1:12639"
}

function unproxy() {
  unset http_proxy
  unset https_proxy
}

alias ip="curl cip.cc"


# set prompt context to user name
if [ -f "/.dockerenv" ]; then
    prompt_context() {
        [ $UID -ne 0 ] && prompt_segment black default "$USER"
    }
fi

