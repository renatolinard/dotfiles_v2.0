````markdown
# Meus Dotfiles Hyprland (Tema Kanagawa)

![Screenshot do Desktop](https://i.imgur.com/L1n5g3u.png)

Este repositório contém todas as minhas configurações pessoais para um ambiente de desktop Hyprland minimalista, funcional e esteticamente coeso no Arch Linux.

O objetivo é criar um sistema portátil que pode ser implantado em uma nova instalação do Arch em minutos usando um único script de automação.

---

## 🚀 Instalação Rápida (A Partir de um TTY)

Este guia assume que você está em uma instalação nova do Arch Linux (perfil `minimal`) com uma conexão de internet ativa.

### Passo 1: Sincronizar o Sistema e Instalar o Git
O `git` é a única dependência que precisamos instalar manualmente para começar.

```bash
sudo pacman -Syu --noconfirm && sudo pacman -S --needed --noconfirm git
````

### Passo 2: Clonar este Repositório

Clone os arquivos para a sua máquina local.

```bash
# Lembre-se de substituir pela URL do seu repositório no GitHub
git clone [https://github.com/renatolinard/dotfiles_v2.0.git](https://github.com/renatolinard/dotfiles_v2.0.git)
```

### Passo 3: Executar o Script de Instalação

Entre na pasta que acabamos de clonar, torne o script executável e rode-o.

```bash
cd dotfiles_v2.0
chmod +x install.sh
./install.sh
```

O script irá automatizar todo o resto, incluindo a instalação de pacotes, configuração dos dotfiles e habilitação de serviços.

### Após a Instalação

Depois que o script terminar, reinicie o computador com `sudo reboot`. Após reiniciar, você será saudado pela tela de login do SDDM. Faça o login e seu ambiente Hyprland iniciará.

-----

## 📖 Guia de Uso e Referência Rápida

### Gerenciamento de Dotfiles (`dots`)

Este setup usa um repositório Git "bare" para gerenciar os arquivos de configuração. O alias `dots`, definido no `~/.bashrc`, é o seu comando principal.

**Fluxo de Trabalho Básico:**

```bash
# Ver o status dos arquivos
dots status

# Adicionar um arquivo modificado
dots add ~/.config/hypr/hyprland.conf

# Salvar as mudanças (commit)
dots commit -m "Minha mensagem descritiva"

# Enviar para o repositório remoto
dots push
```

**Trabalhando com Branches:**

| Ação | Comando |
| :--- | :--- |
| Criar e mudar para nova branch | `dots checkout -b <nome-da-branch>` |
| Mudar para uma branch existente| `dots checkout <nome-da-branch>` |
| Listar todas as branches | `dots branch` |
| Enviar branch pela 1ª vez | `dots push -u origin <nome-da-branch>` |
| Trazer as mudanças para a `main`| `dots checkout main` e depois `dots merge <nome-da-branch>` |

### Atalhos Essenciais

  * **Terminal:** `Super + Enter`
  * **Lançador de Apps (Wofi):** `Super + W`
  * **Gerenciador de Arquivos (Thunar):** `Super + E`
  * **Fechar Janela:** `Super + Q`
  * **Sair do Hyprland:** `Super + M`
  * **Screenshots:** `Print` (tela toda), `Shift + Print` (área), `Alt + Print` (janela)
  * **Tmux Prefixo:** `Ctrl + Espaço`
  * **Tmux Modo de Cópia:** `Prefixo` + `v`

### Funções Customizadas da CLI

  * `ask`: Inicia um chat interativo com a IA.
  * `explain <comando>`: Pede à IA para explicar a saída ou erro de um comando.
  * `summarize <arquivo_ou_url>`: Pede à IA para resumir um arquivo ou URL.
  * `create_script "<descrição>" <arquivo.sh>`: Pede à IA para gerar um script.
  * `dc`: Faz um `dots commit` de forma interativa.

-----

## 🔧 Customização e Diagnóstico

### Principais Arquivos de Configuração

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

### Comandos Úteis de Diagnóstico

```bash
# Descobrir a "class" de uma janela para criar regras no Hyprland
hyprctl clients

# Listar temas de ícones/cursores instalados
ls /usr/share/icons/

# Ver o nome oficial de um tema de cursor
grep -i "Name=" /usr/share/icons/NOME_DA_PASTA/index.theme

# Reiniciar a Waybar para aplicar mudanças
killall waybar; waybar &

# Gerar listas de pacotes para o script de instalação
pacman -Qeq > pkglist.txt
pacman -Qem > aurlist.txt
```

### Alterar Temas GTK / Cursor

1.  Instale o pacote do tema desejado (ex: `yay -S bibata-cursor-theme`).
2.  Execute `nwg-look` para aplicar o tema visualmente.
3.  Atualize as variáveis de ambiente no seu script de lançamento (`~/.config/hypr/scripts/start-hyprland.sh`).

### Alterar Tema do SDDM

1.  Instale o pacote do tema (ex: `yay -S sddm-sugar-dark`).
2.  Edite `/etc/sddm.conf` e altere a linha `Current=<nome_do_tema>`.
3.  Personalize as cores e o fundo em `/usr/share/sddm/themes/<nome_do_tema>/theme.conf`.

<!-- end list -->

```
```
