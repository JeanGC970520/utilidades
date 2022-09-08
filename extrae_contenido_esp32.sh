#!/bin/bash
#	Scipt para extraer el contenido de un esp32

if [[ $# -gt 0 ]]; then
	echo "Se sacaran $# programas"
	for j in $*; do
		echo $j
		ampy -p /dev/ttyUSB0 get $j $j
	done
else
	lectura=$(ampy -p /dev/ttyUSB0 ls)
	#echo "$lectura"
	for i in $lectura; do
		if [[ $i =~ .+\.py ]]; then #Para extraer los .py
			ampy -p /dev/ttyUSB0 get ${i:1} ${i:1}
			#echo ${i:1}
		elif [[ ! $i =~ .+\..+ ]]; then #Para extraer lo que haya dentro de los directorios
			#echo "Dir: ${i:1}"
    	mkdir ${i:1} # Genera el directorio
			contenido_direc=$(ampy -p /dev/ttyUSB0 ls $i)
			for f in $contenido_direc; do
				#echo ${f:${#i}+1}
				ampy -p /dev/ttyUSB0 get $f ${f:1}
			done
		fi
	done
fi
