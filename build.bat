:: Emulator Game Bundler
:: Ver. 0.0.9
:: Author: Kris Kofler
@echo off
set _defaultSettingsPath=".\settings.ini"
set _defaultManifestPath=".\manifest.ini"
set _defaultPathToEmulator="C:\emulator.exe"
set _defaultPathToLibrary="C:\library"
if exist %_defaultSettingsPath% (goto :settingsExist) else (goto :settingsNotExist)

:settingsExist
set _defaultSettingsPath=%_defaultSettingsPath:"=%
for /f "tokens=1,2 delims==" %%a in (%_defaultSettingsPath%) do (
		if %%a==pathToEmulator set _pathToEmulator=%%b
		if %%a==pathToLibrary set _pathToLibrary=%%b
		if %%a==binaryFileMode set _binaryFileMode=%%b
		if %%a==attributes set _attributes=%%b
	)

goto :checkDefaults

:settingsNotExist
set _pathToEmulator=%_defaultPathToEmulator%
set _pathToLibrary=%_defaultPathToLibrary%
goto :checkDefaults

:checkDefaults
if not defined _pathToEmulator set _pathToEmulator=%_defaultPathToEmulator%
if not defined _pathToLibrary set _pathToLibrary=%_defaultPathToLibrary%
goto :manifest


:manifest
if exist %_defaultManifestPath% (goto :manifestExist) else (goto :manifestNotExist)

:manifestExist
set _defaultManifestPath=%_defaultManifestPath:"=%
for /f "tokens=1,2 delims==" %%a in (%_defaultManifestPath%) do (
		if %%a==packageTitle set _packageTitle=%%b
		if %%a==icon set _icon=%%b
		if %%a==packageDescription set _packageDescription=%%b
		if %%a==serialNumber set _serialNumber=%%b
		if %%a==binaryDir set _binaryDir=%%b
		if %%a==fileToRun set _fileToRun=%%b
	)

if not defined _packageTitle (goto :packageTitleNotExist) else (goto :packageTitleExist)

:packageTitleExist
set _packageDirectory=%_packageTitle: =-%
set _packageDirectory=%_packageDirectory:A=a%
set _packageDirectory=%_packageDirectory:B=b%
set _packageDirectory=%_packageDirectory:C=c%
set _packageDirectory=%_packageDirectory:D=d%
set _packageDirectory=%_packageDirectory:E=e%
set _packageDirectory=%_packageDirectory:F=f%
set _packageDirectory=%_packageDirectory:G=g%
set _packageDirectory=%_packageDirectory:H=h%
set _packageDirectory=%_packageDirectory:I=i%
set _packageDirectory=%_packageDirectory:J=j%
set _packageDirectory=%_packageDirectory:K=k%
set _packageDirectory=%_packageDirectory:L=l%
set _packageDirectory=%_packageDirectory:M=m%
set _packageDirectory=%_packageDirectory:N=n%
set _packageDirectory=%_packageDirectory:O=o%
set _packageDirectory=%_packageDirectory:P=p%
set _packageDirectory=%_packageDirectory:Q=q%
set _packageDirectory=%_packageDirectory:R=r%
set _packageDirectory=%_packageDirectory:S=s%
set _packageDirectory=%_packageDirectory:A=a%
set _packageDirectory=%_packageDirectory:T=t%
set _packageDirectory=%_packageDirectory:U=u%
set _packageDirectory=%_packageDirectory:V=v%
set _packageDirectory=%_packageDirectory:W=w%
set _packageDirectory=%_packageDirectory:X=x%
set _packageDirectory=%_packageDirectory:Y=y%
set _packageDirectory=%_packageDirectory:Z=z%

set _pathToLibrary=%_pathToLibrary:"=%
set _packageDirectoryFullPath="%_pathToLibrary%\%_packageDirectory%%_serialNumber%"
if not exist %_packageDirectoryFullPath% mkdir %_packageDirectoryFullPath%
goto :checkSerialNumber

:checkSerialNumber
if not defined _serialNumber (goto :serialNumberNotExist) else (goto :serialNumberExist)

:serialNumberExist
set _serialNumber=%_serialNumber:"=%
set _serialNumber=%_serialNumber: =-%
set _binaryDirectoryFullPath="%_pathToLibrary%\%_packageDirectory%%_serialNumber%"
if not exist %_binaryDirectoryFullPath% mkdir %_binaryDirectoryFullPath%
goto :makeLauncher

:serialNumberNotExist
set _int=0
set _serialNumber=no-serial-%_int%
set _binaryDirectoryFullPath="%_pathToLibrary%\%_packageDirectory%%_serialNumber%"
if exist %_binaryDirectoryFullPath% (goto :genericSerialNumberExist) else (goto :genericSerialNumberNotExist)

:genericSerialNumberExist
set /a _int=%_int%+1
set _serialNumber=no-serial-%_int%
set _binaryDirectoryFullPath="%_pathToLibrary%\%_packageDirectory%%_serialNumber%"
if exist %_binaryDirectoryFullPath% (goto :genericSerialNumberExist) else (goto :genericSerialNumberNotExist)

:genericSerialNumberNotExist
mkdir %_binaryDirectoryFullPath%
goto :makeLauncher

:makeLauncher
setlocal enabledelayedexpansion
for %%i in (%_pathToEmulator%) do (
	set _emuDir=%%~dpi
)
if not defined _fileToRun goto :fileToRunNotExist
set _fileToRun=%_fileToRun:~1%
set _binaryFileFullPath="%_pathToLibrary%\%_packageDirectory%%_serialNumber%\%_packageDirectory%%_serialNumber%%_fileToRun%"

REM Make TEMP
if not exist ".\_temp" mkdir ".\_temp"

REM VBS Script
if defined _attributes (set _attributes= %_attributes% ) else (set _attributes= )
set _vbsTempName=_s
set _vbs=".\_temp\%_vbsTempName%.vbs"
@echo Dim a, b, c>%_vbs%
@echo a = "!_emuDir!">>%_vbs%
@echo b = %_pathToEmulator%>>%_vbs%
@echo c = %_binaryFileFullPath%>>%_vbs%
@echo d = "%_attributes%">>%_vbs%
@echo Set sh = CreateObject("Wscript.Shell")>>%_vbs%
@echo Set fs = CreateObject("Scripting.FileSystemObject")>>%_vbs%
@echo if (fs.FileExists(b)) then>>%_vbs%
@echo   if (fs.FileExists(c)) then>>%_vbs%
@echo     sh.CurrentDirectory = a>>%_vbs%
@echo         sh.Run("cmd.exe /c " ^& b ^& d ^& c), ^0>>%_vbs%
@echo   else>>%_vbs%
@echo     MsgBox("CD Image is missing: " ^& c)>>%_vbs%
@echo   end if>>%_vbs%
@echo else>>%_vbs%
@echo   MsgBox("Emulator is missing: " ^& b)>>%_vbs%
@echo end if>>%_vbs%

set _vbsWrapper=".\utils\vbs-wrapper.bat"
if not exist %_vbsWrapper% goto :utilsVbsWrapperNotExist
call %_vbsWrapper% %_vbs%
set _exe=%_vbsTempName%.exe

echo.Moving %_exe% to _temp
if exist ".\%_exe%" (move /y ".\%_exe%" ".\_temp\%_exe%") else (goto :exeFileNotCreated)

REM Remove VBS
echo.Removing VBS from _temp
if exist %_vbs% del %_vbs%

set _rh=".\utils\rh.exe"
if not exist %_rh% goto :utilsRhNotExist
set _exe=".\_temp\%_exe%"
set _rhExe=%_rh% -open %_exe% -save %_exe% -action
%_rhExe% delete -mask AVI
%_rhExe% delete -mask Dialog
%_rhExe% delete -mask Icon
%_rhExe% delete -mask StringTable
%_rhExe% delete -mask VERSIONINFO

if not defined _icon set _icon=".\assets\psx.ico"
if not defined _packageDescription set _packageDescription=Emulator game launcher

REM Create resource for .exe
set _versioninfo=.\_temp\s.rc
@echo 1 VERSIONINFO>%_versioninfo%
@echo FILEVERSION     1,0,0,^0>>%_versioninfo%
@echo PRODUCTVERSION  1,0,0,^0>>%_versioninfo%
@echo BEGIN>>%_versioninfo%
@echo   BLOCK "StringFileInfo">>%_versioninfo%
@echo   BEGIN>>%_versioninfo%
@echo     BLOCK "000004b0">>%_versioninfo%
@echo     BEGIN>>%_versioninfo%
@echo       VALUE "LegalCopyright", "n/a">>%_versioninfo%
@echo       VALUE "CompanyName", "Emulator Game Bundler">>%_versioninfo%
@echo       VALUE "FileDescription", "%_packageTitle%: %_packageDescription%">>%_versioninfo%
@echo       VALUE "FileVersion", "1.0">>%_versioninfo%
@echo       VALUE "ProductVersion", "%_serialNumber%">>%_versioninfo%
@echo       VALUE "InternalName", "%_packageTitle%">>%_versioninfo%
@echo       VALUE "OriginalFilename", "%_packageTitle%.exe">>%_versioninfo%
@echo       VALUE "ProductName", "%_packageTitle%">>%_versioninfo%
@echo     END>>%_versioninfo%
@echo   END>>%_versioninfo%
@echo   BLOCK "VarFileInfo">>%_versioninfo%
@echo   BEGIN>>%_versioninfo%
@echo     VALUE "Translation", 0x0000, 1200>>%_versioninfo%
@echo   END>>%_versioninfo%
@echo END>>%_versioninfo%

REM Compile rc
if not exist %_versioninfo% goto :resourceNotExist
%_rh% -open %_versioninfo% -save %_versioninfo%.res -action compile
if not exist %_versioninfo%.res goto :resourceNotExist
%_rhExe% add -res %_versioninfo%.res -mask VERSIONINFO,,
if exist %_icon% (%_rhExe% add -res %_icon% -mask ICONGROUP,1,1033) else (%_rhExe% add -res ".\assets\psx.ico" -mask ICONGROUP,1,1033)
%_rhExe% changelanguage(1033)
if exist %_versioninfo% del %_versioninfo%
if exist %_versioninfo%.res del %_versioninfo%.res

move /y %_exe% "%_pathToLibrary%\%_packageDirectory%%_serialNumber%\%_packageTitle%.exe"

REM remove TEMP
if exist ".\_temp" rmdir /s /q ".\_temp"

REM Copy/Move Files
if not defined _binaryFileMode (set _binaryFileMode=false)
REM if %_binaryFileMode%==copy if exist %_binaryDir% xcopy /s %_binaryDir% %_binaryDirectoryFullPath%
REM if %_binaryFileMode%==move if exist %_binaryDir% move /y %_binaryDir%\*.* %_binaryDirectoryFullPath%

if %_binaryFileMode%==false (goto :end) else (goto :copyAndMove)

echo.msg: I started coping or Moving
PAUSE

:copyAndMove
set _from=%_binaryDir%
set _to=%_pathToLibrary%\%_packageDirectory%%_serialNumber%
set _fileTitle=%_packageDirectory%
set _fileSN=%_serialNumber%
for %%f in (%_from%\*.*) do (
  for %%i in (%%f) do (
  	set _ext=%%~xi
  )
  set _newfile=%_to%\%_fileTitle%%_fileSN%!_ext!

  set _counter=2
  if exist !_newfile! set _newfile=%_to%\%_fileTitle%%_fileSN%-!_counter!!_ext!

  :rename
  if exist !_newfile! (
    set /a _counter=!_counter!+1
    set _newfile=%_to%\%_fileTitle%%_fileSN%-!_counter!!_ext!
  )
  if exist !_newfile! goto :rename

  echo.file: !_newfile!
  if %_binaryFileMode%==move (move %%f !_newfile!)
	if %_binaryFileMode%==copy (copy %%f !_newfile!)
)

echo.Bundle created
goto :end

:manifestNotExist
echo.Manifest is missing: %_defaultManifestPath%
goto :end

:packageTitleNotExist
echo.Manifest.packageTitle is missing
goto :end

:utilsVbsWrapperNotExist
echo.Utility vbs-wrapper.bat is missing
goto :end

:utilsRhNotExist
echo.Utility rh.exe(Resource Hacker) is missing
goto :end

:exeFileNotCreated
echo.Executable not created
goto :end

:resourceNotExist
echo.Resource file not created
goto :end

:fileToRunNotExist
echo.File to run is undefined
goto :end

:end
endlocal
echo ---
PAUSE
