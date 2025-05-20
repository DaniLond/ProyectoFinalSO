# Herramientas de Administración para Data Center

## Introducción

Este manual proporciona instrucciones detalladas sobre cómo utilizar las herramientas de administración para data center desarrolladas para entornos Windows (PowerShell) y Linux/Unix (Bash). Estas herramientas están diseñadas para ayudar a administradores de sistemas a monitorear recursos y obtener información vital del sistema de forma rápida y eficiente.

## Instalación

### Windows (PowerShell)

1. **Requisitos previos:**
   - Windows 10/11 o Windows Server 2016 o superior
   - PowerShell 5.1 o superior (viene preinstalado en Windows 10/11)

2. **Instalación:**
   1. Descargue el archivo `DataCenterAdmin.ps1` a su equipo
   2. Abra PowerShell como administrador:
      - Haga clic derecho en el menú Inicio
      - Seleccione "Windows PowerShell (Admin)" o "Terminal de Windows (Admin)"
   3. Navegue al directorio donde descargó el script:
      ```powershell
      cd C:\ruta\al\directorio
      ```
   4. Si es necesario, configure la política de ejecución para permitir la ejecución de scripts:
      ```powershell
      Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope Process
      ```

### Linux/Unix (Bash)

1. **Requisitos previos:**
   - Cualquier distribución Linux moderna o macOS
   - Bash 4.0 o superior
   - Comandos estándar: ps, df, du, find, grep, awk, netstat/ss

2. **Instalación:**
   1. Descargue el archivo `datacenter_admin.sh` a su equipo
   2. Abra una terminal
   3. Navegue al directorio donde descargó el script:
      ```bash
      cd /ruta/al/directorio
      ```
   4. Asigne permisos de ejecución al script:
      ```bash
      chmod +x datacenter_admin.sh
      ```

## Ejecución

### Windows (PowerShell)

Desde PowerShell, ejecute el script:
```powershell
.\DataCenterAdmin.ps1
```

### Linux/Unix (Bash)

Desde la terminal, ejecute el script:
```bash
./datacenter_admin.sh
```

## Funcionalidades y Uso

La herramienta presenta un menú con 5 opciones principales. A continuación se describe cada una con ejemplos de uso:

### 1. Top 5 procesos por consumo de CPU

**Función:** Muestra los cinco procesos que más CPU están consumiendo en ese momento.

**Uso:**
1. Seleccione la opción `1` del menú principal
2. La herramienta mostrará una tabla con los procesos, incluyendo:
   - Nombre del proceso
   - ID del proceso
   - Porcentaje de CPU
   - Consumo de memoria

**Ejemplo de salida en Windows:**
```
=== TOP 5 PROCESOS POR CONSUMO DE CPU ===

ProcessName         Id    CPU WorkingSet
-----------         --    --- ----------
Chrome           3456 78.45   256789504
Teams            2345 45.67   189456384
Outlook          5678 23.45    78945612
Explorer         1234 12.34    45678912
Word             6789  8.90    34567890

Presiona cualquier tecla para continuar...
```

**Ejemplo de salida en Linux:**
```
=== TOP 5 PROCESOS POR CONSUMO DE CPU ===

USER       PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME COMMAND
usuario  12345 35.0  2.1 458716 87654 ?        Ssl  10:15   2:23 firefox
usuario   3456 25.3  1.8 356789 74321 ?        Sl   09:45   1:45 chrome
root      2345 15.6  0.5 123456 21345 ?        Ss   08:30   1:12 dockerd
usuario   5678 10.2  1.2 234567 49876 ?        Sl   11:20   0:45 code
root      1234  8.7  0.3  89012 12345 ?        Ss   08:00   0:30 systemd

Presiona Enter para continuar...
```

**Utilidad:** Esta función es útil para identificar rápidamente procesos que están consumiendo recursos excesivos y podrían estar causando problemas de rendimiento.

### 2. Información de discos/filesystems

**Función:** Muestra información sobre todos los discos o sistemas de archivos conectados a la máquina, incluyendo su tamaño total y espacio libre en bytes.

**Uso:**
1. Seleccione la opción `2` del menú principal
2. La herramienta mostrará una tabla con todos los discos/filesystems disponibles

**Ejemplo de salida en Windows:**
```
=== INFORMACIÓN DE DISCOS/FILESYSTEMS ===

Name Tamaño (bytes)  Espacio Libre (bytes)
---- --------------  ---------------------
C    256060514304    86028374016
D    1099511627776   549755813888
E    32212254720     16106127360

Presiona cualquier tecla para continuar...
```

**Ejemplo de salida en Linux:**
```
=== INFORMACIÓN DE DISCOS/FILESYSTEMS ===

/dev/sda1  41943040000 bytes  15728640000 bytes libres
/dev/sda2  524288000000 bytes  209715200000 bytes libres
/boot      1073741824 bytes  536870912 bytes libres

Presiona Enter para continuar...
```

**Utilidad:** Esta función permite monitorear el espacio de almacenamiento disponible y detectar discos que puedan estar quedándose sin espacio libre.

### 3. Archivo más grande en un disco específico

**Función:** Busca y muestra el archivo más grande en un disco o filesystem que el usuario especifique.

**Uso:**
1. Seleccione la opción `3` del menú principal
2. Ingrese la ruta del directorio que desea analizar (por ejemplo, C:\Users\Nombre en Windows o /home/usuario en Linux).
3. Espere mientras se realiza la búsqueda (puede tardar varios minutos en discos grandes)
4. Se mostrará el archivo más grande con su ruta completa y tamaño en bytes

**Ejemplo de salida en Windows:**
```
=== BUSCAR ARCHIVO MÁS GRANDE ===

Ingresa la ruta del directorio a analizar (ejemplo: C:\Users\DANIELA LONDOÑO\Desktop): C:\Users\usuario\Videos
Buscando el archivo más grande en C:\Users\usuario\Videos...
Este proceso puede tardar varios minutos dependiendo del tamaño del directorio...

Archivo más grande encontrado:
Ruta: C:\Users\usuario\Videos\pelicula.mp4
Tamaño: 8589934592 bytes

Presiona cualquier tecla para continuar...

```

**Ejemplo de salida en Linux:**
```
=== BUSCAR ARCHIVO MÁS GRANDE ===

Ingresa la ruta del directorio a analizar (ejemplo: /home/usuario/Escritorio): /home/usuario/Descargas
Buscando el archivo más grande en /home/usuario/Descargas...
Este proceso puede tardar varios minutos dependiendo del tamaño del directorio...

Archivo más grande encontrado:
Ruta: /home/usuario/Descargas/ubuntu-22.04.iso
Tamaño: 3758096384 bytes

Presiona Enter para continuar...
```

**Utilidad:** Esta función ayuda a identificar archivos que consumen grandes cantidades de espacio de almacenamiento, facilitando la limpieza de discos.

### 4. Información de memoria y swap

**Función:** Muestra la cantidad de memoria libre y el espacio de swap en uso, tanto en bytes como en porcentaje.

**Uso:**
1. Seleccione la opción `4` del menú principal
2. La herramienta mostrará la información de memoria y swap

**Ejemplo de salida en Windows:**
```
=== INFORMACIÓN DE MEMORIA Y SWAP ===

Memoria física libre: 4294967296 bytes (50.00%)
Espacio de swap en uso: 2147483648 bytes (25.00%)

Presiona cualquier tecla para continuar...
```

**Ejemplo de salida en Linux:**
```
=== INFORMACIÓN DE MEMORIA Y SWAP ===

Memoria libre: 2147483648 bytes (40.00%)
Espacio de swap en uso: 1073741824 bytes (20.00%)

Presiona Enter para continuar...
```

**Utilidad:** Esta función permite monitorear el uso de memoria y detectar posibles problemas de rendimiento relacionados con la escasez de RAM o un uso excesivo de swap.

### 5. Conexiones de red activas

**Función:** Muestra el número de conexiones de red activas (en estado ESTABLISHED) y detalles de cada una.

**Uso:**
1. Seleccione la opción `5` del menú principal
2. La herramienta mostrará el número total de conexiones activas y sus detalles

**Ejemplo de salida en Windows:**
```
=== CONEXIONES DE RED ACTIVAS (ESTABLISHED) ===

Número de conexiones activas (ESTABLISHED): 12

LocalAddress  LocalPort RemoteAddress   RemotePort
------------  --------- -------------   ----------
192.168.1.100 54321     142.250.185.78  443
192.168.1.100 54322     104.16.85.20    443
192.168.1.100 54323     13.107.42.16    443
[...]

Presiona cualquier tecla para continuar...
```

**Ejemplo de salida en Linux:**
```
=== CONEXIONES DE RED ACTIVAS (ESTABLISHED) ===

Número de conexiones activas (ESTABLISHED): 8

tcp   ESTAB  0  0  192.168.1.100:22  203.0.113.45:45678  users:(("sshd",pid=1234,fd=3))
tcp   ESTAB  0  0  192.168.1.100:39546  151.101.193.69:443  users:(("firefox",pid=5678,fd=45))
[...]

Presiona Enter para continuar...
```

**Utilidad:** Esta función permite monitorear las conexiones de red activas, lo que puede ser útil para diagnosticar problemas de red o identificar conexiones sospechosas.


## Conclusión

Las herramientas de administración para data center proporcionan una manera rápida y eficiente de monitorear recursos críticos del sistema. Con una interfaz de menú intuitiva y funciones especializadas, estas herramientas pueden ayudar a los administradores a mantener sus sistemas funcionando de manera óptima y a diagnosticar problemas potenciales antes de que afecten el rendimiento.

## Autores

- Leidy Daniela Londoño Candelo
- Isabella Huila Cerón
- Danna Valentina Lopez
