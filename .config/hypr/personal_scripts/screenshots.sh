#!/usr/bin/env bash
#------------------------------------------------------------------------------
# Script   : screenshot.sh 
# Descrição: Diretório para salvar os screenshots 
# Versão   : 0.1
# Autor    : Renato Linard <renatolinardjr@gmail.com>
# Data     : 19/06/2025
# Licença  : GNU/GPL v3.0
# -----------------------------------------------------------------------------
# Uso: 
# -----------------------------------------------------------------------------
#!/bin/bash

# Diretório para salvar os screenshots
output_dir="$HOME/Imagens/Screenshots"
mkdir -p "$output_dir"

# Nome do arquivo com data e hora
file_name="$(date +'%Y-%m-%d_%H-%M-%S').png"
file_path="$output_dir/$file_name"

# Função para notificar o usuário
notify_user() {
    notify-send "Screenshot" "Captura salva em '$file_name' e copiada para a área de transferência." --icon=camera-photo
}

# Lógica para os diferentes tipos de screenshot
case $1 in
    --now)
        # Captura a tela inteira imediatamente
        grim "$file_path"
        ;;
    --area)
        # Permite selecionar uma área com o slurp
        slurp | grim -g - "$file_path"
        ;;
    --window)
        # Captura a janela ativa
        # Nota: A janela ativa é determinada pelo Hyprland, não pelo slurp aqui.
        hyprctl -j activewindow | jq -r '"\(.at[0]),\(.at[1]) \(.size[0])x\(.size[1])"' | grim -g - "$file_path"
        ;;
    *)
        echo "Uso: $0 [--now | --area | --window]"
        exit 1
        ;;
esac

# Se o screenshot foi tirado com sucesso, copie e notifique
if [ -f "$file_path" ]; then
    # Copia a imagem para a área de transferência
    wl-copy < "$file_path"

    # Notifica o usuário
    notify_user
else
    notify-send "Screenshot Falhou" "Não foi possível capturar a tela." --icon=dialog-error
fi

