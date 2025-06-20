#!/usr/bin/env bash
#------------------------------------------------------------------------------
# Script   : dotfiles.sh
# Descrição: script para clonar repositorio dotfles do codeberg e criar ligações
                # simbolicas para os locais corretos.
# Versão   : 0.1
# Autor    : Renato Linard <renatolinardjr@gmail.com>
# Data     : 15/08/2024
# Licença  : GNU/GPL v3.0
# -----------------------------------------------------------------------------
# Uso:  ./dotfiles.sh
# -----------------------------------------------------------------------------

#testar se ja existe repositorio com esse nome
[[ -d ~/Downloads/dotfiles ]] && echo "repositorio ja existe" && exit 1

#clonar repositorio
git clone https://codeberg.org/renatolinard/dotfiles.git ~/Downloads/dotfiles 

# criar as ligações simbolicas

[[ -d ~/Downloads/dotfiles ]] && ln -s ~/Downloads/dotfiles/.bashrc ~/
[[ -d ~/Downloads/dotfiles ]] && ln -s ~/Downloads/dotfiles/.vim ~/
[[ -d ~/Downloads/dotfiles ]] && ln -s ~/Downloads/dotfiles/nvim/ ~/.config/
[[ -d ~/Downloads/dotfiles ]] && ln -s ~/Downloads/dotfiles/wallpaper ~/
[[ -d ~/Downloads/dotfiles ]] && ln -s ~/Downloads/dotfiles/kitty.conf ~/.config/kitty/
[[ -d ~/Downloads/dotfiles ]] && ln -s ~/Downloads/dotfiles/fastfetch ~/.config







