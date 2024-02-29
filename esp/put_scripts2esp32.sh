#!/bin/bash
# Script para cargarle todos los programas de un directorio
#set -e

COMAND=$0
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

function ProgressBar {
# Process data
    let _progress=(${1}*100/${2}*100)/100      
    let _done=(${_progress}*60)/100            # Regla de tres, 80# son el 100%, s
    let _left=60-$_done
# Build progressbar string lengths
    _fill=$(printf "%${_done}s")               # Genera el número de espacios vacios para lo que serán:  #
    _empty=$(printf "%${_left}s")              # Genera el número de espacios vacios para lo que serán:  -
# 1.2 Build progressbar strings and print the ProgressBar line
# 1.2.1 Output example:                           
# 1.2.1.1 Progress : [########################################] 100%
printf "\rProgress : [${_fill// /▇}${_empty// /-}] $1 $2 ${_progress}%%"   # Sustitucion de espacios en blanco por # y de espacios en blanco por -

}

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


#if [[ $# -gt 0 ]]; then
#    echo "Se pasaran $# programas"
#    for j in $*; do
#        echo $j
#        ampy -p /dev/ttyUSB0 put $j
#    done
#else
#    echo "Se leera todo el contenido del directorio y se le pasara al esp32"
#    cont=$(ls)
#    for i in $cont; do
#        echo "$i"
#        ampy -p /dev/ttyUSB0 put $i
#    done
#fi
