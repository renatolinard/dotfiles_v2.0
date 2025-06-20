#!/usr/bin/env bash
#------------------------------------------------------------------------------
# Script   : ydl.sh
# Descrição: cria um menu interativo para escolher a melhor opção de baixar
# um video usando o yt-dlp e organiza em seus diretórios especificos.
# Versão   : 2.0
# Autor    : Renato Linard <renatolinardjr@gmail.com>
# Data     : 14/06/2025
# Licença  : GNU/GPL v3.0
# -----------------------------------------------------------------------------
# Uso: ydl.sh 
# -----------------------------------------------------------------------------
#!/bin/bash

# Cores para a saída
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m' # Sem Cor

# Garante que os diretórios de destino existem
mkdir -p ~/Videos
mkdir -p ~/Music/Melhores

# Limpa a tela para uma apresentação mais limpa
clear

# Exibe o título do script
echo -e "${GREEN}Assistente de Download e Organização (yt-dlp)${NC}"
echo "-------------------------------------------------"

# Define as opções do menu
options=(
    "Baixar um VÍDEO (para ~/Videos)"
    "Baixar ÁUDIO/MP3 de um vídeo (para ~/Music/Melhores)"
    "Baixar PLAYLIST de Vídeos (em pasta própria em ~/Videos)"
    "Baixar PLAYLIST de Áudio/MP3 (em pasta própria em ~/Music)"
    "Baixar PARTE de uma playlist"
    "Sair"
)

# Cria o menu de seleção interativo
PS3=$'\n'"Escolha uma opção: "
select opt in "${options[@]}"; do
    case $opt in
        "Baixar um VÍDEO (para ~/Videos)")
            read -p "Cole o URL do vídeo: " url
            if [[ -n "$url" ]]; then
                echo -e "\n${YELLOW}Iniciando download para ~/Videos...${NC}"
                # NOVO: Adicionado -P para especificar o diretório de saída.
                yt-dlp -P ~/Videos "$url"
            else
                echo "Nenhum URL fornecido."
            fi
            break
            ;;

        "Baixar apenas o ÁUDIO (MP3) de um vídeo")
            read -p "Cole o URL do vídeo: " url
            if [[ -n "$url" ]]; then
                echo -e "\n${YELLOW}Iniciando extração de áudio para ~/Music/Melhores...${NC}"
                # NOVO: Adicionado -P para especificar o diretório de saída.
                yt-dlp -P ~/Music/Melhores -x --audio-format mp3 "$url"
            else
                echo "Nenhum URL fornecido."
            fi
            break
            ;;

        "Baixar PLAYLIST de Vídeos (em pasta própria em ~/Videos)")
            read -p "Cole o URL da playlist: " url
            if [[ -n "$url" ]]; then
                echo -e "\n${YELLOW}Iniciando download da playlist para uma nova pasta em ~/Videos...${NC}"
                # NOVO: O template de saída agora cria uma subpasta com o nome da playlist.
                yt-dlp -o "~/Videos/%(playlist_title)s/%(playlist_index)s - %(title)s.%(ext)s" "$url"
            else
                echo "Nenhum URL fornecido."
            fi
            break
            ;;

        "Baixar PLAYLIST de Áudio/MP3 (em pasta própria em ~/Music)")
            read -p "Cole o URL da playlist: " url
            if [[ -n "$url" ]]; then
                echo -e "\n${YELLOW}Iniciando download da playlist para uma nova pasta em ~/Music...${NC}"
                # NOVO: O template de saída agora cria uma subpasta com o nome da playlist.
                yt-dlp -x --audio-format mp3 -o "~/Music/%(playlist_title)s/%(playlist_index)s - %(title)s.%(ext)s" "$url"
            else
                echo "Nenhum URL fornecido."
            fi
            break
            ;;

        "Baixar uma PARTE de uma playlist")
            read -p "Cole o URL da playlist: " url
            read -p "Qual o intervalo que deseja baixar? (ex: 1-5 ou 2,8,12): " range

            if [[ -n "$url" ]] && [[ -n "$range" ]]; then
                PS3="Deseja baixar Vídeo ou Áudio? "
                select type in "Vídeo (para ~/Videos)" "Áudio (para ~/Music)"; do
                    case $type in
                        "Vídeo (para ~/Videos)")
                            echo -e "\n${YELLOW}Iniciando download do intervalo [${range}] como vídeo...${NC}"
                            # NOVO: Adicionada lógica de organização para o intervalo.
                            yt-dlp -o "~/Videos/%(playlist_title)s/%(playlist_index)s - %(title)s.%(ext)s" --playlist-items "$range" "$url"
                            break
                            ;;
                        "Áudio (para ~/Music)")
                            echo -e "\n${YELLOW}Iniciando download do intervalo [${range}] como áudio/MP3...${NC}"
                            # NOVO: Adicionada lógica de organização para o intervalo.
                            yt-dlp -x --audio-format mp3 -o "~/Music/%(playlist_title)s/%(playlist_index)s - %(title)s.%(ext)s" --playlist-items "$range" "$url"
                            break
                            ;;
                        *) echo "Opção inválida";;
                    esac
                done
            else
                echo "URL ou intervalo não fornecido."
            fi
            break
            ;;

        "Sair")
            echo "Até logo!"
            break
            ;;
        *) echo "Opção inválida: $REPLY";;
    esac
done
