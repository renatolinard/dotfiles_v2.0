# Meus Dotfiles Hyprland (Tema Kanagawa)

Este repositório contém todas as minhas configurações pessoais para um 
ambiente de desktop Hyprland minimalista e funcional no Arch Linux.

O objetivo é criar um sistema portátil que pode ser implantado em uma nova 
instalação do Arch em minutos usando um único script.

---

## 🚀 Instalação Rápida (A Partir de um TTY)

Este guia assume que você está em uma instalação nova do Arch Linux 
(perfil `minimal`) com uma conexão de internet ativa.

### Passo 1: Sincronizar o Sistema e Instalar o Git

O `git` é a única dependência que precisamos instalar manualmente para começar.

```bash
sudo pacman -Syu git
```

Passo 2: Clonar o Repositório de Instalação

```bash
git clone https://codeberg.org/renatolinard/dotfiles_v2.0.git
```

Passo 3: Executar o Script de Instalação
```bash
cd dotfiles_v2.0
chmod +x install.sh
./install.sh
```

O Que o Script Faz?

O install.sh irá automatizar todo o resto:

    Instalar o yay (AUR helper).
    Ler os arquivos pkglist.txt e aurlist.txt para instalar todos os programas e dependências.
    Configurar o repositório "bare" do Git para gerenciar os dotfiles.
    Copiar todas as configurações para os locais corretos na sua pasta home.
    Definir o bash como seu shell padrão.

Após a Instalação

Depois que o script terminar, faça logout e login novamente no TTY. Em seguida, 
para iniciar seu novo ambiente gráfico
```bash
Hyprland
```

Salvando Novas Alterações no Futuro

Para salvar novas mudanças nos seus arquivos de configuração, use o alias dots que está configurado no seu .bashrc:
Bash

# Para adicionar uma mudança em um arquivo
dots add ~/.config/hypr/hyprland.conf

# Para criar um "snapshot" da mudança
dots commit -m "Exemplo: ajusta atalho do terminal"

# Para enviar a mudança para o Codeberg
dots push

# Alterar cursor
```bash
~/.icons/defalt/index.theme
[Icon Theme]
Name=Default
Comment=Default Cursor Theme
Inherits=material_dark_cursors

GTK and Qt configuration files
~/.gtkrc-2.0
~/.config/gtk-3.0/settings.ini

```

# Alterar tema sddm
```bash
In the [Theme] section simply add the themes name: Current=sugar-dark
# Copy from /usr/lib/sddm/sddm.conf.d/default.conf
/etc/sddm.conf.d/sddm.conf

cp -r ~/sugar-dark /usr/share/sddm/themes/
```
