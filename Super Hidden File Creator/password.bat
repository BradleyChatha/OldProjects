@echo OFF
title Super Hidden Files Creator - By Bradley

echo Password...
set/p "com=>"cooper
if %com%==honeydew goto ALLOW
echo WRONG!
pause
echo Choose Your Fate...
echo 1. MUSH MY CAT 
echo 2. Delete all of your documents.
echo Type 1 or 2
pause >nul
shutdown -im -r
goto End

:ALLOW
color C
cls
echo ACCESS GRANTED
pause
cls
color 7
echo Enter the name of folder to hide or unhide:
set/p "fol=>"
if EXIST %fol% goto SELECT
if notEXIST %fol% GOTO notfound

:notfound
ECHO File Not FOund try again.
goto End

:SELECT
echo Hide/Unhide [h/u]
set/p "com=>"cooper
if %com%==h goto HIDE
if %com%==u goto UNHIDE

:HIDE
attrib %fol% +s +h
goto End

:UNHIDE
echo Enter password to Unlock folder
set/p "pass=>"cooper
if NOT %pass%==honeydew goto FAIL
attrib %fol% -s -h
goto End

:FAIL
echo Invalid password
pause
goto End

:End