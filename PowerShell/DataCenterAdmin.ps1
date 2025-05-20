function Show-Menu {
    Write-Host "============================================="
    Write-Host "    HERRAMIENTA DE ADMINISTRACIÓN DE DATA CENTER    "
    Write-Host "============================================="
    Write-Host ""
    Write-Host "1. Top 5 procesos por consumo de CPU"
    Write-Host "2. Información de discos/filesystems"
    Write-Host "3. Archivo más grande en un disco específico"
    Write-Host "4. Información de memoria y swap"
    Write-Host "5. Conexiones de red activas (ESTABLISHED)"
    Write-Host "Q. Salir"
    Write-Host ""
}

function Get-Top5CPUProcesses {
    Write-Host "=== TOP 5 PROCESOS POR CONSUMO DE CPU ===" -ForegroundColor Cyan
    Get-Process | Sort-Object -Property CPU -Descending | Select-Object -First 5 | 
        Format-Table -Property ProcessName, Id, CPU, WorkingSet -AutoSize
}

function Get-DiskInfo {
    Write-Host "=== INFORMACIÓN DE DISCOS/FILESYSTEMS ===" -ForegroundColor Cyan
    Get-PSDrive -PSProvider FileSystem | 
        Format-Table -Property Name, @{Name="Tamaño (bytes)"; Expression={$_.Used + $_.Free}}, 
                              @{Name="Espacio Libre (bytes)"; Expression={$_.Free}}
}

function Find-LargestFile {
    Write-Host "=== BUSCAR ARCHIVO MÁS GRANDE ===" -ForegroundColor Cyan
    
    $path = Read-Host "Ingresa la ruta del directorio a analizar (ejemplo: C:\Users\DANIELA LONDOÑO\Desktop)"

    if (Test-Path $path) {
        Write-Host "Buscando el archivo más grande en $path..."
        Write-Host "Este proceso puede tardar varios minutos dependiendo del tamaño del directorio..."

        try {
            $largestFile = Get-ChildItem -Path $path -Recurse -File -ErrorAction SilentlyContinue |
                Sort-Object -Property Length -Descending |
                Select-Object -First 1

            if ($largestFile) {
                Write-Host "Archivo más grande encontrado:"
                Write-Host "Ruta: $($largestFile.FullName)"
                Write-Host "Tamaño: $($largestFile.Length) bytes"
            } else {
                Write-Host "No se encontraron archivos o no se tienen permisos suficientes."
            }
        } catch {
            Write-Host "Error al buscar archivos: $_"
        }
    } else {
        Write-Host "La ruta especificada no existe. Intenta nuevamente."
    }
}

function Get-MemoryInfo {
    Write-Host "=== INFORMACIÓN DE MEMORIA Y SWAP ===" -ForegroundColor Cyan
    
    $os = Get-CimInstance -ClassName Win32_OperatingSystem
    
    # Memoria física libre
    $freePhysicalMemory = $os.FreePhysicalMemory * 1KB
    $totalVisibleMemory = $os.TotalVisibleMemorySize * 1KB
    $percentFreePhysicalMemory = ($freePhysicalMemory / $totalVisibleMemory) * 100
    
    # Información de swap/página
    $totalVirtualMemory = $os.TotalVirtualMemorySize * 1KB
    $freeVirtualMemory = $os.FreeVirtualMemory * 1KB
    $usedSwap = ($totalVirtualMemory - $freeVirtualMemory) - ($totalVisibleMemory - $freePhysicalMemory)
    if ($usedSwap -lt 0) { $usedSwap = 0 }
    
    $totalSwap = $totalVirtualMemory - $totalVisibleMemory
    $percentUsedSwap = if ($totalSwap -gt 0) { ($usedSwap / $totalSwap) * 100 } else { 0 }
    
    Write-Host "Memoria física libre: $([math]::Round($freePhysicalMemory)) bytes ($([math]::Round($percentFreePhysicalMemory, 2))%)"
    Write-Host "Espacio de swap en uso: $([math]::Round($usedSwap)) bytes ($([math]::Round($percentUsedSwap, 2))%)"
}

function Get-EstablishedConnections {
    Write-Host "=== CONEXIONES DE RED ACTIVAS (ESTABLISHED) ===" -ForegroundColor Cyan
    
    $connections = Get-NetTCPConnection -State Established
    $connectionCount = $connections.Count
    
    Write-Host "Número de conexiones activas (ESTABLISHED): $connectionCount"
    
    # Mostrar detalles de las conexiones
    $connections | Format-Table -Property LocalAddress, LocalPort, RemoteAddress, RemotePort -AutoSize
}

# Bucle principal del programa
do {
    Show-Menu
    $choice = Read-Host "Ingresa tu opción"
    
    switch ($choice) {
        '1' { 
            Get-Top5CPUProcesses
            Pause }
        '2' { 
            Get-DiskInfo
            Pause }
        '3' { 
            Find-LargestFile
            Pause }
        '4' { 
            Get-MemoryInfo
            Pause
             }
        '5' { 
            Get-EstablishedConnections
            Pause }
        'Q' { 
            return
            Pause }
        'q' { 
            return
            Pause }
        default { 
            Write-Host "Opción inválida. Presiona cualquier tecla para continuar..." -ForegroundColor Red
            Pause
        }
    }
} while ($true)
