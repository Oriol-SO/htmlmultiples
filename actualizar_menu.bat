@echo off
echo ========================================================
echo   ACTUALIZANDO EL MENU DE LA BARRA LATERAL (SIDEBAR)
echo ========================================================
echo.

powershell -NoProfile -ExecutionPolicy Bypass -File "src\generador_menu.ps1"

echo.
echo ========================================================
echo   ?Listo! Ahora puedes refrescar tu index.html
echo ========================================================
pause

