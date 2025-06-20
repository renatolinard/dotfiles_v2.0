#!/bin/bash

#----Verifica se o shell está no modo interativo----
iatest=$(expr index "$-" i)
#---------------------------------------------------

#-----------Fastfetch--------------
if [ -f /usr/bin/fastfetch ]; then
    fastfetch
fi
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
export VISUAL=code
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
alias kfont="kitten choose_fonts"
alias cat="bat"
alias dots='git --git-dir=$HOME/.dotfiles_v2.0/ --work-tree=$HOME'
alias hypr='dbus-launch --exit-with-session Hyprland'
alias chat="firefox --new-window https://chat.openai.com && exit"
alias .fls="cd ~/Downloads/dotfiles/"
alias kty="nvim ~/.config/kitty/kitty.conf"
alias .tmux="nvim ~/.tmux.conf"
alias work="tmux new -s WORKSTATION"
alias mkdir="mkdir -p"
alias cls="clear" 
alias vim='nvim'
alias v='nvim'
alias music="ncmpcpp"
alias vrc="vim ~/.vim/vimrc"
alias nvrc="cd ~/.config/nvim/lua/ && vim ."
alias ~='cd ~'
alias ..='cd ..'
alias ls="exa"
alias lh="ls -lh"
alias la="ls -la"
alias bashrc="vim ~/.bashrc"
alias upd="sudo pacman -Syyu && yay -Syu"
export PATH=$PATH:~/.config/hypr/scripts
export PATH=$PATH:/home/renatolinard/.cargo/bin
#------------------------------------------------------------------------------

#------------------------------FUNÇÕES-----------------------------------------

#------"exa" after "cd"-----------
cd ()
{
	if [ -n "$1" ]; then
		builtin cd "$@" && exa -lh
	else
		builtin cd ~ && exa -lh
	fi
}

#-------Limpeza de cache------------
clstemp () {
    sudo pacman -Rns $(pacman -Qtdq)
    yay -Scc
}

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

#------------------pesquisar youtube-------------------------------------------
 # Função para pesquisar e tocar vídeos do YouTube com mpv
    yt() {
      mpv "ytdl://ytsearch100:$*"
    }
#-----------------------------------------------------------------------------

#--- Encontrar um arquivo com fzf+bat e abri-lo com nvim
fv() {
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

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
