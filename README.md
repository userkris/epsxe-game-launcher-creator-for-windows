# ePSXe Game Launcher Creator for Windows

Simple ```.bat``` script creates Windows application to run specific game CD image via [ePSXe](https://www.epsxe.com/) PlayStation One emulator (Primary). EXE files will start CD image game via emulator without but without emulator UI. The idea is to imitate Windows App feel for PlayStation games and use the launcher in Stat Menu and Steam.

## How to use

### Prepare Directories
To avoid any issues with permission it is recommended to avoid use of ```C:\Program Files\``` instead create directories ```C:\games\psx```

#### [1] Get ePSXe
Get ePSXe from [https://www.epsxe.com/](https://www.epsxe.com/). ePSXe is portable application, does not require installation process.\
Extract everything from archive to ```C:\games\psx\epsxe```.

#### [2] Make library directory for all your games
Recommended to keep games in ```C:\games\psx\library```.

#### [3] Copy Launcher Creator
Place everything to ```C:\games\psx\launcher-creator```

#### Example of PSX directory
```
C:\games\psx
  epsxe            - ePSXe emulator
  library          - library of your games
  launcher-creator - launcher creator program
```

### Setup Launcher Creator
Do not use whitespaces in paths! I didn't find the way to make it work properly with whitespaces in paths. Replace whitespaces with dash ```-```.\
Main settings file is `.\launcher-creator\settings.ini`.

#### [1] Path to emulator
```pathToEmulator``` - path to emulator EXE file.\
It should be:\
```pathToEmulator="C:\games\psx\epsxe\epsxe.exe"```\
Make sure there is no whitespaces and rename the file if needed.\
It could be any Windows application, another emulator etc.

#### [2] Attributes to Run CD Images
```attributes=-nogui -loadbin```\
These are attributes for ePSXe to run CD image.\
Can be modified if you use another emulator.

#### [3] Library
```pathToLibrary="C:\games\psx\library"```\
Path to library, no whitespaces.

#### [4] Copy or Move Mode
```binaryFileMode=move```\
Move mode will move all the files from ```.\launcher-creator\source``` directory to your library. Designed to avoid unnecessary coping.\
```binaryFileMode=copy```
Copy mode will copy files to library.
```binaryFileMode=false```\
False mode will create EXE file in your library but keep your source content untouched.

### Setup EXE File
Manifest file containts data about your launcher `.\launcher-creator\manifest.ini`.\
Manifest example for [Crash Team Racing](https://en.wikipedia.org/wiki/Crash_Team_Racing).

#### [1] Title
```packageTitle=Crash Team Racing```\
This is the title of your game. You can use whitespaces and keep format.

#### [2] Description
```packageDescription=Kart racing video game developed by Naughty Dog and published by Sony Computer Entertainment for the PlayStation.```\
A short game description same format as title. This value appears in Windows explorer.

#### [3] Icon for EXE
```icon=".\source\favicon.ico"```\
I recommend using relative path to icon to ```build.bat``` file. Avoid whitespaces.

#### [4] Serial Number
```serialNumber=[NTSC-U][SCUS-94426]```\
Sometimes you wish to have different versions of same title eg. a modded game or for different region like Japan etc. This value represents the ID of the game and also modifies directory name in library. In case you don't know serial number and you still want the EXE file, just comment this line and program will generate ```no-serial-1``` incremented. Again... do not use whitespaces.


#### [5] Source Directory with CD Image File
```binaryDir=".\source\"```\
This is where you keep original ```.bin```, ```.cue``` etc. files. Copy or Move modes use content of this directory.

#### [6] File to Run by Emulator
```fileToRun=*.cue```\
ePSXe can run a lot of CD image types. If you have single ```.bin``` or ```.iso``` file, just put the correct extension. In case you have ```.cue``` + ```.bin```, it would be good start with ```.cue```.\
```build.bat``` will copy everything from source to your library. Everything will be renamed regarding your game title and serial number. As a starting file it will choose the one with extension you declared.

### Run
Run ```build.bat```.\
This example above creates directory in library and moves stuff from source to this directory.

Example:
```
Source:
C:\games\psx\launcher-creator\source
  Crash-Team-Racing.cue
  Crash-Team-Racing.bin
  favicon.ico

Result:
C:\games\psx\library
  crash-team-racing[NTSC-U][SCUS-94426]
    Crash Team Racing.exe
    crash-team-racing[NTSC-U][SCUS-94426].cue
    crash-team-racing[NTSC-U][SCUS-94426].bin
    crash-team-racing[NTSC-U][SCUS-94426].ico
```
Crash Team Racing EXE file will start ```.cue``` file via ePSXe.\
That's it!

## Dependencies
- Modified [bat2exeIEXP.bat](https://github.com/npocmaka/batch.scripts/blob/master/hybrids/iexpress/bat2exeIEXP.bat) to create EXE files via Windows IEXPRESS tool
- [Resource Hacker by Angus Johnson](http://www.angusj.com/resourcehacker/) to modify EXE files
