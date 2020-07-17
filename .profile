#! /usr/bin/env bash

alias diff='colordiff -u'
alias disable-prettier="echo '**' > .prettierignore"
alias ggf='gotta-go-fast'
alias ghci='stack exec -- ghci'
alias git='hub'
alias gup='gup -t $GUP_TOKEN'
alias less='nvim - -R'
alias ls='ls -G --color'
alias pi='pip3'
alias py='python3'
alias rg="rg --colors 'path:none' --colors 'line:none'"
alias tclip='tee >(pbcopy)'
alias tree="tree -I 'target|node_modules|dist|vendor|deps|_build|cover'"
alias uuid='uuid -v4'
alias vi='nvim'

for context in mt1 testk8s us1-staging us1 global global-staging; do
    alias $context="kubectl --context $context"
done

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


vih() {
  vi +":help $@" +:on
}

[ -f ~/.fzf.bash ] && source ~/.fzf.bash
[ -f ~/.config/secrets/env ] && source ~/.config/secrets/env

export BASH_COMPLETION_COMPAT_DIR='/usr/local/etc/bash_completion.d'
[ -f /usr/local/etc/profile.d/bash_completion.sh ] && source /usr/local/etc/profile.d/bash_completion.sh

# history config
shopt -s histappend
shopt -s cmdhist
shopt -s globstar
export HISTSIZE=1000000
export HISTFILESIZE="$HISTSIZE"
export HISTCONTROL=ignoreboth
export PROMPT_COMMAND='history -a'

# put current directory in kitty tab title
if [ $KITTY_WINDOW_ID ]; then
  export PROMPT_COMMAND='kitty @ set-tab-title "${PWD##*/}";'"$PROMPT_COMMAND"
fi

# nvim best vim
export VISUAL='nvim'
export EDITOR="$VISUAL"
export PAGER='ansifilter | nvim - -R'
export MANPAGER='ansifilter | nvim - -R +":setfiletype man"'
export MANWIDTH=999

export LS_COLORS="fi=30:di=30;1:ex=31:pi=30:so=30:bd=30:cd=30:ln=31;1:or=30;41;1"
export PS1_COLOUR='31'
export FZF_DEFAULT_COMMAND='fd -t f'
export FZF_DEFAULT_OPTS='--reverse --height 16 --color "fg:0,bg:15,preview-fg:0,preview-bg:15,hl:1,fg+:0,bg+:7,gutter:15,hl+:1,info:0,border:15,prompt:0,pointer:0,spinner:0"'
export GOPATH="$HOME/code/go"
export PS1="\n\[\033[0;\$(ps1_colour)m\]\W\$(branch) $\[\033[0m\] "
export VAULT_ADDR='https://vault.pusherplatform.io:8200'
export QMK_HOME="$HOME/code/qmk_firmware"
export NODE_DISABLE_COLORS=1

export GPG_TTY=$(tty)

export PATH="/usr/local/opt/coreutils/libexec/gnubin:$HOME/Library/Python/3.8/bin:$HOME/bin:$HOME/.local/bin:$HOME/.cargo/bin:$GOPATH/bin:/usr/local/opt/gnu-sed/libexec/gnubin:/usr/local/opt/grep/libexec/gnubin:$PATH"
