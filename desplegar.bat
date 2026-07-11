@echo off
echo Preparando los archivos para subir...
git add .

echo.
echo Creando el commit con la fecha actual...
git commit -m "Actualizacion %DATE% %TIME%"

echo.
echo Subiendo los cambios a GitHub (origin main)...
git push origin main

echo.
echo =========================================
echo ?Despliegue completado!
echo =========================================
pause

