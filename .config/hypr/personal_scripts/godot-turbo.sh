#!/bin/bash

# --- CONFIGURAÇÃO DE CAMINHOS ---
# Usamos caminhos absolutos para garantir que funcione mesmo fora do terminal interativo
GAME_MODE="$HOME/.config/hypr/scripts/game-mode.sh"
WORK_MODE="$HOME/.config/hypr/scripts/work-mode.sh"

# Inicia o bloco de lógica em background (detached)
(
    # 1. Ativa o Modo Performance
    # Verifica se o arquivo existe e é executável antes de tentar rodar
    if [ -x "$GAME_MODE" ]; then
        "$GAME_MODE"
    else
        # Fallback caso o script não seja achado (tenta rodar direto do PATH)
        game-mode.sh
    fi

    # 2. Lança o Godot
    # O '&' no final joga o Godot para background dentro deste subshell
    # O '> /dev/null 2>&1' silencia qualquer erro de terminal do Godot
    godot --display-driver wayland --rendering-driver vulkan --single-window > /dev/null 2>&1 &

    # 3. Espera de Segurança (Warm-up)
    # Dá 5 segundos para o Godot carregar na memória antes de começarmos a vigiar
    sleep 5

    # 4. LOOP DE VIGILÂNCIA (WATCHDOG)
    # Aqui está o segredo: O script não termina. Ele fica num loop infinito
    # perguntando pro sistema: "Tem algum processo com nome 'godot' rodando?"
    # Enquanto a resposta for SIM, ele dorme por 2 segundos e pergunta de novo.
    while pgrep -f "godot" > /dev/null; do
        sleep 2
    done

    # 5. Restaura o Modo Trabalho
    # O script só chega aqui quando o loop acima quebra (ou seja, quando você fecha o Godot)
    if [ -x "$WORK_MODE" ]; then
        "$WORK_MODE"
    else
        work-mode.sh
    fi

) & disown # Desvincula totalmente do terminal atual

# Fecha a janela do terminal imediatamente
exit 0
