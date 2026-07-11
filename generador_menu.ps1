$ErrorActionPreference = "Stop"

# La carpeta que contiene las páginas (ajustado a "paginas")
$targetFolder = "paginas"

# Asegurarse de que estamos en el directorio correcto
$basePath = (Resolve-Path $targetFolder -ErrorAction SilentlyContinue).Path

if (-not $basePath) {
    Write-Host "La carpeta '$targetFolder' no existe. Por favor, crea la carpeta primero."
    exit
}

function Get-FolderTree {
    param($path)
    
    $items = Get-ChildItem -Path $path
    $result = @()
    
    foreach ($item in $items) {
        # Calcular la ruta relativa para el iframe
        $relativePath = $item.FullName.Substring($basePath.Length + 1) -replace '\\', '/'
        
        if ($item.PSIsContainer) {
            # Es una carpeta, procesar su contenido recursivamente
            $children = Get-FolderTree -path $item.FullName
            if ($children.Count -gt 0) {
                $result += @{
                    type     = 'folder'
                    name     = $item.Name
                    children = $children
                }
            }
        }
        else {
            # Es un archivo, solo agregar si es HTML
            if ($item.Name -match '\.html$') {
                $result += @{
                    type = 'file'
                    name = $item.Name
                    path = "$targetFolder/$relativePath"
                }
            }
        }
    }
    return $result
}

Write-Host "Leyendo la carpeta '$targetFolder'..."
$tree = Get-FolderTree -path $basePath

# Convertir el arbol a JSON y guardarlo como un script JS
$json = $tree | ConvertTo-Json -Depth 10 -Compress
$jsContent = "const menuData = $json;"

# Escribir el archivo
$jsContent | Out-File -FilePath "menu_data.js" -Encoding utf8

Write-Host "¡Menú actualizado exitosamente en 'menu_data.js'!"
