# Guia de Referência Rápida (Cola) - Setup Hyprland Completo

Este é um manual de referência com os comandos e dicas mais importantes para 
gerenciar e personalizar o ambiente Hyprland construído no Arch Linux.

## 1\. Gerenciamento de Sistema (Arch Linux)

### 1.1. Atualização do Sistema

```bash
# Comando padrão para atualizar todos os pacotes
sudo pacman -Syu

# Comando para usar em caso de conflitos de arquivos
# Exemplo para conflitos na pasta da nvidia:
sudo pacman -Syu --overwrite 'usr/lib/firmware/nvidia/*'
```

**Dica:** O erro de "conflicting files" geralmente se resolve movendo a pasta 
conflitante para um backup (`sudo mv /caminho/pasta /caminho/pasta.bak`) e 
rodando a atualização padrão novamente.

### 1.2. Instalação de Pacotes

```bash
# Instalar pacotes dos repositórios oficiais
sudo pacman -S <nome_do_pacote>

# Instalar pacotes do AUR (Arch User Repository)
yay -S <nome_do_pacote>
```

### 1.3. Gerenciamento de Serviços (`systemd`)

```bash
# Habilitar um serviço para iniciar no boot E iniciá-lo agora
sudo systemctl enable --now <nome_do_serviço>.service
# Exemplo: sudo systemctl enable --now NetworkManager.service

# Desabilitar um serviço para não iniciar mais no boot
sudo systemctl disable <nome_do_serviço>.service

# Iniciar ou parar um serviço manualmente
sudo systemctl start <nome_do_serviço>.service
sudo systemctl stop <nome_do_serviço>.service
```

## 2\. Gerenciamento de Dotfiles (Git Bare)

### 2.1. O Alias `dots` (Coração do Método)

Este alias, definido no `~/.bashrc`, é o comando principal para interagir com seus dotfiles.

```bash
alias dots='git --git-dir=$HOME/.dotfiles_v2.0/ --work-tree=$HOME'
```

### 2.2. Fluxo de Trabalho do Dia a Dia

```bash
# 1. Ver o status dos seus arquivos de configuração
dots status

# 2. Adicionar um arquivo ou pasta específica para ser rastreado
dots add ~/.config/hypr/hyprland.conf

# 3. Salvar as mudanças com uma mensagem descritiva
dots commit -m "Mensagem explicando a mudança"

# 4. Enviar as mudanças para o seu repositório remoto (Codeberg)
dots push
```

**Dica Crucial:** Nunca use `dots add .` na sua pasta `home` (`~`). Sempre 
adicione arquivos e pastas pelo seu caminho explícito para evitar adicionar arquivos indesejados.

### 2.3. Resolução de Problemas

```bash
# Limpar a "staging area" de arquivos adicionados por engano
dots reset

# Remover um link simbólico ou arquivo do rastreamento do Git (sem apagar o arquivo local)
dots rm --cached <caminho/do/arquivo>
```

## 3\. Configuração do Ambiente Hyprland

### 3.1. Descobrindo Propriedades de Janelas

Para criar `windowrule` ou `layerrule`, use o `hyprctl`.

```bash
# Lista todas as janelas abertas e suas propriedades
hyprctl clients
```

**Dica:** Procure pela linha `class:` para encontrar o nome do aplicativo (ex: `class: app.zen_browser.zen`).

### 3.2. Script de Inicialização (Wrapper Script)

Para garantir que variáveis de ambiente (como as de tema) sejam carregadas corretamente, iniciamos o Hyprland através de um script (`~/.config/hypr/scripts/start-hyprland.sh`) em vez de diretamente. O alias `hypr` no `.bashrc` aponta para este script.

## 4\. Ferramentas da Linha de Comando (CLI)

### 4.1. `fzf` + `bat` (Busca e Visualização)

  * **`Ctrl + T`**: Abre o `fzf` para encontrar arquivos e pastas.
  * **`Ctrl + R`**: Abre o `fzf` para buscar no seu histórico de comandos.
  * **`Alt + C`**: Abre o `fzf` para navegar rapidamente entre diretórios.
  * **Preview:** A variável `FZF_DEFAULT_OPTS` no seu `.bashrc` habilita a pré-visualização de arquivos com `bat` dentro do `fzf`.

### 4.2. `tmux` (Modo de Cópia `vi`)

  * **Prefixo:** `Ctrl + Espaço`
  * `Prefixo` + `v`: Entrar no modo de cópia (visual).
  * **Navegação:** `h, j, k, l` (como no Vim).
  * `v`: Iniciar seleção de caractere.
  * `Shift + v`: Iniciar seleção de linha.
  * `y`: Copiar a seleção para a área de transferência do sistema (usando `wl-copy`).
  * `Ctrl + Shift + V`: Colar o conteúdo da área de transferência.
  * `Prefixo` + `r`: Recarregar a configuração do `tmux`.

### 4.3. Gemini CLI (Funções Customizadas)

  * `ask`: Inicia um chat interativo.
  * `explain <comando>`: Executa um comando e pede à IA para explicar a saída ou o erro.
  * `summarize <arquivo_ou_url>`: Pede à IA para resumir um arquivo ou o conteúdo de uma URL.
  * `create_script "<descrição>" <nome_do_arquivo.sh>`: Pede à IA para gerar um script.

## 5\. Comandos de Diagnóstico e Reparo

```bash
# Descobrir o caminho de um programa
which nerdfetch

# Listar temas de ícones/cursores instalados para encontrar o nome exato
ls /usr/share/icons/

# Ver o nome oficial de um tema de cursor
grep -i "Name=" /usr/share/icons/NOME_DA_PASTA/index.theme

# Reiniciar a Waybar para aplicar mudanças
killall waybar; waybar &

# Testar a tela de bloqueio com uma configuração específica
swaylock -C ~/.config/swaylock/config

# Instalar o pacote correto para ter efeitos no swaylock
yay -S swaylock-effects

# Reconstruir o "armazém" de certificados de segurança do sistema
sudo trust extract-compat

# Redefinir o perfil de um aplicativo Flatpak corrompido (Exemplo com Zen)
mv ~/.var/app/app.zen_browser.zen ~/.var/app/app.zen_browser.zen.backup
```

# Gerar lista de packages essenciais

```bash
pacman -Qeq > pkglist.txt
pacman -Qem > aurlist.txt
```
