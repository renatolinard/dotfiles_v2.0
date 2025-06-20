#!/usr/bin/env bash
#------------------------------------------------------------------------------
# Script   : espelhar.sh
# Descrição: Script para iniciar scrcpy wifi
# Versão   : 0.1
# Autor    : Renato Linard <renatolinardjr@gmail.com>
# Data     : 09/08/2024
# Licença  : GNU/GPL v3.0
# -----------------------------------------------------------------------------
# Uso: espelhar.sh
# -----------------------------------------------------------------------------

read -p "Digite se ip: " IP
adb connect $IP:5555
scrcpy --turn-screen-off --stay-awake &

exit 0

