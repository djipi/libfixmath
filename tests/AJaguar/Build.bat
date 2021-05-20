@echo off
cls
echo.
echo Build libfixmath's M68K library testing suite
echo.

IF %1.==. goto usage
IF %2.==. goto usage
make -f makefile cmd=%1 version=%2
goto end

:usage
echo Usage
echo "build <all | assemble | compile | clean | debug_dump | link | makedirs | rebuild> <Debug | Release>"
goto end

:end
echo.
@echo on
