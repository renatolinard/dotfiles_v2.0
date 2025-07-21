# Guia de Referência Rápida (Cola) - Setup Hyprland Completo

Este é um manual de referência com os comandos e dicas mais importantes para 
gerenciar e personalizar o ambiente Hyprland construído no Arch Linux.

## 1\. Gerenciamento de Sistema (Arch Linux)

### 1.1. Atualização do Sistema

```bash
# Comando padrão para atualizar todos os pacotes
sudo pacman -Syu

# Comando para usar em caso de conflitos de arquivos (exemplo)
sudo pacman -Syu --overwrite 'usr/lib/firmware/nvidia/*'
```

  * **Dica:** A forma mais segura de resolver conflitos é mover a pasta 
  conflitante (`sudo mv /caminho/pasta /caminho/pasta.bak`) e rodar a atualização padrão.

### 1.2. Instalação de Pacotes

```bash
# Instalar pacotes dos repositórios oficiais
sudo pacman -S <nome_do_pacote>

# Instalar pacotes do AUR (Arch User Repository)
yay -S <nome_do_pacote>
```

### 1.3. Gerar Listas de Pacotes

```bash
# Pacotes oficiais instalados explicitamente
pacman -Qeq > pkglist.txt

# Pacotes do AUR instalados explicitamente
pacman -Qem > aurlist.txt
```

### 1.4. Gerenciamento de Serviços (`systemd`)

```bash
# Habilitar um serviço para iniciar no boot E iniciá-lo agora
sudo systemctl enable --now <nome_do_serviço>.service

# Desabilitar um serviço
sudo systemctl disable <nome_do_serviço>.service

# Iniciar ou parar um serviço manualmente
sudo systemctl start <nome_do_serviço>.service
sudo systemctl stop <nome_do_serviço>.service
```

## 2\. Gerenciamento de Dotfiles (Git Bare)

### 2.1. O Alias `dots`

Definido no `~/.bashrc`, é o comando principal para interagir com seus dotfiles.

```bash
alias dots='git --git-dir=$HOME/.dotfiles_v2.0/ --work-tree=$HOME'
```

### 2.2. Fluxo de Trabalho do Dia a Dia

```bash
# 1. Ver o status
dots status

# 2. Adicionar um arquivo ou pasta específica
dots add ~/.config/hypr/hyprland.conf

# 3. Salvar as mudanças (commit)
dots commit -m "Mensagem explicando a mudança"

# 4. Enviar as mudanças para o repositório remoto
dots push
```

  * **Dica Crucial:** Nunca use `dots add .` na sua pasta `home` (`~`).

### 2.3. Fluxo de Trabalho com Branches

```bash
# Criar uma nova branch e já mudar para ela
dots checkout -b <nome-da-branch>

# Mudar para uma branch existente
dots checkout <nome-da-branch>

# Listar todas as branches
dots branch

# Enviar uma nova branch para o repositório remoto pela primeira vez
dots push -u origin <nome-da-branch>

# Trazer as mudanças de uma branch para a 'main'
dots checkout main
dots merge <nome-da-branch>
```

### 2.4. Resolução de Problemas

```bash
# Limpar a "staging area" de arquivos adicionados por engano
dots reset

# Remover um arquivo do rastreamento do Git (sem apagar o arquivo local)
dots rm --cached <caminho/do/arquivo>
```

## 3\. Configuração do Ambiente Gráfico

### 3.1. Hyprland

```bash
# Iniciar a sessão (alias do .bashrc que chama o script wrapper)
hypr

# Inspecionar janelas abertas para descobrir a 'class'
hyprctl clients
```

### 3.2. Principais Arquivos de Configuração

  * **Hyprland:** `~/.config/hypr/hyprland.conf`
  * **Waybar:** `~/.config/waybar/config` e `style.css`
  * **Wofi:** `~/.config/wofi/config` e `style.css`
  * **Ghostty:** `~/.config/ghostty/config`
  * **Starship:** `~/.config/starship.toml`
  * **Tmux:** `~/.tmux.conf`
  * **Swaylock:** `~/.config/swaylock/config`
  * **SDDM:** `/etc/sddm.conf`
  * **Tema do SDDM:** `/usr/share/sddm/themes/<tema>/theme.conf`
  * **Script de Lançamento:** `~/.config/hypr/scripts/start-hyprland.sh`
  * **Script de Screenshot:** `~/.config/hypr/scripts/screenshot.sh`

## 4\. Ferramentas da Linha de Comando (CLI)

  * **`fzf` + `bat`**

      * `Ctrl + T`: Encontrar arquivos.
      * `Ctrl + R`: Buscar no histórico de comandos.
      * `Alt + C`: Mudar de diretório.
      * **Preview:** Habilitado pela variável `FZF_DEFAULT_OPTS` no `.bashrc`.

  * **`tmux` (Modo de Cópia `vi`)**

      * **Prefixo:** `Ctrl + Espaço`
      * `Prefixo` + `v`: Entrar no modo de cópia.
      * `v` / `Shift+V`: Iniciar seleção por caractere / por linha.
      * `y`: Copiar para a área de transferência do sistema.
      * `Ctrl + Shift + V`: Colar.
      * `Prefixo` + `r`: Recarregar a configuração.

  * **Gemini CLI (Funções Customizadas)**

      * `ask`: Inicia um chat interativo.
      * `explain <comando>`: Pede à IA para explicar a saída/erro de um comando.
      * `summarize <arquivo_ou_url>`: Pede à IA para resumir um arquivo ou URL.
      * `create_script "<descrição>" <arquivo.sh>`: Pede à IA para gerar um script.

## 5\. Comandos de Diagnóstico e Reparo

```bash
# Descobrir o caminho de um programa
which <comando>

# Listar temas de ícones/cursores instalados
ls /usr/share/icons/

# Ver o nome oficial de um tema de cursor
grep -i "Name=" /usr/share/icons/NOME_DA_PASTA/index.theme

# Reiniciar a Waybar para aplicar mudanças
killall waybar; waybar &

# Instalar o pacote correto para ter efeitos no swaylock
yay -S swaylock-effects

# Reconstruir o "armazém" de certificados de segurança do sistema
sudo trust extract-compat

# Redefinir o perfil de um aplicativo Flatpak corrompido (Exemplo)
mv ~/.var/app/app.zen_browser.zen ~/.var/app/app.zen_browser.zen.backup
```
