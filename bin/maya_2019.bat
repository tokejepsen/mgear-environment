
set MAYA_PLUG_IN_PATH=%MAYA_PLUG_IN_PATH%;%~dp0plugins
cd "%~p1"
start "" "C:/Program Files/Autodesk/Maya2019/bin/maya.exe" %*
