#!/usr/bin/env bash
#------------------------------------------------------------------------------
# Script   : rmpc
# Descrição: adiciona uma musica a playlist do rmpc
# Versão   : 0.1
# Autor    : Renato Linard <renatolinardjr@gmail.com>
# Data     : 14/06/2025
# Licença  : GNU/GPL v3.0
# -----------------------------------------------------------------------------
# Uso: rmpc-add.sh
# -----------------------------------------------------------------------------
#
# #!/bin/bash

# Verifica se um URL foi fornecido
if [ -z "$1" ]; then
    echo "Uso: yt-add <URL do YouTube>"
    exit 1
fi

echo "A obter o fluxo de áudio do YouTube..."

# Usa yt-dlp para obter o URL direto do melhor fluxo de áudio e adiciona-o ao MPD com o mpc
URL_STREAM=$(yt-dlp -f bestaudio -g "$1")
mpc add "$URL_STREAM"

echo "Adicionado à lista de reprodução do MPD!"


