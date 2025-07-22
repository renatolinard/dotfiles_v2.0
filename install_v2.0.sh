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

# --- Instalação de Ativos Locais (Fontes, Temas, Cursores) ---
echo -e "${YELLOW}--> Instalando ativos locais do repositório...${NC}"

# Instalação de Fontes
if [ -d "my-fonts-main" ]; then
    echo "Copiando fontes locais..."
    sudo cp -r my-fonts-main/** /usr/share/fonts/
fi

# Instalação de Cursores
if [ -d "my_cursors" ]; then
    echo "Copiando cursores locais..."
    sudo cp -r my_cursors/** /usr/share/icons/
fi

# Instalação do Tema GTK
if [ -d "kanagawa_gtk3" ]; then
    echo "Copiando tema GTK local..."
    sudo cp -r kanagawa_gtk3/** /usr/share/themes/
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

echo "Aplicando tema aos aplicativos Flatpak..."
sudo flatpak override --filesystem=$HOME/.themes
sudo flatpak override --filesystem=/usr/share/themes
sudo flatpak override --env=GTK_THEME=Kanagawa

echo "Atualizando o cache de fontes..."
fc-cache -fv

# Tema sddm
echo -e "${YELLOW}--> Configurando tema SDDM...${NC}"
if [ -d "/usr/share/sddm/themes/sugar-dark" ]; then
    sudo rm -r /usr/share/sddm/themes/sugar-dark
    sudo cp -r /home/renatolinard/sugar-dark /usr/share/sddm/themes/
    echo "Altera a linha 40: Current=<nome_do_tema> para Current=sugar-dark"
    sudo vim /etc/sddm.conf.d/sddm.conf
fi

# --- Finalização ---
echo -e "${GREEN}------------------------------------------------${NC}"
echo -e "${GREEN}Instalação concluída com sucesso!${NC}"
echo -e "${YELLOW}Por favor, reinicie a máquina com 'sudo reboot'.${NC}"
echo -e "${GREEN}------------------------------------------------${NC}"
