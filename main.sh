#!/bin/bash

source ./esp/convert_to_mpys.bash
source ./esp/put_scripts2esp.bash
source ./esp/get_scripts2esp.bash

while [ "$#" -gt 0 ]; 
do
    case "$1" in

        encrypt)
            #echo "Opcion para encriptar .py"
            shift 1
            encrypt $*
            shift $#
            ;;

        put)
            #echo "Opcion para enviar datos al esp"
            shift 1
            put $*
            shift $#
            ;;
        
        get)
            #echo "Opcion para extraer datos del esp"
            shift 1
            get $*
            shift $#
            ;;
        
        -h|--help)
            echo "Desplegar ayuda"
            shift $#
            ;;
    esac
done