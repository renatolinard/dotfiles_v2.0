#!/bin/bash

WIDGET="$1"

if eww active-windows | grep -q "$WIDGET"; then
    eww close "$WIDGET"
else
    eww open "$WIDGET"
fi
