#!/bin/bash
# 1. Create ProgressBar function
# 1.1 Input is currentState($1) and totalState($2)

#   80 => Es el número de # (hash) que se pintaran en pantalla.
#   El comando let permite evaluar expresiones aritmeticas en Linux, no puede trabajar con numeros con punto flotante, es decir 
#   solo trabaja con enteros. Como se puede observar es una alternativa a usar: $(( expresion_aritmetica )). Aunque let permite 
#   hacer mucho más.
function ProgressBar {
# Process data
    _progress=$(( (${1}*100)/${2} ))           # Alternativa a las operaciones de abajo, una simple regla de tres: _progress=(currentState*100)/totalState
    #_progress=$(( (${1}*100/${2}*100)/100 ))
    #let _progress=(${1}*100/${2}*100)/100      
    let _done=(${_progress}*80)/100            # Regla de tres, 80# son el 100%, s
    let _left=80-$_done
# Build progressbar string lengths
    _fill=$(printf "%${_done}s")               # Genera el número de espacios vacios para lo que serán:  #
    _empty=$(printf "%${_left}s")              # Genera el número de espacios vacios para lo que serán:  -
   # echo $_progress $_done $_left 
# 1.2 Build progressbar strings and print the ProgressBar line
# 1.2.1 Output example:                           
# 1.2.1.1 Progress : [########################################] 100%
printf "\rProgress : [${_fill// /\#}${_empty// /-}] ${_progress}%%"   # Sustitucion de espacios en blanco por # y de espacios en blanco por -

}

# Variables
_start=1

# This accounts as the "totalState" variable for the ProgressBar function
_end=100

# Proof of concept
for number in $(seq ${_start} ${_end})
do
    sleep 0.1
    ProgressBar ${number} ${_end}
done
printf '\nFinished!\n'
