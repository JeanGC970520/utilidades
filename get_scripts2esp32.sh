#!/bin/bash
#	Scipt para extraer el contenido de un esp32 recursivamente

function get_scripts {
	dir="/$subdir"
	lectura=$(ampy -p /dev/ttyUSB0 ls $dir)
	#echo "$lectura"
	for i in $lectura; do
		if [[ $i =~ .+\.(py|json|mpy|log|md|txt)$ ]]; then #Para extraer los ficheros 
			name=${i:${#dir}}
			ampy -p /dev/ttyUSB0 get ${i:1} ${i:1}
			echo ${i:1} ${i:1}
		elif [[ ! $i =~ *\.* ]]; then #Para extraer lo que haya dentro de los directorios
			echo "Dir: ${i:1}"
			if [[ ! -e ${i:1} ]] ; then
				echo "Generando directorio: ${i:1}"
    		mkdir ${i:1} # Genera el directorio
			fi
			subdir="${i:1}"
			get_scripts
		fi
	done
}


if [[ $# -gt 0 ]]; then
	echo "Se sacaran $# programas"
	for j in $*; do
		echo $j
		ampy -p /dev/ttyUSB0 get $j $j
	done
else
  get_scripts  
	rm ./boot.py
fi
