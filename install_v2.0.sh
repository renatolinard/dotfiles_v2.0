#!/bin/bash

# --- Configuração de Segurança ---
set -e

# --- Definição de Cores para a Saída ---
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# --- Variáveis do Repositório ---
GIT_USER="renatolinard"
GIT_REPO="dotfiles_v2.0"

# --- Início do Script ---
echo -e "${BLUE}------------------------------------------------${NC}"
echo -e "${BLUE}Iniciando a instalação do ambiente Hyprland...${NC}"
echo -e "${BLUE}------------------------------------------------${NC}"

# --- Instalação de Dependências ---
echo -e "${YELLOW}--> Atualizando o sistema e instalando dependências básicas...${NC}"
sudo pacman -Syu --noconfirm
# 'go' é necessário para compilar o yay
sudo pacman -S --needed --noconfirm git base-devel go

# --- Instalação do Yay ---
if ! command -v yay &> /dev/null; then
    echo -e "${YELLOW}--> Instalando o yay (AUR Helper)...${NC}"
    git clone https://aur.archlinux.org/yay.git /tmp/yay
    (cd /tmp/yay && makepkg -si --noconfirm)
    rm -rf /tmp/yay
else
    echo -e "${GREEN}--> yay já está instalado.${NC}"
fi

# --- Instalação dos Pacotes
echo -e "${YELLOW}--> Instalando pacotes das listas (pkglist e aurlist)...${NC}"
if [ ! -f "pkglist.txt" ] || [ ! -f "aurlist.txt" ]; then
    echo "ERRO CRÍTICO: pkglist.txt ou aurlist.txt não encontrados."
    exit 1
fi
yay -S --needed --noconfirm - < pkglist.txt
yay -S --needed --noconfirm - < aurlist.txt

# --- ativos locais(Fontes, Temas, Cursores) ---
echo -e "${YELLOW}--> Instalando ativos locais do repositório...${NC}"

# Instalação de Fontes
if [ -d "ativos/my-fonts-main" ]; then
    echo "Copiando fontes locais..."
    sudo cp -r ativos/my-fonts-main/** /usr/share/fonts/
fi

# Instalação de Cursores
if [ -d "ativos/my_cursors" ]; then
    echo "Copiando cursores locais..."
    sudo cp -r ativos/my_cursors/** /usr/share/icons/
fi

# Instalação do Tema GTK
if [ -d "ativos/kanagawa_gtk3" ]; then
    echo "Copiando tema GTK local..."
    sudo cp -r ativos/kanagawa_gtk3/** /usr/share/themes/
fi

# instalação ghostty from source
echo -e "${YELLOW}--> Built ghostty from source...${NC}"
#clone ultimas atualizações 
git clone https://github.com/ghostty-org/ghostty
#construção
if [ -d "ghostty" ]; then
    (cd ghostty && sudo zig build -p /usr -Doptimize=ReleaseFast)
else 
    echo -e "${YELLOW}AVISO: Erro de instalação, faca a construção 
    manualmente.${NC}" 
fi

#instalação e configuração Zen Browser
echo -e "${BLUE}Iniciando a instalação do Zen Browser...${NC}"
flatpak install flathub app.zen_browser.zen

#instalação neovim from source 
echo -e "${YELLOW}--> Built neovim from source...${NC}"
#instalação limpa
rm -rf ~/.config/nvim
rm -rf ~/.local/state/nvim
rm -rf ~/.local/share/nvim
#clone ultimas atualizações 
git clone https://github.com/neovim/neovim
#construção
if [ -d "neovim" ]; then
    (cd neovim && make CMAKE_BUILD_TYPE=RelWithDebInfo && sudo make install)
    rm -rf ~/neovim
else 
    echo -e "${YELLOW}AVISO: Erro de instalação, faca a construção 
    manualmente.${NC}" 
fi

# --- Configuração dos Dotfiles (Método Bare) ---
echo -e "${YELLOW}--> Configurando os dotfiles na pasta home...${NC}"
git clone --bare https://github.com/$GIT_USER/$GIT_REPO.git $HOME/.$GIT_REPO

DOTS_CMD="git --git-dir=$HOME/.$GIT_REPO/ --work-tree=$HOME"
$DOTS_CMD checkout -f
$DOTS_CMD config --local status.showUntrackedFiles no

# --- Configurações Pós-Instalação ---
echo -e "${YELLOW}--> Executando tarefas de pós-instalação...${NC}"
echo "Habilitando serviços essenciais..."
systemctl --user enable mpd.service || true # Tenta habilitar como usuário
sudo systemctl enable sddm.service
sudo systemctl enable --now NetworkManager.service
sudo systemctl enable --now bluetooth.service
sudo systemctl disable iwd.service || true

echo "Definindo Bash como shell padrão..."
chsh -s /bin/bash

echo "Configurando o Git..."
read -p "Seu nome completo para o Git: " git_name
read -p "Seu e-mail para o Git: " git_email
git config --global user.name "$git_name"
git config --global user.email "$git_email"

echo "Atualizando o cache de fontes..."
fc-cache -fv

# --- Configuração do Tema SDDM
echo -e "${YELLOW}--> Configurando tema SDDM (Sugar Dark)...${NC}"
if [ -d "ativos/sugar-dark" ]; then
    sudo rm -rf /usr/share/sddm/themes/sugar-dark
    sudo cp -r ativos/sugar-dark /usr/share/sddm/themes/
    sudo mkdir -p /etc/sddm.conf.d
    sudo cp ativos/sugar-dark/sddm.conf /etc/sddm.conf.d
else
    echo -e "${YELLOW}AVISO: Diretório do tema não encontrado no repositório.
    Pulando configuração do SDDM.${NC}"
fi

# --- confuguração grub theme
echo -e "${YELLOW}--> Configurando tema dark matter para o grub...${NC}"
if [ -d "ativos/darkmatter" ]; then
    sudo cp -r ativos/darkmatter /boot/grub/themes/
    # copy grub config file
    sudo rm /etc/default/grub 
    sudo cp ativos/darkmatter/grub /etc/default/
    # update the grub
    sudo grub-mkconfig -o /boot/grub/grub.cfg
else 
    echo -e "${YELLOW}AVISO: Diretório do tema não encontrado no repositório.
    Pulando configuração do SDDM.${NC}"
fi

# --- Finalização ---
echo -e "${GREEN}------------------------------------------------${NC}"
echo -e "${GREEN}Instalação concluída com sucesso!${NC}"
echo -e "${YELLOW}Por favor, reinicie a máquina com 'sudo reboot'.${NC}"
echo -e "${GREEN}------------------------------------------------${NC}"
