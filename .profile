#! /usr/bin/env bash

alias cp='cp -riv'
alias diff='colordiff -u'
alias disable-prettier="echo '**' > .prettierignore"
alias ggf='gotta-go-fast'
alias ghci='stack exec -- ghci'
alias ls='ls -G --color'
alias mkdir='mkdir -vp'
alias mv='mv -iv'
alias rg="rg --colors 'path:none' --colors 'line:none'"
alias tclip='tee >(pbcopy)'
alias tree="tree -I 'target|node_modules|dist|vendor|deps|_build|cover'"
alias vi='nvim'

# Passes aliases to root
alias sudo='sudo '

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

pe() {
    pipenv run python -c "from src.problem_$1 import main; print(main())"
}

pet() {
    pipenv run python test.py $@
}

spell() {
    cat $@ | ispell -l | sort | uniq
}

[ -f ~/.fzf.bash ] && source ~/.fzf.bash

export BASH_COMPLETION_COMPAT_DIR='/usr/local/etc/bash_completion.d'
[ -f /usr/local/etc/profile.d/bash_completion.sh ] && source /usr/local/etc/profile.d/bash_completion.sh

# history config
shopt -s histappend
shopt -s globstar
HISTSIZE=
HISTFILESIZE=
HISTCONTROL=ignoredups:erasedups
HISTFILE=~/.bash_eternal_history
PROMPT_COMMAND="history -a"

if [ $KITTY_WINDOW_ID ]; then
    # put current directory in kitty tab title
    export PROMPT_COMMAND='kitty @ set-tab-title "$(tab-title)"; '"$PROMPT_COMMAND"

    # Copy terminfo: https://sw.kovidgoyal.net/kitty/faq.html#i-get-errors-about-the-terminal-being-unknown-or-opening-the-terminal-failing-when-sshing-into-a-different-computer
    alias ssh='kitty +kitten ssh'
fi

export VISUAL='nvim'
export EDITOR="$VISUAL"
export LS_COLORS="fi=30:di=30;1:ex=31:pi=30:so=30:bd=30:cd=30:ln=31;1:or=30;41;1"
export PS1_COLOUR='31'
export FZF_DEFAULT_COMMAND='fd -t f'
export FZF_DEFAULT_OPTS='--reverse --height 16 --color "fg:0,bg:15,preview-fg:0,preview-bg:15,hl:1,fg+:0,bg+:7,gutter:15,hl+:1,info:0,border:15,prompt:0,pointer:0,spinner:0"'
export GOPATH="$HOME/code/go"
export PS1="\n\[\033[0;\$(ps1_colour)m\]\W\$(branch) $\[\033[0m\] "
export NODE_DISABLE_COLORS=1
export _ZO_ECHO=1

export GPG_TTY=$(tty)

[ -f ~/.config/secrets/env ] && source ~/.config/secrets/env

export PATH="/usr/local/opt/python@3.9/libexec/bin:$HOME/bin:$HOME/.local/bin:$HOME/.cargo/bin:$GOPATH/bin:/usr/local/opt/coreutils/libexec/gnubin:/usr/local/opt/gnu-sed/libexec/gnubin:/usr/local/opt/grep/libexec/gnubin:/usr/local/opt/findutils/libexec/gnubin:/opt/homebrew/bin:/opt/homebrew/opt/gnu-sed/libexec/gnubin:$PATH"

eval "$(direnv hook bash)"
eval "$(zoxide init bash)"
alias j='z'
