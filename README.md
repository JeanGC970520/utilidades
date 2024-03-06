# Comando ESP

Comando para automatizar y facilitar la interaccion con modulos ESP, como el ESP32, ESP32-S3, entre otros.

## Instalacion

Para utilizar este comando, debemos seguir los siguientes pasos:

1. Clonar repositorio.
2. Crear alias.
3. Usar comando.

### 1. [Clonar repositorio](https://github.com/JeanGC970520/utilidades)

Para este paso debemos ejecutar el siguiente comando donde queramos que el repo se clone:

```console
git clone https://github.com/JeanGC970520/utilidades.git
```

### 2. Crear alias

Para esto primero debemos ubicar el archivo `.bashrc`, comunmente se encuentra en la raiz del directorio del usuario, para ello basta con ejecutar:

```console
ls -a ~ | grep .bashrc
```

Salida:

```console
.bashrc
.bashrc.bk
```

Posiblemente aparezca algo como lo anterior. Ahora debemos abrir el archivo `.bashrc` con el editor de texto que queramos:

```console
code ~/.bashrc
```

Buscaremos la seccion de los alias, que se vera algo asi:

```console
# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
```

Ahora procederemos a agregar un alias debajo del ultimo que se tenga. La ruta debe ser en donde se hizo el clone del repositorio:

```console
alias esp='~/Documents/esp32/utilidades/main.sh'
```

### Usar comando

Para este paso final, debemos darle ciertos permisos al script `main.sh` para que pueda ser ejecutable. Para ello nos colocamos en la ruta donde se encuentra dicho script del repositorio y ejecutamos:

```console
chmod +x main.sh
```

Por ultimo para asegurarnos que los cambios se hayan guardado y efectuado correctamente, cargaremos de nuevo nuestro `.bashrc` con el siguiente comando:

```console
source ~/.bashrc
```
