#! bin/bash

# 1 Input is currentState($1) and totalState($2)
function ProgressBar {
    let _progress=(${1}*100/${2}*100)/100
    let _done=(${_progress}*4)/10
    let _left=40-$_done
    _fill=$(printf "%${_done}s")
    _empty=$(printf "%${_left}s")
printf "\rProgress : [${_fill// /█}${_empty// /-}] ${_progress}%%  $1 / $2"
}

#tasks[0]='ampy --port /dev/ttyUSB0 rm baja.txt'
#tasks[0]='ampy --port /dev/ttyUSB0 rm esquema.json'
#tasks[1]='ampy --port /dev/ttyUSB0 rm interpolation.mpy'
#tasks[2]='ampy --port /dev/ttyUSB0 rm main.py'
#tasks[3]='ampy --port /dev/ttyUSB0 rm rf.mpy'
#tasks[4]='ampy --port /dev/ttyUSB0 rm sibo.mpy'
#tasks[6]='ampy --port /dev/ttyUSB0 rm udr.json'
#tasks[5]='ampy --port /dev/ttyUSB0 rm utils.mpy'
#tasks[8]='ampy --port /dev/ttyUSB0 rm ulogger'
#tasks[0]='esptool.py --chip esp32 --port /dev/ttyUSB0 erase_flash'
#tasks[1]='esptool.py --chip esp32 --port /dev/ttyUSB0 --baud 460800 write_flash -z 0x1000 /home/roberto/Documentos/Desarrollo/TG/Monterrey/MicroJr/esp32-20220117-v1.18.bin'



tasks[0]='ampy --port /dev/ttyUSB0 put baja.txt'
tasks[1]='ampy --port /dev/ttyUSB0 put esquema.json'
tasks[2]='ampy --port /dev/ttyUSB0 put interpolation.mpy'
tasks[3]='ampy --port /dev/ttyUSB0 put main.py'
tasks[4]='ampy --port /dev/ttyUSB0 put rf.mpy'
tasks[5]='ampy --port /dev/ttyUSB0 put sibo.mpy'
tasks[6]='ampy --port /dev/ttyUSB0 put udr.json'
tasks[7]='ampy --port /dev/ttyUSB0 put utils.mpy'
tasks[8]='ampy --port /dev/ttyUSB0 put ulogger'

total=${#tasks[@]}

ProgressBar 0 $total
for index in "${!tasks[@]}"
do 
    ${tasks[$index]}
    ProgressBar $index $total
done
ProgressBar $total $total
printf '\nCompleto!\n'
