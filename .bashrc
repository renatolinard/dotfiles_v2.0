#!/bin/bash

#----Verifica se o shell está no modo interativo----
iatest=$(expr index "$-" i)
#---------------------------------------------------

#-----------Fastfetch--------------
# if [ -f /usr/bin/fastfetch ]; then
#     fastfetch
# fi
fastfetch
#----------------------------------

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
#---------------------------------------------------------

#------------------Prompt starship------------------------
eval "$(starship init bash)"
#--------------------------------------------------------

#-----------------Permitir copiar no tmux/vim com C+S+v-----------------------
# Desabilita o "Bracketed Paste Mode" para evitar erros de colagem dentro do tmux/nvim
bind 'set enable-bracketed-paste off'

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

# Opções padrão do FZF para ativar o preview kanagawa
export FZF_DEFAULT_OPTS='--height 40% --layout=reverse --border --preview --color=bg:-1,bg+:#2A2A37,fg:-1,fg+:#DCD7BA,hl:#938AA9,hl+:#c4746e
--color=header:#b6927b,info:#658594,pointer:#7AA89F
--color=marker:#7AA89F,prompt:#c4746e,spinner:#8ea49e'

#----------- Ignore case on auto-completion--------------------------
if [[ $iatest -gt 0 ]]; then bind "set completion-ignore-case on"; fi
#--------------------------------------------------------------------

#-- Show auto-completion list automatically, without double tab-----
if [[ $iatest -gt 0 ]]; then bind "set show-all-if-ambiguous On"; fi
#-------------------------------------------------------------------

#-----------Substituir sino por sinal visual------------------
if [[ $iatest -gt 0 ]]; then bind "set bell-style visible"; fi
#-------------------------------------------------------------

#------------------------------GENERAL ALIAS´S---------------------------------
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
alias ls="exa"
alias lh="ls -lh"
alias la="ls -la"
alias bashrc="vim ~/.bashrc"
alias upd="sudo pacman -Syyu && yay -Syu"
alias ask='gemini'

###alias dots###
alias ds="dots status"
alias da="dots add"
alias dp="dots push"

###alias git###
alias gs="git status"
alias ga="git add"
alias gp="git push"
#--- PATH ---
export PATH=$PATH:~/.config/hypr/scripts
export PATH=$PATH:/home/renatolinard/.cargo/bin

# ===================================================================
# FUNÇÕES E ALIASES PARA A GEMINI CLI 
# ===================================================================

# 1. O Tradutor de Erros (agora salva as respostas)
# Use: what... <comando que deu erro>
#-------------------------------------------------------------------
what() {
    # Define o diretório de notas e o nome do arquivo com data e hora
    local notes_dir="$HOME/gemini_notes"
    local output_file="$notes_dir/what_$(date +'%Y-%m-%d').md"

    # Garante que o diretório de notas exista
    mkdir -p "$notes_dir"

    # Executa o comando e canaliza a saída para a Gemini, que por sua vez
    # é exibida no terminal E salva no arquivo de nota pelo comando 'tee'.
    "$@" 2>&1 | gemini -p "Explique de maneira simples a saída ou o erro do 
    seguinte comando e sugira uma solução. Esse resposta será uma nota em 
    markdown" | tee "$output_file"
}

explain() {
    local notes_dir="$HOME/gemini_notes"
    local output_file="$notes_dir/explain_$(date +'%Y-%m-%d').md"
    mkdir -p "$notes_dir"

    # Verifica se o argumento é uma URL ou um arquivo local
    if [[ "$1" == http* ]]; then
        curl -sL "$1" | gemini -p "Explique com uma linguagem simples o conteúdo 
        desta página da web e crie um resumo com os pontos principais, organize
        toda a reposta em markdown" | tee "$output_file"
    else
        cat "$1" | gemini -p "Explique com uma linguagem simples este arquivo 
        de configuração/script e crie um resumo com os pontos principais, organize 
        toda resposta em markdown" | tee "$output_file"
    fi
}
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

#------------------Extrair arquivos-----------------------------
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


#------------------------------------------------------------------------------
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
