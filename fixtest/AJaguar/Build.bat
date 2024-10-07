@echo off
cls
echo.
echo Build libfixmath's M68K library fixtest suite
echo.

if %1.==. goto usage
if %1.==HELP. goto usage
if %2.==. goto builwo2
make -f makefile %1 cmd=%1 mode=%2
goto end

:builwo2
make -f Makefile %1 cmd=%1 mode=Debug
goto end

:usage
echo Usage:
echo -----
echo:build HELP
echo -----
echo "build <all | assemble | clean | compile | link | makedirs | rebuild | reports> <Debug | Release>"
echo Note: Debug is set by default
if %1.==HELP. goto HELP
goto end

:HELP
echo.
echo Options:
echo -----
echo all : incremental build source
echo -----
echo assemble : assembling
echo -----
echo clean : remove all build outputs
echo -----
echo compile : compilation
echo -----
echo HELP : display this help page
echo -----
echo link : create the application
echo -----
echo makedirs : create the necessary directories
echo -----
echo rebuild : clean, and rebuild sources to make a fresh new build
goto end

:end
echo.
@echo on
