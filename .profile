alias b='git checkout $(git branch | awk '\''!/\*/'\''| fzf)'
alias ghci='stack exec -- ghci'
alias git='hub'
alias gup='gup -t $GUP_TOKEN'
alias ls='ls -G'
alias tree='tree -C'
alias vi='nvim'

# kubectl goodness
alias kc='kubectl -n chatkit'
alias kcd='kc --context deneb'
alias kci='kc --context integration1 -n $(kc --context integration1 get ns | awk "/chatkit/ { print \$1 }")'
alias kcm='kc --context minikube -n chatkit-acceptance'
alias kcp='kc --context us1'
alias kcs='kc --context us1-staging'

cd() {
  builtin cd "$@" && ls -A
}

n() {
  if [[ $1 == pull ]]; then
    cd $HOME/notes
    git pull
  elif [[ $1 == push ]]; then
    cd $HOME/notes
    git add .
    git commit -m "$(date)"
    git push
  elif [[ $1 == '' ]]; then
    cd $HOME/notes
  fi
}

branch() {
    git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
}

set -o vi

[ -f /usr/local/etc/bash_completion ] && . /usr/local/etc/bash_completion
[ -f ~/.fzf.bash ] && source ~/.fzf.bash
[ -f ~/.config/secrets/env ] && source ~/.config/secrets/env

# put current directory in iterm tab title
if [ $ITERM_SESSION_ID ]; then
  export PROMPT_COMMAND='echo -ne "\033];${PWD##*/}\007"; ':"$PROMPT_COMMAND";
fi

# history config
shopt -s histappend
shopt -s cmdhist
export HISTSIZE=1000000
export HISTFILESIZE="$HISTSIZE"
export HISTCONTROL=ignoreboth
export PROMPT_COMMAND="$PROMPT_COMMAND; history -a"

# nvim best vim
export VISUAL='nvim'
export EDITOR="$VISUAL"

export FZF_DEFAULT_COMMAND='fd -t f'
export FZF_DEFAULT_OPTS='--reverse --height 16 --color light'
export GOPATH="$HOME/code/go"
export PASSWORD_STORE_DIR="$HOME/.password-store"
export PS1="\n\[\033[0;31m\]\W\$(branch) $\[\033[0m\] "
export VAULT_ADDR='https://vault.pusherplatform.io:8200'

export PATH="$HOME/bin:$HOME/.cargo/bin:$GOPATH/bin:$PATH"
