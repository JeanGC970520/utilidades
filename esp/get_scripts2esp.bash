#!/bin/bash
#	Scipt para extraer el contenido de un esp32 recursivamente

function get_all {
	port=$1
	dir="/$subdir"
	lectura=$(ampy -p $port ls $dir)
	#echo "$lectura"
	for i in $lectura; do
		if [[ $i =~ .+\.(py|json|mpy|log|md|txt|dat)$ ]]; then #Para extraer los ficheros 
			if [[ ${i##*/} == boot.py ]]; then
				continue
			fi
			ampy -p $port get ${i:1} ${i:1}
			echo $i
		elif [[ ! $i =~ *\.* ]]; then #Para extraer lo que haya dentro de los directorios
			echo "Dir: ${i:1}"
			if [[ ! -e ${i:1} ]] ; then
				echo "Generando directorio: ${i:1}"
    		mkdir ${i:1} # Genera el directorio
			fi
			subdir="${i:1}"
			get_all $1
		fi
	done
}

function get_scripts {
	port=$1
	shift 1
	inicio=0
	num_scripts=$#
	for _script in $*; do
		if [[ $_script =~ .+\..+ ]]; then
			# echo "Get $_script"
			ProgressBar $inicio $num_scripts
			inicio=$(( $inicio+1 ))
			ampy -p $port get $_script $_script
		else
			echo "The argument $_script isn't a script."
			exit_abnormal
		fi
	done
	ProgressBar $inicio $num_scripts
	echo ""
}

function get_directory {
	if [[ ! $2 =~ .+\..+ && ! -d ./$2 ]]; then
		echo "$2 is a directory and doesn't exist."
		mkdir $2
		get_dir_ampy $*
	elif [[ ! $2 =~ .+\..+ ]]; then
		echo "$2 is a directory and exist."
		get_dir_ampy $*
	else
		echo "The argument $2 isn't a directory."
		get_exit_abnormal
	fi
}

function get_dir_ampy {
	port=$1
	shift 1
	local content
	local subdirs
	ampy_tree $port $1 content subdirs
	# declare -p content
	# declare -p subdirs
	unset content[0]
	# for data in ${content[@]}; do 
	# 	echo $data 
	# done
	inicio=0
	num_scripts=${#content[@]}
	for dir in ${subdirs[@]}; do
		# echo .$dir
		mkdir .$dir
	done
	echo "Numero de archivos a extraer: $num_scripts"
	for _script in ${content[@]}; do
		# echo "$_script .$_script"
		ProgressBar $inicio $num_scripts
		inicio=$(( $inicio+1 ))
		ampy -p $port get $_script .$_script
	done
	ProgressBar $inicio $num_scripts
	echo ""
}

function ampy_tree {
	port=$1
	shift 1
	root=${1%/} # Con % elimino la parte mas corta de donde encuentre ese patron (/)
	if [[ $1 =~ ^/$ ]]; then
		root=$1
	fi
	local -n array=$2
	local -n allDirs=$3
	# echo "root: $root"
	dirs=($root)
	count=0
	while [[ ${#dirs[@]} -gt 0 ]];
	do
		# echo "Directorio a escanear ${dirs[$count]}"
		content=$(ampy -p $port ls ${dirs[$count]})
		for data in $content; do 
			# echo $data
			if [[ ! $data =~ .+\..+ ]]; then
				# echo "$data is a directory"
				dirs+=($data)
				allDirs+=($data)
				continue
			fi
			array+=($data)
		done
		unset dirs[$count]
		count=$(( $count + 1 ))
		# declare -p dirs
		# echo "Dirs: ${dirs[$count]} count: $count"
	done
}

function ls_esp {
	portArg=$1
	if [ $# -gt 1 ]; then
		portArg=$2
		shift 1
	fi
	dir=$2
	if [[ $# -lt 2 ]]; then	
		dir=/
	fi
	echo -e "Directorio a listar: $dir"
	port=${portArg#--port[=?]}
	local data
	local directories
	ampy_tree $port $dir data directories
	readarray -td '' data_sorted < <(printf '%s\0' "${data[@]}" | sort -z -n)
	cat -n <(printf '%s\n' "${data_sorted[@]}")
}

function get_usage {
	echo "Get a script, directry or all content of device."
	echo "USAGE: get --port [PORT] | --port=[PORT] [OPTION] [ARGUMENTS]: "
    echo "	--port  Port to make the connection and send the content."
	echo "	-s		Get script or scripts. The argmunets have to be names of scripts."
	echo "	-d		Get directory. The arguments have to be a directory."
	echo "	-a		Get all content of device. Not pass any argument."
}


function get_exit_abnormal {
	get_usage
	exit 1
}

function get {

	while getopts ":-:s:d:ah" opt;
	do
		case ${opt} in
			-)
                case "${OPTARG}" in
                    port)
                        port="${!OPTIND}"; OPTIND=$(( $OPTIND + 1 ))
                        echo "Puerto seleccionado con '--${OPTARG}': ${port}" >&2
                        ;;
                    port=*)
                        port=${OPTARG#*=}
                        echo "Puerto seleccionado con '--port=${port}'" >&2
                        ;;
                    *) 
                        if [ "$OPTERR" = 1 ] && [ "${optspec:0:1}" != ":" ]; then
                            echo "Unknown option --${OPTARG}" >&2
                        fi
                        get_exit_abnormal
                        ;;
                esac;;
			s)
				echo "This option get a script or scripts of the device."
				shift $(( OPTIND - 2 ))
				args=$*
				get_scripts $port $args
				;;
			d)
				echo "This option get a directory of the device."
				shift $(( OPTIND - 2 ))
				args=$*
				get_directory $port $args
				;;
			a)
				echo "This option get all content of the device."
				get_all $port
				;;
			h)
				get_usage
				;;
			:)
				echo "Error: -${OPTARG} requiere argumentos."
				get_exit_abnormal
				;;
			*)
				echo -e "Option '-$OPTARG' not valid.\n"
				get_exit_abnormal
				;;
			esac
	done

}

