@echo off
:: ----------------------------------------------------------------------------
:: Batch file to create a x64 build package (ZIP) of the D3D9Client
::
:: Notes:
:: - you need to have 7-Zip installed (you might however still need to adjust
::   the ZIP_CMD setting below to make it work)
::
:: - The generated ZIP file name contains the hashtag number in square-brackets.
::   If that number ends with an 'M' (like e.g. 35884M), it means that it
::   was build containing local modifications!
::   This should *not* be a officially released version!
::
:: ----------------------------------------------------------------------------
setlocal

:: --- Setup
set BASE_DIR=..\..
set OUT_DIR=_release
set "VERSION=30.7"


:: Check if SDK and other needed resources are present
for %%a in ("%BASE_DIR%\Orbitersdk\lib\orbiter.lib" ^
            "%BASE_DIR%\Orbitersdk\VS2015\PropertyPages\orbiter.props") ^
do if not exist %%a (
  echo ======================================================================
  echo   Getting Orbiter SDK libs ^& headers^.^.^.
  echo ======================================================================
  REM @todo: make this git!
  goto exit_nok
  REM pushd .
  REM call get_orbiter_libs.bat
  REM if errorlevel 1 goto exit_nok
  REM popd
)


:: Enhance Version by Orbiter Version
echo ======================================================================
echo   Getting Version information
echo ======================================================================
echo   ^.^.^.

:: --- Update working copy & get revision number
REM svn update --quiet -rHEAD %BASE_DIR%
for /F "tokens=*" %%i IN ('git rev-parse --short HEAD') DO set REVISION=%%i
set ZIP_NAME=D3D9Client%VERSION%[%REVISION%]-forOrbiter-x64


if "%VS141COMNTOOLS%"=="" if "%VS142COMNTOOLS%"=="" call helper_vswhere.bat

:: Visual Studio 2019
if not "%VS142COMNTOOLS%"=="" (
  set "SETVCVARS=%VS142COMNTOOLS%..\..\VC\Auxiliary\Build\vcvarsall.bat"
  set SOLUTIONFILE=D3D9ClientVS2019.sln
  set CAM_SOLUTIONFILE=GenericCamera.sln
  set EXTMFD_SOLUTIONFILE=DX9ExtMFD.sln
  set GCAPI_PROJECTFILE=gcAPI.vs201x.vcxproj
  set BUILD_FLAG=-m
  goto assign
)
:: Visual Studio 2017
if not "%VS141COMNTOOLS%"=="" (
  set "SETVCVARS=%VS141COMNTOOLS%..\..\VC\Auxiliary\Build\vcvarsall.bat"
  set SOLUTIONFILE=D3D9ClientVS2017.sln
  set CAM_SOLUTIONFILE=GenericCamera.sln
  set EXTMFD_SOLUTIONFILE=DX9ExtMFD.sln
  set GCAPI_PROJECTFILE=gcAPI.vs201x.vcxproj
  set BUILD_FLAG=/p:XPDeprecationWarning=false /m
  goto assign
)
:: Visual Studio 2015
if not "%VS140COMNTOOLS%"=="" (
  set "SETVCVARS=%VS140COMNTOOLS%..\..\VC\vcvarsall.bat"
  set SOLUTIONFILE=D3D9ClientVS2015.sln
  set CAM_SOLUTIONFILE=GenericCamera.sln
  set EXTMFD_SOLUTIONFILE=DX9ExtMFD.sln
  set GCAPI_PROJECTFILE=gcAPI.vs201x.vcxproj
  goto assign
)

:assign
set VC=msbuild.exe
set BUILD_FLAG=%BUILD_FLAG% /t:build /v:minimal /nologo
set SOLUTIONFILE="%BASE_DIR%\Orbitersdk\D3D9Client\%SOLUTIONFILE%"
set CONFIG=/p:Configuration=Release /p:Platform=x64
set CONFIG_DBG=/p:Configuration=Debug /p:Platform=x64
set ZIP_CMD="C:\Program Files\7-Zip\7z.exe"


:: --- Create folder structure
if exist "%OUT_DIR%" (
  rmdir /S /Q "%OUT_DIR%"
)
mkdir "%OUT_DIR%"


:: --- Start build environment
:: Prevent vcvarsall.bat of Visual Studio 2017 from changing the current working directory
set "VSCMD_START_DIR=%CD%"
call "%SETVCVARS%" x64
if errorlevel 1 goto exit_nok
echo.


:: D3D9Client (RELEASE)
echo ======================================================================
echo   Building D3D9Client
echo ======================================================================

call %VC% %BUILD_FLAG% %SOLUTIONFILE% %CONFIG%
if errorlevel 1 goto exit_nok

:: gcAPI_dbg.lib (DEBUG)
:: if not exist "%BASE_DIR%\Orbitersdk\lib\gcAPI_dbg.lib" (
::   echo ======================================================================
::   echo   Building gcAPI_dbg^.lib ^(DEBUG version of gcAPI.lib^)
::   echo ======================================================================
::   call %VC% "%BASE_DIR%\Orbitersdk\D3D9Client\gcAPI\%GCAPI_PROJECTFILE%" ^
::        %BUILD_FLAG% %CONFIG_DBG%
::   if errorlevel 1 goto exit_nok
:: )

:: gcAPI.lib (RELEASE)
:: call %VC% "%BASE_DIR%\Orbitersdk\D3D9Client\gcAPI\%GCAPI_PROJECTFILE%" ^
::           %BUILD_FLAG% %CONFIG%
:: if errorlevel 1 goto exit_nok

:: GenericCamera (RELEASE)
REM if not "%CAM_SOLUTIONFILE%"=="" (
REM   echo.
REM   echo.
REM   echo ======================================================================
REM   echo   Building GenericCamera MFD
REM   echo ======================================================================
REM   call %VC% "%BASE_DIR%\Orbitersdk\samples\GenericCamera\%CAM_SOLUTIONFILE%" ^
REM             %BUILD_FLAG% %CONFIG%
REM   if errorlevel 1 goto exit_nok
REM )

:: DX9ExtMFD (RELEASE)
REM if not "%EXTMFD_SOLUTIONFILE%"=="" (
REM   echo.
REM   echo.
REM   echo.======================================================================
REM   echo   Building DX9ExtMFD
REM   echo ======================================================================
REM   call %VC% "%BASE_DIR%\Orbitersdk\samples\DX9ExtMFD\%EXTMFD_SOLUTIONFILE%" ^
REM             %BUILD_FLAG% %CONFIG%
REM   if errorlevel 1 goto exit_nok
REM )


echo.
echo.
echo ======================================================================
echo   Creating ZIP files
echo ======================================================================

:: --- Export
set ABS_PATH=%cd%
pushd ..\..
git archive HEAD Config        | %ZIP_CMD% x -bso0 -y -si -ttar -o"%ABS_PATH%\%OUT_DIR%"
git archive HEAD Doc           | %ZIP_CMD% x -bso0 -y -si -ttar -o"%ABS_PATH%\%OUT_DIR%"
git archive HEAD Meshes        | %ZIP_CMD% x -bso0 -y -si -ttar -o"%ABS_PATH%\%OUT_DIR%"
git archive HEAD Modules       | %ZIP_CMD% x -bso0 -y -si -ttar -o"%ABS_PATH%\%OUT_DIR%"
git archive HEAD Orbitersdk    | %ZIP_CMD% x -bso0 -y -si -ttar -o"%ABS_PATH%\%OUT_DIR%"
git archive HEAD Textures      | %ZIP_CMD% x -bso0 -y -si -ttar -o"%ABS_PATH%\%OUT_DIR%"
git archive HEAD Utils         | %ZIP_CMD% x -bso0 -y -si -ttar -o"%ABS_PATH%\%OUT_DIR%"
git archive HEAD D3D9Client.cfg| %ZIP_CMD% x -bso0 -y -si -ttar -o"%ABS_PATH%\%OUT_DIR%"
del "%ABS_PATH%\%OUT_DIR%\pax_global_header"
popd

:: --- Remove some files we don't need to have in the source-package
del "%OUT_DIR%\Orbitersdk\D3D9Client\doc\images\*.psd"


:: --- Copy the DLLs
if not exist "%OUT_DIR%\Modules\Plugin" mkdir "%OUT_DIR%\Modules\Plugin"
if not exist "%OUT_DIR%\Orbitersdk\lib" mkdir "%OUT_DIR%\Orbitersdk\lib"
copy /y %BASE_DIR%\Modules\Plugin\D3D9Client.dll ^
         %OUT_DIR%\Modules\Plugin\D3D9Client.dll > nul
copy /y %BASE_DIR%\Orbitersdk\lib\gcAPI.lib ^
         %OUT_DIR%\Orbitersdk\lib\gcAPI.lib > nul
:: copy /y %BASE_DIR%\Orbitersdk\lib\gcAPI_dbg.lib ^
::          %OUT_DIR%\Orbitersdk\lib\gcAPI_dbg.lib > nul
copy /y %BASE_DIR%\Modules\Plugin\GenericCamera.dll ^
         %OUT_DIR%\Modules\Plugin\GenericCamera.dll > nul
copy /y %BASE_DIR%\Modules\Plugin\DX9ExtMFD.dll ^
         %OUT_DIR%\Modules\Plugin\DX9ExtMFD.dll > nul


:: --- Packing
pushd %OUT_DIR%
%ZIP_CMD% a -tzip -mx9 "..\%ZIP_NAME%+src.zip" *

rmdir /S /Q "Orbitersdk\D3D9Client"
rmdir /S /Q "Utils"
%ZIP_CMD% a -tzip -mx9 "..\%ZIP_NAME%.zip" *
popd

:: --- Publishing
::ftp_helper.bat is supposed to contain folowing imformation if used
::set SERVER=
::set USER=
::set TGTPATH=
if not exist ftp_helper.bat goto exit_ok
echo --------------------------
set /p GOBUILD=Publish a Build [Y/N] ? 
if %GOBUILD%==N goto exit_ok
if %GOBUILD%==n goto exit_ok
call ftp_helper.bat
set /p STA=Stable or Beta [S/B] ? 
set TYPE=beta
if %STA%==S set TYPE=stable
if %STA%==s set TYPE=stable
echo --------------------------
set /p PASS=Password: 
echo user %USER% %PASS%>ftp.tmp
echo cd %TGTPATH%>>ftp.tmp
echo get index.html html.tmp>>ftp.tmp
echo bye>>ftp.tmp
ftp -n -i -s:ftp.tmp %SERVER%
call ModHTML.exe html.tmp "%ZIP_NAME%(r%REVISION%).zip" BETA %TYPE%
echo --------------------------
echo user %USER% %PASS%>ftp.tmp
echo cd %TGTPATH%>>ftp.tmp
echo send html.tmp index.html>>ftp.tmp
echo binary>>ftp.tmp
echo send "%ZIP_NAME%(r%REVISION%).zip">>ftp.tmp
echo bye>>ftp.tmp
ftp -n -i -s:ftp.tmp %SERVER%
del ftp.tmp
del html.tmp
pause

:: --- Pass / Fail exit
:exit_ok
cd %ABS_PATH%
call :cleanup
exit /B 0

:exit_nok
echo.
echo Build failed!
call :cleanup
exit /B 1


:: --- Cleanup
:cleanup
rmdir /S /Q "%OUT_DIR%"
endlocal
