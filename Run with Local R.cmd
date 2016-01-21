cd /d %~dp0
SET PATH=%PATH%;%CD%
RScript.exe setup.R
RScript.exe run_local_unix.R
pause