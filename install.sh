#!/bin/bash

echo "------------------------------------------------"
echo "Iniciando a instalação do ambiente Hyprland..."
echo "------------------------------------------------"

# --- Variáveis do Repositório ---
GIT_USER="renatolinard"
GIT_REPO="dotfiles_v2.0"

# --- Instalação de Dependências ---
echo "Atualizando o sistema e instalando dependências básicas..."
sudo pacman -Syu --noconfirm
sudo pacman -S --needed --noconfirm git base-devel

# --- Instalação do Yay ---
if ! command -v yay &> /dev/null; then
    echo "Instalando o yay..."
    git clone https://aur.archlinux.org/yay.git /tmp/yay
    pushd /tmp/yay > /dev/null
    makepkg -si --noconfirm
    popd > /dev/null
    rm -rf /tmp/yay
else
    echo "yay já está instalado."
fi

# --- Instalação dos Pacotes (com caminhos simplificados) ---
echo "Instalando pacotes das listas..."

# Verifica se os arquivos de lista existem na pasta atual
if [ ! -f "pkglist.txt" ] || [ ! -f "aurlist.txt" ]; then
    echo "ERRO CRÍTICO: Os arquivos pkglist.txt ou aurlist.txt não foram encontrados."
    echo "Certifique-se de que eles existem no repositório e que você está executando o script de dentro da pasta clonada."
    exit 1
fi

yay -S --needed --noconfirm - < pkglist.txt
yay -S --needed --noconfirm - < aurlist.txt

# --- Configuração dos Dotfiles (Método Bare) ---
echo "Configurando os dotfiles na pasta home..."
# Clona o repositório como 'bare' para o local correto
git clone --bare https://codeberg.org/$GIT_USER/$GIT_REPO.git $HOME/.$GIT_REPO

# Define o comando base como uma variável para robustez
DOTS_CMD="git --git-dir=$HOME/.$GIT_REPO/ --work-tree=$HOME"

# Faz o checkout forçado dos arquivos
$DOTS_CMD checkout -f

# Configura o repositório
$DOTS_CMD config --local status.showUntrackedFiles no

# --- Configurações Finais ---
echo "Definindo Bash como shell padrão..."
chsh -s /bin/bash

echo "------------------------------------------------"
echo "Instalação concluída!"
echo "Por favor, reinicie a máquina com 'sudo reboot'."
echo "Após reiniciar, faça o login e inicie o Hyprland com o alias 'hypr'."
echo "------------------------------------------------"
