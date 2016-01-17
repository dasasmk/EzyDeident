cd /d %~dp0
SET PATH=%PATH%;%CD%
RScript.exe --internet2 "%CD%/run.R"
pause