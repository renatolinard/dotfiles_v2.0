# Guia Definitivo: Criando um Setup Portátil de Dotfiles com Git Bare

Este guia documenta o processo completo para criar e gerenciar um repositório 
de "dotfiles" usando o método "bare" do Git, garantindo que seu ambiente de 
desktop seja seguro, versionado e facilmente portátil para novas máquinas.

## Fase 1: Preparação e Configuração Inicial

O objetivo desta fase é criar um repositório Git local e um remoto (no Codeberg)
e conectá-los, preparando o terreno para o gerenciamento dos seus arquivos.

### 1.1. Limpeza (Opcional)
Se estiver recomeçando, garanta um ambiente limpo:
* **No Codeberg.org:** Apague o repositório antigo.
* **Na sua máquina:** `rm -rf ~/.dotfiles_v2.0`

### 1.2. Criação dos Repositórios
1.  **Remoto:** Crie um **novo repositório vazio** no Codeberg.org (ex: `dotfiles_v2.0`).
2.  **Local:** Crie o repositório "bare" na sua máquina. O nome da pasta deve 
ser o mesmo que você usará no alias.

```bash
git init --bare $HOME/.dotfiles_v2.0
```

### 1.3. O Alias `dots`
Este é o comando mais importante. Adicione-o ao seu `~/.bashrc` para criar um 
atalho que gerenciará seus dotfiles.

```bash
# ~/.bashrc
alias dots='git --git-dir=$HOME/.dotfiles_v2.0/ --work-tree=$HOME'

Importante: Recarregue seu shell para que o alias funcione: source ~/.bashrc
1.4. O Filtro .gitignore_global

Para evitar o erro de adicionar acidentalmente todos os seus arquivos pessoais, criamos um filtro.

    Crie o arquivo de filtro:
    Bash

nvim ~/.gitignore_global

Cole este conteúdo. A lógica é: ignore tudo (*), depois libere (!) apenas o que nos interessa.

# Ignora tudo por padrão
*

# Mas NÃO ignora (re-inclui) os seguintes arquivos e pastas
!/.bashrc
!/.Xresources
!/.config/
!/.scripts/
!/install.sh
!/pkglist.txt
!/aurlist.txt
!/README.md

# Ignora a própria pasta do repositório para evitar loops
/.dotfiles_v2.0/

# Ignora pastas de cache e lixo que podem estar dentro de .config
.config/yay/

Configure o Git para usar este filtro:
Bash

    dots config --global core.excludesfile ~/.gitignore_global

1.5. Configuração Final e Conexão

    Diga ao Git para não mostrar arquivos não rastreados (deixa o dots status limpo):
    Bash

dots config --local status.showUntrackedFiles no

Conecte seu repositório local ao do Codeberg:
Bash

    # Substitua com seu usuário e nome de repo
    dots remote add origin [https://codeberg.org/renatolinard/dotfiles_v2.0.git](https://codeberg.org/renatolinard/dotfiles_v2.0.git)

Fase 2: Adicionando seus Arquivos

Agora que tudo está configurado, vamos adicionar nossos arquivos de configuração e do projeto.
2.1. Adicionando os Arquivos de Configuração (add)

Seja explícito, adicionando cada pasta ou arquivo que faz parte do seu setup.
Bash

dots add .bashrc .Xresources .config/hypr .config/waybar .config/ghostty .config/wofi .config/swaylock .config/dunst .config/starship.toml .config/nwg-look .scripts/

2.2. Adicionando os Arquivos do Projeto

Crie os arquivos README.md, install.sh, pkglist.txt e aurlist.txt na sua pasta home (~). O conteúdo para os dois primeiros está no guia PROJETO_ARQUIVOS.md. Para as listas de pacotes, execute:
Bash

pacman -Qeq > pkglist.txt
pacman -Qem > aurlist.txt

Agora, adicione-os ao Git:
Bash

dots add README.md install.sh pkglist.txt aurlist.txt

2.3. Salvando e Enviando (commit e push)

    Crie um "snapshot" das suas configurações:
    Bash

dots commit -m "Versão inicial completa do meu ambiente Hyprland Kanagawa"

Envie tudo para o Codeberg:
Bash

    dots push -u origin main

Pronto! Seu repositório está completo, seguro e pronto para ser usado.
Fase 3: Manutenção do Dia a Dia (Guia Rápido)

    Ver status: dots status
    Adicionar uma mudança: dots add <caminho/do/arquivo>
    Salvar a mudança: dots commit -m "Mensagem descritiva"
    Enviar para o Codeberg: dots push
    Desfazer uma adição errada: dots reset


---
---

# PROJETO_ARQUIVOS.md

```markdown
# Arquivos do Projeto: README.md e install.sh

Este arquivo contém o conteúdo final para o `README.md` e o `install.sh` do seu repositório de dotfiles.

## README.md

Crie um arquivo chamado `README.md` na sua pasta `home` (`~`) e cole o seguinte conteúdo nele.

```markdown
# Meus Dotfiles Hyprland (Tema Kanagawa)

Este repositório contém todas as minhas configurações pessoais para um ambiente de desktop Hyprland minimalista e funcional no Arch Linux.

O objetivo é criar um sistema portátil que pode ser implantado em uma nova instalação do Arch em minutos usando um único script.

---

## 🚀 Instalação Rápida (A Partir de um TTY)

Este guia assume que você está em uma instalação nova do Arch Linux (perfil `minimal`) com uma conexão de internet ativa.

### Passo 1: Sincronizar o Sistema e Instalar o Git

O `git` é a única dependência que precisamos instalar manualmente para começar.

```bash
sudo pacman -Syu --noconfirm && sudo pacman -S --needed --noconfirm git

Passo 2: Clonar o Repositório de Instalação

Clone este repositório para ter acesso ao script de instalação.
Bash

# Substitua com seu usuário e nome de repo
git clone https://codeberg.org/renatolinard/dotfiles_v2.0.git

Passo 3: Executar o Script de Instalação

Entre na pasta que acabamos de clonar, torne o script executável e rode-o.
Bash

cd dotfiles_v2.0
chmod +x install.sh
./install.sh

O Que o Script Faz?

O install.sh irá automatizar todo o resto:

    Instalar o yay (AUR helper).
    Ler os arquivos pkglist.txt e aurlist.txt para instalar todos os programas e dependências.
    Configurar o repositório "bare" do Git para gerenciar os dotfiles.
    Copiar todas as configurações para os locais corretos na sua pasta home.
    Definir o bash como seu shell padrão.

Após a Instalação

Depois que o script terminar, faça logout e login novamente no TTY. Em seguida, para iniciar seu novo ambiente gráfico, basta usar o alias que criamos:
Bash

hypr

Salvando Novas Alterações no Futuro

Para salvar novas mudanças nos seus arquivos de configuração, use o alias dots que está configurado no seu .bashrc:
Bash

# Para adicionar uma mudança em um arquivo
dots add ~/.config/hypr/hyprland.conf

# Para criar um "snapshot" da mudança
dots commit -m "Exemplo: ajusta atalho do terminal"

# Para enviar a mudança para o Codeberg
dots push


## install.sh

Crie um arquivo chamado `install.sh` na sua pasta `home` (`~`) e cole o seguinte conteúdo nele.

```bash
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

