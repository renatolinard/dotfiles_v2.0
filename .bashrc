#!/bin/bash

#----Verifica se o shell está no modo interativo----
iatest=$(expr index "$-" i)
#---------------------------------------------------

#-----------Fastfetch--------------
if [ -f /usr/bin/fastfetch ]; then
    fastfetch
fi
#----------------------------------

# ================================= fzf ================================= #

_fzf_comprun() {
    local command=$1
    shift

    case "$command" in
        cd)           fzf --preview 'eza --tree --color=always {} | head -200' "$@" ;;
        export|unset) fzf --preview "eval 'echo \${}'"         "$@" ;;
        ssh)          fzf --preview 'dig {}'                   "$@" ;;
        *)            fzf --preview "$show_file_or_dir_preview" "$@" ;;
    esac
}

# Configure FZF for directory preview
if command -v fzf &> /dev/null; then
    _fzf_preview() {
        eza --color=always --icons=always "$1"
    }
fi


# --- pywal ---
cat ~/.cache/wal/sequences

#----configurações globais ---------
if [ -f /etc/bashrc ]; then
    . /etc/bashrc
fi
#-----------------------------------

#---funcionalidade de auto-completar comandos-------------
if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
fi

#------------------Prompt starship------------------------
eval "$(starship init bash)"
#--------------------------------------------------------

#--- Define Editor--
export EDITOR=nvim
export VISUAL=nvim
#-------------------

# ---renderizar paginas do man com bat--
export MANPAGER="sh -c 'col -bx | bat -l man -p'"
# ------------------------
#
# ----Ativação dos scripts do FZF para Bash
source /usr/share/fzf/key-bindings.bash
source /usr/share/fzf/completion.bash
#-------------------------------------------

#----------- Ignore case on auto-completion--------------------------
if [[ $iatest -gt 0 ]]; then bind "set completion-ignore-case on"; fi
#--------------------------------------------------------------------

#-- Show auto-completion list automatically, without double tab-----
if [[ $iatest -gt 0 ]]; then bind "set show-all-if-ambiguous On"; fi
#-------------------------------------------------------------------

#------------------------------GENERAL ALIAS´S---------------------------------
alias reload="source ~/.bashrc"
alias lock="swaylock"
alias cat="bat"
alias blue="bluetuith"
alias dots='git --git-dir=$HOME/.dotfiles_v2.0/ --work-tree=$HOME'
alias .tmux="nvim ~/.tmux.conf"
alias work="tmux new -s WORKSTATION"
alias mkdir="mkdir -p"
alias cls="clear && fastfetch" 
alias vim='nvim'
alias v='nvim'
alias play="mpv"
alias nvrc="cd ~/.config/nvim/lua/ && vim ."
alias ~='cd ~'
alias ..='cd ..'
alias ls="eza -T --level=1 --color=always --icons=always"
alias lh="eza -lh --icons=always"
alias la="eza -la --icons=always"
alias lt="eza -T --level=3 --color=always --icons=always"
alias bashrc="vim ~/.bashrc"
alias upd="sudo pacman -Syyu && yay -Syu"
alias ask='gemini'

###alias dots###
alias ds="dots status"
alias da="dots add"
alias dp="dots push"
alias db="dots branch"
alias dcc="dots checkout"

###alias git###
alias gs="git status"
alias ga="git add"
alias gp="git push"
#--- PATH ---
export PATH=$PATH:~/.config/hypr/scripts
export PATH=$PATH:/home/renatolinard/.cargo/bin

# =======
# FUNÇÕES
# =======

#------"exa" after "cd"----------------------
cd ()
{
    if [ -n "$1" ]; then
        builtin cd "$@" && exa -lh
    else
        builtin cd ~ && exa -lh
    fi
}
#--------------------------------------------

#------------------Extrair arquivos------------
ex ()
{
    if [ -f $1 ] ; then
        case $1 in
            *.tar.bz2)   tar xjf $1   ;;
            *.tar.gz)    tar xzf $1   ;;
            *.bz2)       bunzip2 $1   ;;
            *.rar)       unrar x $1   ;;
            *.gz)        gunzip $1    ;;
            *.tar)       tar xf $1    ;;
            *.tbz2)      tar xjf $1   ;;
            *.tgz)       tar xzf $1   ;;
            *.zip)       unzip $1     ;;
            *.Z)         uncompress $1;;
            *.7z)        7za e x $1   ;;
            *.deb)       ar x $1      ;;
            *.tar.xz)    tar xf $1    ;;
            *.tar.zst)   unzstd $1    ;;
            *)           echo "'$1' cannot be extracted via ex()" ;;
        esac
    else
        echo "'$1' is not a valid file"
    fi
}
#------------------------------------------------------------------------------

#--- Encontrar um arquivo com fzf+bat e abri-lo com nvim
ff() {
    local file
    file=$(fzf --preview 'bat --color=always --style=numbers {}' --query="$1" --height=80%)
    if [ -n "$file" ]; then
        nvim "$file"
    fi
}

#----Commit dots
dc() {
    # Pede ao usuário para digitar a mensagem e a salva na variável 'commit_message'
    read -p "Digite a mensagem do commit: " commit_message

    # Verifica se a mensagem não está vazia
    if [ -z "$commit_message" ]; then
        echo "Mensagem de commit vazia. Abortando."
        return 1 # Retorna com um erro
    fi

    # Executa o commit usando a mensagem fornecida
    # As aspas duplas são importantes para lidar com mensagens com espaços
    dots commit -m "$commit_message"
}

gc() {
    # Pede ao usuário para digitar a mensagem e a salva na variável 'commit_message'
    read -p "Digite a mensagem do commit: " commit_message

    # Verifica se a mensagem não está vazia
    if [ -z "$commit_message" ]; then
        echo "Mensagem de commit vazia. Abortando."
        return 1 # Retorna com um erro
    fi

    # Executa o commit usando a mensagem fornecida
    # As aspas duplas são importantes para lidar com mensagens com espaços
    git commit -m "$commit_message"
}

y() {
    local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
    yazi "$@" --cwd-file="$tmp"
    IFS= read -r -d '' cwd < "$tmp"
    [ -n "$cwd" ] && [ "$cwd" != "$PWD" ] && builtin cd -- "$cwd"
    rm -f -- "$tmp"
}

# ~/.bashrc

# Função para fazer uma limpeza completa do sistema
clstemp() {
    echo "--> Procurando por pacotes órfãos..."
    # Lista os pacotes para revisão antes de perguntar
    pacman -Qtdq | sudo pacman -Rns -

    echo -e "\n--> Limpando o cache de pacotes (pacman e yay)..."
    yay -Scc

    echo -e "\nLimpeza concluída!"
}

#------------------------------------------------------------------------------
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

eval "$(zoxide init bash)"
