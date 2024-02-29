#!/bin/bash
# Script para cargarle todos los programas de un directorio
#set -e

source ./esp/progress_bar.bash

function usage {
    echo "Usage: put2esp [OPTION] [SCRIPTS or DIRECTORY]"
    echo "Writes N scripts using ampy command to sends its to esp32, options:"
    echo "      -s      Send only the SCRIPTS that are passed as parameters."
    echo "      -d      Send all DIRECTORY that are passed as parameter."
    echo "      -a      Send all current DIRECTORY."
}

function exit_abnormal {
    usage
    exit 1
}

function send_scripts {
    inicio=0
    num_scripts=$#
    read -p "Proporciona por favor el puerto para hacer la conexion: " port
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
    read -p "Proporciona por favor el puerto para hacer la conexion: " port
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

    while getopts ":s:d:ah" opt;
    do
        case ${opt} in
            s)
                echo "Option to send some files"
                shift $(( OPTIND - 2 ))
                args=$*
                send_scripts $args 
                ;;
            d)
                echo "Option to send a directory"
                shift $(( OPTIND - 2 ))
                args=$*
                send_scripts $args 
                ;;
            a)
                echo "Option to send all current directory"
                send_all_directory
                ;;
            h)
                usage
                ;;
            :)
                echo "Error: -$OPTARG requiere argumentos."
                exit_abnormal
                ;;
            *)
                echo "Invalid option: $OPTARG"
                exit_abnormal
                ;;
        esac
    done

}
