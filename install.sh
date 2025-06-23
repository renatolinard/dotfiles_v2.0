#!/usr/bin/env bash
#------------------------------------------------------------------------------
# Script   : install.sh
# Descrição: Instalção completa do hyprland
# Versão   : 2.0
# Autor    : Renato Linard <renatolinardjr@gmail.com>
# Data     : 20/06/2025
# Licença  : GNU/GPL v3.0
# -----------------------------------------------------------------------------
# Uso: install.sh ./install.sh
# -----------------------------------------------------------------------------

#!/bin/bash

echo "------------------------------------------------"
echo "Iniciando a instalação do ambiente Hyprland..."
echo "------------------------------------------------"

# --- Variáveis do Repositório ---
GIT_USER="renatolinard"
GIT_REPO="dotfiles_v2.0"

# --- Encontra o diretório de onde o script está sendo executado ---
SCRIPT_DIR=<span class="math-inline">\( cd \-\- "</span>( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

# --- Instalação de Dependências ---
echo "Atualizando o sistema e instalando dependências básicas..."
sudo pacman -Syu --noconfirm
sudo pacman -S --needed --noconfirm git base-devel

# --- Instalação do Yay ---
if ! command -v yay &> /dev/null; then
    echo "Instalando o yay..."
    git clone [https://aur.archlinux.org/yay.git](https://aur.archlinux.org/yay.git) /tmp/yay
    (cd /tmp/yay && makepkg -si --noconfirm)
    rm -rf /tmp/yay
else
    echo "yay já está instalado."
fi

# --- Instalação dos Pacotes ---
echo "Instalando pacotes das listas..."
yay -S --needed --noconfirm - < "$SCRIPT_DIR/pkglist.txt"
yay -S --needed --noconfirm - < "$SCRIPT_DIR/aurlist.txt"

# --- Configuração dos Dotfiles (Método Bare) ---
echo "Configurando os dotfiles na pasta home..."
# Remove o diretório clonado para dar lugar ao método bare
cd ~
rm -rf "$SCRIPT_DIR"

# Clona o repositório como 'bare' para o local correto
git clone --bare [https://codeberg.org/$GIT_USER/$GIT_REPO.git](https://codeberg.org/$GIT_USER/$GIT_REPO.git) $HOME/.$GIT_REPO

# Define um alias temporário para usar no script
alias dots_temp='git --git-dir=$HOME/.$GIT_REPO/ --work-tree=$HOME'

# Faz o checkout forçado dos arquivos, criando um backup de qualquer arquivo conflitante
dots_temp checkout -f

# Configura o repositório para não mostrar arquivos não rastreados
dots_temp config --local status.showUntrackedFiles no

# --- Configurações Finais ---
echo "Definindo Bash como shell padrão..."
chsh -s /bin/bash

echo "------------------------------------------------"
echo "Instalação concluída!"
echo "Faça logout e login novamente para que o alias 'dots' do seu .bashrc funcione."
echo "Depois, inicie o Hyprland com o alias 'hypr'."
echo "------------------------------------------------"
