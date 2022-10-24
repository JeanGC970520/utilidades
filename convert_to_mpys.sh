#!/bin/bash
# Script para convertir todos los .py en .mpy excepto por el main.py
echo "Leyendo $PWD"
lectura=$(ls)
echo "Creando directorio mpys."
mkdir mpys
for file in $lectura; do
    # echo "File: $file"
    if [[ $file =~ (.+\.py)$ && $file != main.py ]]; then
        echo "El script $file será convertido a .mpy"
        mpy-cross $file
    fi
done
