#!/bin/bash
#	Scipt para extraer el contenido de un esp32 recursivamente

function get_all {
	dir="/$subdir"
	lectura=$(ampy -p /dev/ttyUSB0 ls $dir)
	#echo "$lectura"
	for i in $lectura; do
		if [[ $i =~ .+\.(py|json|mpy|log|md|txt|dat)$ ]]; then #Para extraer los ficheros 
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
			get_all
		fi
	done
}

function get_scripts {
	for _script in $*; do
		if [[ $_script =~ .+\..+ ]]; then
			echo "Get $_script"
			ampy -p /dev/ttyUSB0 get $_script $_script
		else
			echo "The argument $_script isn't a script."
			exit_abnormal
		fi
	done
}

function get_directory {
	#echo $1
	if [[ ! $1 =~ .+\..+ && ! -d ./$1 ]]; then
		echo "$1 is a directory and doesn't exist."
		mkdir $1
		get_dir_ampy $1
	elif [[ ! $1 =~ .+\..+ ]]; then
		echo "$1 is a directory and exist."
		get_dir_ampy $1
	else
		echo "The argument $1 isn't a directory."
		exit_abnormal
	fi
}

function get_dir_ampy {
	content=$(ampy -p /dev/ttyUSB0 ls $1)
	#echo $content
	for _script in $content; do
		#echo "$_script .$_script"
		ampy -p /dev/ttyUSB0 get $_script .$_script
	done
}
#if [[ $# -gt 0 ]]; then
#	echo "Se sacaran $# programas"
#	for j in $*; do
#		echo $j
#		if [[ ! $j =~ .+\..+ && ! -d .$j ]]; then	
#			echo "Es un directorio y no existe."
#			mkdir .$j
#		fi
#		ampy -p /dev/ttyUSB0 get $j $j
#	done
#else
#  get_scripts  
#	rm ./boot.py
#fi

function usage {
	echo "USAGE: get2esp [OPTION] [ARGUMENTS]: "
	echo "Get a script, directory or all content of device."
	echo "	-s		Get script or scripts. The argmunets have to be names of scripts."
	echo "	-d		Get directory. The arguments have to be a directory."
	echo "	-a		Get all content of device. Not pass any argument."
}


function exit_abnormal {
	usage
	exit 1
}


while getopts ":s:d:ah" opt;
do
	case ${opt} in
		s)
			echo "This option get a script or scripts of device."
			shift $(( OPTIND - 2 ))
			args=$*
			get_scripts $args
			;;
		d)
			echo "This option get a directory of device."
			shift $(( OPTIND - 2 ))
			args=$*
			get_directory $args
			;;
		a)
			echo "Option to get all content of device."
			get_all
			;;
		h)
			usage
			;;
		:)
			echo "Error: -${OPTARG} requiere argumentos."
			exit_abnormal
			;;
		*)
			echo "Option not valid"
			exit_abnormal
		esac
done

