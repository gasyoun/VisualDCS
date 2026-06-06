@echo off
REM ============================================================
REM  Reassemble the split DCS-data files into their originals.
REM  Run this from inside the src\DCS-data folder:
REM      cd src\DCS-data
REM      rejoin.bat
REM
REM  copy /b concatenates the parts in order, byte-for-byte.
REM  The result is identical to the original (MD5 verified).
REM ============================================================

echo Rebuilding 10.csv ...
copy /b "10.csv.part001"+"10.csv.part002" "10.csv"

echo Rebuilding 10.txt ...
copy /b "10.txt.part001"+"10.txt.part002"+"10.txt.part003" "10.txt"

echo.
echo Done. Expected MD5 checksums:
echo   10.csv  f7e90cecf30299e364275d9ea56080a7
echo   10.txt  e6e0e27cd60fe61f70e02d9b6c4cc774
echo (verify with: certutil -hashfile 10.csv MD5)
