#!/bin/bash
# Script para automatizar el borrado de la memoria flash del esp32 y la instalaccion de un nuevo firmware
# Consideraciones:
#			1.- Se necesita un puerto USB
#			2.- Se necesita la ruta donde se encuentra el firmware a instalar

function firmware_usage {
    echo "Install a [FIRMWARE] in a [DEVICE]. First erase the flash and then install it"
    echo -e "USAGE: firmware --port [PORT] | --port=[PORT]\n  --device [DEVICE] | --device=[DEVICE] [FIRMWARE]: \n"
    echo "  --port   Port to make the connection and send the content."
    echo "  --device Target device to download it the [FIRMWARE]."
}

function install {
    while getopts ":-:h" opt;
    do
        case ${opt} in 
            -)
                case "${OPTARG}" in
                    port)
                        port="${!OPTIND}"; OPTIND=$(( $OPTIND + 1 ))
                        echo "Puerto seleccionado con '--${OPTARG}': ${port}" >&2
                        ;;
                    port=*)
                        port=${OPTARG#*=}
                        echo "Puerto seleccionado con '--port=${port}'" >&2
                        ;;
                    device)
                        device="${!OPTIND}"; OPTIND=$(( $OPTIND + 1 ))
                        echo "Dispositivo seleccionado con '--${OPTARG}': ${device}" >&2
                        ;;
                    device=*)
                        device=${OPTARG#*=}
                        echo "Dispositivo seleccionado con '--device=${device}'" >&2
                        ;;
                    *) 
                        if [ "$OPTERR" = 1 ] && [ "${optspec:0:1}" != ":" ]; then
                            echo "Unknown option --${OPTARG}" >&2
                        fi
                        put_exit_abnormal
                        ;;
                esac;;
            h)
                firmware_usage
                ;;
            *)
                echo -e "Option '-$OPTARG' not valid.\n"
                firmware_usage
                exit 1
                ;;
        esac
    done
    shift $(( OPTIND -1 )) # Quedarse con el ultimo argumento
    esptool.py --chip $device --port $port erase_flash
    esptool.py --chip $device --port $port --baud 460800 write_flash -z 0x1000 $1
}