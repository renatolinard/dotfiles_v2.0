#!/usr/bin/env bash
# ~/.local/bin/work-mode.sh

# 1. Configura CPU para POWERSAVE (Otimização)
# (-c all aplica para todos os núcleos)
sudo -n cpupower -c all frequency-set -g powersave > /dev/null

# 2. Reinicia serviços
systemctl --user start mpd.service > /dev/null 2>&1 &

# 3. Restaura o Visual Bonito
hyprctl --batch "\
    keyword animations:enabled 1;\
    keyword decoration:shadow:enabled 1;\
    keyword decoration:blur:enabled 1;\
    keyword general:gaps_in 10;\
    keyword general:gaps_out 14;\
    keyword general:border_size 1;\
    keyword decoration:rounding 10;\
    keyword decoration:active_opacity 0.9;\
    keyword decoration:inactive_opacity 0.8;\
    keyword decoration:fullscreen_opacity 1.0"

# 4. Notificação
notify-send "Modo Trabalho 💻" "CPU Otimizada (Powersave)." > /dev/null 2>&1 &
