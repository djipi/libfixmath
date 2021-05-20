@echo off
cls
echo.
echo Build libfixmath's M68K library
echo.

if %1.==. goto usage
if %1.==FULL. goto FULL
if %1.==HELP. goto usage
if %2.==. goto builwo2
if %2.==ALL. goto ALL
make -f Makefile %1 cmd=%1 env=%2
goto end

:FULL
make -f Makefile all cmd=all env=Debug
make -f Makefile all cmd=all env=Profile
make -f Makefile all cmd=all env=Release
goto end

:ALL
make -f Makefile %1 cmd=%1 env=Debug
make -f Makefile %1 cmd=%1 env=Profile
make -f Makefile %1 cmd=%1 env=Release
goto end

:builwo2
make -f Makefile %1 cmd=%1 env=Debug
goto end

:usage
echo Usage:
echo -----
echo:build FULL
echo -----
echo:build HELP
echo -----
echo "build <all | clean[_...] | compile | config | link | makedirs | rebuild | report_[...] | reports> <ALL | Debug | Profile | Release>"
echo Note: Debug is set by default
if %1.==HELP. goto HELP
goto end

:HELP
echo.
echo Options:
echo -----
echo all : incremental build source
echo -----
echo clean[_...] can be empty or be completed with:
echo d : remove the *.d files from the project
echo obj : remove the *.o files from the project (Runtime not included)
echo report : remove the report text files
echo s : remove the *.s files (from C compilation in case of -S option has been set)
echo su : remove the *.su files from the project
echo -----
echo compile : compilation
echo -----
echo config : display the makefile configuration
echo -----
echo FULL : build all environements (Debug, etc.) 
echo -----
echo HELP : display this help page
echo -----
echo link : create the library
echo -----
echo makedirs : create the necessary directories
echo -----
echo rebuild : clean, and rebuild sources to make a fresh new build
echo -----
echo report_[...] must be completed with:
echo stack : generate a stack usage report based on generated *.su files
echo -----
echo reports : generate all reports available
goto end

:end
echo.
@echo on
