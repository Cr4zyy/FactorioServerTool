@echo off 
:: Factorio Server Tool v1.11
:: 13/Apr/2016
:: www.cr4zyb4st4rd.co.uk

goto skip

:acsii
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
echo.
goto:eof

:getDateTime
for /f "tokens=2 delims==" %%I in ('wmic os get localdatetime /format:list') do set dateTime=%%I
set dateTime=%dateTime:~0,8%-%dateTime:~8,6%
goto:eof

:: > or eq to x & < or eq to y
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
::grab and stop ip because it echos annoying stuff
for /f "skip=4 usebackq tokens=2" %%a in (`nslookup myip.opendns.com resolver1.opendns.com`) do set CurrIP=%%a
cls

:vars
set BatchDir=%~dp0
set FactorioServerConfig=%appdata%\Factorio\FactorioServerConfig.ini
set DefaultConfig=%appdata%\Factorio\config\config.ini
set ServerConfig=%appdata%\Factorio\config\config-server.ini 
set TempConfig=%appdata%\Factorio\config\config-temp.tmp
set TempFile=%appdata%\Factorio\config\temp.tmp
set Latency=100
set AutoSaveTimer=5
set AutoSaveSlots=3
set NumServerPort=34197
set InstallDir=0
set OptionDelay=10
set CreateSave=0
set FastStart=0
set SaveSelection=0
set SetupComplete=0
::check if batch has been run and config exists

IF NOT EXIST %FactorioServerConfig% goto setupBatch

find "SetupComplete=" %FactorioServerConfig% | sort /r | date | find "=" > en#er.bat
echo set SetupValue=%%6> enter.bat
call en#er.bat
del en?er.bat > nul

call :GEOLE %SetupValue% 0 1
IF %GEOLEvalue%== 1 echo SetupComplete = OK
IF %GEOLEvalue%== 0 set failed=This error is so show that the tool has tried to fix the problem, please re-launch the tool and if this continues please delete %FactorioServerConfig%&& call :errorFix SetupComplete 1

IF [%SetupValue%]==[1] ( 
	goto checkBatch 
) else ( 
	goto setupBatch
)

:checkBatch
call :acsii

echo ------------------------------------------------------------------------------  
echo  Reading config options from file:
echo  %FactorioServerConfig%
echo ------------------------------------------------------------------------------  

find "InstallDir=" %FactorioServerConfig% | sort /r | date | find "=" > en#er.bat
echo set SavedDir=%%6> enter.bat
call en#er.bat
del en?er.bat > nul
set FactorioDir=%SavedDir:?= %
IF EXIST "%FactorioDir%\bin\x64\Factorio.exe" echo InstallDir = OK
IF NOT EXIST "%FactorioDir%\bin\x64\Factorio.exe" set failed=This error is so show that the tool has tried to fix the problem, please re-launch the tool and if this continues please delete %FactorioServerConfig%&& call :errorFix InstallDir 0 SetupComplete 0
::echo Install Dir: %FactorioDir%


find "AutoSaveTimer=" %FactorioServerConfig% | sort /r | date | find "=" > en#er.bat
echo set AutoSaveTimer=%%6> enter.bat
call en#er.bat
del en?er.bat > nul
::echo Auto Save Interval: %AutoSaveTimer%
call :GEOLE %AutoSaveTimer% 1 500
IF %GEOLEvalue%== 1 echo AutoSaveTimer = OK
IF %GEOLEvalue%== 0 set failed=This error is so show that the tool has tried to fix the problem, please re-launch the tool and if this continues please delete %FactorioServerConfig%&& call :errorFix AutoSaveTimer 5


find "AutoSaveSlots=" %FactorioServerConfig% | sort /r | date | find "=" > en#er.bat
echo set AutoSaveSlots=%%6> enter.bat
call en#er.bat
del en?er.bat > nul

call :GEOLE %AutoSaveSlots% 1 500
IF %GEOLEvalue%== 1 echo AutoSaveSlots = OK
IF %GEOLEvalue%== 0 set failed=This error is so show that the tool has tried to fix the problem, please re-launch the tool and if this continues please delete %FactorioServerConfig%&& call :errorFix AutoSaveSlots 3

find "Latency=" %FactorioServerConfig% | sort /r | date | find "=" > en#er.bat
echo set Latency=%%6> enter.bat
call en#er.bat
del en?er.bat > nul
::echo Latency: %Latency%
call :GEOLE %Latency% 1 5000
IF %GEOLEvalue%== 1 echo Latency = OK
IF %GEOLEvalue%== 0 set failed=This error is so show that the tool has tried to fix the problem, please re-launch the tool and if this continues please delete %FactorioServerConfig%&& call :errorFix Latency 100

find "SaveSelection=" %FactorioServerConfig% | sort /r | date | find "=" > en#er.bat
echo set SaveSelection=%%6> enter.bat
call en#er.bat
del en?er.bat > nul

call :GEOLE %SaveSelection% 0 1
IF %GEOLEvalue%== 1 echo SaveSelection = OK
IF %GEOLEvalue%== 0 set failed=This error is so show that the tool has tried to fix the problem, please re-launch the tool and if this continues please delete %FactorioServerConfig%&& call :errorFix SaveSelection 0

::this value is not set by the batch but can be added as explained in the "About"
find "FastStart=" %FactorioServerConfig% | sort /r | date | find "=" > en#er.bat
echo set FastStart=%%6> enter.bat
call en#er.bat
del en?er.bat > nul
call :GEOLE %FastStart% 0 1
IF %GEOLEvalue%== 1 echo FastStart = OK
IF %GEOLEvalue%== 0 set failed=This error is so show that the tool has tried to fix the problem, please re-launch the tool and if this continues please delete %FactorioServerConfig%&& call :errorFix FastStart 0
echo.

IF NOT EXIST %ServerConfig% set failed=Could not locate config-server.ini but found the FactorioServerConfig.ini trying to repair please try again and if it fails delete: %FactorioServerConfig% && call :errorFix SetupComplete 0

IF %FastStart%== 1 goto latestSave

IF %SaveSelection%== 1 (
	goto enterSave
) else (
	goto latestSave
)

:setupBatch
:: Begin server setup enter install dir
::look for factorio first
call :acsii

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
echo  Found Factorio folder checking for Factorio.exe
IF EXIST "%SteamDir%\steamapps\common\Factorio\bin\x64\Factorio.exe" (
	set InstallDir=%SteamDir%\steamapps\common\Factorio
	goto foundInstallDir
) else (
	echo  No Factorio.exe located, please make sure Factorio is installed.
	goto inputLocation
)



:notInMainDir
:: if factorio is not in the main steam dir it could be in an alternative steam library location so we find it here
IF EXIST %SteamDir%\steamapps\libraryfolders.vdf (

	echo  Searching for other steam Library folder locations
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
set /p ans0= Is this location correct [Y/N]?
IF %ans0%== y goto makeConfig
IF %ans0%== n goto inputLocation
IF NOT %ans0%== y echo Incorrect answer&& goto foundInstallDir
IF NOT %ans0%== n echo Incorrect answer&& goto foundInstallDir

:inputLocation
echo ------------------------------------------------------------------------------  
echo  Please enter the main Factorio Install Directory
echo  e.g. E:\Program Files (x86)\Steam\steamapps\common\Factorio
echo ------------------------------------------------------------------------------  
echo.
set /p InstallDir=

IF NOT EXIST "%InstallDir%\bin\x64\Factorio.exe" echo  No Factorio.exe located, please make sure Factorio is installed.&& goto inputLocation


set /p ans1=Is the directory - %InstallDir%, correct? [Y/N]
IF %ans1%== y goto makeConfig
IF %ans1%== n goto inputLocation
IF NOT %ans1%== y echo Incorrect answer&& goto inputLocation
IF NOT %ans1%== n echo Incorrect answer&& goto inputLocation

:makeConfig
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
IF EXIST "%appdata%\Factorio\server\saves" (
	IF EXIST "%appdata%\Factorio\config\config-server.ini" (
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
set /p ans2=Would you like to create the server folders? [Y/N]
IF %ans2%== y goto createServerDir
set failed=You opted to not create server files, without them this tool can not operate
IF %ans2%== n goto errorEnd
IF NOT %ans2%== y echo Incorrect answer&& goto noServerSave
IF NOT %ans2%== n echo Incorrect answer&& goto noServerSave

:createServerDir
cls
call :acsii
echo -------------------------------------------------------------------------------
echo  Mods and Save files
echo -------------------------------------------------------------------------------

set /p ans3=Copy your Single Player mods folder? [Y/N]
IF %ans3%== y set SPMods=1&& goto spFolder
IF %ans3%== n set SPMods=0&& goto spFolder
IF NOT %ans3%== y echo Incorrect answer&& goto createServerDir
IF NOT %ans3%== n echo Incorrect answer&& goto createServerDir


:spFolder
echo.
echo.
echo Copy your Single Player saves folder? 
echo Selecting No will still allow you to create a new save
set /p ans4=[Y/N]?
IF %ans4%== y set SPSaves=1&& goto createSave
IF %ans4%== n set SPSaves=0&& goto createSave
IF NOT %ans4%== y echo Incorrect answer&& goto spFolder
IF NOT %ans4%== n echo Incorrect answer&& goto spFolder

IF %SPSaves%== 0 (call :createSave) else goto copyContent

:createSave
echo.
echo.
set /p ansN=Create a new save file? [Y/N]
IF %ansN%== y set CreateSave=1&& goto saveCreateDone
IF %ansN%== n set CreateSave=2&& goto saveCreateDone
IF NOT %ansN%== y echo Incorrect answer&& goto createSave
IF NOT %ansN%== n echo Incorrect answer&& goto createSave

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

:copyContent
::make the directories before we use xcopy otherwise it promts about file/directory type and that's annoying
mkdir %appdata%\Factorio\server
mkdir %appdata%\Factorio\server\saves
mkdir %appdata%\Factorio\server\mods

IF %SPMods%== 1 xcopy /s /e /y %appdata%\Factorio\mods %appdata%\Factorio\server\mods
IF %SPSaves%== 1 xcopy /s /e /y %appdata%\Factorio\saves %appdata%\Factorio\server\saves
timeout 1
cls

set failed=Failed to create the server files^(s^) and^/or folder^(s^), you may need to run this as an administrator ^(right-click^)
IF EXIST "%appdata%\Factorio\server\saves" (
	call :acsii
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
set /p ans8=Create a new config-server.ini? [Y/N]
IF %ans8%== y goto configSetup
IF %ans8%== n goto useAnotherConfig
IF NOT %ans8%== y echo Incorrect answer&& goto checkConfig
IF NOT %ans8%== n echo Incorrect answer&& goto checkConfig

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

set /p ans9=Is the location - %AlternateConfig%, correct? [Y/N]
IF %ans9%== y goto copyConfig
IF %ans9%== n goto useAnotherConfig
IF NOT %ans9%== y echo Incorrect answer&& goto useAnotherConfig
IF NOT %ans9%== n echo Incorrect answer&& goto useAnotherConfig

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
set /p ansCS=Setup Server config file? [Y/N]
IF %ansCS%== y goto configServerData
IF %ansCS%== n goto useAnotherConfig
IF NOT %ansCS%== y echo Incorrect answer&& goto configSetup
IF NOT %ansCS%== n echo Incorrect answer&& goto configSetup

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
call :acsii
:pickPortcls
IF EXIST %ServerConfig% (
	find "port=" %ServerConfig% | sort /r | date | find "=" > en#er.bat
	echo set CurServPort=%%6> enter.bat
	call en#er.bat
	del en?er.bat > nul
) else (
	set CurServPort=-NO SET OR FOUND-
)
echo -------------------------------------------------------------------------------
echo  Set your SERVER port number                                ^(recommend 34197^)
echo  Current port number: %CurServPort%                     ^(Accepted Values: 1024-65535^)
echo -------------------------------------------------------------------------------
echo.
set /p NumServerPort=
set /a "NewServerPort=%NumServerPort%"
::dont allow ports outside range

call :GEOLE %NewServerPort% 1024 65535
if %GEOLEvalue%== 1 (call :confirmPort) else goto portFail

:portFail
cls
call :acsii
echo -------------------------------------------------------------------------------
echo  The port %NewServerPort% has not been accepted 
echo  It is outside the range of 1024-65535
echo  Please use a port within the defined range
echo -------------------------------------------------------------------------------
goto pickPortcls

:confirmPort
set /p ans6=Is the port - %NewServerPort%, correct? [Y/N]
IF %ans6%== y goto addPort
IF %ans6%== n goto pickPort
IF NOT %ans6%== y echo Incorrect answer&& goto confirmPort
IF NOT %ans6%== n echo Incorrect answer&& goto confirmPort

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
call :acsii
:setSaveTimercls
::get current value if available
IF EXIST %FactorioServerConfig% (
	find "AutoSaveTimer=" %FactorioServerConfig% | sort /r | date | find "=" > en#er.bat
	echo set CurSaveInt=%%6mins> enter.bat
	call en#er.bat
	del en?er.bat > nul
) else (
	set CurSaveInt=-NOT SET OR FOUND- will default to 5mins, if not changed
)
echo.
echo -------------------------------------------------------------------------------
echo  Set the auto save timer for the server, value in minutes    ^(recommended 5^)
echo  Current save interval: %CurSaveInt%                       ^(Accepted values: 1-500^)
echo -------------------------------------------------------------------------------
echo.
set /p AutoSaveTimer=

call :GEOLE %AutoSaveTimer% 1 500
if %GEOLEvalue%== 1 (call :confirmTimer) else goto timerFail

:timerFail
cls
call :acsii
echo -------------------------------------------------------------------------------
echo  The value %AutoSaveTimer% has not been accepted 
echo  It is outside the range of 1-500
echo  Please use a value within the defined range
echo -------------------------------------------------------------------------------
goto setSaveTimercls

:confirmTimer
set /p ans7=Is this value - %AutoSaveTimer%, correct? [Y/N]
IF %ChangeSaveInterval%== 0 (
	IF %ans7%== y goto setSaveSlots
	IF %ans7%== n goto setSaveTimer
	IF NOT %ans7%== y echo Incorrect answer&& goto confirmTimer
	IF NOT %ans7%== n echo Incorrect answer&& goto confirmTimer
)
IF %ChangeSaveInterval%== 1 (
echo -------------------------------------------------------------------------------
echo  Writing config file - %FactorioServerConfig%
echo -------------------------------------------------------------------------------
	type %FactorioServerConfig% | find /v "AutoSaveTimer=" > BatchConfig.tmp
	copy /y BatchConfig.tmp %FactorioServerConfig%
	echo AutoSaveTimer=%AutoSaveTimer% >> %FactorioServerConfig%
	del BatchConfig.tmp
	IF %ans7%== n goto setSaveTimer
	IF %ans7%== y goto setSaveSlots
	IF NOT %ans7%== y echo Incorrect answer&& goto confirmTimer
	IF NOT %ans7%== n echo Incorrect answer&& goto confirmTimer
)

:setSaveSlots
cls
call :acsii
:setSaveSlotscls
::get current value if available
IF EXIST %FactorioServerConfig% (
	find "AutoSaveSlots=" %FactorioServerConfig% | sort /r | date | find "=" > en#er.bat
	echo set CurSaveSlot=%%6slots> enter.bat
	call en#er.bat
	del en?er.bat > nul
) else (
	set CurSaveSlot=-NOT SET OR FOUND- will default to 3 slots
)
echo.
echo -------------------------------------------------------------------------------
echo  Set the amount of autosaves slots for the server           ^(recommended 3^)
echo  Current autosave save slots: %CurSaveSlot%               ^(Accepted values: 1-500^)
echo -------------------------------------------------------------------------------
echo.
set /p AutoSaveSlots=
set ChangeLatency=0

call :GEOLE %AutoSaveSlots% 1 500
if %GEOLEvalue%== 1 (call :confirmSaveSlots) else goto saveSlotFail

:saveSlotFail
cls
call :acsii
echo -------------------------------------------------------------------------------
echo  The value %AutoSaveSlots% has not been accepted 
echo  It is outside the range of 1-500
echo  Please use a value within the defined range
echo -------------------------------------------------------------------------------
goto setSaveSlotscls

:confirmSaveSlots

set /p ansS=Is this value - %AutoSaveSlots%, correct? [Y/N]
IF %ChangeSaveInterval%==0 (
	IF %ansS%==y goto setLatency
	IF %ansS%==n goto setSaveSlots
	IF NOT %ansS%== y echo Incorrect answer&& goto confirmSaveSlots
	IF NOT %ansS%== n echo Incorrect answer&& goto confirmSaveSlots
)
IF %ChangeSaveInterval%==1 (
	echo -------------------------------------------------------------------------------
	echo  Writing config file - %FactorioServerConfig%
	echo -------------------------------------------------------------------------------
	type %FactorioServerConfig% | find /v "AutoSaveSlots=" > BatchConfig.tmp
	copy /y BatchConfig.tmp %FactorioServerConfig%
	echo AutoSaveSlots=%AutoSaveSlots% >> %FactorioServerConfig%
	del BatchConfig.tmp
	
	IF %ansS%==y goto startServer
	IF %ansS%==n goto setSaveSlots
	IF NOT %ansS%== y echo Incorrect answer&& goto confirmSaveSlots
	IF NOT %ansS%== n echo Incorrect answer&& goto confirmSaveSlots
)

:setLatency
cls
call :acsii
:setLatencycls
::get current value if available
IF EXIST %FactorioServerConfig% (
	find "Latency=" %FactorioServerConfig% | sort /r | date | find "=" > en#er.bat
	echo set CurLatValue=%%6ms> enter.bat
	call en#er.bat
	del en?er.bat > nul
) else (
	set CurLatValue=-NOT SET OR FOUND- will default to 100 ms
)
echo.
echo -------------------------------------------------------------------------------
echo  Set the server multiplayer latency                ^(Accepted values: 1-5000^)
echo  ^(recommended worst player ping+30^)                            ^(default 100^)
echo  Current latency value: %CurLatValue%
echo -------------------------------------------------------------------------------
echo.
set /p Latency=

call :GEOLE %Latency% 1 500
if %GEOLEvalue%== 1 (call :confirmLatency) else goto latencyFail

:latencyFail
cls
call :acsii
echo -------------------------------------------------------------------------------
echo  The value %Latency% has not been accepted 
echo  It is outside the range of 1-5000
echo  Please use a value within the defined range
echo -------------------------------------------------------------------------------
goto setLatencycls

:confirmLatency
set /p ansL=Is this value - %Latency% ms, correct? [Y/N]
IF %ChangeLatency%== 0 (
	IF %ansL%== y goto serverComplete
	IF %ansL%== n goto setLatency
	IF NOT %ansL%== y echo Incorrect answer&& goto confirmLatency
	IF NOT %ansL%== n echo Incorrect answer&& goto confirmLatency
)
IF %ChangeLatency%== 1 (
	echo -------------------------------------------------------------------------------
	echo  Writing config file - %FactorioServerConfig%
	echo -------------------------------------------------------------------------------
	type %FactorioServerConfig% | find /v "Latency=" > BatchConfig.tmp
	copy /y BatchConfig.tmp %FactorioServerConfig%
	echo Latency=%Latency% >> %FactorioServerConfig%
	del BatchConfig.tmp
	IF %ansL%== y goto startServer
	IF %ansL%== n goto setLatency
	IF NOT %ansL%== y echo Incorrect answer&& goto confirmLatency
	IF NOT %ansL%== n echo Incorrect answer&& goto confirmLatency
)

:serverComplete
cls
call :acsii
::server setup complete now pick savefiles and write configs
echo.
echo -------------------------------------------------------------------------------
echo  Select which savefile to load on launch newest save file or pick a save file
echo  This setting will be remembered for the next time^(s^)
echo  You can always select a different save file before the server launches
echo -------------------------------------------------------------------------------
echo.
set /p ans5=Load newest save file (Y) by default or (N) to select the save file? [Y/N]
IF %ans5%== y set SaveSel=0&& goto writeConfig
IF %ans5%== n set SaveSel=1&& goto writeConfig
IF NOT %ans5%== y echo Incorrect answer&& goto serverComplete
IF NOT %ans5%== n echo Incorrect answer&& goto serverComplete


:resetSaveSelect
cls
call :acsii
echo.
echo -------------------------------------------------------------------------------
echo  Select newest server savefile for launch by default? ^(Y^)
echo  or ^(N^) open the savefile selection menu each launch.
echo  ^(Y^) is a faster method
echo -------------------------------------------------------------------------------
echo.
set /p ansR=Use newest save file ^(Y^) on launch or ^(N^) open file selection menu? [Y/N]

IF %ansR%== y set SaveSel=0&& goto resetSaveConfigWrite
IF %ansR%== n set SaveSel=1&& goto resetSaveConfigWrite
IF NOT %ansR%== y echo Incorrect answer&& goto resetSaveSelect
IF NOT %ansR%== n echo Incorrect answer&& goto resetSaveSelect

:resetSaveConfigWrite
echo -------------------------------------------------------------------------------
echo  Writing config file - %FactorioServerConfig%
echo -------------------------------------------------------------------------------

type %FactorioServerConfig% | find /v "SaveSelection=" > BatchConfig.tmp
copy /y BatchConfig.tmp %FactorioServerConfig%
echo SaveSelection=%SaveSel% >> %FactorioServerConfig%
del BatchConfig.tmp

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
type %FactorioServerConfig% | find /v "InstallDir=" > BatchConfig.tmp
copy /y BatchConfig.tmp %FactorioServerConfig%
echo InstallDir=%InstallString%>> %FactorioServerConfig%
del BatchConfig.tmp

type %FactorioServerConfig% | find /v "AutoSaveTimer=" > BatchConfig.tmp
copy /y BatchConfig.tmp %FactorioServerConfig%
echo AutoSaveTimer=%AutoSaveTimer% >> %FactorioServerConfig%
del BatchConfig.tmp

type %FactorioServerConfig% | find /v "AutoSaveSlots=" > BatchConfig.tmp
copy /y BatchConfig.tmp %FactorioServerConfig%
echo AutoSaveSlots=%AutoSaveSlots% >> %FactorioServerConfig%
del BatchConfig.tmp

type %FactorioServerConfig% | find /v "Latency=" > BatchConfig.tmp
copy /y BatchConfig.tmp %FactorioServerConfig%
echo Latency=%Latency% >> %FactorioServerConfig%
del BatchConfig.tmp

type %FactorioServerConfig% | find /v "SaveSelection=" > BatchConfig.tmp
copy /y BatchConfig.tmp %FactorioServerConfig%
echo SaveSelection=%SaveSel% >> %FactorioServerConfig%
del BatchConfig.tmp

type %FactorioServerConfig% | find /v "SetupComplete=" > BatchConfig.tmp
copy /y BatchConfig.tmp %FactorioServerConfig%
echo SetupComplete=1 >> %FactorioServerConfig%
del BatchConfig.tmp

IF %SaveSel%== 0 goto latestSave
IF %SaveSel%== 1 goto enterSave

:enterSave
cls
call :acsii
::for launching with user defined save
cd /d %appdata%\Factorio\server\saves
echo -------------------------------------------------------------------------------
echo  Enter save file name to load
echo  Showing newest 10 save files
echo -------------------------------------------------------------------------------
set n=0
for /F "delims=" %%S in ('dir *.zip /b /o:-d') do (
  echo %%S
  set /a "n+=1, 1/(10-n)" 2>nul || goto :break
)
:break
echo -------------------------------------------------------------------------------
echo  Enter the save file name (savefile.zip). Tab to complete.
echo  If you want to load the newest save leave blank.
echo -------------------------------------------------------------------------------
echo.
set /p SelectedSave=

IF [%SelectedSave%]==[] goto latestSave

IF EXIST "%appdata%\Factorio\server\saves\%SelectedSave%" (
	set SaveFile=%SelectedSave%
	goto startServer
) else (
		IF EXIST "%appdata%\Factorio\server\saves\%SelectedSave%.zip" (
		set SaveFile=%SelectedSave%.zip
		goto startServer
	)
	echo Save file does not exist, please retry.
	goto enterSave
)


:latestSave
::for launching with the newest save file
cd /d %appdata%\Factorio\server\saves
for /F "delims=" %%I in ('dir *.zip /b /od') do set SaveFile=%%I

echo -------------------------------------------------------------------------------
echo  Starting server with newest found save file
echo  %SaveFile%
echo -------------------------------------------------------------------------------

IF %FastStart%== 1 goto executeServer

goto startServer

:selectSPSave
cls
call :acsii
cd /d %appdata%\Factorio\saves
echo -------------------------------------------------------------------------------
echo  Enter save file name to load
echo  Showing newest 10 Single Player save files
echo -------------------------------------------------------------------------------
set n=0
for /F "delims=" %%S in ('dir *.zip /b /o:-d') do (
  echo %%S
  set /a "n+=1, 1/(10-n)" 2>nul || goto :break1
)
:break1
echo -------------------------------------------------------------------------------
echo  Enter the save file name (savefile.zip). Tab to complete.
echo  If you want to load the newest SP save leave blank.
echo  SP saves will be copied and re-named in the server\saves folder
echo -------------------------------------------------------------------------------
echo.
set /p SelectedSPSave=

IF [%SelectedSPSave%]==[] goto latestSPSave

IF EXIST "%appdata%\Factorio\saves\%SelectedSPSave%" (
	set SaveFile=%SelectedSPSave%
	goto copySave
) else (
	IF EXIST "%appdata%\Factorio\saves\%SelectedSPSave%.zip" (
		set SaveFile=%SelectedSPSave%.zip
		goto copySave
	)
	echo Save file does not exist, please retry.
	goto selectSPSave
)

:copySave
set SaveFileName=%SaveFile:~0,-4%

::append datetime to the filename to avoid conflicts
call :getDateTime
set newSaveName=%SaveFileName%_%dateTime%.zip

copy /y %appdata%\Factorio\saves\%SelectedSPSave% %appdata%\Factorio\server\saves\%newSaveName%
set SaveFile=%newSaveName%

goto startServer

:latestSPSave
cls
call :acsii
cd /d %appdata%\Factorio\saves
for /F "delims=" %%G in ('dir *.zip /b /od') do (
	set LatestSP=%%~nG
	set LatestSPext=%%~xG
)

::append datetime to the filename to avoid conflicts
for /f "tokens=2 delims==" %%I in ('wmic os get localdatetime /format:list') do set dateTime=%%I
set dateTime=%dateTime:~0,8%-%dateTime:~8,6%
set newSaveName=%LatestSP%_%dateTime%%LatestSPext%

echo.
echo -------------------------------------------------------------------------------
echo  Latest SP save file is: %LatestSP%%LatestSPext%
echo  Copying it and renaming it to: %newSaveName%
echo -------------------------------------------------------------------------------
echo.
copy /y %appdata%\Factorio\saves\%LatestSP%%LatestSPext% %appdata%\Factorio\server\saves\%newSaveName%
set SaveFile=%newSaveName%

goto startServer

:aboutThis
cls
call :acsii
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
echo  Version: v1.11
echo  Dated: 14/Apr/2016
echo  Author: Scott Coxhead
echo.
echo  Web: cr4zyb4st4rd.co.uk
echo  Github: github.com/Cr4zyy/FactorioServerTool/
echo.
echo  Probably a scrip mess but it seems to work. ^:D
echo  www.cr4zyb4st4rd.co.uk
echo.
echo -------------------------------------------------------------------------------
timeout 20

:startServer
cls

IF [%SaveFile%]==[] set failed=Could not detect any save files, you should run this as administrator&& goto errorEnd

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
  
call :acsii
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
echo    [1] Start the server now!              [6] Modify Server port
echo    [2] Select server save file^(s^)         [7] Set initial save selection
echo    [3] Single player save file^(s^)         [8] Open Factorio Appdata
echo    [4] Modify Auto save time/slots        [9] Open Factorio Install Dir
echo    [5] Modify Latency value               [A]bout
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
call :acsii
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

:errorEnd
cls
call :acsii
color 4f
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
echo \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\----------------////////////////////////////////
echo.
echo  ERROR
echo  Reason: %failed%
echo.
echo ///////////////////////////////----------------\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
pause
color 07
cls
goto end

:errorFix
cls
call :acsii
color 2f
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
echo \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\----------------////////////////////////////////
echo.
echo  ERROR The option for %1 %3 will be reset, you might need to adjust settings
echo.
echo  Reason: %failed%
echo.
echo ///////////////////////////////----------------\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
echo.

type %FactorioServerConfig% | find /v "%1=" > BatchConfig.tmp
copy /y BatchConfig.tmp %FactorioServerConfig%
echo %1=%2 >> %FactorioServerConfig%
del BatchConfig.tmp

type %FactorioServerConfig% | find /v "%3=" > BatchConfig.tmp
copy /y BatchConfig.tmp %FactorioServerConfig%
echo %3=%4 >> %FactorioServerConfig%
del BatchConfig.tmp
echo.
echo  If these errors are persistent read below:
echo  You can [D]elete the config file by pressing D, this is unrecoverable and will have to be recreated.
echo  This will not affect your saved games or Factorio install
echo  Otherwise just [S]kip it
echo.
choice /c:DS /n /d:S /t:20 /m "[D]elete or [S]kip"
IF %ERRORLEVEL%== 1 del %FactorioServerConfig%
IF %ERRORLEVEL%== 2 echo  This will now exit
timeout 5
color 07
cls
goto end

:end
EXIT
goto:eof



