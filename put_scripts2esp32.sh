#!/bin/bash
# Script para cargarle todos los programas de un directorio

COMAND=$0
function usage {
    echo "Usage: put2esp [OPTION] [SCRIPTS or DIRECTORY]"
    echo "Writes N scripts using ampy command to sends its to esp32, options:"
    echo "      -s      Send only the SCRIPTS that are passed as parameters."
    echo "      -d      Send all DIRECTORY that are passed as parameter."
}

function exit_abnormal {
    usage
    exit 1
}

function send_scripts {
    inicio=1
    num_scripts=$#
    echo "Se pasaran $num_scripts programas"
    for j in $*; do
        ProgressBar $inicio $num_scripts
        inicio=$(( $inicio+1 ))
        #echo -ne "\n\rEscribiendo $j al esp32\n"
        sleep 0.2
        ampy -p /dev/ttyUSB0 put $j
    done
    echo ""
}

function send_all_directory {
    echo "Se leera todo el contenido del directorio y se le pasara al esp32"
    cont=$(ls -a $1)
    rest=2          #Le resto dos por . y ..
    if [[ $cont =~ main.py ]]; then rest=3; fi
    total_objs=$(($(ls -a $1 | wc -l)-$rest))  #$(ls -a | wc -l) 
    inicio=$(($total_objs-($total_objs-1)))
    echo $total_objs $inicio
    for i in $cont; do
        if [[ $i != main.py && $i != "." && $i != ".." ]]; then 
            #echo "Escribiendo $i al esp32"
            ProgressBar $inicio $total_objs
            inicio=$(( $inicio+1 ))
            sleep 0.2
            ampy -p /dev/ttyUSB0 put $i
        fi
    done
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
printf "\rProgress : [${_fill// /\#}${_empty// /-}] $1 $2 ${_progress}%%"   # Sustitucion de espacios en blanco por # y de espacios en blanco por -

}

while getopts ":s:d:h" opt;
do
    case ${opt} in
        s)
            shift $(( OPTIND - 2 ))
            args=$*
            send_scripts $args 
            ;;
        d)
            shift $(( OPTIND - 2 ))
            args=$*
            send_all_directory $args 
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
