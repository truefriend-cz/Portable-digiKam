@echo off

set "ThisDir=%~dp0"
set "ThisDir=%ThisDir:~0,-1%"


for %%I in ("%ThisDir%\..") do set "ThisDir=%%~fI"
pushd %ThisDir%


set "path_D=C:\Temp_digiKam"
del "%path_D%\*" /F /Q
for /d %%p in ("%path_D%\*") do rd /Q /S "%%p"
rd /Q /S "%path_D%"

mkdir "C:\Temp_digiKam"
mkdir "%ThisDir%\Backup\DB"
mkdir "%ThisDir%\Backup\Settings"

xcopy "%ThisDir%\Backup\DB\*" "C:\Temp_digiKam\" /E
xcopy "%ThisDir%\Backup\Settings\*" "%LocalAppData%\" /E

rem SET LANG=en.UTF-8
"%ThisDir%\Bin\digiKam\digikam.exe"

%windir%\System32\taskkill.exe /f /im digikam.exe

set "path_A=%ThisDir%\Backup\DB"
del "%path_A%\*" /F /Q
for /d %%p in ("%path_A%\*") do rd /Q /S "%%p"
rd /Q /S "%path_A%"

set "path_B=%ThisDir%\Backup\Settings"
del "%path_B%\*" /F /Q
for /d %%p in ("%path_B%\*") do rd /Q /S "%%p"
rd /Q /S "%path_B%"

set "path_C=%LocalAppData%\digikam"
del "%path_C%\*" /F /Q
for /d %%p in ("%path_C%\*") do rd /Q /S "%%p"
rd /Q /S "%path_C%"

mkdir "%ThisDir%\Backup\DB"
mkdir "%ThisDir%\Backup\Settings"

del "C:\Temp_digiKam\recognition.db" /F /Q
del "C:\Temp_digiKam\thumbnails-digikam.db" /F /Q
xcopy "C:\Temp_digiKam\*" "%ThisDir%\Backup\DB\" /E
xcopy "%LocalAppData%\digikam_systemrc" "%ThisDir%\Backup\Settings\"
xcopy "%LocalAppData%\digikamrc" "%ThisDir%\Backup\Settings\"


set "path_D=C:\Temp_digiKam"
del "%path_D%\*" /F /Q
for /d %%p in ("%path_D%\*") do rd /Q /S "%%p"
rd /Q /S "%path_D%"

del "%LocalAppData%\digikam_systemrc" /F /Q
del "%LocalAppData%\digikamrc" /F /Q


popd
exit