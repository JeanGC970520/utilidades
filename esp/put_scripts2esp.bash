#!/bin/bash
# Script para cargarle todos los programas de un directorio
#set -e

source ./esp/progress_bar.bash

function put_usage {
    echo "Writes N scripts using ampy command to sends its to esp32, options:"
    echo "Usage: put --port [PORT] | --port=[PORT] [OPTION] [SCRIPTS or DIRECTORY]"
    echo "      --port  Port to make the connection and send the content."
    echo "      -s      Send only the SCRIPTS that are passed as parameters."
    echo "      -d      Send all DIRECTORY that are passed as parameter."
    echo "      -a      Send all current DIRECTORY."
}

function put_exit_abnormal {
    put_usage
    exit 1
}

function send_scripts {
    inicio=0
    port=$1
    shift 1
    num_scripts=$#
    echo "Se pasaran $num_scripts programas"
    for j in $*; do
        ProgressBar $inicio $num_scripts
        inicio=$(( $inicio+1 ))
        #echo -ne "\n\rEscribiendo $j al esp32\n"
        sleep 0.2
        ampy -p $port put $j
    done
    ProgressBar $inicio $num_scripts
    echo ""
}

function send_all_directory {
    port=$1
    shift 1
    echo "Se leera todo el contenido del directorio $pwd y se le pasara al esp32"
    cont=$(ls -a $pwd)
    rest=2          #Le resto dos por . y ..
    if [[ $cont =~ ".git" ]]; then rest=3; fi
    total_objs=$(($(ls -a $pwd | wc -l)-$rest))  #$(ls -a | wc -l) 
    inicio=0
    for i in $cont; do
        if [[ ! $i =~ ^([.]+|.git)$ ]]; then 
            #echo "Escribiendo $i al esp32"
            ProgressBar $inicio $total_objs
            inicio=$(( $inicio+1 ))
            sleep 0.2
            ampy -p $port put $i
        fi
    done
    ProgressBar $inicio $total_objs
    echo ""
}

function put {

    while getopts ":-:s:d:ah" opt;
    do
        case "${opt}" in 
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
                    *) 
                        if [ "$OPTERR" = 1 ] && [ "${optspec:0:1}" != ":" ]; then
                            echo "Unknown option --${OPTARG}" >&2
                        fi
                        put_exit_abnormal
                        ;;
                esac;;
            s)
                echo "Option to send some files"
                shift $(( OPTIND - 2 ))
                args=$*
                if [ -z $port ]; then   # Se comprueba si el puerto fue pasado o no
                    echo "Especifica un puerto de conexion" >&2
                    put_exit_abnormal
                fi
                send_scripts $port $args 
                ;;
            d)
                echo "Option to send a directory"
                shift $(( OPTIND - 2 ))
                args=$*
                send_scripts $port $args 
                ;;
            a)
                echo "Option to send all current directory"
                send_all_directory $port 
                ;;
            h)
                usage
                ;;
            :)
                echo "Error: -$OPTARG requiere argumentos."
                put_exit_abnormal
                ;;
            *)
                echo -e "Option '-$OPTARG' not valid.\n"
                put_exit_abnormal
                ;;
        esac
    done

}
