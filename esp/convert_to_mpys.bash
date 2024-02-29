#!/bin/bash
# Script para convertir todos los .py en .mpy excepto por el main.py

DIR_RAIZ=$PWD
DIR_ACTUAL=${DIR_RAIZ##*/}  #Elimina la parte mas larga que coincida con el 
                            #patron que hay despúes de ##

function convertTompy {
    echo "Reading $DIR_ACTUAL"
    lectura=$(find $(pwd) -name "*.py")
    for obj in $lectura; do
        name=${obj##*/}
        if [[ $obj =~ .*/test/.* ]]; then
            #echo "Scripts del paquete test"
            continue
        fi
        if [[ $name != main.py ]]; then
            
            path=${obj#*$DIR_ACTUAL*}
            dir=mpys${path/$name/} 
            if [ ! -e $dir ]; then  # Aqui si ponia [[ condicion ]] no funcionaba, por ello la importancia de los parentesis.
                echo "Making directory $dir"
                mkdir -p $dir
            fi

            if [[ $name =~ ^([__].+\.py)$ ]]; then
                #echo "__init__.py founded"
                cp ${dir:5}$name $dir
                continue
            fi
            
            echo "$name would be convert to .mpy"
            mpy-cross $obj   # Generacion de archivo .mpy
            mpy=${name/\.py/\.mpy}
            #echo "Mover: ${dir:4}$mpy a $dir" # ${path%/$name}
            mv ${dir:5}$mpy $dir
        fi
    done
}

#convertTompy

function convertTompy_script {
    for script in $*; do
        if [ ! -e "mpys/" ]; then
            mkdir mpys/
        fi
        mpy-cross $script
        mv ${script/\.py/\.mpy} mpys/
    done
}

function usage {
    echo "mpy command convert a script py or a complete directory with py's scripts to .mpy"
    echo "USAGE: mpy [OPTION] [ARGMUNENTS]"
    echo "  -f  Convert the script that passed like argument."
    echo "  -d  Convert the complete directory where the command has been called."
}

function exit_abnormal {
    usage
    exit 1
}

function encrypt {

    while getopts ":f:dh" opt;
    do
        case ${opt} in 
            f)
                echo "Convert to mpy one script."
                shift $(( OPTIND - 2 ))
                args=$*
                convertTompy_script $args
                ;;
            d)
                echo "Convert to mpy all directory."
                convertTompy
                ;;
            h)
                usage
                ;;
            :)
                echo "Error: -${OPTARG} need arguments."
                exit_abnormal
                ;;
            *)
                echo "Option nor valid."
                exit_abnormal
                ;;
        esac
    done

}
