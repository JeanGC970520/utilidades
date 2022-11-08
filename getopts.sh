#!/bin/bash

## Script para practicar el getopts. Esto con el objetivo de generar comandos bash personalizados y con el estilo de cualquier otro comando
COMAND=$0  # El comando es el primer argumetno que se le pasa al script

function usage {
    echo "Usage: $COMAND [-a ARGUMENT] [-b ARGUMETN]"
    echo "      -h          Display this help message."
    echo "      -a          Opcion a."
    echo "      -b          OPcion b."
}


function exit_abnormal {
    usage
    exit 1
}

##   Las opciones con ':' reciben argumentos. 

##   OPTARG Esta variable se establece en cualquier argumento para una opción encontrada por getopts. 
##   También contiene el indicador de opción de una opción desconocida. https://wiki.bash-hackers.org/howto/getopts_tutorial

##   IMPORTANTE: Cuando se usaran opciones con ARGUMENTOS, colocar ':' (colon) antes de todos los nombres de las opciones: ":opt_1opt_2:opt_3..."
#       'However, if you put a colon at the beginning of the optstring, getopts runs in "silent error checking mode."
#       It will not report any verbose errors about options or arguments, and you need to perform error checking in your script.'
#     Consultar: https://www.computerhope.com/unix/bash/getopts.htm https://www.shellscript.sh/tips/getopts/

while getopts ":a:b:h" opt;
do
    case $opt in
        a)
            shift $(( OPTIND - 2 ))   #Para posicionar el indice en el primer parametro despues de la opcion (a ó b, o la que sea)
            echo "Pasaste la opcion -${opt} al comando. Con los argumentos: $*"
            ;;
        b)
            shift $(( OPTIND - 2 ))  ## Con este comando sacamos el primer argumento que es la opcion elegida
            echo "Pasaste la opcion -${opt} al comando. Con los argumentos: $*"
            ;;
        h)
            usage
            ;;
        :)
            echo "Error: -$OPTARG requiere argumentos"
            exit_abnormal
            ;;
        \?)
            echo "Invalid option: -$OPTARG." 
            exit_abnormal
            ;;

    esac
done
