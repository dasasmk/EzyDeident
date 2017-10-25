cd /d %~dp0
SET PATH=%PATH%;%CD%\..\PortableEnv\Pandoc;%CD%\..\PortableEnv\miktex-portable-2.9.5719\miktex\bin;%CD%
..\PortableEnv\R-Portable\App\R-Portable\bin\i386\RScript.exe ..\PortableEnv\R-Portable\App\R-Portable\bin\start.R
pause