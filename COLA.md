# Folha de Comandos (Cola) - Setup Hyprland Completo

Este é um guia de referência rápida com os principais comandos e conceitos que 
usamos para construir e gerenciar o ambiente Hyprland.

## 1\. Instalação de Pacotes

#### Pacotes dos Repositórios Oficiais (`pacman`)

```bash
# Comando consolidado para instalar todos os pacotes essenciais do Arch
sudo pacman -S --needed hyprland ghostty thunar waybar wofi hyprpaper dunst 
polkit-kde-agent playerctl swaylock grim slurp wl-clipboard jq pamixer fastfetch
bash-completion exa tmux unrar unzip p7zip mpv bluez bluez-utils papirus-icon-theme 
xdg-desktop-portal-gtk git base-devel
```

#### Pacotes do AUR (`yay`)

```bash
# Instalação do yay (se necessário)
# git clone https://aur.archlinux.org/yay.git /tmp/yay && (cd /tmp/yay && makepkg -si)

# Comando consolidado para instalar os pacotes do AUR
yay -S --needed nvm wlogout bluetuith kanagawa-gtk-theme-git bibata-cursor-theme
catppuccin-cursors-mocha swaylock-effects starship
```

#### Pacotes Flatpak

```bash
# Instalação do Zen Browser via Flatpak
flatpak install flathub io.github.zen_browser.zen
```

## 2\. Gerenciamento de Sistema e Serviços

#### Serviços (`systemctl`)

```bash
# Habilita e inicia o serviço de Bluetooth no boot
sudo systemctl enable --now bluetooth.service
```

#### Shell Padrão (`chsh`)

```bash
# Define o Bash como o shell padrão do usuário
chsh -s /bin/bash
```

## 3\. Gerenciamento de Dotfiles (Git Bare)

#### O Alias (Coração do Método)

```bash
# Adicionar ao ~/.bashrc
alias dots='git --git-dir=$HOME/.dotfiles_v2.0/ --work-tree=$HOME'
```

#### Configuração Inicial

```bash
# Criar o repositório local "bare"
git init --bare $HOME/.dotfiles_v2.0

# Configurar o Git para usar o arquivo de ignore global
dots config --global core.excludesfile ~/.gitignore_global

# Conectar ao repositório remoto (exemplo)
dots remote add origin https://codeberg.org/renatolinard/dotfiles_v2.0.git
```

#### Fluxo de Trabalho do Dia a Dia

```bash
# Ver o status dos arquivos de configuração
dots status

# Adicionar um arquivo específico para ser rastreado
dots add ~/.config/hypr/hyprland.conf

# Salvar as mudanças com uma mensagem
dots commit -m "Minha mensagem de commit"

# Enviar as mudanças para o Codeberg
dots push
```

#### Comandos de Reparo

```bash
# Limpar a "staging area" de arquivos adicionados por engano
dots reset

# Remover um arquivo do rastreamento do Git (sem apagar o arquivo local)
dots rm --cached <caminho/do/arquivo>
```

## 4\. Comandos Úteis do Dia a Dia

#### Iniciar o Ambiente Gráfico

```bash
# Alias para iniciar o Hyprland dentro de uma sessão D-Bus
hypr
```

#### Teste e Recarga

```bash
# Reiniciar a Waybar com a configuração e estilo corretos
killall waybar; waybar -c ~/.config/waybar/config -s ~/.config/waybar/style.css &

# Testar a tela de bloqueio
swaylock
```

#### Ferramentas de Linha de Comando

```bash
# Abrir o gerenciador de Bluetooth de terminal
bluetuith

# Testar as notificações
notify-send "Título" "Esta é uma notificação de teste." --icon=dialog-information

# Funções customizadas do .bashrc
fv # Encontra um arquivo com fzf/bat e o abre no nvim
fk # Mata um processo de forma interativa com fzf
```

#### Atalhos de Teclado (Lembretes)

  * **Print:** Screenshot da tela inteira.
  * **Shift + Print:** Screenshot de uma área selecionada.
  * **Alt + Print:** Screenshot da janela ativa.
  * **Teclas de Volume:** Controlam o volume com `pamixer`.

## 5\. Comandos de Diagnóstico

```bash
# Listar temas de ícones/cursores instalados para encontrar o nome exato
ls /usr/share/icons/

# Ver detalhes de um arquivo, incluindo se é um link simbólico
ls -la <caminho/do/arquivo>

# Descobrir o caminho real para o qual um link simbólico aponta
readlink -f <caminho/do/link/simbolico>

# Descobrir o caminho de um executável
which swaylock

# Ver a saída de log da Waybar em tempo real (para depuração)
waybar -c ~/.config/waybar/config -s ~/.config/waybar/style.css
```
