:: Change the working directory to the conda-git-deployment directory.
:: "pushd" is being used so any UNC paths get mapped until a restart happens.
pushd %~dp0

:: Make CWD root of avalon-environment repository.
cd ..

:: Isolating the execution environment.
:: Powershell is needed for downloading miniconda.
set PATH=C:\WINDOWS\System32\WindowsPowerShell\v1.0

:: Get installation directory.
set MINICONDA_DIRECTORY=%~dp0miniconda
set INSTALLATION_DIRECTORY=%MINICONDA_DIRECTORY%\windows

:: Install miniconda if the directory %directory% does not exist.
IF EXIST %INSTALLATION_DIRECTORY% GOTO INSTALLATIONEXISTS

:: Create "installers" directory if it does not exist, and download miniconda into it.
IF EXIST %MINICONDA_DIRECTORY%\miniconda.exe GOTO INSTALLEREXISTS
mkdir %MINICONDA_DIRECTORY%
SET "FILENAME=%MINICONDA_DIRECTORY%\miniconda.exe"
SET "URL=https://repo.continuum.io/miniconda/Miniconda2-latest-Windows-x86_64.exe"
powershell "Import-Module BitsTransfer; Start-BitsTransfer '%URL%' '%FILENAME%'"
:INSTALLEREXISTS

%MINICONDA_DIRECTORY%\miniconda.exe /RegisterPython=0 /AddToPath=0 /S /D=%INSTALLATION_DIRECTORY%
:INSTALLATIONEXISTS

:: Set minimum PATH for conda to function.
:: PATH has to have "C:\Windows\System32" for conda to function properly. Specifically for "cmd" and "chcp" executables.
set PATH=C:\Windows\System32;%INSTALLATION_DIRECTORY%\Scripts

:: Activate conda by activating the root environment
call activate root

:: Ensure mgear environment is setup
IF EXIST %INSTALLATION_DIRECTORY%\envs\mgear-environment GOTO ENVIRONMENTEXISTS
call conda env create -f %~dp0environment.yml
:ENVIRONMENTEXISTS

:: Activate mgear environment
call activate mgear-environment

:: Initialize git and submodules
IF EXIST %~dp0avalon-setup\bin GOTO SUBMODULESEXISTS
python %~dp0initialize_git.py
git submodule update --init --recursive
:SUBMODULESEXISTS

:: Setup mGear
set PATH=%~dp0;%PATH%
set PYTHONPATH=%~dp0mgear_dist\framework\scripts;%~dp0animbits\scripts;%~dp0crank\scripts;%~dp0flex\scripts;%~dp0mgear_core\scripts;%~dp0rigbits\scripts;%~dp0shifter\scripts;%~dp0shifter_classic_components\scripts;%~dp0simpleRig\scripts;%~dp0synoptic\scripts
