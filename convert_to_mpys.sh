#!/bin/bash
# Script para convertir todos los .py en .mpy excepto por el main.py
#echo "Creando directorio mpys."
#mkdir mpys/

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
        if [[ $name =~ ^([^__].+\.py)$ && $name != main.py ]]; then
            echo "$name would be convert to .mpy"
            mpy-cross $obj   # Generacion de archivo .mpy
            mpy=${name/\.py/\.mpy}
            path=${obj#*$DIR_ACTUAL*}
            dir=mpys${path/$name/} 
            if [ ! -e $dir ]; then  # Aqui si ponia [[ condicion ]] no funcionaba, por ello la importancia de los parentesis.
                echo "Making directory $dir"
                mkdir -p $dir
            fi
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


function convert_recursivamente {
    lectura=$(ls $SUBDIR)
    for obj in $lectura; do
        # echo "File: $file"
        if [[ $obj =~ (.+\.py)$ && $obj != main.py ]]; then
            echo "El script $obj será convertido a .mpy"
            #echo ${obj%*\.py}  # pruebas
            name=${obj%*\.py}
            #echo ${obj/*\.py/${name}\.mpy}  # pruebas
            #mpy-cross $obj 
            #mv ${obj/*\.py/${name}\.mpy} mpys/$SUBDIR
            echo "Moviendo $name a dir: $SUBDIR" # pruebas
        elif [[ -d $obj ]]; then #Esta condicion comprueba si hay un . en el nombre, niega esa comparacion por lo que si hay un . sera False, sino True
            echo "$obj es un DIRECTORIO"
            SUBDIR=$obj
            #cd $file
            convert_recursivamente
        fi
    done
}

#convert_recursivamente
