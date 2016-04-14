@echo off 
setlocal
:: Factorio Server Tool v0.1.13
:: 14/Apr/2016
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
echo -------------------------------- Made by Cr4zy --------------------------------
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
set evalue=0
IF %1 GEQ %2 set /a "evalue=%evalue%+1"
IF %1 LEQ %3 set /a "evalue=%evalue%+1"
IF %evalue% EQU 2 set GEOLEvalue=1
goto:eof

:skip
::scale cmd to fit nicely
mode con: cols=80 lines=50
::prettyness
color 30
::grab and store ip because it echos annoying stuff
for /f "skip=4 usebackq tokens=2" %%a in (`nslookup myip.opendns.com resolver1.opendns.com`) do set CurrIP=%%a
cls

:vars
set BatchDir=%~dp0

::Server Files
set FactorioServerConfig=%appdata%\Factorio\FactorioServerConfig.ini
set DefaultConfig=%appdata%\Factorio\config\config.ini
set ServerConfig=%appdata%\Factorio\config\config-server.ini 
set TempConfig=%appdata%\Factorio\config\config-temp.tmp
set TempFile=%appdata%\Factorio\config\temp.tmp
set BatchTemp=%appdata%\Factorio\BatchConfig.tmp

:: Server folders
set ServerSaveFolder=%appdata%\Factorio\server\saves
set ServerModFolder=%appdata%\Factorio\server\mods
set StandardSaveFolder=%appdata%\Factorio\saves
set StandardModFolder=%appdata%\Factorio\mods
set ServerFolder=%appdata%\Factorio\server

:: Default settings/options
set Latency=100
set AutoSaveTimer=5
set AutoSaveSlots=3
set NewServerPort=34197
set InstallDir=0
set OptionDelay=10
set CreateSave=0
set FastStart=0
set SaveSelection=0
set SetupComplete=0

:: Check if batch has been run before and a config exists
IF NOT EXIST %FactorioServerConfig% goto setupBatch

find "SetupComplete=" %FactorioServerConfig% | sort /r | date | find "=" > en#er.bat
echo set SetupValue=%%6> enter.bat
call en#er.bat
del en?er.bat > nul

call :GEOLE %SetupValue% 0 1

IF [%SetupValue%]==[1] ( 
	goto checkBatch 
) else ( 
	goto setupBatch
)

:checkBatch
call :ascii
echo ------------------------------------------------------------------------------  
echo  Reading config options from file:
echo  %FactorioServerConfig%
echo ------------------------------------------------------------------------------  
echo.

::Check SetupComplete
IF %GEOLEvalue%== 1 echo SetupComplete = OK
IF %GEOLEvalue%== 0 set failed=This error is so show that the tool has tried to fix the problem, please re-launch the tool and if this continues please delete %FactorioServerConfig%&& call :errorFix SetupComplete 1

::Check Install Directory
find "InstallDir=" %FactorioServerConfig% | sort /r | date | find "=" > en#er.bat
echo set SavedDir=%%6> enter.bat
call en#er.bat
del en?er.bat > nul
set FactorioDir=%SavedDir:?= %

IF EXIST "%FactorioDir%\bin\x64\Factorio.exe" echo InstallDir = OK
IF NOT EXIST "%FactorioDir%\bin\x64\Factorio.exe" set failed=This error is so show that the tool has tried to fix the problem, please re-launch the tool and if this continues please delete %FactorioServerConfig%&& call :errorFix InstallDir 0 SetupComplete 0

::Check AutoSave Timer
find "AutoSaveTimer=" %FactorioServerConfig% | sort /r | date | find "=" > en#er.bat
echo set AutoSaveTimer=%%6> enter.bat
call en#er.bat
del en?er.bat > nul

call :GEOLE %AutoSaveTimer% 1 500
IF %GEOLEvalue%== 1 echo AutoSaveTimer = OK
IF %GEOLEvalue%== 0 set failed=This error is so show that the tool has tried to fix the problem, please re-launch the tool and if this continues please delete %FactorioServerConfig%&& call :errorFix AutoSaveTimer 5

::Check AutoSave Slots
find "AutoSaveSlots=" %FactorioServerConfig% | sort /r | date | find "=" > en#er.bat
echo set AutoSaveSlots=%%6> enter.bat
call en#er.bat
del en?er.bat > nul

call :GEOLE %AutoSaveSlots% 1 500
IF %GEOLEvalue%== 1 echo AutoSaveSlots = OK
IF %GEOLEvalue%== 0 set failed=This error is so show that the tool has tried to fix the problem, please re-launch the tool and if this continues please delete %FactorioServerConfig%&& call :errorFix AutoSaveSlots 3

::Check Latency
find "Latency=" %FactorioServerConfig% | sort /r | date | find "=" > en#er.bat
echo set Latency=%%6> enter.bat
call en#er.bat
del en?er.bat > nul

call :GEOLE %Latency% 1 5000
IF %GEOLEvalue%== 1 echo Latency = OK
IF %GEOLEvalue%== 0 set failed=This error is so show that the tool has tried to fix the problem, please re-launch the tool and if this continues please delete %FactorioServerConfig%&& call :errorFix Latency 100

::Check Save Selection
find "SaveSelection=" %FactorioServerConfig% | sort /r | date | find "=" > en#er.bat
echo set SaveSelection=%%6> enter.bat
call en#er.bat
del en?er.bat > nul

call :GEOLE %SaveSelection% 0 1
IF %GEOLEvalue%== 1 echo SaveSelection = OK
IF %GEOLEvalue%== 0 set failed=This error is so show that the tool has tried to fix the problem, please re-launch the tool and if this continues please delete %FactorioServerConfig%&& call :errorFix SaveSelection 0

::Check Fast Start
::this value is not set by the batch but can be added as explained in the "About"
find "FastStart=" %FactorioServerConfig% | sort /r | date | find "=" > en#er.bat
echo set FastStart=%%6> enter.bat
call en#er.bat
del en?er.bat > nul

call :GEOLE %FastStart% 0 1
IF %GEOLEvalue%== 1 echo FastStart = OK
IF %GEOLEvalue%== 0 set failed=This error is so show that the tool has tried to fix the problem, please re-launch the tool and if this continues please delete %FactorioServerConfig%&& call :errorFix FastStart 0
echo.

::Check for config-server.ini 
IF NOT EXIST %ServerConfig% set failed=Could not locate config-server.ini but found the FactorioServerConfig.ini trying to repair please try again and if it fails delete: %FactorioServerConfig% && call :errorFix SetupComplete 0

::Fast Start bypass
IF %FastStart%== 1 goto latestSave

:: Check SaveSelection and goto appropriate choice
IF %SaveSelection%== 1 (
	goto enterSave
) else (
	goto latestSave
)

:setupBatch
:: Begin server setup enter install dir
::look for factorio first
call :ascii

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
echo  Found Factorio appmanifest checking for Factorio.exe
IF EXIST "%SteamDir%\steamapps\common\Factorio\bin\x64\Factorio.exe" set InstallDir=%SteamDir%\steamapps\common\Factorio&&goto foundInstallDir
echo  No Factorio.exe located, please make sure Factorio is installed.
goto inputLocation




:notInMainDir
:: if factorio is not in the main steam dir it could be in an alternative steam library location so we find it here
IF EXIST %SteamDir%\steamapps\libraryfolders.vdf (

	echo  Searching for other Steam Library folder locations...
	set FactorioLib=0

	set LibraryFile=%SteamDir%\steamapps\libraryfolders.vdf

	type "%LibraryFile%" > TempLib.tmp
	
	for /f "tokens=*" %%a in (TempLib.tmp) do call :processLine %%a
	del TempLib.tmp
	goto break2

	:processline
	set line=%*
	echo %line: =?%>> Temp.tmp
	goto :eof
	
	:break2
	::library dir only have \\ in them this way we can ignore other lines in the file
	for /f "tokens=2" %%d in ('findstr "\\" Temp.tmp') do call :processDir %%d
	del Temp.tmp
	goto break3
	
	:processDir
	set LibraryEntry=%*
	::remove delimiting \
	set LibraryEntry=%LibraryEntry:\\=\%
	::remove quotes ""
	set LibraryEntry=%LibraryEntry:"=%
	::finally remove the ? we added earlier so we can have a working dir path
	set LibraryEntry=%LibraryEntry:?= %
	echo %LibraryEntry%>> Libaries.tmp
	goto :eof
	
	:break3
	for /f "tokens=*" %%L in (Libaries.tmp) do call :searchLib %%L
	del Libaries.tmp
	goto break4
	
	:searchLib
	set SteamLibDir=%*
	:: if we find the exe set installdir
	IF EXIST "%SteamLibDir%\SteamApps\common\Factorio\bin\x64\Factorio.exe" set InstallDir=%SteamLibDir%\SteamApps\common\Factorio&&set FactorioLib=1
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
choice /c:YN /n /m "Is this location correct? [Y/N]"
IF %ERRORLEVEL%== 1 goto makeConfig
IF %ERRORLEVEL%== 2 goto inputLocation


:inputLocation
echo ------------------------------------------------------------------------------  
echo  Please enter the main Factorio Install Directory
echo  e.g. E:\Program Files (x86)\Steam\steamapps\common\Factorio
echo ------------------------------------------------------------------------------  
echo.
set /p InstallDir=
choice /c:YN /n /m "Is the directory - %InstallDir%, correct? [Y/N]"

IF NOT EXIST "%InstallDir%\bin\x64\Factorio.exe" echo  No Factorio.exe located, please make sure Factorio is installed.&& goto inputLocation

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
IF EXIST "%appdata%\Factorio" (
	goto saveData
) else (
	goto noAppData
)
	
:noAppData
echo ------------------------------------------------------------------------------  
echo  Could not locate Factorio AppData Folder
echo ------------------------------------------------------------------------------  
set failed=No Appdata folder
goto errorEnd

:saveData
IF EXIST "%ServerSaveFolder%" (
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
echo  No server files located!
echo ------------------------------------------------------------------------------  
echo.
choice /c:YN /n /m "Would you like to create the server folders? [Y/N]"
IF %ERRORLEVEL%== 1 goto createServerDir
IF %ERRORLEVEL%== 2 set failed=You opted to not create server files, without them this tool can not operate&& goto errorEnd


:createServerDir
cls
call :ascii
echo -------------------------------------------------------------------------------
echo  Mods and Save files
echo -------------------------------------------------------------------------------

choice /c:YN /n /m "Copy your Single Player mods folder? [Y/N]"
IF %ERRORLEVEL%== 1 set SPMods=1&& goto spFolder
IF %ERRORLEVEL%== 2 set SPMods=0&& goto spFolder


:spFolder
echo.
echo.
echo Selecting [N]o will still allow you to create a new save file
choice /c:YN /n /m "Copy your Single Player saves folder? [Y/N]"
IF %ERRORLEVEL%== 1 set SPSaves=1&& goto createSave
IF %ERRORLEVEL%== 2 set SPSaves=0&& goto createSave


IF %SPSaves%== 0 (call :createSave) else goto copyContent

:createSave
echo.
echo.
choice /c:YN /n /m "Create a new save file? [Y/N]"
IF %ERRORLEVEL%== 1 set CreateSave=1&& goto saveCreateDone
IF %ERRORLEVEL%== 2 set CreateSave=2&& goto saveCreateDone


:saveCreateDone
IF %SPSaves%== 0 (
	IF %CreateSave%== 2 (
		set failed=You chose to not copy current SP saves or to create a new one, without a save file the server will not work.
		goto errorEnd
	)
)
::create a new save file using --create	
call :getDateTime
set CreateSaveName=FST_%dateTime%.zip
IF %CreateSave%== 1 "%FactorioDir%\bin\x64\Factorio.exe" --create %CreateSaveName%&& set SPSaves=1

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
mkdir %ServerFolder%
mkdir %ServerSaveFolder%
mkdir %ServerModFolder%

IF %SPMods%== 1 xcopy /s /e /y %StandardModFolder% %ServerModFolder%
IF %SPSaves%== 1 xcopy /s /e /y %StandardSaveFolder% %ServerSaveFolder%
timeout 1
cls

set failed=Failed to create the server files^(s^) and^/or folder^(s^), you may need to run this as an administrator ^(right-click^)
IF EXIST "%ServerSaveFolder%" (
	call :ascii
	goto configSetup
) else (
	goto errorEnd
)

:checkConfig
echo -------------------------------------------------------------------------------
echo  While this tool found server save files 
echo  It could not locate a config-server.ini file
echo  In the following location: %appdata%\Factorio\config\
echo  Answering (N) no will allow you to choose another config if you have one
echo -------------------------------------------------------------------------------
echo.
choice /c:YN /n /m "Create a new config-server.ini? [Y/N]"
IF %ERRORLEVEL%== 1 goto configSetup
IF %ERRORLEVEL%== 2 goto useAnotherConfig

:useAnotherConfig
echo -------------------------------------------------------------------------------
echo  If you are using another name for your config-server.ini
echo  or have it stored in another location
echo  enter the full filename below and it will be copied
echo -------------------------------------------------------------------------------
echo.
set /p AlternateConfig=

IF NOT EXIST %AlternateConfig% (
	echo No file located
	goto useAnotherConfig
)

choice /c:YN /n /m "Is the location - %AlternateConfig%, correct? [Y/N]"
IF %ERRORLEVEL%== 1 goto copyConfig
IF %ERRORLEVEL%== 2 goto useAnotherConfig


:copyConfig
echo -------------------------------------------------------------------------------
echo  Copying your config file into config-server.ini
echo  Located in %appdata%\Factorio\config\
echo -------------------------------------------------------------------------------
copy %AlternateConfig% %ServerConfig%
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
choice /c:YN /n /m "Setup Server config file? [Y/N]"
IF %ERRORLEVEL%== 1 goto configServerData
IF %ERRORLEVEL%== 2 goto useAnotherConfig

:configServerData
::save configs and make new ones and a backup
IF EXIST %DefaultConfig% (
echo -------------------------------------------------------------------------------
echo  Creating config.ini backup
copy %DefaultConfig% %appdata%\Factorio\config\config-backup.ini 
echo  Creating config-server.ini
copy %DefaultConfig% %ServerConfig%
echo -------------------------------------------------------------------------------
) else (
set failed=You have no config file in %appdata%\Factorio\config\
goto errorEnd
)

::modify save locations for server
find "read-data=" %DefaultConfig% | sort /r | date | find "=" > en#er.bat
echo set CurReadData=%%6> enter.bat
call en#er.bat
del en?er.bat > nul

find "write-data=" %DefaultConfig% | sort /r | date | find "=" > en#er.bat
echo set CurWriteData=%%6> enter.bat
call en#er.bat
del en?er.bat > nul

type %ServerConfig% | find /v "[path]" > %TempConfig%
type %TempConfig% | find /v "read-data=" > %ServerConfig%
type %ServerConfig% | find /v "write-data=" > %TempConfig%
copy /y %TempConfig% %ServerConfig%
echo [path]>> %TempFile%
echo read-data=%CurReadData%>> %TempFile%
echo write-data=%CurWriteData%/server>> %TempFile%
type %TempFile% %TempConfig% > %ServerConfig%
del %TempConfig%
del %TempFile%

set ChangePortNumber=0

:pickPort
cls
call :ascii
:pickPortcls
IF EXIST %ServerConfig% (
	find "port=" %ServerConfig% | sort /r | date | find "=" > en#er.bat
	echo set CurServPort=%%6> enter.bat
	call en#er.bat
	del en?er.bat > nul
) else (
	set CurServPort=-NOT SET OR FOUND-
)
echo -------------------------------------------------------------------------------
echo  Set your SERVER port number                               ^(Recommended 34197^)
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
echo  The port %NewServerPort% has not been accepted 
echo  It is outside the range of 1024-65535
echo  Please use a port within the defined range
echo -------------------------------------------------------------------------------
goto pickPortcls

:confirmPort
choice /c:YN /n /m "Is the port - %NewServerPort%, correct? [Y/N]"
IF %ERRORLEVEL%== 1 goto addPort
IF %ERRORLEVEL%== 2 goto pickPort

:addPort
find "port=" %DefaultConfig% | sort /r | date | find "=" > en#er.bat
echo set CurrentPort=%%6> enter.bat
call en#er.bat
del en?er.bat > nul

type %ServerConfig% | find /v "port=" > %TempConfig%
copy /y %TempConfig% %ServerConfig%
echo port=%NewServerPort%>> %ServerConfig%
del %TempConfig%

echo.
echo -------------------------------------------------------------------------------
echo  Forward port %NewServerPort% on your router/firewall, UDP only
echo -------------------------------------------------------------------------------
echo  Your friends will be able to connect on:
echo  %CurrIP%:%NewServerPort%
echo -------------------------------------------------------------------------------
echo  YOU will be able to connect with:
echo  localhost
echo -------------------------------------------------------------------------------
set ChangeSaveInterval=0
IF %ChangePortNumber%== 0  goto setSaveTimer
IF %ChangePortNumber%== 1  goto startServer

:setSaveTimer
cls
call :ascii
:setSaveTimercls
::get current value if available
IF EXIST %FactorioServerConfig% (
	find "AutoSaveTimer=" %FactorioServerConfig% | sort /r | date | find "=" > en#er.bat
	echo set CurSaveInt=%%6mins> enter.bat
	call en#er.bat
	del en?er.bat > nul
) else (
	set CurSaveInt=-NOT SET OR FOUND-
)
echo.
echo -------------------------------------------------------------------------------
echo  Set the auto save timer for the server                        ^(Recommended 5^)
echo  Value is in minutes                                  ^(Accepted values: 1-500^)
echo  Current save interval: %CurSaveInt%
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
choice /c:YN /n /m "Is this time value - %AutoSaveTimer% mins, correct? [Y/N]"
IF %ChangeSaveInterval%== 0 (
	IF %ERRORLEVEL%== 1 goto setSaveSlots
	IF %ERRORLEVEL%== 2 goto setSaveTimer
	
)
IF %ChangeSaveInterval%== 1 (
	::if incorrect dont save config
	IF %ERRORLEVEL%== 2 goto setSaveTimer
	
	echo -------------------------------------------------------------------------------
	echo  Writing config file - %FactorioServerConfig%
	echo -------------------------------------------------------------------------------
	type %FactorioServerConfig% | find /v "AutoSaveTimer=" > %BatchTemp%
	copy /y %BatchTemp% %FactorioServerConfig%
	echo AutoSaveTimer=%AutoSaveTimer% >> %FactorioServerConfig%
	del %BatchTemp%
	
	IF %ERRORLEVEL%== 1 goto setSaveSlots

)

:setSaveSlots
cls
call :ascii
:setSaveSlotscls
::get current value if available
IF EXIST %FactorioServerConfig% (
	find "AutoSaveSlots=" %FactorioServerConfig% | sort /r | date | find "=" > en#er.bat
	echo set CurSaveSlot=%%6slots> enter.bat
	call en#er.bat
	del en?er.bat > nul
) else (
	set CurSaveSlot=-NOT SET OR FOUND-
)
echo.
echo -------------------------------------------------------------------------------
echo  Set the amount of autosaves slots for the server              ^(Recommended 3^)
echo  Autosave overwrites files once past the set value    ^(Accepted values: 1-500^)
echo  Current autosave save slots: %CurSaveSlot%
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
choice /c:YN /n /m "Is this save amount value - %AutoSaveSlots%, correct? [Y/N]"

IF %ChangeSaveInterval%==0 (
	IF %ERRORLEVEL%== 1 goto setLatency
	IF %ERRORLEVEL%== 2 goto setSaveSlots
)
IF %ChangeSaveInterval%==1 (
	::dont save config if N
	IF %ERRORLEVEL%== 2 goto setSaveSlots
		
	echo -------------------------------------------------------------------------------
	echo  Writing config file - %FactorioServerConfig%
	echo -------------------------------------------------------------------------------
	type %FactorioServerConfig% | find /v "AutoSaveSlots=" > %BatchTemp%
	copy /y %BatchTemp% %FactorioServerConfig%
	echo AutoSaveSlots=%AutoSaveSlots% >> %FactorioServerConfig%
	del %BatchTemp%
	
	IF %ERRORLEVEL%== 1 goto startServer
)

:setLatency
cls
call :ascii
:setLatencycls
::get current value if available
IF EXIST %FactorioServerConfig% (
	find "Latency=" %FactorioServerConfig% | sort /r | date | find "=" > en#er.bat
	echo set CurLatValue=%%6ms> enter.bat
	call en#er.bat
	del en?er.bat > nul
) else (
	set CurLatValue=-NOT SET OR FOUND-
)
echo.
echo -------------------------------------------------------------------------------
echo  Set the server multiplayer latency                  ^(Accepted values: 1-5000^)
echo  ^(recommended worst player ping+30^)                              ^(default 100^)
echo  Current latency value: %CurLatValue%
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
choice /c:YN /n /m "Is this latency number - %Latency% ms, correct? [Y/N]"
IF %ChangeLatency%== 0 (
	IF %ERRORLEVEL%== 1 goto serverComplete
	IF %ERRORLEVEL%== 2 goto setLatency
)
IF %ChangeLatency%== 1 (
	:: dont write config if N
	IF %ERRORLEVEL%== 2 goto setLatency
	echo -------------------------------------------------------------------------------
	echo  Writing config file - %FactorioServerConfig%
	echo -------------------------------------------------------------------------------
	type %FactorioServerConfig% | find /v "Latency=" > %BatchTemp%
	copy /y %BatchTemp% %FactorioServerConfig%
	echo Latency=%Latency% >> %FactorioServerConfig%
	del %BatchTemp%
	
	IF %ERRORLEVEL%== 1 goto startServer
)

:serverComplete
cls
call :ascii
::server setup complete now pick savefiles and write configs
echo.
echo -------------------------------------------------------------------------------
echo  Select which savefile to load on launch newest save file or pick a save file
echo  This setting will be remembered for the next time^(s^)
echo  You can always select a different save file before the server launches
echo -------------------------------------------------------------------------------
echo.

choice /c:YN /n /m "Load newest save file (Y) by default or (N) to select the save file? [Y/N]"
IF %ERRORLEVEL%== 1 set SaveSel=0&& goto writeConfig
IF %ERRORLEVEL%== 2 set SaveSel=1&& goto writeConfig


:resetSaveSelect
cls
call :ascii
echo.
echo -------------------------------------------------------------------------------
echo  Select newest server savefile for launch by default? ^(Y^)
echo  or ^(N^) open the savefile selection menu each launch.
echo  ^(Y^) is a faster method
echo -------------------------------------------------------------------------------
echo.

choice /c:YN /n /m "Use newest save file (Y) on launch or (N) open file selection menu? [Y/N]"
IF %ERRORLEVEL%== 1 set SaveSel=0&& goto resetSaveConfigWrite
IF %ERRORLEVEL%== 2 set SaveSel=1&& goto resetSaveConfigWrite

:resetSaveConfigWrite
echo -------------------------------------------------------------------------------
echo  Writing config file - %FactorioServerConfig%
echo -------------------------------------------------------------------------------

type %FactorioServerConfig% | find /v "SaveSelection=" > %BatchTemp%
copy /y %BatchTemp% %FactorioServerConfig%
echo SaveSelection=%SaveSel% >> %FactorioServerConfig%
del %BatchTemp%

goto startServer

:writeConfig
::before we start the server we need to save our config
::write choices to ini
echo -------------------------------------------------------------------------------
echo  Writing config file - %FactorioServerConfig%
echo -------------------------------------------------------------------------------
::make config file for batch
copy /y NUL %FactorioServerConfig% >NUL

set InstallString=%InstallDir: =?%
type %FactorioServerConfig% | find /v "InstallDir=" > %BatchTemp%
copy /y %BatchTemp% %FactorioServerConfig%
echo InstallDir=%InstallString%>> %FactorioServerConfig%
del %BatchTemp%

type %FactorioServerConfig% | find /v "AutoSaveTimer=" > %BatchTemp%
copy /y %BatchTemp% %FactorioServerConfig%
echo AutoSaveTimer=%AutoSaveTimer% >> %FactorioServerConfig%
del %BatchTemp%

type %FactorioServerConfig% | find /v "AutoSaveSlots=" > %BatchTemp%
copy /y %BatchTemp% %FactorioServerConfig%
echo AutoSaveSlots=%AutoSaveSlots% >> %FactorioServerConfig%
del %BatchTemp%

type %FactorioServerConfig% | find /v "Latency=" > %BatchTemp%
copy /y %BatchTemp% %FactorioServerConfig%
echo Latency=%Latency% >> %FactorioServerConfig%
del %BatchTemp%

type %FactorioServerConfig% | find /v "SaveSelection=" > %BatchTemp%
copy /y %BatchTemp% %FactorioServerConfig%
echo SaveSelection=%SaveSel% >> %FactorioServerConfig%
del %BatchTemp%

type %FactorioServerConfig% | find /v "SetupComplete=" > %BatchTemp%
copy /y %BatchTemp% %FactorioServerConfig%
echo SetupComplete=1 >> %FactorioServerConfig%
del %BatchTemp%

IF %SaveSel%== 0 goto latestSave
IF %SaveSel%== 1 goto enterSave

:enterSave
cls
call :ascii
::for launching with user defined save
cd /d %ServerSaveFolder%
echo -------------------------------------------------------------------------------
echo  Enter save file name to load
echo  Showing newest 10 save files
echo -------------------------------------------------------------------------------
set n=0
for /F "delims=" %%S in ('dir %ServerSaveFolder%\*.zip /b /o:-d') do (
  echo %%S
  set /a "n+=1, 1/(10-n)" 2>nul || goto :break
)
:break
echo -------------------------------------------------------------------------------
echo  Enter the save file name ^(savefile.zip^). Tab to complete.
echo  If you want to load the newest save leave the input blank.
echo -------------------------------------------------------------------------------
echo.
set /p SelectedSave=
cd /d %BatchDir%
IF [%SelectedSave%]==[] goto latestSave



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
for /F "delims=" %%I in ('dir %ServerSaveFolder%\*.zip /b /od') do set SaveFile=%%I
echo -------------------------------------------------------------------------------
echo  Starting server with newest found save file
echo  '%SaveFile%'
echo -------------------------------------------------------------------------------
::IF DEFINED somevariable echo Value exists
IF [%SaveFile%]==[] set failed=Could not detect any save files you might need to run this as an administrator or create a new save file below&& call :errorEnd 1
IF %FastStart%== 1 goto executeServer

goto startServer

:selectSPSave
cls
call :ascii
cd /d %StandardSaveFolder%
echo -------------------------------------------------------------------------------
echo  Enter save file name to load
echo  Showing newest 10 Single Player save files
echo -------------------------------------------------------------------------------
set ns=0
for /F "delims=" %%S in ('dir %StandardSaveFolder%\*.zip /b /o:-d') do (
  echo %%S
  set /a "ns+=1, 1/(10-ns)" 2>nul || goto :break1
)
:break1
echo -------------------------------------------------------------------------------
echo  Enter the save file name ^(savefile.zip^). Tab to complete.
echo  If you want to load the newest SP save leave blank.
echo  SP saves will be copied and re-named in the server^\saves folder
echo -------------------------------------------------------------------------------
echo.
set /p SelectedSPSave=
cd /d %BatchDir%
IF [%SelectedSPSave%]==[] goto latestSPSave

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
set SaveFileName=%SaveFile:~0,-4%

::append datetime to the filename to avoid conflicts
call :getDateTime
set newSaveName=%SaveFileName%_%dateTime%.zip

copy /y %StandardSaveFolder%\%SelectedSPSave% %ServerSaveFolder%\%newSaveName%
set SaveFile=%newSaveName%

goto startServer

:latestSPSave
cls
call :ascii
::cd /d %StandardSaveFolder%
for /F "delims=" %%G in ('dir %StandardSaveFolder%\*.zip /b /od') do (
	set LatestSP=%%~nG
	set LatestSPext=%%~xG
)

::append datetime to the filename to avoid conflicts
call :getDateTime
set newSaveName=%LatestSP%_%dateTime%%LatestSPext%

IF [%newSaveName%]==[] set failed=Could not detect any save files, you might need to run this as an administrator or create a new save file below&& call :errorEnd 1

echo.
echo -------------------------------------------------------------------------------
echo  Latest SP save file is: '%LatestSP%%LatestSPext%'
echo  Copying it and renaming it to: '%newSaveName%'
echo -------------------------------------------------------------------------------
echo.
copy /y %StandardSaveFolder%\%LatestSP%%LatestSPext% %ServerSaveFolder%\%newSaveName%
set SaveFile=%newSaveName%

IF [%SaveFile%]==[] set failed=Could not detect any save files, you might need to run this as an administrator or create a new save file below&& call :errorEnd 1

goto startServer

:aboutThis
cls
call :ascii
echo -------------------------------------------------------------------------------
echo.
echo  A small batch script to help easily setup hosting a dedicated Factorio server 
echo  Windows 7+ (might work on XP who knows)
echo.
echo  This tool is not affiliated with Factorio in any way.
echo  Not responsible for direct, indirect, incidental or consequential damages resulting from any defect, error or failure to perform.
echo  Also not responsible for making it so easy to host a server you don't stop playing the game.
echo.
echo -------------------------------------------------------------------------------
echo.
echo  Stores it's own config file containing options from the intial run
echo  %FactorioServerConfig%
echo.
echo  You can add FastStart=1 to this config to skip the Options screen
echo  and always begin the server with the newest server savefile.
echo  To undo either set it to 0 or remove it.
echo.
echo -------------------------------------------------------------------------------
echo.
echo  Version: v0.1.13
echo  Dated: 14/Apr/2016
echo  Author: Scott Coxhead
echo.
echo  Web: cr4zyb4st4rd.co.uk
echo  Github: github.com/Cr4zyy/FactorioServerTool/
echo.
echo  Probably a script mess but it seems to work, for me. ^:D
echo.
echo -------------------------------------------------------------------------------
timeout 20

:startServer
cls
::grab port number from config-server.ini
IF EXIST %ServerConfig% (
	find "port=" %ServerConfig% | sort /r | date | find "=" > en#er.bat
	echo set ServerPort=%%6> enter.bat
	call en#er.bat
	del en?er.bat > nul
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
echo  Above should show your IP, if not, check here: icanhazip.com
echo.
echo  YOU can connect with: localhost
echo.
echo -------------------------------------------------------------------------------
echo.
echo  Using save file: %SaveFile%
echo  Auto save interval: %AutoSaveTimer% mins
echo  Auto save slots: %AutoSaveSlots%
echo  Latency value: %Latency% ms
echo.
echo -------------------------------------------------------------------------------
echo.
echo  Server starting in %%N seconds.
echo.
echo -------------------------------------------------------------------------------
echo.
echo  Or select a following option:
echo.
echo      [1] START the server now!              [6] Modify Server PORT
echo      [2] Select server save FILE^(s^)         [7] Set INITIAL save selection
echo      [3] Single player save FILE^(s^)         [8] Open Factorio AppData Dir
echo      [4] Modify Auto SAVE TIME^&SLOTS        [9] Open Factorio Install Dir
echo      [5] Modify LATENCY value               [A]bout
echo.
echo -------------------------------------------------------------------------------
echo.
choice /c:123456789AB /n /d:B /t:1 /m "Select a choice from above"
IF NOT ERRORLEVEL==11 goto :breakout
)

:breakout
IF %ERRORLEVEL%== 10 goto aboutThis

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
IF %ERRORLEVEL%== 8 set OptionDelay=5 && "%SystemRoot%\explorer.exe" "%appdata%\Factorio"
IF %ERRORLEVEL%== 9 set OptionDelay=5 && "%SystemRoot%\explorer.exe" "%FactorioDir%"
goto startServer

:executeServer
:: change to factorio dir and start server with chosen save file
::increase window size for some easier log viewing
mode con: cols=80 lines=100

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
echo  ///////////////////////////////-----/--\-----\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\ 
echo ///////////////////////////////-----/----\-----\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
echo.
timeout 2
echo.
color 08
cd /d %FactorioDir%
start /wait bin\x64\Factorio.exe --start-server %SaveFile% --autosave-interval %AutoSaveTimer% --autosave-slots %AutoSaveSlots% --latency-ms %Latency% -c %ServerConfig%&&cd /d %BatchDir%&&color 07
goto end

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
IF %1== 1 (call :errorNewSave %random% ) else goto end

:errorNewSave
echo.
echo  You can create a new savefile here
echo  This save will be the newest file for the next run, if it still cant be detected you might need to run as admin.
echo  This will only create a file named 'FST_FIX%1.zip' it will 
echo.
choice /c:CS /n /d:S /t:20 /m "[C]reate or [S]kip"
IF %ERRORLEVEL%== 1 (	
	"%FactorioDir%\bin\x64\Factorio.exe" --create FST_FIX%1.zip
	timeout 1
	mkdir %appdata%\Factorio\server\saves\
	copy /y %appdata%\Factorio\saves\FST_FIX%1.zip %appdata%\Factorio\server\saves\
	pause
	echo This tool will now exit
	timeout 5
	color 07
	cls
	EXIT
	goto:eof
)
IF %ERRORLEVEL%== 2 echo  This tool will now exit
timeout 5
color 07
cls
goto end

pause
color 07
cls
goto end

:errorFix
cls
call :ascii
color 1f
call :errorASCII
echo \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\----------------////////////////////////////////
echo.
echo  ERROR Config option for %1 %3 will be reset, you might need to adjust settings
echo.
echo  Reason: %failed%
echo.
echo ///////////////////////////////----------------\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
echo.

type %FactorioServerConfig% | find /v "%1=" > %BatchTemp%
copy /y %BatchTemp% %FactorioServerConfig%
echo %1=%2 >> %FactorioServerConfig%
del %BatchTemp%

type %FactorioServerConfig% | find /v "%3=" > %BatchTemp%
copy /y %BatchTemp% %FactorioServerConfig%
echo %3=%4 >> %FactorioServerConfig%
del %BatchTemp%
echo.
echo  If these errors are persistent read below:
echo  You can [D]elete the config file by pressing D, this is unrecoverable and will have to be recreated.
echo  This will not affect your saved games or Factorio install
echo  Otherwise just [S]kip it
echo.
choice /c:DS /n /d:S /t:20 /m "[D]elete or [S]kip"
IF %ERRORLEVEL%== 1 del %FactorioServerConfig%
IF %ERRORLEVEL%== 2 echo  This tool will now exit
timeout 5
color 07
cls
goto end

:end
endlocal
EXIT
goto:eof