#!/bin/bash

# Lista as redes Wi-Fi e formata a saída como JSON
nmcli -t -f SSID,SECURITY,SIGNAL device wifi list | awk -F: '{
    if ($2 == "" || $2 == "--") {
        security="none"
    } else {
        security=$2
    }
    printf "{\"ssid\":\"%s\",\"security\":\"%s\",\"signal\":\"%s\"}\n", $1, security, $3
}' | jq -s '.'
