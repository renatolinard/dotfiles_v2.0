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
sudo pacman -S --needed --noconfirm git base-devel

# --- Instalação do Yay ---
if ! command -v yay &> /dev/null; then
    echo -e "${YELLOW}--> Instalando o yay (AUR Helper)...${NC}"
    git clone https://aur.archlinux.org/yay.git /tmp/yay
    (cd /tmp/yay && makepkg -si --noconfirm)
    rm -rf /tmp/yay
else
    echo -e "${GREEN}--> yay já está instalado.${NC}"
fi

# --- Instalação de Fontes ---
echo -e "${YELLOW}--> Instalando fontes...${NC}"
if [ -d "my-fonts-main" ]; then
    echo "Copiando diretório de fontes 'my-fonts-main' para o sistema..."
    sudo cp -r my-fonts-main /usr/share/fonts/
    echo -e "${GREEN}Fontes locais copiadas com sucesso.${NC}"
else
    echo -e "${YELLOW}AVISO: Diretório 'my-fonts-main' não encontrado. Pulando cópia de fontes locais.${NC}"
fi
echo "Instalando fontes de ícones e emojis..."
yay -S --needed --noconfirm noto-fonts-emoji ttf-font-awesome

# --- Instalação dos Pacotes ---
echo -e "${YELLOW}--> Instalando pacotes das listas (pkglist e aurlist)...${NC}"
if [ ! -f "pkglist.txt" ] || [ ! -f "aurlist.txt" ]; then
    echo "ERRO CRÍTICO: pkglist.txt ou aurlist.txt não encontrados."
    exit 1
fi
yay -S --needed --noconfirm - < pkglist.txt
yay -S --needed --noconfirm - < aurlist.txt

# --- Configuração dos Dotfiles (Método Bare) ---
echo -e "${YELLOW}--> Configurando os dotfiles na pasta home...${NC}"
# Clona o repositório como 'bare'
git clone --bare https://codeberg.org/$GIT_USER/$GIT_REPO.git $HOME/.$GIT_REPO

# Define o comando base como uma variável
DOTS_CMD="git --git-dir=$HOME/.$GIT_REPO/ --work-tree=$HOME"
$DOTS_CMD checkout -f
$DOTS_CMD config --local status.showUntrackedFiles no

# --- Configurações Pós-Instalação ---
echo -e "${YELLOW}--> Executando tarefas de pós-instalação...${NC}"
# Habilitando serviços essenciais
echo "Habilitando NetworkManager e Bluetooth..."
sudo systemctl enable --now NetworkManager.service
sudo systemctl enable --now bluetooth.service
sudo systemctl disable iwd.service || true

# Definir Bash como shell padrão
echo "Definindo Bash como shell padrão..."
chsh -s /bin/bash

# Configurar o Git
echo "Configurando o Git. Por favor, insira seus dados:"
read -p "Seu nome completo para o Git: " git_name
read -p "Seu e-mail para o Git: " git_email
git config --global user.name "$git_name"
git config --global user.email "$git_email"

# Aplicar tema Kanagawa aos aplicativos Flatpak
echo "Aplicando tema aos aplicativos Flatpak..."
sudo flatpak override --filesystem=$HOME/.themes
sudo flatpak override --filesystem=/usr/share/themes
sudo flatpak override --env=GTK_THEME=Kanagawa

# Atualizar o cache de fontes do sistema
echo "Atualizando o cache de fontes..."
fc-cache -fv

# --- Finalização ---
echo -e "${GREEN}------------------------------------------------${NC}"
echo -e "${GREEN}Instalação concluída com sucesso!${NC}"
echo -e "${YELLOW}Por favor, reinicie a máquina com 'sudo reboot'.${NC}"
echo -e "${GREEN}------------------------------------------------${NC}"
