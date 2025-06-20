#!/usr/bin/env bash
#------------------------------------------------------------------------------
# Script   : gupd

# Descrição: blocos de comando para realizar commit e push para repositorio 
#local e remoto

# Versão   : 0.1
# Autor    : Renato Linard <renatolinardjr@gmail.com>
# Data     : 04/08/2024
# Licença  : GNU/GPL v3.0
# -----------------------------------------------------------------------------
# Uso: gupd
# -----------------------------------------------------------------------------

git add .
git commit -m "atualização automatica via gupd.sh"
git push

