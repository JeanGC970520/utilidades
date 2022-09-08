#!/bin/bash
# Script para cargarle todos los programas de un directorio

if [[ $# -gt 0 ]]; then
    echo "Se pasaran $# programas"
    for j in $*; do
        echo $j
        ampy -p /dev/ttyUSB0 put $j
    done
else
    echo "Se leera todo el contenido del directorio y se le pasara al esp32"
    cont=$(ls)
    for i in $cont; do
        echo "$i"
        ampy -p /dev/ttyUSB0 put $i
    done
fi
