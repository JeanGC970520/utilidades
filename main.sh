#!/bin/bash

source ./esp/convert_to_mpys.bash
source ./esp/put_scripts2esp.bash
source ./esp/get_scripts2esp.bash
source ./esp/install_firmware.bash


function main_usage {
    echo "esp is a commandline that allow encrypt files. "
    echo "Allows you to upload and download programs to the ESP module. List its content."
    echo "You can also install a certain firmware of your choice."
    echo -e "USAGE: [COMMAND] [COMMAND_OPTIONS]: \n"
    echo -e "Commands:"
    echo "  encrypt  - Convert files .py to .mpy"
    echo "  ls       - List the ESP device content"
    echo "  put      - Send files or directories to the port selected"
    echo "  get      - Download files or directories from the ESP device to the host"
    echo "  firmware - Install on the device selected the firmware choice it"
}

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
        
        firmware)
            shift 1
            install $*
            shift $#
            ;;
        
        ls)
            shift 1
            ls $*
            shift $#
            ;;

        -h|--help)
            main_usage
            shift $#
            ;;
    esac
done