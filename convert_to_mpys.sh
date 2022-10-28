#!/bin/bash
# Script para convertir todos los .py en .mpy excepto por el main.py
#echo "Creando directorio mpys."
#mkdir mpys/

DIR_RAIZ=$PWD
DIR_ACTUAL=${DIR_RAIZ##*/}  #Elimina la parte mas larga que coincida con el 
                            #patron que hay despúes de ##
echo "Leyendo $DIR_ACTUAL"

function convertTompy {
    lectura=$(find $(pwd) -name "*.py")
    for obj in $lectura; do
        name=${obj##*/}
        if [[ $obj =~ (.+\.py)$ && $name != main.py ]]; then
            echo "El $name será convertido a .mpy"
            mpy-cross $obj   # Generacion de archivo .mpy
            mpy=${name/\.py/\.mpy}
            path=${obj#*$DIR_ACTUAL*}
            dir=mpys${path/$name/} 
            if [ ! -e $dir ]; then  # Aqui si ponia [[ condicion ]] no funcionaba, por ello la importancia de los parentesis.
                echo "Generando directorio $dir"
                mkdir -p $dir
            fi
            #echo "Mover: ${dir:4}$mpy a $dir" # ${path%/$name}
            mv ${dir:5}$mpy $dir
        fi
    done
}

convertTompy



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
