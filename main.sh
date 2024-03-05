#!/bin/bash

SCRIPT=$(readlink -f $0);
dir_base=`dirname $SCRIPT`;
 
source ${dir_base}/esp/convert_to_mpys.bash
source ${dir_base}/esp/put_scripts2esp.bash
source ${dir_base}/esp/get_scripts2esp.bash
source ${dir_base}/esp/install_firmware.bash


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

function verify_args {
    if [ $# -eq 0 ]; then
        echo -e "Arguments are NECESSARY.\n"
        main_usage
        exit 1
    fi
}

while [ "$#" -gt 0 ]; 
do
    case "$1" in

        encrypt)
            #echo "Opcion para encriptar .py"
            shift 1
            verify_args $*
            encrypt $*
            shift $#
            ;;

        put)
            #echo "Opcion para enviar datos al esp"
            shift 1
            verify_args $*
            put $*
            shift $#
            ;;
        
        get)
            #echo "Opcion para extraer datos del esp"
            shift 1
            verify_args $*
            get $*
            shift $#
            ;;
        
        firmware)
            shift 1
            verify_args $*
            install $*
            shift $#
            ;;
        
        ls)
            shift 1
            verify_args $*
            ls_esp $*
            shift $#
            ;;

        -h|--help)
            main_usage
            shift $#
            ;;

        *)
            echo -e "Option '$1' not valid.\n"
            main_usage
            shift $#
            ;;
    esac
done