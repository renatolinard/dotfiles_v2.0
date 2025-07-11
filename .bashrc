#!/bin/bash

#----Verifica se o shell está no modo interativo----
iatest=$(expr index "$-" i)
#---------------------------------------------------

#-----------Fastfetch--------------
# if [ -f /usr/bin/fastfetch ]; then
#     fastfetch
# fi
nerdfetch 
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

#----------------------------CUSTOM PROMPT ------------------------------------
# function parse_git_dirty {
#   STATUS="$(git status 2> /dev/null)"
#   if [[ $? -ne 0 ]]; then printf ""; return; else printf " ["; fi
#   if echo "${STATUS}" | grep -c "renamed:"         &> /dev/null; then printf " >"; else printf ""; fi
#   if echo "${STATUS}" | grep -c "branch is ahead:" &> /dev/null; then printf " !"; else printf ""; fi
#   if echo "${STATUS}" | grep -c "new file::"       &> /dev/null; then printf " +"; else printf ""; fi
#   if echo "${STATUS}" | grep -c "Untracked files:" &> /dev/null; then printf " ?"; else printf ""; fi
#   if echo "${STATUS}" | grep -c "modified:"        &> /dev/null; then printf " *"; else printf ""; fi
#   if echo "${STATUS}" | grep -c "deleted:"         &> /dev/null; then printf " -"; else printf ""; fi
#   printf " ]"
# }
# 
# parse_git_branch() {
#   git rev-parse --abbrev-ref HEAD 2> /dev/null
# }
# 
# prompt_comment() {
#     DIR="$HOME/.local/share/promptcomments/"
#     MESSAGE="$(find "$DIR"/*.txt | shuf -n1)"
#     cat "$MESSAGE"
# }
# 
# #PS1="\[\e[1;31m\]\$(parse_git_branch)\[\033[34m\]\$(parse_git_dirty)\n\\[\e[38;5;166m\]  \033[1;33m\]\u:\[\e[1;37m\] \w \[\e[1;36m\]\[\e[0;37m\] "
# PS1="\[\e[1;31m\]\$(parse_git_branch)\[\033[34m\]\$(parse_git_dirty)\n\\[\e[38;5;166m\]  \033[1;33m\] \w \[\e[1;36m\]\[\e[0;37m\] "
# PS2="\[\e[1;31m\]\$(parse_git_branch)\[\033[34m\]\$(parse_git_dirty)\n\\[\e[38;5;166m\]  \033[1;33m\] \w \[\e[1;36m\]\[\e[0;37m\] "

#------------------------------------------------------------------------------

#--- Define Editor--
export EDITOR=vim
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

# Opções padrão do FZF para ativar o preview com bat
export FZF_DEFAULT_OPTS='--height 40% --layout=reverse --border --preview "bat --color=always --style=numbers --line-range :500 {}"'

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
alias cls="clear" 
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

#---Matar um processo usando fzf
fk() {
    local pid
    pid=$(ps -ef | sed 1d | fzf -m | awk '{print $2}')

    if [ "x$pid" != "x" ]
    then
        echo $pid | xargs kill -${1:-9}
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

# Função 's' para gerenciamento de sessão interativo com sesh + fzf
s() {
    # Pega a seleção do fzf a partir da lista gerada pelo 'sesh list'
    # A flag --query="$1" permite que você digite algo como 's dotfiles' para já começar filtrando
    local selection
    selection=$(sesh list | fzf --query="$1")

    # Se nada for selecionado (pressionou ESC), não faz nada
    if [ -z "$selection" ]; then
        return
    fi

    # Extrai o nome da sessão (a primeira palavra da linha selecionada)
    local session_name
    session_name=$(echo "$selection" | awk '{print $1}')

    # Conecta à sessão
    tmux attach-session -t "$session_name"
}
#------------------------------------------------------------------------------
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

