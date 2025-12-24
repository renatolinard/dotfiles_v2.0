#!/usr/bin/env bash
# ~/.local/bin/game-mode.sh

# 1. Configura CPU para PERFORMANCE usando cpupower
# (-c all aplica para todos os núcleos)
sudo -n cpupower -c all frequency-set -g performance > /dev/null

# 2. Para serviços desnecessários (dispare e esqueça)
systemctl --user stop mpd.service > /dev/null 2>&1 &

# 3. Otimização Visual do Hyprland
hyprctl --batch "\
    keyword animations:enabled 0;\
    keyword decoration:shadow:enabled 0;\
    keyword decoration:blur:enabled 0;\
    keyword general:gaps_in 0;\
    keyword general:gaps_out 0;\
    keyword general:border_size 1;\
    keyword decoration:rounding 0;\
    keyword decoration:active_opacity 1;\
    keyword decoration:inactive_opacity 1;\
    keyword decoration:fullscreen_opacity 1"

# 4. Notificação
notify-send "Modo Jogo 🎮" "CPU em Performance Máxima!" > /dev/null 2>&1 &
