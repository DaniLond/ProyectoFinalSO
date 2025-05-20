show_menu() {
    echo "============================================="
    echo "    HERRAMIENTA DE ADMINISTRACIÓN DE DATA CENTER    "
    echo "============================================="
    echo ""
    echo "1. Top 5 procesos por consumo de CPU"
    echo "2. Información de discos/filesystems"
    echo "3. Archivo más grande en un disco específico"
    echo "4. Información de memoria y swap"
    echo "5. Conexiones de red activas (ESTABLISHED)"
    echo "Q. Salir"
    echo ""
}

get_top_cpu_processes() {
    echo "=== TOP 5 PROCESOS POR CONSUMO DE CPU ==="
    echo ""
    
    ps aux --sort=-%cpu | head -6
    
    echo ""
    read -p "Presiona Enter para continuar..."
}

get_disk_info() {
    echo "=== INFORMACIÓN DE DISCOS/FILESYSTEMS ==="
    echo ""
    
    df -B1 | awk '{print $1, $2 " bytes", $4 " bytes libres"}' | column -t
    
    echo ""
    read -p "Presiona Enter para continuar..."
}

find_largest_file() {
    echo "=== BUSCAR ARCHIVO MÁS GRANDE ==="
    echo ""

    read -p "Ingresa la ruta del directorio a analizar (ejemplo: /home/usuario/Escritorio): " path

    if [ -d "$path" ]; then
        echo "Buscando el archivo más grande en $path..."
        echo "Este proceso puede tardar varios minutos dependiendo del tamaño del directorio..."

        largest_file=$(find "$path" -type f -exec du -b {} + 2>/dev/null | sort -nr | head -n 1)

        if [ -n "$largest_file" ]; then
            size=$(echo "$largest_file" | cut -f1)
            file=$(echo "$largest_file" | cut -f2-)
            echo ""
            echo "Archivo más grande encontrado:"
            echo "Ruta: $file"
            echo "Tamaño: $size bytes"
        else
            echo "No se encontraron archivos o no se tienen permisos suficientes."
        fi
    else
        echo "La ruta especificada no existe. Intenta nuevamente."
    fi

    echo ""
    read -p "Presiona Enter para continuar..."
}


get_memory_info() {
    echo "=== INFORMACIÓN DE MEMORIA Y SWAP ==="
    echo ""
    
    # Memoria libre
    total_mem=$(grep MemTotal /proc/meminfo | awk '{print $2 * 1024}')
    free_mem=$(grep MemAvailable /proc/meminfo | awk '{print $2 * 1024}')
    percent_free_mem=$(awk "BEGIN {printf \"%.2f\", ($free_mem / $total_mem) * 100}")
    
    # Información de swap
    total_swap=$(grep SwapTotal /proc/meminfo | awk '{print $2 * 1024}')
    free_swap=$(grep SwapFree /proc/meminfo | awk '{print $2 * 1024}')
    used_swap=$((total_swap - free_swap))
    percent_used_swap=0
    if [ "$total_swap" -gt 0 ]; then
        percent_used_swap=$(awk "BEGIN {printf \"%.2f\", ($used_swap / $total_swap) * 100}")
    fi
    
    echo "Memoria libre: $free_mem bytes ($percent_free_mem%)"
    echo "Espacio de swap en uso: $used_swap bytes ($percent_used_swap%)"
    
    echo ""
    read -p "Presiona Enter para continuar..."
}

get_established_connections() {
    echo "=== CONEXIONES DE RED ACTIVAS (ESTABLISHED) ==="
    echo ""

    if command -v ss &>/dev/null; then
        connections=$(ss -tunaep | grep ESTAB)
        connection_count=$(echo "$connections" | wc -l)
    else
        connections=$(netstat -tunaep | grep ESTABLISHED)
        connection_count=$(echo "$connections" | wc -l)
    fi
    
    echo "Número de conexiones activas (ESTABLISHED): $connection_count"
    echo ""
    echo "$connections"
    
    echo ""
    read -p "Presiona Enter para continuar..."
}

while true; do
    show_menu
    read -p "Ingresa tu opción: " choice
    
    case $choice in
        1) get_top_cpu_processes ;;
        2) get_disk_info ;;
        3) find_largest_file ;;
        4) get_memory_info ;;
        5) get_established_connections ;;
        [Qq]) echo "Saliendo..."; exit 0 ;;
        *) echo "Opción inválida."; read -p "Presiona Enter para continuar..." ;;
    esac
done