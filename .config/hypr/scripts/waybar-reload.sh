#!/usr/bin/env bash
#------------------------------------------------------------------------------
# Script   : 
# Descrição: 
# Versão   : 0.1
# Autor    : Renato Linard <renatolinardjr@gmail.com>
# Data     : 31/07/2025
# Licença  : GNU/GPL v3.0
# -----------------------------------------------------------------------------
# Uso: 
# -----------------------------------------------------------------------------

# -----------------------------------------------------
# Prevent duplicate launches: only the first parallel
# invocation proceeds; all others exit immediately.
# -----------------------------------------------------
exec 200>/tmp/waybar-launch.lock
flock -n 200 || exit 0

# -----------------------------------------------------
# Quit all running waybar instances
# -----------------------------------------------------
killall waybar || true
pkill waybar || true
sleep 0.5

# -----------------------------------------------------
# Loading the configuration
# -----------------------------------------------------
config_file="config"
style_file="style.css"

# Standard files can be overwritten with an existing config-custom or style-custom.css
if [ -f ~/.config/waybar/config.jsonc ]; then
    config_file="config"
fi
if [ -f ~/.config/waybar/style.css ]; then
    style_file="style.css"
fi

# activate
waybar &

# Explicitly release the lock (optional) -> flock releases on exit
flock -u 200
exec 200>&-
