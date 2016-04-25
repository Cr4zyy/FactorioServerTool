@echo off 
setlocal
:: Factorio Server Tool v0.1.34
:: 24/Apr/2016
:: http://cr4zyb4st4rd.co.uk
:: https://github.com/Cr4zyy/FactorioServerTool

::Skip this stuff only called when needed
goto skip
::Functions and calls
:ascii
echo _______________________________________________________________________________
echo -------------------------------------------------------------------------------
echo            888888    db     dP""b8 888888  dP"Yb  88""Yb 88  dP"Yb  
echo  ________  88__     dPYb   dP   `"   88   dP   Yb 88__dP 88 dP   Yb  ________
echo  """"""""  88""    dP__Yb  Yb        88   Yb   dP 88"Yb  88 Yb   dP  """""""" 
echo            88     dP""""Yb  YboodP   88    YbodP  88  Yb 88  YbodP  
echo.
echo  .dP"Y8 888888 88""Yb Yb    dP 888888 88""Yb     888888  dP"Yb   dP"Yb  88     
echo  `Ybo." 88__   88__dP  Yb  dP  88__   88__dP       88   dP   Yb dP   Yb 88     
echo  o.`Y8b 88""   88"Yb    YbdP   88""   88"Yb        88   Yb   dP Yb   dP 88  .o 
echo  8bodP' 888888 88  Yb    YP    888888 88  Yb       88    YbodP   YbodP  88ood8 
echo -------------------------------------------------------------------------------
echo _______________________________________________________________________________
echo.
goto:eof

:getDateTime
for /f "tokens=2 delims==" %%I in ('wmic os get localdatetime /format:list') do set dateTime=%%I
set dateTime=%dateTime:~0,8%-%dateTime:~8,6%
goto:eof

:: %2 > or eq to %1 < or eq to %3
:GEOLE
set GEOLEvalue=0
set GEOLEerror=0
set evalue=0

::make sure we're working with numbers here!
set /a "num1=%1"
set /a "num2=%2"
set /a "num3=%3"
IF %1 NEQ %num1% set GEOLEerror=1&& goto:eof
IF %2 NEQ %num2% set GEOLEerror=1&& goto:eof
IF %3 NEQ %num3% set GEOLEerror=1&& goto:eof

IF %num1% GEQ %num2% set /a "evalue+=1"
IF %num1% LEQ %num3% set /a "evalue+=1"
IF %evalue% EQU 2 set GEOLEvalue=1
goto:eof

::Write values to ini config
:iniWrite
call :clearEL
type %3 | find /v "%1=" > "%writeTemp%"
copy /y %writeTemp% %3
IF ERRORLEVEL 1 set failed=Could not write file Make sure you have permission, you may need to run this tool as an admin ^(right-click run as admin^)  Attempted to write files to: %3&& call :errorEnd 0
echo %1=%2 >> %3
del %writeTemp%
goto:eof

::Read the values from the ini config
:iniRead
pushd "%3"
	FOR /f "delims== tokens=2" %%i in ('findstr "%1=" "%4"') do set readOutput=%%i
	::batch is atrocious so we're writing many values with spaces on the end unavoidably, this is to remove those...
	set %2=%readOutput: =%
popd
goto:eof

::sets errorlevel to 0 properly
:clearEL
exit /b 0

:skip
set vnumber=0.1.34
::scale cmd to fit nicely
mode con: cols=80 lines=60
::prettyness
color 30
title Factorio Server Tool %vnumber%
::grab and store ip because it echos annoying stuff
for /f "skip=4 usebackq tokens=2" %%a in (`nslookup myip.opendns.com resolver1.opendns.com`) do set CurrIP=%%a
cls

::variables
set BatchDir=%~dp0
set FSTbat=%~f0

::FactorioServerTool files
set FST_Config=%appdata%\Factorio\FST_Config.ini
set FST_ConfigFile=FST_Config.ini
set FST_ConfigDir=%appdata%\Factorio
set FacAppdata=%appdata%\Factorio

::If a user wants they can store the config.ini in the same place as the batchfile this is a check for that.
IF EXIST "%BatchDir%\FST_Config.ini" (
	set FST_Config=%BatchDir%\FST_Config.ini
	set FST_ConfigDir=%BatchDir%
)
::Try to create temp files in %temp%, if that fails try %appdata%, if that fails error
IF NOT EXIST "%temp%\Factorio" (
	mkdir "%temp%\Factorio"
	IF ERRORLEVEL== 1 (
		IF NOT EXIST "%appdata%\Factorio" (
			mkdir "%appdata%\Factorio"
			IF ERRORLEVEL== 1 (
				set failed=The tool could not create a temporary folder in either your temp or appdata folders, please try running the tool as an administrator to gain permissions.
				goto errorEnd
			) else (
				set FacTemp=%appdata%\Factorio
				set TempConfig=%appdata%\Factorio\config-temp.tmp
				set TempFile=%appdata%\Factorio\temp.tmp
				set writeTemp=%appdata%\Factorio\writeTemp.tmp
				set TempLib=%appdata%\Factorio\TempLib.tmp
			)
		)
	) else (
		set FacTemp=%temp%\Factorio
		set TempConfig=%temp%\Factorio\config-temp.tmp
		set TempFile=%temp%\Factorio\temp.tmp
		set writeTemp=%temp%\Factorio\writeTemp.tmp
		set TempLib=%temp%\Factorio\TempLib.tmp
	)		
) else (
	set FacTemp=%temp%\Factorio
	set TempConfig=%temp%\Factorio\config-temp.tmp
	set TempFile=%temp%\Factorio\temp.tmp
	set writeTemp=%temp%\Factorio\writeTemp.tmp
	set TempLib=%temp%\Factorio\TempLib.tmp
)

:: Default FST settings/options
:: Used incase of resets etc
set Latency=100
set AutoSaveTimer=5
set AutoSaveSlots=3
set NewServerPort=34190
set InstallDir=0
set OptionDelay=10
set CreateSave=0
set FastStart=0
set SaveSelection=0
set SetupComplete=0
set WinOS=0
set ExtraParams=0

::string vars
set errorString1=The tool has attempted to fix the error that occured, please re-launch the tool. If these errors continue please delete the config located:  %FST_Config%
set enterRecommended=       Enter/Return will input the default 'Recommended' value listed

:: Check if batch has been run before and a config exists
IF NOT EXIST "%FST_Config%" goto setupBatch

call :iniRead version cfgvnumber "%FST_ConfigDir%" "%FST_ConfigFile%"
set /a cfgvnumber=cfgvnumber
set intvnumber=%vnumber:.=%
::if cfg older than 0.1.31 write new values if they DONT exist!
IF %cfgvnumber% LEQ 0131 (
	echo ------------------------------------------------------------------------------  
	echo  NOTE! If you were using an older version due to changes in making this tool
	echo  work across other Windows locale installs the tool could quit without error
	echo.
	echo  If that is the case you may have to delete the config file for the tool which
	echo  is located at: %FST_Config%
	echo.
	echo ------------------------------------------------------------------------------
	pause
)
::  read ini  "Search STRG" "VAR to set" "Folder containing file" "File to search"
:: have to specify folder seperately because findstr cant handle spaces in dir names....
call :iniRead SetupComplete SetupValue "%FST_ConfigDir%" "%FST_ConfigFile%"
IF [%SetupValue%]==[1] ( 
	goto checkBatch 
) else ( 
	goto setupBatch 
)

:checkBatch
call :ascii
echo ------------------------------------------------------------------------------  
echo  Reading config options from file:
echo  %FST_Config%
echo ------------------------------------------------------------------------------  
echo.

call :iniRead version cfgvnumber "%FST_ConfigDir%" "%FST_ConfigFile%"
set /a cfgvnumber=cfgvnumber
set intvnumber=%vnumber:.=%
::if cfg older than 0.1.31 write new values if they DONT exist!
IF %cfgvnumber% LEQ 0131 (
	echo ------------------------------------------------------------------------------  
	echo  Detected an older config file version, writing new entries as required.
	echo ------------------------------------------------------------------------------ 
	
	find "ExtraParams=" "%FST_Config%" > NUL
	IF ERRORLEVEL== 1 ( call :iniWrite ExtraParams %ExtraParams% "%FST_Config%" )
	
	call :clearEL
	
	find "FastStart=" "%FST_Config%" > NUL
	IF ERRORLEVEL== 1 ( call :iniWrite FastStart %FastStart% "%FST_Config%" )
	
	call :clearEL
	
	find "version=" "%FST_Config%" > NUL
	set intvnumber=%vnumber:.=%
	IF ERRORLEVEL== 1 ( call :iniWrite version %intvnumber% "%FST_Config%" )
	
	echo ------------------------------------------------------------------------------ 
)

::  read ini  "Search STRG" "VAR to set" "File to search"
call :iniRead SetupComplete SetupValue "%FST_ConfigDir%" "%FST_ConfigFile%"
IF [%SetupValue%]==[] set failed=%errorString1%&& call :errorFix SetupComplete 1
call :GEOLE %SetupValue% 0 1
::Check SetupComplete
IF %GEOLEvalue%== 1 echo SetupComplete = OK
IF %GEOLEvalue%== 0 set failed=%errorString1%&& call :errorFix SetupComplete 1
IF %GEOLEerror%== 1 set failed=%errorString1%&& call :errorFix SetupComplete 1


::Check Install Directory
call :iniRead InstallDir SavedDir "%FST_ConfigDir%" "%FST_ConfigFile%"
:: sets the dir in a usable fashion with spaces
set FactorioDir=%SavedDir:?= %
:: sets dir with no spaces
set InstallDir=%SavedDir%
IF EXIST "%FactorioDir%\bin" echo InstallDir = OK
IF NOT EXIST "%FactorioDir%\bin" set failed=%errorString1%&& call :errorFix InstallDir 0 SetupComplete 0

::get FacData for var
call :iniRead FacData FacData "%FST_ConfigDir%" "%FST_ConfigFile%"
set FacData=%FacData:?= %
call :iniRead FacConfig FactorioConfig "%FST_ConfigDir%" "%FST_ConfigFile%"
set FacCfg=%FactorioConfig:?= %
::set the server data vars
::faccfg
set DefaultConfig=%FacCfg%\config.ini
set ServerConfig=%FacCfg%\config-server.ini
set ServerConfigFile=config-server.ini
::facdata
set ServerSaveFolder=%FacData%\server\saves
set ServerModFolder=%FacData%\server\mods
set StandardSaveFolder=%FacData%\saves
set StandardModFolder=%FacData%\mods
set ServerFolder=%FacData%\server

::Check for 32/64 bit Install
call :iniRead WinOS WinOS "%FST_ConfigDir%" "%FST_ConfigFile%"
IF EXIST "%FactorioDir%\bin\%WinOS%\Factorio.exe" echo Executable = OK
IF NOT EXIST "%FactorioDir%\bin\%WinOS%\Factorio.exe" set failed=%errorString1%&& call :errorFix WinOS 0

::Check AutoSave Timer
call :iniRead AutoSaveTimer AutoSaveTimer "%FST_ConfigDir%" "%FST_ConfigFile%"
call :GEOLE %AutoSaveTimer% 1 500
IF %GEOLEvalue%== 1 echo AutoSaveTimer = OK
IF %GEOLEvalue%== 0 set failed=%errorString1%&& call :errorFix AutoSaveTimer 5
IF %GEOLEerror%== 1 set failed=%errorString1%&& call :errorFix AutoSaveTimer 5

::Check AutoSave Slots
call :iniRead AutoSaveSlots AutoSaveSlots "%FST_ConfigDir%" "%FST_ConfigFile%"
call :GEOLE %AutoSaveSlots% 1 500
IF %GEOLEvalue%== 1 echo AutoSaveSlots = OK
IF %GEOLEvalue%== 0 set failed=%errorString1%&& call :errorFix AutoSaveSlots 3
IF %GEOLEerror%== 1 set failed=%errorString1%&& call :errorFix AutoSaveSlots 3

::Check Latency
call :iniRead Latency Latency "%FST_ConfigDir%" "%FST_ConfigFile%"
call :GEOLE %Latency% 1 5000
IF %GEOLEvalue%== 1 echo Latency = OK
IF %GEOLEvalue%== 0 set failed=%errorString1%&& call :errorFix Latency 100
IF %GEOLEerror%== 1 set failed=%errorString1%&& call :errorFix Latency 100

::Check Save Selection
call :iniRead SaveSelection SaveSelection "%FST_ConfigDir%" "%FST_ConfigFile%"
call :GEOLE %SaveSelection% 0 1
IF %GEOLEvalue%== 1 echo SaveSelection = OK
IF %GEOLEvalue%== 0 set failed=%errorString1%&& call :errorFix SaveSelection 0
IF %GEOLEerror%== 1 set failed=%errorString1%&& call :errorFix SaveSelection 0

::Check Fast Start
::this value is not set by the batch but can be added as explained in the "About"
call :iniRead FastStart FastStart "%FST_ConfigDir%" "%FST_ConfigFile%"
IF %FastStart%==%FastStart: =% set FastStart=0
call :GEOLE %FastStart% 0 1
IF %GEOLEvalue%== 1 ( IF %FastStart%== 1 echo FastStart = OK )
IF %GEOLEvalue%== 0 set failed=%errorString1%&& call :errorFix FastStart 0
IF %GEOLEerror%== 1 set failed=%errorString1%&& call :errorFix FastStart 0

::Check for config-server.ini 
IF NOT EXIST %ServerConfig% set failed=%errorString1%&& call :errorFix SetupComplete 0

::Check ExtraParams
::this value is not set by the batch but can be added as explained in the "About"
find "ExtraParams=" "%FST_Config%" > NUL
IF %ERRORLEVEL%== 0 (
	for /f "tokens=*" %%p in (%FST_Config%) do call :processParam %%p
	goto pbreak1

	:processParam
	set line=%*
	echo %line: =?% >> "%TempFile%"
	goto :eof
	
	:pbreak1
	find "ExtraParams=" "%TempFile%" | find "=" > "%TempConfig%"
	for /f "tokens=2 delims==" %%d in (%TempConfig%) do set ExtraParams=%%d
	::anything with 0/?/null is not an arg, so ignore
	set ExtraParams=%ExtraParams: =%
	IF "%ExtraParams%"=="0" set ExtraParams=&& del %TempFile%&& del %TempConfig%&& echo ExtraParams = NONE&& goto ParamsChecked
	IF "%ExtraParams%"=="" set ExtraParams=&& del %TempFile%&& del %TempConfig%&& echo ExtraParams = NONE&& goto ParamsChecked
	::remove the ? we used to let us read all the values
	del %TempFile%
	del %TempConfig%
	set ExtraParams=%ExtraParams:?= %
	echo ExtraParams = OK
	goto ParamsChecked
)
echo ExtraParams = NONE
:ParamsChecked
echo.
echo.
::do Fast Start bypass
IF %FastStart%== 1 goto latestSave
:: Check SaveSelection and goto appropriate choice
IF %SaveSelection%== 1 (
	goto enterSave
) else (
	goto latestSave
)

:setupBatch
call :clearEL
:: Begin server setup enter install dir
::look for factorio first
title Factorio Server Tool [ Setup Wizard ]
cls
call :ascii
echo ------------------------------------------------------------------------------  
echo                       Welcome to the Factorio Server Tool
echo ------------------------------------------------------------------------------  
echo.
echo  Select where to save the config file for FST. 'FST_Config.ini'
echo  Either the Appdata folder or the same directory as the FactorioServerTool.bat
echo.
echo  Appdata:
echo  %FacAppdata%
echo.
echo  or Same Directory:
echo  %BatchDir%
echo.
echo  You can move the ini file between the appdata folder and the batch directory
echo.
echo  However if a ini exists in the same directory it will be the file used
echo.
echo ------------------------------------------------------------------------------  
echo.
choice /c:NAS /n /m ">Use [A]ppdata folder or the [S]ame directory as FactorioServerTool.bat"

IF %ERRORLEVEL%== 1 goto setupBatch
IF %ERRORLEVEL%== 2 set FST_Config=%appdata%\Factorio\FST_Config.ini&& set FST_ConfigDir=%appdata%\Factorio
IF %ERRORLEVEL%== 3 set FST_Config=%BatchDir%FST_Config.ini&& set FST_ConfigDir=%BatchDir%

call :clearEL

IF NOT EXIST "%FST_ConfigDir%" (
	mkdir "%FST_ConfigDir%"
	IF ERRORLEVEL== 1 (
		echo.
		echo  ERROR!
		echo.
		echo  The tool could not create the directory in the location you have selected
		echo  Please either choose the other directory option, run the tool as an admin
		echo  ^(right-click run as admin^) or change the location you are running the 
		echo  FactorioServerTool.bat from.
		echo.
		pause
		goto setupBatch
	)
)
IF NOT EXIST "%FST_Config%" (
	copy NUL "%FST_Config%"
	IF ERRORLEVEL== 1 (
		echo.
		echo  ERROR!
		echo.
		echo  The tool could not create the 'FST_Config.ini' in the location you have 
		echo  selected, this is probably due to permission issues, either select the
		echo  other location provided, run the tool as an admin ^(right-click run as admin^) 
		echo  or change the location you are running the FactorioServerTool.bat from.
		echo.
		pause
		goto setupBatch
	)
)
::delete it after empty file inteferes with some checks
del %FST_Config%

cls 
call :ascii
echo ------------------------------------------------------------------------------
echo  Now attempting to find your Steam directory
echo  If you don't use Steam you will be prompted to input your Install dir after.
echo ------------------------------------------------------------------------------
echo  Locating Steam Directory...

FOR /f "tokens=1,2*" %%E in ('reg query HKEY_CURRENT_USER\Software\Valve\Steam\') do if %%E==SteamPath set SteamDir=%%G
:: if nothing then go to input
IF ["%SteamDir%"]==[] echo No Steam Install found && goto inputLocation

set SteamDir=%SteamDir:/=\%

IF EXIST "%SteamDir%\steamapps\appmanifest_427520.acf" (
	goto checkInstallDir
) else (
	goto notInMainDir
)

:checkInstallDir
echo  Found Factorio appmanifest checking for Factorio install location
IF EXIST "%SteamDir%\steamapps\common\Factorio\bin\win32" set WinOS=win32&&goto checkExecutable
IF EXIST "%SteamDir%\steamapps\common\Factorio\bin\x64" set WinOS=x64&&goto checkExecutable
echo  No Factorio folder located, please make sure Factorio is installed.
goto inputLocation

:checkExecutable
echo  Found Factorio install folder as '%WinOS%' checking for Factorio.exe
IF EXIST "%SteamDir%\steamapps\common\Factorio\bin\%WinOS%\Factorio.exe" set InstallDir=%SteamDir%\steamapps\common\Factorio&&goto foundInstallDir
echo  No Factorio.exe located, please make sure Factorio is installed.
goto inputLocation


:notInMainDir
:: if factorio is not in the main steam dir it could be in an alternative steam library location so we find it here
IF EXIST %SteamDir%\steamapps\libraryfolders.vdf (

	echo  Searching for other Steam Library folder locations...
	set FactorioLib=0

	set LibraryFile=%SteamDir%\steamapps\libraryfolders.vdf

	type "%LibraryFile%" > %TempLib%
	
	for /f "tokens=*" %%a in (%TempLib%) do call :processLine %%a
	del %TempLib%
	goto break2

	:processline
	set line=%*
	echo %line: =?%>> %TempFile%
	goto :eof
	
	:break2
	::library dir only have \\ in them this way we can ignore other lines in the file
	::also findstr sucks and hates spaces in directories so pushd
	pushd "%FacTemp%"
	for /f "tokens=2" %%d in ('findstr "\\" "Temp.tmp"') do call :processDir %%d
	del Temp.tmp
	popd
	goto break3
	
	:processDir
	set LibraryEntry=%*
	::remove delimiting \
	set LibraryEntry=%LibraryEntry:\\=\%
	::remove quotes ""
	set LibraryEntry=%LibraryEntry:"=%
	::finally remove the ? we added earlier so we can have a working dir path
	set LibraryEntry=%LibraryEntry:?= %
	echo %LibraryEntry%>> %TempFile%
	goto :eof
	
	:break3
	for /f "tokens=*" %%L in (%TempFile%) do call :searchLib %%L
	del %TempFile%
	goto break4
	
	:searchLib
	set SteamLibDir=%*
	:: make sure we check the version
	IF EXIST "%SteamLibDir%\steamapps\common\Factorio\bin\win32" set WinOS=win32
	IF EXIST "%SteamLibDir%\steamapps\common\Factorio\bin\x64" set WinOS=x64
	
	:: if we find the exe set installdir
	IF EXIST "%SteamLibDir%\SteamApps\common\Factorio\bin\%WinOS%\Factorio.exe" set InstallDir=%SteamLibDir%\SteamApps\common\Factorio&&set FactorioLib=1
	goto :eof
	
) else (
	echo  Could not locate Factorio automatically.
)

:break4
IF %FactorioLib%== 1 (
	goto foundInstallDir
	) else (
echo ------------------------------------------------------------------------------  
echo  No Factorio.exe located, if Factorio is installed
goto inputLocation
)

:foundInstallDir
echo ------------------------------------------------------------------------------  
echo.
echo  Found Factorio.exe installed in
echo  %InstallDir%
echo.
echo ------------------------------------------------------------------------------
choice /c:YN /n /m ">Is this location correct? [Y/N]"
IF %ERRORLEVEL%== 1 goto makeConfig
IF %ERRORLEVEL%== 2 goto inputLocation


:inputLocation
cls
call :ascii
:inputLocationCLS
echo ------------------------------------------------------------------------------  
echo  Please enter the main Factorio Install Directory
echo.
echo  This is the top level Factorio directory, it contains all the sub folders
echo.
echo  e.g. C:\Program Files (x86)\Factorio
echo ------------------------------------------------------------------------------  
echo.
set /p InstallDir=
::NUL WinOS incase it found a steam install but user wants another directory
set WinOS=
::do a check for the supplied location
IF EXIST "%InstallDir%\bin\win32" set WinOS=win32
IF EXIST "%InstallDir%\bin\x64" set WinOS=x64

IF NOT EXIST "%InstallDir%\bin\%WinOS%\Factorio.exe" echo  No Factorio.exe located, please make sure Factorio is installed.&& goto inputLocationCLS

choice /c:YN /n /m ">Is the directory - '%InstallDir%' correct? [Y/N]"

IF %ERRORLEVEL%== 1 goto makeConfig
IF %ERRORLEVEL%== 2 goto inputLocation

:makeConfig
cls
call :ascii
echo ------------------------------------------------------------------------------  
echo                          Welcome to the Setup Wizard!
echo    This tool will help you through the configuration of your server options
echo ------------------------------------------------------------------------------  
set FactorioDir=%InstallDir%
goto findSaveLoc

:findSaveLoc
::game can be installed without steam so we need to check for where the default config is stored and from that we can get the folder location for saves, mods, etc
echo ------------------------------------------------------------------------------  
echo  Locating default location for config, mod and save folders
echo ------------------------------------------------------------------------------
set ConfigPathFile=config-path.cfg
IF EXIST "%InstallDir%\%ConfigPathFile%" (
	pushd "%InstallDir%"
	::config location
	FOR /f "delims=__ tokens=3" %%i in ('findstr "config-path=" "%ConfigPathFile%"') do set ConfigDefault=%%i
	FOR /f "delims=__ tokens=4" %%j in ('findstr "config-path=" "%ConfigPathFile%"') do set FacCfgPath=%%j
	::data location
	FOR /f "delims== tokens=2" %%i in ('findstr "use-system-read-write-data-directories=" "%ConfigPathFile%"') do set DataDefault=%%i
	popd
)
set FacCfgPath=%FacCfgPath:/=\%
set FacCfgPath=%FacCfgPath:~1%

::The last part of the config path refers to the config folder so add it to the directory location
IF [%ConfigDefault%]==[system-write-data] set FacCfg=%appdata%\Factorio\%FacCfgPath%
::While the default folder would be the %InstallDir% as it's configurable check for the dir anyway
IF [%ConfigDefault%]==[executable] set FacCfg=%InstallDir%\bin\%WinOS%\%FacCfgPath%

::Check where data is stored by default
IF [%DataDefault%]==[true] set FacData=%appdata%\Factorio
::if not using the system data dir use the config dir and go up a level to find the data location
IF [%DataDefault%]==[false] set FacData=%FacCfg%\..

::Now that we know the actual data locations we can set the vars (for this run, we store and set again on next run)
:: Factorio variables
set DefaultConfig=%FacCfg%\config.ini
set ServerConfig=%FacCfg%\config-server.ini
set ServerConfigFile=config-server.ini

set ServerSaveFolder=%FacData%\server\saves
set ServerModFolder=%FacData%\server\mods
set StandardSaveFolder=%FacData%\saves
set StandardModFolder=%FacData%\mods
set ServerFolder=%FacData%\server
::save facdata to ini for next runs

IF EXIST "%FacData%" (
	goto saveData
) else (
	goto noAppData
)
	
:noAppData
echo ------------------------------------------------------------------------------  
echo  Could not locate Factorio data folders.
echo ------------------------------------------------------------------------------  
set failed=No Factorio data folder was found, you need to launch the game to create these files.
call :errorEnd 0

:saveData
IF EXIST "%ServerSaveFolder%\*.zip" (
	IF EXIST "%ServerConfig%" (
		set ChangeSaveInterval=0
		goto setSaveTimer
	) else (
		goto checkConfig
	)
) else (
	goto noServerSave
)

:noServerSave
echo ------------------------------------------------------------------------------  
echo  You have no server data files, you will need to create them.
echo ------------------------------------------------------------------------------  
echo.
choice /c:YN /n /m ">Would you like to create the server folders? [Y/N]"
IF %ERRORLEVEL%== 1 goto createServerDir
IF %ERRORLEVEL%== 2 set failed=You opted to not create server files! Without them this tool can not operate&& call :errorEnd 0


:createServerDir
cls
call :ascii
echo -------------------------------------------------------------------------------
echo  Server Mods and Save file setup
echo -------------------------------------------------------------------------------
echo.
choice /c:YN /n /m ">Copy your Single Player mods folder? [Y/N]"
IF %ERRORLEVEL%== 1 set SPMods=1&& goto spFolder
IF %ERRORLEVEL%== 2 set SPMods=0&& goto spFolder


:spFolder
echo ------------------------------------------------------------------------------
echo.
echo  Selecting [N]o will still allow you to create a new save file
echo.
choice /c:YN /n /m ">Copy your Single Player saves folder? [Y/N]"
IF %ERRORLEVEL%== 1 set SPSaves=1&& goto createSave
IF %ERRORLEVEL%== 2 set SPSaves=0&& goto createSave


IF %SPSaves%== 0 (call :createSave) else goto copyContent

:createSave
echo ------------------------------------------------------------------------------  
echo.
echo  If you do not have any save files you will need to create one!
echo.
choice /c:YN /n /m ">Create a new save file? [Y/N]"
IF %ERRORLEVEL%== 1 set CreateSave=1&& goto saveCreateDone
IF %ERRORLEVEL%== 2 set CreateSave=2&& goto saveCreateDone


:saveCreateDone
IF %SPSaves%== 0 (
	IF %CreateSave%== 2 (
		set failed=You chose to not copy current SP saves or to create a new one.  Without a save file the server can not start.
		call :errorEnd 0
	)
)
::create a new save file using --create	
call :getDateTime
set CreateSaveName=FST_%dateTime%.zip
IF %CreateSave%== 1 "%FactorioDir%\bin\%WinOS%\Factorio.exe" --create %CreateSaveName%&& set SPSaves=1

cls
call :ascii
echo -------------------------------------------------------------------------------
echo.
echo  Created a new save file: %CreateSaveName%
echo.
echo -------------------------------------------------------------------------------
echo.

:copyContent
echo -------------------------------------------------------------------------------
echo.
echo  Copying files to server directory
echo.
echo -------------------------------------------------------------------------------
echo.
::make the directories before we use xcopy otherwise it promts about file/directory type and that's annoying
mkdir "%ServerFolder%"
mkdir "%ServerSaveFolder%"
mkdir "%ServerModFolder%"

IF %SPMods%== 1 xcopy /s /e /y "%StandardModFolder%" "%ServerModFolder%"
IF %SPSaves%== 1 xcopy /s /e /y "%StandardSaveFolder%" "%ServerSaveFolder%"
timeout 2
cls

set failed=Failed to create the server files^(s^) and^/or folder^(s^) This tool may need to be run as an administrator ^(right-click^) it to do so
IF EXIST "%ServerSaveFolder%" (
	call :ascii
	goto configSetup
) else (
	call :errorEnd 0
)

:checkConfig
echo -------------------------------------------------------------------------------
echo  While this tool found server save files 
echo  It could not locate a config-server.ini file
echo  In the following location: 
echo  %FacCfg%
echo.
echo  Answering ^(N^)o will allow you to choose another config if you have one
echo -------------------------------------------------------------------------------
echo.
choice /c:YN /n /m ">Create a new config-server.ini? [Y/N]"
IF %ERRORLEVEL%== 1 goto configSetup
IF %ERRORLEVEL%== 2 goto useAnotherConfig

:useAnotherConfig
echo -------------------------------------------------------------------------------
echo  If you are using another name for your config-server.ini
echo  or have it stored in another location
echo  enter the full filename below and it will be copied
echo.
echo  You can still [C]reate a new config, just input anything to get the choice
echo -------------------------------------------------------------------------------
echo.
set /p AlternateConfig=

IF NOT EXIST "%AlternateConfig%" (
	echo No file located you can [R]etry or [C]reate a new one
	choice /c:RC /n /m "[R/C]"
	IF %ERRORLEVEL%== 1 goto useAnotherConfig
	IF %ERRORLEVEL%== 2 goto configSetup&& set AlternateConfig=
)

choice /c:YNC /n /m ">Is the location - %AlternateConfig%, correct? [Y/N/C]"
IF %ERRORLEVEL%== 1 goto copyConfig
IF %ERRORLEVEL%== 2 goto useAnotherConfig
IF %ERRORLEVEL%== 3 goto configSetup&& set AlternateConfig=


:copyConfig
echo -------------------------------------------------------------------------------
echo  Copying your config file into config-server.ini
echo  Located in %FacCfg%
echo -------------------------------------------------------------------------------
copy "%AlternateConfig%" "%ServerConfig%"
set ChangeSaveInterval=0
goto setSaveTimer

:configSetup
::setup server config
echo -------------------------------------------------------------------------------
echo  Server Config Setup
echo  Sets up server write data location
echo  Lets you pick the server port 
echo -------------------------------------------------------------------------------
echo.
choice /c:YN /n /m ">Setup Server config file? [Y/N]"
IF %ERRORLEVEL%== 1 goto configServerData
IF %ERRORLEVEL%== 2 goto useAnotherConfig

:configServerData
::save configs and make new ones and a backup
IF EXIST "%DefaultConfig%" goto creatingConfig
IF NOT EXIST "%DefaultConfig%" goto creatingConfigFail

:creatingConfig	
call :clearEL
echo -------------------------------------------------------------------------------
echo  Creating config.ini backup
copy /y "%DefaultConfig%" "%FacCfg%\config-backup.ini" 
echo  Creating config-server.ini
copy "%DefaultConfig%" "%ServerConfig%" 
echo -------------------------------------------------------------------------------
IF ERRORLEVEL 1 set failed=Could not write config-backup.ini/config-server.ini Make sure you have permission, you may need to run this tool as an admin ^(right-click run as admin^)  Attempted to write files to: %FacCfg%&& call :errorEnd 0
goto writeServerConfig

:creatingConfigFail
set failed=Could not locate a config.ini you need to start the game to create this file! If you have started the game, the file couldn't be found in: %FacCfg%
call :errorEnd 0

:writeServerConfig
::modify save locations for server
call :iniRead read-data CurReadData "%FacCfg%" "%ServerConfigFile%"
call :iniRead write-data CurWriteData "%FacCfg%" "%ServerConfigFile%"

type "%ServerConfig%" | find /v "[path]" > "%TempConfig%"
type "%TempConfig%" | find /v "read-data=" > "%ServerConfig%"
type "%ServerConfig%" | find /v "write-data=" > "%TempConfig%"

copy /y "%TempConfig%" "%ServerConfig%"

echo [path]>> "%TempFile%"
echo read-data=%CurReadData%>> "%TempFile%"
echo write-data=%CurWriteData%\server>> "%TempFile%"

type "%TempFile%" "%TempConfig%" > "%ServerConfig%"

del "%TempConfig%"
del "%TempFile%"

set ChangePortNumber=0

:pickPort
title Factorio Server Tool [ Setup Port ]
cls
call :ascii
:pickPortcls
IF EXIST "%ServerConfig%" (
	call :iniRead port CurServPort "%FacCfg%" "%ServerConfigFile%"
) else (
	set CurServPort=-NOT SET OR FOUND-
)
::Get current default config port and add + 1 for recommended port this way it cant conflict with gameclient
call :iniRead port NewServerPort "%FacCfg%" "config.ini"
set /a "NewServerPort+=1"

echo -------------------------------------------------------------------------------
echo  %enterRecommended%
echo -------------------------------------------------------------------------------
echo  Set your SERVER port number                              ^(Recommended: %NewServerPort%^)
echo  This port needs to be forwarded as UDP          ^(Accepted Values: 1024-65535^)
echo  Current port number: %CurServPort%
echo -------------------------------------------------------------------------------
echo.
set /p NewServerPort=
::dont allow ports outside range
call :GEOLE %NewServerPort% 1024 65535
if %GEOLEvalue%== 1 (call :confirmPort) else goto portFail

:portFail
cls
call :ascii
echo -------------------------------------------------------------------------------
echo  %enterRecommended%
echo -------------------------------------------------------------------------------
echo  The port %NewServerPort% has not been accepted 
echo  It is outside the range of 1024-65535
echo  Please use a port within the defined range
echo -------------------------------------------------------------------------------
goto pickPortcls

:confirmPort
choice /c:YN /n /m ">Is the port - %NewServerPort%, correct? [Y/N]"
IF %ERRORLEVEL%== 1 goto addPort
IF %ERRORLEVEL%== 2 goto pickPort

:addPort
call :iniWrite port %NewServerPort% "%ServerConfig%"

echo.
echo -------------------------------------------------------------------------------
echo  Forward port %NewServerPort% on your router/firewall, UDP only
echo -------------------------------------------------------------------------------
echo  Your friends will be able to connect on:
echo  %CurrIP%:%NewServerPort%
echo -------------------------------------------------------------------------------
echo  YOU will be able to connect with:
echo  localhost:%NewServerPort%
echo -------------------------------------------------------------------------------
set ChangeSaveInterval=0
IF %ChangePortNumber%== 0  goto setSaveTimer
IF %ChangePortNumber%== 1  goto startServer

:setSaveTimer
title Factorio Server Tool [ Setup Autosave ]
cls
call :ascii
:setSaveTimercls
::get current value if available
IF EXIST "%FST_Config%" (
	call :iniRead AutoSaveTimer CurSaveInt "%FST_ConfigDir%" "%FST_ConfigFile%"
) else (
	set CurSaveInt=-NOT SET OR FOUND-
)
echo -------------------------------------------------------------------------------
echo  %enterRecommended%
echo -------------------------------------------------------------------------------
echo  Set the auto save timer for the server                       ^(Recommended: 5^)
echo  Value is in minutes                                  ^(Accepted values: 1-500^)
echo  Current save interval: %CurSaveInt% mins
echo -------------------------------------------------------------------------------
echo.
set /p AutoSaveTimer=

call :GEOLE %AutoSaveTimer% 1 500
if %GEOLEvalue%== 1 (call :confirmTimer) else goto timerFail

:timerFail
cls
call :ascii
echo -------------------------------------------------------------------------------
echo  The value %AutoSaveTimer% has not been accepted 
echo  It is outside the range of 1-500
echo  Please use a value within the defined range
echo -------------------------------------------------------------------------------
goto setSaveTimercls

:confirmTimer
choice /c:YN /n /m ">Is this time value - %AutoSaveTimer% mins, correct? [Y/N]"
IF %ChangeSaveInterval%== 0 (
	IF %ERRORLEVEL%== 1 goto setSaveSlots
	IF %ERRORLEVEL%== 2 goto setSaveTimer
	
)
IF %ChangeSaveInterval%== 1 (
	::if incorrect dont save config
	IF %ERRORLEVEL%== 2 goto setSaveTimer
	
	echo -------------------------------------------------------------------------------
	echo  Writing config file:
	echo  %FST_Config%
	echo -------------------------------------------------------------------------------
	call :iniWrite AutoSaveTimer %AutoSaveTimer% "%FST_Config%"
	
	IF %ERRORLEVEL%== 1 goto setSaveSlots

)

:setSaveSlots
title Factorio Server Tool [ Setup Autosave ]
cls
call :ascii
:setSaveSlotscls
::get current value if available
IF EXIST "%FST_Config%" (
	call :iniRead AutoSaveSlots CurSaveSlot "%FST_ConfigDir%" "%FST_ConfigFile%"
) else (
	set CurSaveSlot=-NOT SET OR FOUND-
)
echo -------------------------------------------------------------------------------
echo  %enterRecommended%
echo -------------------------------------------------------------------------------
echo  Set the amount of autosaves slots for the server             ^(Recommended: 3^)
echo  Autosave overwrites files once past the set value    ^(Accepted values: 1-500^)
echo  Current autosave save slots: %CurSaveSlot% slots
echo -------------------------------------------------------------------------------
echo.
set /p AutoSaveSlots=
set ChangeLatency=0

call :GEOLE %AutoSaveSlots% 1 500
if %GEOLEvalue%== 1 (call :confirmSaveSlots) else goto saveSlotFail

:saveSlotFail
cls
call :ascii
echo -------------------------------------------------------------------------------
echo  The value %AutoSaveSlots% has not been accepted 
echo  It is outside the range of 1-500
echo  Please use a value within the defined range
echo -------------------------------------------------------------------------------
goto setSaveSlotscls

:confirmSaveSlots
choice /c:YN /n /m ">Is this save amount value - %AutoSaveSlots%, correct? [Y/N]"

IF %ChangeSaveInterval%==0 (
	IF %ERRORLEVEL%== 1 goto setLatency
	IF %ERRORLEVEL%== 2 goto setSaveSlots
)
IF %ChangeSaveInterval%==1 (
	::dont save config if N
	IF %ERRORLEVEL%== 2 goto setSaveSlots
		
	echo -------------------------------------------------------------------------------
	echo  Writing config file:
	echo  %FST_Config%
	echo -------------------------------------------------------------------------------
	call :iniWrite AutoSaveSlots %AutoSaveSlots% "%FST_Config%"
	
	IF %ERRORLEVEL%== 1 goto startServer
)

:setLatency
title Factorio Server Tool [ Setup Latency ]
cls
call :ascii
:setLatencycls
::get current value if available
IF EXIST "%FST_Config%" (
	call :iniRead Latency CurLatValue "%FST_ConfigDir%" "%FST_ConfigFile%"
) else (
	set CurLatValue=-NOT SET OR FOUND-
)
echo -------------------------------------------------------------------------------
echo  %enterRecommended%
echo -------------------------------------------------------------------------------
echo  Set the server multiplayer latency                         ^(Recommended: 100^)
echo  ^(Good value: player ping+~50^)                       ^(Accepted values: 1-5000^)
echo  Current latency value: %CurLatValue% ms
echo -------------------------------------------------------------------------------
echo.
set /p Latency=

call :GEOLE %Latency% 1 500
if %GEOLEvalue%== 1 (call :confirmLatency) else goto latencyFail

:latencyFail
cls
call :ascii
echo -------------------------------------------------------------------------------
echo  The value %Latency% has not been accepted 
echo  It is outside the range of 1-5000
echo  Please use a value within the defined range
echo -------------------------------------------------------------------------------
goto setLatencycls

:confirmLatency
choice /c:YN /n /m ">Is this latency number - %Latency% ms, correct? [Y/N]"
IF %ChangeLatency%== 0 (
	IF %ERRORLEVEL%== 1 goto serverComplete
	IF %ERRORLEVEL%== 2 goto setLatency
)
IF %ChangeLatency%== 1 (
	:: dont write config if N
	IF %ERRORLEVEL%== 2 goto setLatency
	echo -------------------------------------------------------------------------------
	echo  Writing config file:
	echo  %FST_Config%
	echo -------------------------------------------------------------------------------
	call :iniWrite Latency %Latency% "%FST_Config%"
	
	IF %ERRORLEVEL%== 1 goto startServer
)

:serverComplete
cls
call :ascii
::server setup complete now pick savefiles and write configs
echo.
echo -------------------------------------------------------------------------------
echo  Select which savefile to load on launch, the newest save or pick a save file
echo  This setting will be the default behavior on following runs
echo  You can always select a different save file before the server launches
echo -------------------------------------------------------------------------------
echo.

choice /c:YN /n /m ">Load newest save file (Y) by default or (N) to select the save file? [Y/N]"
IF %ERRORLEVEL%== 1 set SaveSel=0&& goto writeConfig
IF %ERRORLEVEL%== 2 set SaveSel=1&& goto writeConfig


:resetSaveSelect
title Factorio Server Tool [ Setup Default Save ]
cls
call :ascii
echo.
echo -------------------------------------------------------------------------------
echo  Select the newest server savefile for launch by default? ^(Y^)
echo  or ^(N^) open the savefile selection menu each launch.
echo  ^(Y^) is a faster method
echo -------------------------------------------------------------------------------
echo.

choice /c:YN /n /m ">Use newest save file (Y) on launch or (N) open file selection menu? [Y/N]"
IF %ERRORLEVEL%== 1 set SaveSel=0&& goto resetSaveConfigWrite
IF %ERRORLEVEL%== 2 set SaveSel=1&& goto resetSaveConfigWrite

:resetSaveConfigWrite
echo -------------------------------------------------------------------------------
echo  Writing config file:
echo  %FST_Config%
echo -------------------------------------------------------------------------------

call :iniWrite SaveSelection %SaveSel% "%FST_Config%"

goto startServer

:writeConfig
title Factorio Server Tool [ Writing Config ]
::before we start the server we need to save our config
::write choices to ini
echo -------------------------------------------------------------------------------
echo  Writing config to file:
echo  %FST_Config%
echo -------------------------------------------------------------------------------

set InstallString=%InstallDir: =?%
call :iniWrite InstallDir %InstallString% "%FST_Config%"
call :iniWrite WinOS %WinOS% "%FST_Config%"
call :iniWrite AutoSaveTimer %AutoSaveTimer% "%FST_Config%"
call :iniWrite AutoSaveSlots %AutoSaveSlots% "%FST_Config%"
call :iniWrite Latency %Latency% "%FST_Config%"
call :iniWrite SaveSelection %SaveSel% "%FST_Config%"
call :iniWrite SetupComplete 1 "%FST_Config%"
set FactorioData=%FacData: =?%
call :iniWrite FacData %FactorioData% "%FST_Config%"
set FactorioConfig=%FacCfg: =?%
call :iniWrite FacConfig %FactorioConfig% "%FST_Config%"

::as of 0.1.32 set these values
call :iniWrite FastStart 0 "%FST_Config%"
call :iniWrite ExtraParams 0 "%FST_Config%"
set intvnumber=%vnumber:.=%
call :iniWrite version %intvnumber% "%FST_Config%"

set ExtraParams=

IF %SaveSel%== 0 goto latestSave
IF %SaveSel%== 1 goto enterSave

:enterSave
title Factorio Server Tool [ Pick Save File ]
cls
call :ascii
::for launching with user defined save
pushd "%ServerSaveFolder%"
echo -------------------------------------------------------------------------------
echo  Enter save file name to load
echo  Showing newest 10 save files, sorted newest ^> oldest
echo -------------------------------------------------------------------------------
echo  Date      Time  -- File name
echo -------------------------------------------------------------------------------
set n=0
for /F "delims=" %%S in ('dir "%ServerSaveFolder%\*.zip" /b /o:-d') do (
	for %%a in ("%%S") do (
		echo %%~ta -- %%~na
	)
	set /a "n+=1, 1/(10-n)" 2>nul || goto :break
)
:break
set SelectedSave=
echo -------------------------------------------------------------------------------
echo  Enter the save file name ^(savefile.zip^). Tab to complete.
echo  If you want to load the newest save leave the input blank.
echo -------------------------------------------------------------------------------
echo.
set /p SelectedSave=

IF NOT DEFINED SelectedSave goto latestSave
::remove quotes from autocompleted entries if they contain spaces
set SelectedSave=%SelectedSave:"=%


IF EXIST "%ServerSaveFolder%\%SelectedSave%" (
	set SaveFile=%SelectedSave%
	goto startServer
) else (
		IF EXIST "%ServerSaveFolder%\%SelectedSave%.zip" (
		set SaveFile=%SelectedSave%.zip
		goto startServer
	)
	echo Save file does not exist, please pick another save.
	goto enterSave
)

:latestSave
::for launching with the newest save file
for /F "delims=" %%I in ('dir "%ServerSaveFolder%\*.zip" /b /od') do set SaveFile=%%~I
set SaveFile=%SaveFile:"=%

::if the newest file is a autosave, rename it, this way it doesnt get overwritten when autosaving
set AutoSaveFile=%SaveFile:~0,-4%
set AutoSaveFile=%AutoSaveFile:~0,9%
call :getDateTime
set newSaveName=FST_AS_%dateTime%.zip
IF "%AutoSaveFile%"=="_autosave" (
	echo  Determined newest save file is an autosave file, renaming it to avoid conflicts
	copy /y "%ServerSaveFolder%\%SaveFile%" "%ServerSaveFolder%\%newSaveName%"
	set SaveFile=%newSaveName%
)

echo -------------------------------------------------------------------------------
echo  Starting server with newest found save file
echo  '%SaveFile%'
echo -------------------------------------------------------------------------------

::IF DEFINED somevariable echo Value exists
IF "%SaveFile%"=="" set failed=Could not detect any save files you might need to run this as an administrator or create a new save file below&& call :errorEnd 1
IF %FastStart%== 1 goto executeServer
goto startServer

:selectSPSave
title Factorio Server Tool [ Pick Save File ]
cls
call :ascii
pushd "%StandardSaveFolder%"
echo -------------------------------------------------------------------------------
echo  Enter save file name to load
echo  Showing newest 10 Single Player save files, sorted newest ^> oldest
echo -------------------------------------------------------------------------------
echo  Date      Time  -- File name
echo -------------------------------------------------------------------------------
set ns=0
for /F "delims=" %%S in ('dir "%StandardSaveFolder%\*.zip" /b /o:-d') do (
	for %%a in ("%%S") do (
		echo %%~ta -- %%~na
	)
  set /a "ns+=1, 1/(10-ns)" 2>nul || goto :break1
)
:break1
set SelectedSPSave=
echo -------------------------------------------------------------------------------
echo  Enter the save file name ^(savefile.zip^). Tab to complete.
echo  If you want to load the newest SP save leave blank.
echo  SP saves will be copied and re-named in the server^\saves folder
echo -------------------------------------------------------------------------------
echo.
set /p SelectedSPSave=
popd
IF NOT DEFINED SelectedSPSave goto latestSPSave
set SelectedSPSave=%SelectedSPSave:"=%


IF EXIST "%StandardSaveFolder%\%SelectedSPSave%" (
	set SaveFile=%SelectedSPSave%
	goto copySave
) else (
	IF EXIST "%StandardSaveFolder%\%SelectedSPSave%.zip" (
		set SaveFile=%SelectedSPSave%.zip
		goto copySave
	)
	echo Save file does not exist, please pick another save.
	goto selectSPSave
)

:copySave
set SaveFileName=%SaveFileName:"=%
set SaveFileName=%SaveFile:~0,-4%

::append datetime to the filename to avoid conflicts
call :getDateTime
set newSaveName=%SaveFileName%_%dateTime%.zip

copy /y "%StandardSaveFolder%\%SelectedSPSave%" "%ServerSaveFolder%\%newSaveName%"
set SaveFile=%newSaveName%

goto startServer

:latestSPSave
cls
call :ascii

for /F "delims=" %%G in ('dir "%StandardSaveFolder%\*.zip" /b /od') do (
	set LatestSP=%%~nG
	set LatestSPext=%%~xG
)

set LatestSP=%LatestSP:"=%

::append datetime to the filename to avoid conflicts
call :getDateTime
set newSaveName=%LatestSP%_%dateTime%%LatestSPext%
IF "%newSaveName%"=="" set failed=Could not detect any save files you might need to run this as an administrator Or create a new save file below&& call :errorEnd 1
echo.
echo -------------------------------------------------------------------------------
echo  Latest SP save file is: '%LatestSP%%LatestSPext%'
echo  Copying it and renaming it to: '%newSaveName%'
echo -------------------------------------------------------------------------------
echo.
copy /y "%StandardSaveFolder%\%LatestSP%%LatestSPext%" "%ServerSaveFolder%\%newSaveName%"
set SaveFile=%newSaveName%

IF "%SaveFile%"=="" set failed=Could not detect any save files you might need to run this as an administrator or create a new save file below&& call :errorEnd 1

goto startServer

:makeNewSaveFile
cls
call :ascii
::create a new save file using --create	
set CreateNewSaveName=
set SaveExists=0
echo -------------------------------------------------------------------------------
echo  Please input a name for your new save, leaving this blank will generate a new
echo  file name ^(FST_YYYYMMDD-HHMMSS^) spaces will be converted to underscores ^(_^)
echo  Avoid any special characters.
echo -------------------------------------------------------------------------------
echo.
set /p CreateNewSaveName=
::set save name to FST_DATE_TIME if no user input
call :getDateTime
IF NOT DEFINED CreateNewSaveName set CreateNewSaveName=FST_%dateTime%
::strip spaces replace with _
set CreateNewSaveName=%CreateNewSaveName: =_%
::strip .zip if input
set IsZip=%CreateNewSaveName:~-4%
IF "%IsZip%"==".zip" set CreateNewSaveName=%CreateNewSaveName:~0,-4%
::strip . replace with _
set CreateNewSaveName=%CreateNewSaveName:.=_%
::add zip ext for all answers
set CreateNewSaveName=%CreateNewSaveName%.zip
::check if file already exists, we dont want to overwrite anything!
IF EXIST "%ServerSaveFolder%\%CreateNewSaveName%" set SaveExists=1
IF EXIST "%StandardSaveFolder%\%CreateNewSaveName%" set SaveExists=1
IF "%SaveExists%"=="1" (
	echo -------------------------------------------------------------------------------
	echo  Detected a save file that already matches the input name.
	echo  Found a file matching: %CreateNewSaveName%
	echo  Continue to input another save file name
	echo -------------------------------------------------------------------------------
	pause
	goto makeNewSaveFile
)

echo -------------------------------------------------------------------------------
echo.
echo  Creating save file: %CreateNewSaveName%
echo.
echo -------------------------------------------------------------------------------

"%FactorioDir%\bin\%WinOS%\Factorio.exe" --create "%CreateNewSaveName%"

echo -------------------------------------------------------------------------------
echo.
echo  Moving save file to server directory
echo.
echo -------------------------------------------------------------------------------

move /y "%StandardSaveFolder%\%CreateNewSaveName%" "%ServerSaveFolder%"

echo -------------------------------------------------------------------------------
echo.
echo  Would you like to use this save file now?
echo.
echo -------------------------------------------------------------------------------
choice /c:YN /n /m ">Use new file now? [Y/N]"
IF %ERRORLEVEL%== 1 goto latestSave
IF %ERRORLEVEL%== 2 goto startServer

:aboutThis
call :clearEL
title Factorio Server Tool [ About ]
cls
call :ascii
echo                                      INFO
echo -------------------------------------------------------------------------------
echo.
echo  A batch script to help easily setup hosting a dedicated Factorio server!
echo.
echo  This tool is not affiliated with Factorio in any way.
echo.
echo  Not responsible for direct, indirect, incidental or consequential damages 
echo  resulting from any defect, error or failure to perform.
echo  Or for making it so easy to host a server you can't stop playing the game.
echo.
echo ===============================================================================
echo                 FST_Config.ini location and additional options
echo -------------------------------------------------------------------------------
echo.
echo  Stores its config file containing config options in:
echo  %FST_Config%
echo  You can if you wish move this file between the appdata folder and the
echo  batch file directory, do note that if one is loscated in the same directory
echo  as the batch file, that will be the one used for the config options.
echo.
echo  You can set FastStart=1 in the config file to skip the Options screen
echo  and always begin the server straight away with the newest savefile.
echo.
echo  Add additional parameters, not supported by the setup, setting ExtraParams=
echo  e.g. ExtraParams=--Parameter 0 --Parameter 1
echo  The hyphens must be set in the config file or the parameters will not work.
echo.
echo  Both settings can be reset/disabled by setting the value to 0
echo.
echo ===============================================================================
echo                                      ABOUT
echo -------------------------------------------------------------------------------
echo  Version: v%vnumber%
echo  Dated: 24/Apr/2016
echo  Author: Scott Coxhead
echo.
echo  Github: github.com/Cr4zyy/FactorioServerTool/
echo.
echo  Probably a script mess but it seems to work, for me. ^:D Hope it works for you.
echo.
echo ===============================================================================
echo                                Select an option:
echo -------------------------------------------------------------------------------
choice /c:CGB /n /m ">Open [C]onfig file, go to [G]ithub or go [B]ack to options"

IF %ERRORLEVEL%== 1 "%FST_Config%"&& goto aboutThis
IF %ERRORLEVEL%== 2 start http://github.com/Cr4zyy/FactorioServerTool/&& goto aboutThis
IF %ERRORLEVEL%== 3 echo goto startServer

:startServer
title Factorio Server Tool [ Options ]
cls
::mod counter (or close enough)
pushd "%ServerModFolder%"
IF EXIST mod-list.json (
	FOR /F "tokens=2" %%m IN ('FINDSTR ^"true^" "mod-list.json"') do (
		echo %%m>> "%TempFile%"
		)
	popd
	FOR /f "tokens=3" %%l in ('find /v /c "" "%TempFile%"') do set ModCount=%%~nl
	set /a "ModCount-=1"
	del "%TempFile%"
)

::savefile date
pushd "%ServerSaveFolder%"
for %%a in ("%SaveFile%") do set SaveFileDate=%%~ta
popd

::grab port number from config-server.ini
IF EXIST "%ServerConfig%" (
	call :iniRead port ServerPort "%FacCfg%" "%ServerConfigFile%"
) else (
	set ServerPort=Could not find config-server.ini to identify port
)
::put ip:port into user clipboard so they can send it to their friends!
echo %CurrIP%:%ServerPort%| clip
::show info before server start and allow changes
for /l %%N in (%OptionDelay% -1 1) do (
if %%N leq 1 goto :executeServer
cls
call :ascii
echo.
echo  Tell your friends to connect to ^(You can paste this, it's in your clipboard^!^):
echo  %CurrIP%:%ServerPort%
echo.
echo  Above should show your IP, if not, check here: http://icanhazip.com
echo  Note if you're on a complex network e.g. university, it may not be correct!!
echo.
echo  YOU can connect with: localhost:%ServerPort%
echo.
echo -------------------------------------------------------------------------------
echo.
echo  Using save file: %SaveFile%
echo  Which is dated: %SaveFileDate%
echo.
echo  Auto save interval: %AutoSaveTimer% mins                   Auto save slots: %AutoSaveSlots%
echo  Latency value: %Latency% ms                        Mods loaded: %ModCount%
echo  Extra Params: %ExtraParams%
echo.
echo -------------------------------------------------------------------------------
echo.
echo  Server starting in %%N seconds.
echo.
echo -------------------------------------------------------------------------------
echo.
echo  Or select a following option:
echo.
echo     [1] START the server now!                [6] Modify Server PORT
echo.
echo     [2] Select server save FILE^(s^)           [7] Set INITIAL save selection
echo.
echo     [3] Single player save FILE^(s^)           [8] Open Factorio Data Dir
echo.
echo     [4] Modify Auto SAVE TIME ^& SLOTS        [9] Open Factorio Install Dir
echo.
echo     [5] Modify LATENCY value
echo.
echo     [C]reate a new save game                 [A]bout
echo.
echo -------------------------------------------------------------------------------
echo.
choice /c:123456789CAB /n /d:B /t:1 /m ">Select a choice from above"
IF NOT ERRORLEVEL==12 goto :breakout
)

:breakout
IF %ERRORLEVEL%== 11 goto aboutThis
IF %ERRORLEVEL%== 10 goto makeNewSaveFile
IF %ERRORLEVEL%== 1 goto executeServer
IF %ERRORLEVEL%== 2 goto enterSave
IF %ERRORLEVEL%== 3 goto selectSPSave
IF %ERRORLEVEL%== 4 (
	set ChangeSaveInterval=1
	goto setSaveTimer
)
IF %ERRORLEVEL%== 5 (
	set ChangeLatency=1
	goto setLatency
)
IF %ERRORLEVEL%== 6 (
	set ChangePortNumber=1
	goto pickPort
)
IF %ERRORLEVEL%== 7 goto resetSaveSelect
IF %ERRORLEVEL%== 8 set OptionDelay=5 && "%SystemRoot%\explorer.exe" "%FacData%"
IF %ERRORLEVEL%== 9 set OptionDelay=5 && "%SystemRoot%\explorer.exe" "%FactorioDir%"
goto startServer

:executeServer
:: change to factorio dir and start server with chosen save file
:: increase window size for some easier log viewing
mode con: cols=80 lines=80
title Factorio Server Tool [ Server Starting ]
color 84
call :ascii
echo \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\-----\----/-----////////////////////////////////
echo  \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\-----\--/-----//////////////////////////////// 
echo.
echo                          88b 88  dP"Yb  888888 888888          
echo                 ________ 88Yb88 dP   Yb   88   88__   ________ 
echo                 """""""" 88 Y88 Yb   dP   88   88""   """""""" 
echo                          88  Y8  YbodP    88   888888          
echo.                               
echo              Quit the server with CTRL + C before exiting the window^!
echo                    This makes sure the server SAVES the game^!
echo.
echo                         Server IP: %CurrIP%:%ServerPort%
echo                         ^(This is in your paste buffer^)
echo %CurrIP%:%ServerPort%| clip
echo.
echo  ///////////////////////////////-----/--\-----\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\ 
echo ///////////////////////////////-----/----\-----\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
echo.
timeout 2
echo.
color 08
pushd "%FactorioDir%"
title Factorio Server Tool [ Server Running - CTRL+C to quit ]
start /wait bin\%WinOS%\Factorio.exe --start-server "%SaveFile%" --autosave-interval %AutoSaveTimer% --autosave-slots %AutoSaveSlots% --latency-ms %Latency% -c "%ServerConfig%" %ExtraParams%&&timeout 2&&popd&&call :restartScript
goto end

:restartScript
::scale cmd to fit nicely
mode con: cols=80 lines=60
::prettyness
color 30
title Factorio Server Tool [ Server Shutdown ]
::reset this incase we set it for latest save fast restart
set FastStart=0

cls
call :ascii
echo.
echo -------------------------------------------------------------------------------
echo                                    GOOD BYE?
echo -------------------------------------------------------------------------------
echo  The server has been shutdown.
echo.
echo  [R]eload the script, providing you with the options screen again.
echo.
echo  [F]ast Restart the server, instant server start, no options.
echo.
echo  [L]ast Save Restart, as above, but with the newest save file.
echo.
echo  [Q]uit.
echo.
choice /c:RFLQ /n /m "> [R]eload, [F]ast Restart, [L]ast Save Restart or [Q]uit"

IF %ERRORLEVEL%== 1 goto skip
IF %ERRORLEVEL%== 2 goto executeServer
IF %ERRORLEVEL%== 3 set FastStart=1&& goto latestSave
IF %ERRORLEVEL%== 4 echo ----------------------------------QUITTING-------------------------------------
cd /d %BatchDir%
goto quickend



:errorASCII
echo             MMMMMMMMMMMMMMMM             
echo          MMM                MMMM         
echo        MM                       MM       
echo      MM                           MM     
echo     MM                             MM    
echo    M                                MM   
echo   MM         mm           mm        MM  
echo  MM         MMMM         MMMM         M      dP"Yb  88  88     88b 88  dP"Yb  
echo  MM         MMMM         MMMM         MM    dP   Yb 88  88     88Yb88 dP   Yb 
echo  MM                                   MM    Yb   dP 888888     88 Y88 Yb   dP 
echo   M               ____                M      YbodP  88  88     88  Y8  YbodP 
echo   MM        ./MMMMMMMMMMMM\.         MM  
echo    MM      MM              MM       MM   
echo     MM     m                m      MM    
echo      MM                          MMM     
echo        MMM                     MMM       
echo           MMM               MMM          
echo               MMMMMMMMMMMMM              
echo.
goto:eof

:errorEnd
title Factorio Server Tool [ ERROR ]
cls
call :ascii
color 4f
call :errorASCII
echo \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\----------------////////////////////////////////
echo.
echo  ERROR
echo  Reason: %failed%
echo.
echo ///////////////////////////////----------------\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
echo.
IF %1== 1 call :errorNewSave %random%
pause
echo ----------------------------------QUITTING-------------------------------------
goto end

:errorNewSave
title Factorio Server Tool [ ERROR - Create a save ]
echo.
echo  You can [C]reate a new savefile below
echo  This save will be the newest file for the next run
echo  if it still can not be detected you may need to run as an admin.
echo  This will create a new file named 'FST_newsave%1.zip'
echo.
echo  If you would prefer to locate the save files yourself you can
echo  [E]xit this without creating a new save.
echo.
choice /c:CE /n /d:E /t:20 /m "[C]reate or [E]xit"
IF %ERRORLEVEL%== 1 (	
	"%FactorioDir%\bin\%WinOS%\Factorio.exe" --create FST_newsave%1.zip
	timeout 1
	mkdir "%ServerSaveFolder%"
	copy /y "%StandardSaveFolder%\FST_newsave%1.zip" "%ServerSaveFolder%"
	
	echo -------------------------------------------------------------------------------
	echo  Hopefully the above created a new file with no errors.
	echo  If so you can either [R]estart this tool or [Q]uit it.
	echo.
	choice /c:RQ /n /m "[R]estart or [Q]uit"
	IF %ERRORLEVEL%== 1 start "Factorio Server Tool" /D "%BatchDir%" "%FSTbat%"&&goto quickend
	IF %ERRORLEVEL%== 2 echo -------------------------------------------------------------------------------
	goto end
)
IF %ERRORLEVEL%== 2 echo ----------------------------------QUITTING-------------------------------------
IF %ERRORLEVEL%== 3 echo ----------------------------------QUITTING-------------------------------------
goto end

pause
goto end

:errorFix
title Factorio Server Tool [ ERROR - Attempted a fix ]
set option1=%1
set value1=%2
set option2=%3
set value2=%4
cls
call :ascii
color 1f
call :errorASCII
echo \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\----------------////////////////////////////////
echo.
echo  ERROR Config option for [%1] [%3] will be reset
echo  You might need to adjust settings on the next run if it fixes.
echo.
echo  Reason: %failed%
echo.
echo ///////////////////////////////----------------\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
echo.

set fvalue=0
::If we can't find WinOS then check to see if InstallDir is set
IF [%option1%]==[WinOS] set /a "fvalue=%fvalue%+1" 
IF NOT [%InstallDir%]==[0] set /a "fvalue=%fvalue%+2"
IF %fvalue%== 3 (
	:: if resetting WinOS and Install dir exists
	:: check if InstallDir [FactorioDir is the dir with spaces] is correct and exists
	IF EXIST "%FactorioDir%" (
		::if so we can just reset the WinOS value
		IF EXIST "%FactorioDir%\bin\win32" set value1=win32&&goto resetConfigValue1
		IF EXIST "%FactorioDir%\bin\x64" set value1=x64&&goto resetConfigValue1
	)
	::if not then we reset InstallDir, SetupComplete which will force dir to be completely reset, including WinOS on next run
	set option1=SetupComplete
	set value1=0
	set option2=InstallDir
	set value2=0
) else IF %fvalue%== 1 (
	set option1=SetupComplete
	set value1=0
	set option2=InstallDir
	set value2=0
	echo -------------------------------------------------------------------------------
	echo  Could not determine the version of the game you have installed 
	echo  You will need to setup your install directory again, sorry!
	echo -------------------------------------------------------------------------------
)

IF [%option2%]==[] goto resetConfigValue1
:resetConfigValue2
call :iniWrite %option2% %value2% "%FST_Config%"


::only reset the first value
:resetConfigValue1
call :iniWrite %option1% %value1% "%FST_Config%"

echo -------------------------------------------------------------------------------
echo  Reset the config value^(s^) documented above in FST_Config.ini
echo  You might not be prompted to modify these values
echo  Make sure when you get to the Option launch screen you double check 
echo  and if necessary modify them with the options 2-7
echo -------------------------------------------------------------------------------
echo.

echo.
echo -------------------------------------------------------------------------------
echo  If these errors are persistent read below:
echo -------------------------------------------------------------------------------
echo.
echo  You can [D]elete the FactorioServerTool config file
echo  This is unrecoverable and will have to be recreated, though the setup wizard
echo.
echo  This will not affect your saved games or Factorio install
echo.
echo  You can attempt to [R]estart this script with the fixes applied
echo.
echo  Or [Q]uit and either check the FST_Config.ini or restart the tool
echo.
choice /c:DRQ /n /m "[D]elete, [R]estart or [Q]uit"

IF %ERRORLEVEL%== 1 (
	del "%FST_Config%"
	echo ----------------------------------QUITTING-------------------------------------
)
IF %ERRORLEVEL%== 2 start "Factorio Server Tool" /D "%BatchDir%" "%FSTbat%"&&goto quickend
IF %ERRORLEVEL%== 3 echo ----------------------------------QUITTING-------------------------------------
goto end

:end
echo  This tool will now exit
timeout 5
:quickend
color 07
cls
endlocal
EXIT
goto:eof