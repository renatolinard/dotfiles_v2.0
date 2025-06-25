#!/bin/bash

# Script interativo v2.1 para download e organização de mídias com yt-dlp.
# CORRIGIDO: Lógica do menu alterada para usar $REPLY (o número digitado).

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
    # NOVO: A verificação agora é feita com base no número ($REPLY) e não no texto ($opt)
    case $REPLY in
        1) # Baixar um VÍDEO
            read -p "Cole o URL do vídeo: " url
            if [[ -n "$url" ]]; then
                echo -e "\n${YELLOW}Iniciando download para ~/Videos...${NC}"
                yt-dlp -P ~/Videos "$url"
            else
                echo "Nenhum URL fornecido."
            fi
            break
            ;;

        2) # Baixar apenas o ÁUDIO/MP3
            read -p "Cole o URL do vídeo: " url
            if [[ -n "$url" ]]; then
                echo -e "\n${YELLOW}Iniciando extração de áudio para ~/Music/Melhores...${NC}"
                yt-dlp -P ~/Music/Melhores -x --audio-format mp3 "$url"
            else
                echo "Nenhum URL fornecido."
            fi
            break
            ;;

        3) # Baixar PLAYLIST de Vídeos
            read -p "Cole o URL da playlist: " url
            if [[ -n "$url" ]]; then
                echo -e "\n${YELLOW}Iniciando download da playlist para uma nova pasta em ~/Videos...${NC}"
                yt-dlp -o "~/Videos/%(playlist_title)s/%(playlist_index)s - %(title)s.%(ext)s" "$url"
            else
                echo "Nenhum URL fornecido."
            fi
            break
            ;;

        4) # Baixar PLAYLIST de Áudio/MP3
            read -p "Cole o URL da playlist: " url
            if [[ -n "$url" ]]; then
                echo -e "\n${YELLOW}Iniciando download da playlist para uma nova pasta em ~/Music...${NC}"
                yt-dlp -x --audio-format mp3 -o "~/Music/%(playlist_title)s/%(playlist_index)s - %(title)s.%(ext)s" "$url"
            else
                echo "Nenhum URL fornecido."
            fi
            break
            ;;

        5) # Baixar uma PARTE de uma playlist
            read -p "Cole o URL da playlist: " url
            read -p "Qual o intervalo que deseja baixar? (ex: 1-5 ou 2,8,12): " range

            if [[ -n "$url" ]] && [[ -n "$range" ]]; then
                PS3="Deseja baixar Vídeo ou Áudio? "
                select type in "Vídeo (para ~/Videos)" "Áudio (para ~/Music)"; do
                    case $type in
                        "Vídeo (para ~/Videos)")
                            echo -e "\n${YELLOW}Iniciando download do intervalo [${range}] como vídeo...${NC}"
                            yt-dlp -o "~/Videos/%(playlist_title)s/%(playlist_index)s - %(title)s.%(ext)s" --playlist-items "$range" "$url"
                            break
                            ;;
                        "Áudio (para ~/Music)")
                            echo -e "\n${YELLOW}Iniciando download do intervalo [${range}] como áudio/MP3...${NC}"
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

        6) # Sair
            echo "Até logo!"
            break
            ;;
        *) echo "Opção inválida. Por favor, escolha um número de 1 a 6.";;
    esac
done
