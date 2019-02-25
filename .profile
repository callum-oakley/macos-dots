#! /bin/bash

alias cat='bat --theme=GitHub -p'
alias diff='colordiff -u'
alias disable-prettier="echo '**' > .prettierignore"
alias ghci='stack exec -- ghci'
alias git='hub'
alias gup='gup -t $GUP_TOKEN'
alias ls='ls -G'
alias py='python3'
alias tclip='tee >(pbcopy)'
alias tree="tree -C -I 'target|node_modules|dist|vendor|deps|_build|cover'"
alias vi='nvim'

# kubectl goodness
kube_aliases() {
  alias k$1="kubectl --context $2"
  for namespace in analytics chatkit feeds platform webhooks; do
    alias k$1${namespace:0:1}="k$1 -n $namespace"
  done
  alias k$1ac="k$1 -n analytics-chatkit"
}

kube_aliases d deneb
kube_aliases s us1-staging
kube_aliases p us1

alias ki='kubectl --context integration1'
alias kic='ki -n $(ki get ns | awk "/chatkit/ { print \$1 }")'

alias kk='KUBECONFIG="$(kind get kubeconfig-path --name="chatkit-acceptance")" kubectl'
alias kkc='kk -n chatkit-acceptance'


cd() {
  builtin cd "$@" &&
    ls -A &&
    pwd | rg -q '^/Users/callum/' &&
    { pwd | sed -e s:/Users/callum/::; cat ~/.dir-history; } | sponge ~/.dir-history &&
    nub < ~/.dir-history | sponge ~/.dir-history
}

h() {
  dir=$(cat ~/.dir-history | fzf) &&
  cd ~/"$dir"
}

b() {
  branch=$(git branch | awk '!/\*/'| fzf)
  git checkout $branch
}


branch() {
  git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
}

ps1_colour() {
  echo $PS1_COLOUR
}

fdt() {
  q=$1
  shift
  (fd -t f "$q"; tree $(fd -t d "$q") $@) | rg "$q|$"
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
shopt -s globstar
export HISTSIZE=1000000
export HISTFILESIZE="$HISTSIZE"
export HISTCONTROL=ignoreboth
export PROMPT_COMMAND="$PROMPT_COMMAND; history -a"

# nvim best vim
export VISUAL='nvim'
export EDITOR="$VISUAL"

export PS1_COLOUR='31'
export FZF_DEFAULT_COMMAND='fd -t f'
export FZF_DEFAULT_OPTS='--reverse --height 16 --color light'
export GOPATH="$HOME/code/go"
export PASSWORD_STORE_DIR="$HOME/.password-store"
export PS1="\n\[\033[0;\$(ps1_colour)m\]\W\$(branch) $\[\033[0m\] "
export VAULT_ADDR='https://vault.pusherplatform.io:8200'

# android
export ANDROID_HOME=$HOME/Library/Android/sdk
export PATH=$PATH:$ANDROID_HOME/emulator
export PATH=$PATH:$ANDROID_HOME/tools
export PATH=$PATH:$ANDROID_HOME/tools/bin
export PATH=$PATH:$ANDROID_HOME/platform-tools

export PATH="$HOME/bin:$HOME/.cargo/bin:$GOPATH/bin:/usr/local/opt/grep/libexec/gnubin:$PATH"
