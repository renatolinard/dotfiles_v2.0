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
echo -e "${BLUE}Iniciando a instalação (Adaptação Garuda Linux)...${NC}"
echo -e "${BLUE}------------------------------------------------${NC}"

# --- Instalação de Dependências ---
echo -e "${YELLOW}--> Atualizando o sistema e instalando dependências básicas...${NC}"
sudo pacman -Syu --noconfirm
# 'go' é necessário para compilar o yay
sudo pacman -S --needed --noconfirm git base-devel go

# --- Instalação do Yay ---
# O Garuda geralmente já vem com yay ou paru, mas verificamos por segurança
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
if [ ! -d "ghostty" ]; then
    git clone https://github.com/ghostty-org/ghostty
fi

#construção
if [ -d "ghostty" ]; then
    # Puxa atualizações se a pasta já existir
    (cd ghostty && git pull && sudo zig build -p /usr -Doptimize=ReleaseFast)
else 
    echo -e "${YELLOW}AVISO: Erro de instalação, faca a construção manualmente.${NC}" 
fi

#instalação e configuração Zen Browser
echo -e "${BLUE}Iniciando a instalação do Zen Browser...${NC}"
flatpak install flathub app.zen_browser.zen -y

# --- Configuração dos Dotfiles (Método Bare) ---
echo -e "${YELLOW}--> Configurando os dotfiles na pasta home...${NC}"
# Verifica se já existe para evitar erro fatal
if [ ! -d "$HOME/.$GIT_REPO" ]; then
    git clone --bare https://github.com/$GIT_USER/$GIT_REPO.git $HOME/.$GIT_REPO
else
    echo "Repositório bare já existe, apenas atualizando..."
fi

DOTS_CMD="git --git-dir=$HOME/.$GIT_REPO/ --work-tree=$HOME"
$DOTS_CMD checkout -f
$DOTS_CMD config --local status.showUntrackedFiles no

# --- Configurações Pós-Instalação ---
echo -e "${YELLOW}--> Executando tarefas de pós-instalação...${NC}"
echo "Habilitando serviços essenciais..."
systemctl --user enable mpd.service || true 

# NOTA: Removemos a habilitação forçada do SDDM pois o Garuda já cuida disso.
# sudo systemctl enable sddm.service

# O Garuda usa NetworkManager, garantimos que está ativo
sudo systemctl enable --now NetworkManager.service
sudo systemctl enable --now bluetooth.service

# Garuda costuma usar iwd ou wpa_supplicant como backend, mas desabilitar iwd explicitamente
# pode ser perigoso se o Garuda depender dele. Comentei por segurança, mas pode descomentar se preferir.
# sudo systemctl disable iwd.service || true

echo "Definindo Bash como shell padrão..."
# O Garuda usa Fish por padrão. Se você quiser manter o Fish, comente a linha abaixo.
chsh -s /bin/bash

echo "Configurando o Git..."
read -p "Seu nome completo para o Git: " git_name
read -p "Seu e-mail para o Git: " git_email
git config --global user.name "$git_name"
git config --global user.email "$git_email"

echo "Atualizando o cache de fontes..."
fc-cache -fv

# --- REMOVIDO: Configuração do Tema SDDM (Mantendo o do Garuda) ---
# O bloco original foi removido para preservar o Sweet-KDE/Dragonized do Garuda.

# --- REMOVIDO: Configuração Grub Theme (Mantendo o do Garuda) ---
# O bloco original foi removido para preservar o GRUB do Garuda.

# --- Configuração do Caps Lock (Ctrl/Esc) ---
echo -e "${YELLOW}--> Configurando Caps Lock para funcionar como Ctrl/Esc...${NC}"

# Cria o arquivo de configuração para o udevmon.
sudo tee /etc/interception/udevmon.d/caps2esc.yml > /dev/null <<'EOF'
- JOB: intercept -g $DEVNODE | caps2esc | uinput -d $DEVNODE
  DEVICE:
    EVENTS:
      EV_KEY: [KEY_CAPSLOCK]
EOF

# Habilita o serviço que monitora os dispositivos para iniciar no próximo boot.
echo "Habilitando o serviço udevmon..."
sudo systemctl enable udevmon.service

# --- Finalização ---
echo -e "${GREEN}------------------------------------------------${NC}"
echo -e "${GREEN}Instalação dos dotfiles concluída!${NC}"
echo -e "${YELLOW}O GRUB e o SDDM originais do Garuda foram preservados.${NC}"
echo -e "${YELLOW}Por favor, reinicie a máquina com 'sudo reboot'.${NC}"
echo -e "${GREEN}------------------------------------------------${NC}"
