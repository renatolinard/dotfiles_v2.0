#!/usr/bin/env bash 

# Opções 

editor="nvim"

# Variaveis

dia_de_hoje=$( date +"%d/%m/%Y" )
header="#!/usr/bin/env bash
#------------------------------------------------------------------------------
# Script   : 
# Descrição: 
# Versão   : 0.1
# Autor    : Renato Linard <renatolinardjr@gmail.com>
# Data     : $dia_de_hoje
# Licença  : GNU/GPL v3.0
# -----------------------------------------------------------------------------
# Uso: 
# -----------------------------------------------------------------------------
"

# Testar se o usuario passou o numero certo de argumento (1 argumento)
[[ $# -ne 1 ]] && echo "Digite o nome de um argumento!!! Saindo" && exit 1
# Testar se o arquivo ja existe
[[ -f $1 ]] && echo "Arquivo ja existente... Saindo" && exit 1

echo "$header" >> $1
chmod +x $1
$editor $1

exit 0
