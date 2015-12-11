@echo off
setlocal enableextensions enabledelayedexpansion
REM - MAIN START //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
REM - /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
call:intro
call:initUser
call:initAuto
call:checkConfigs
call:process
call:destroy
exit /b
REM - MAIN END //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
REM - ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


REM ==========================================================================================================================================	
:initUser
	REM Set the name of the configurations file.
	set config_filename=configs.txt
	REM Read all the required information from the configurations file.
	call:readConfigurationFile
exit /b

REM ==========================================================================================================================================	
:copyIcons
	echo:
	echo ==================
	echo   Copying Icons
	echo ==================

	REM Use only "copyAndRenameTo" function to simplify copy to destination and correct function at "checkConfigs".
	set actuallyCopied=0
	
	REM Next we will read the list of copyAndRenameTo calls with arguments.
	if defined _Copy_Param_List_ (
		call:parser_iter "!_Copy_Param_List_!"
	)
	
	REM If these numbers are different, there is a problem during copy.
	echo:
	echo Total files to be copied   : !_Call_Copy_Counter_!
	echo Total files actually copied: %actuallyCopied%
exit /b 0

REM - /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
REM - /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
REM - ADVANCED MODIFICATIONS: From here you don't need to configure anything only if you want a different behaviour. Edit at your own risk.
REM - /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
REM - /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

REM - ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
:initAuto
	REM You can change here how the input file name is constructed (not recommended).
	set input_FileName=%input_Name%.%input_Extension%
	REM You can change here what output extension you need the files to be converted (default png).
	REM Available Extensions: alias, arcib, biorad, bmp, cin, cvs, dcx, dds, degas, dkb, dpx, emf, fits, gif, gpat, grob, hru, ico, iff, jif, jpeg, jpg, jxr, kro, miff, mtv, ngg, nlm, nol, otb, pabx, palm, pbm, pcl, pcx, pdf, pgm, png, pnm, ppm, prc, ps, psd, psion3, psion5, grt, rad, raw, rawe, ray, rla, sct, soft, tdi, tga, ti, tiff, uyvy, uyvyi, vista, vivid, wbmp, wrl, xbm, xpm. 
	set output_Ext=png
	
	REM You can decide if just want to make icons leaving them in this folder,
	REM copy to destination and/or delete icons from this folder.
	if "%makeIcons%"=="" ( 
		set makeIcons=1
	)
	if "%copyIcons%"=="" ( 
		set copyIcons=1
	)
	if "%deleteIcons%"=="" ( 
		set deleteIcons=1
	)
exit /b

REM ==========================================================================================================================================	
:intro
	color 1F
	echo:
	echo **********************
	echo *** MakeIcons v3.1 ***
	echo **********************
	echo:
exit /b 0

REM ==========================================================================================================================================	
:process
	if ERRORLEVEL 1 (
		echo:
		call:errorMessage
		echo Something went wrong. Operation Aborted.
		echo:
		exit /b
	) else (
	
		if "%makeIcons%"=="1" (
			call:makeIcons
		)
		if %copyIcons%==1 (
			call:copyIcons
		)
		if %deleteIcons%==1 (
			call:deleteIcons
		)
	)
	pause
exit /b

REM ==========================================================================================================================================	
:makeIcons
	echo:
	echo ==================
	echo   Creating Icons
	echo ==================
	set	createdFilesCount=0
	
	REM === Square Icons ===
	for %%r in (%square_list%) do (	
		call:nconvert square %%r
		set /a createdFilesCount=!createdFilesCount!+1
	)
	REM === Rectangle Icons ===
	for %%l in (%rectangle_list%) do (
		for /f "tokens=1,2 delims=x" %%a in ("%%l") do (
			call:nconvert rectangle %%a %%b
			set /a createdFilesCount=!createdFilesCount!+1
		)
	)
	echo:
	echo Total files created: !createdFilesCount!
exit /b 0

REM ==========================================================================================================================================	
:deleteIcons
	echo:
	echo ==================
	echo   Deleting Icons
	echo ==================
	set	deletedFilesCount=0
	REM === Square Icons ===
	
	for %%r in (%square_list%) do (		
		call:deleteFromHere %%r
		set /a deletedFilesCount=!deletedFilesCount!+1
	)
	REM === Rectangle Icons ===
	for %%l in (%rectangle_list%) do (
		for /f "tokens=1,2 delims=x" %%a in ("%%l") do (
			call:deleteFromHere %%ax%%b
			set /a deletedFilesCount=!deletedFilesCount!+1
		)
	)
	echo:
	echo Total files deleted: !deletedFilesCount!
exit /b 0

REM ==========================================================================================================================================	
:nconvert
	rem call:nconvert square size
	if %1==square (
		call nconvert.exe -o %2 -out %output_Ext% -overwrite -ratio -resize %2 0 %input_FileName%>>NUL
	)
	rem call:nconvert rectangle width height
	if %1==rectangle (
		call nconvert.exe -o %2x%3 -out %output_Ext% -overwrite -resize %2 %3 %input_FileName%>>NUL
	)
exit /b 0

REM ==========================================================================================================================================	
:copyAndRenameTo
	set filename=%1.%output_Ext%
	set destination=%2\%3.%output_Ext%
	if exist "%filename%" (
		copy /Y "%filename%" "%destination%">>NUL
		set /a actuallyCopied=!actuallyCopied!+1
		echo %filename% copied to: %destination%
	) else ( 
		echo File "%filename%" does not exist, unable to copy. Make sure it is in square or rectangle lists to be created.
	)
exit /b 0

REM ==========================================================================================================================================	
:deleteFromHere
	set filename=%1.%output_Ext%
	if exist "%filename%" (
		del /Q %filename%
		echo %filename% deleted.
	) else ( 
		echo File "%filename%" does not exist, unable to delete.
	)
exit /b 0

REM ==========================================================================================================================================	
:checkConfigs
	REM If there is an error from a previous subroutine, pass to the next without doing anything, until error handle catches.
	if ERRORLEVEL 1 exit /b
	
	REM Error section---------------------------------------------------------------------------------------------------
	REM Things here whill check configurationsand will cause the program to stop if something is wrong.
	if not defined input_Name set exit /b 1
	if not defined input_Extension exit /b 2
	if not defined input_FileName set exit /b 3
	if not defined output_Ext exit /b 4
	if not exist "%input_FileName%" exit /b 5
	if not defined makeIcons exit /b 6
	if not defined copyIcons exit /b 7
	if not defined deleteIcons exit /b 8

	set needList=0
	if defined makeIcons if %makeIcons%==1 set needList=1
	if defined deleteIcons if %deleteIcons%==1 set needList=1
	
	
	
	if %needList%==1 (
		if not defined icon_size_list ( exit /b 9 )
		for %%r in (%icon_size_list%) do (
			call:CheckValueAndAddToList %%r
			if errorlevel 1 ( exit /b !errorlevel! )
		)
		
		
		
		if not defined square_list (
			if not defined rectangle_list (
				exit /b 9
			)
		)
	)
	
	if defined square_list (
		REM === Square Icons ===
		for %%r in (%square_list%) do (
			call:isPositiveValidNumber %%r
			if errorlevel 1 ( 
				set _error_value_=%%r
				exit /b 107 
			)
		)
	)
	if defined rectangle_list (
		REM === Rectangle Icons ===
		for %%l in (%rectangle_list%) do (
			for /f "tokens=1,2 delims=x" %%a in ("%%l") do (
				call:isPositiveValidNumber %%a
				if errorlevel 1 ( 
					set _error_value_=%%a 
					set _error_value_2_=%%l
					exit /b 106 
				)
				call:isPositiveValidNumber %%b
				if errorlevel 1 ( 
					set _error_value_=%%b
					set _error_value_2_=%%l
					exit /b 106 
				)
			)
		)
	)
	
	
	
	REM Warnings section---------------------------------------------------------------------------------------------------
	REM Things here will not cause the program to stop but will give a message to inform of abnormalities.
	if defined copyIcons if %copyIcons%==1 (
		if !_Call_Copy_Counter_!==0 echo WARNING: It will be impossible to copy icons because function "copyAndRenameTo" is never used.
	)

exit /b 0

REM ==========================================================================================================================================	
:errorMessage
if errorlevel 110 ( echo ERROR: Cannot use "!_error_value_!" as value in icon size list, it should be positive number.
) else (
	if errorlevel 109 ( echo ERROR: Cannot use "!_error_value_!" in "!_error_value_2_!" as value in icon size list, it should be a combination of two positive numbers separated with a "x", example "100x120".
	) else (
		if errorlevel 108 ( echo ERROR: Cannot use !_error_value_2_! as value for icon size list, should be positive number or a combination of two positive numbers separated with a "x", example "100x120". 
		) else (
			if errorlevel 107 ( echo ERROR: Cannot use "!_error_value_!" as value in square list, should be positive number.
			) else (
				if errorlevel 106 ( echo ERROR: Cannot use "!_error_value_!" in "!_error_value_2_!" as value in rectangle list, should be a combination of two positive numbers separated with a "x", example "100x120".
				) else (
					if errorlevel 105 ( echo ERROR: Cannot use !copyParam1! as value for copy, should be positive number or a combination of two positive numbers separated with a "x", example "100x120". 
					) else (
						if errorlevel 104 ( echo ERROR: Cannot use !copyParam1_2! as value for copy, should be positive number.
						) else (
							if errorlevel 103 ( echo ERROR: Cannot use !copyParam1_1! as value for copy, should be positive number.
							) else (
								if errorlevel 102 ( echo ERROR: One parameter for rectangular list is not correctly defined.
								) else (
									if errorlevel 101 ( echo ERROR: One copy parameter from %config_filename% is missing.
									) else (
										if errorlevel 100 ( echo ERROR: There are !_Invalid_Line_Counter_! invalid lines in %config_filename%.
										) else (
											if errorlevel 9 ( echo ERROR: To make or delete icons you need to define at least one element in any of the lists.
											) else (
												if errorlevel 8 ( echo ERROR: "deleteIcons" was not defined. 
												) else (
													if errorlevel 7 ( echo ERROR: "copyIcons" was not defined.
													) else (
														if errorlevel 6 ( echo ERROR: "makeIcons" was not defined.
														) else (
															if errorlevel 5 ( echo ERROR: "%input_FileName%" file doesn't exist in this folder.
															) else (
																if errorlevel 4 ( echo ERROR: "output_Ext" was not defined.
																) else (
																	if errorlevel 3 ( echo ERROR: "input_FileName" was not defined.
																	) else (
																		if errorlevel 2 ( echo ERROR: You need to define a input file extension. 
																		)  else (
																			if errorlevel 1  ( echo ERROR: You need to define a input file name. 
																			) else (
																			 echo MISTERIO: Como llegaste aqui?
																			)	
																		)
																	)
																)
															)
														)
													)
												)
											)
										)
									)
								)
							)
						)
					)
				)
			)
		)
	)
)

exit /b

REM ==========================================================================================================================================	
:destroy
	color
exit /b

REM ==========================================================================================================================================	
:readConfigurationFile
	REM This subroutine will read the configurations and test if values are correct, in any case there is an incorrect value, the program will abort.
	echo ==================
	echo   Reading Configuration File "%config_filename%"
	echo ==================
	set _Invalid_Line_Counter_=0
	set _Line_Counter_=0
	set _Line_Counter_Echo_=0

	REM We will proceed to check if the config file contains invalid lines. (tha does not start with "#", "set" or "copy")
	for /f "tokens=1" %%a in (%config_filename%) do (
		set test_set=0
		set test_copy=0
		set test_gato=0
		set /a _Line_Counter_=!_Line_Counter_!+1
		echo %%a | findstr /I "^set">nul
		if not errorlevel 1 (
			set test_set=1
		)
		echo %%a | findstr /I "^copy">nul
		if not errorlevel 1 (
			set test_copy=1
		)
		echo %%a | findstr /I "^#">nul
			if not errorlevel 1 (
			set test_gato=1
		)
		if "!test_set!"=="0" (
			if "!test_copy!"=="0" (
				if "!test_gato!"=="0" (
					set /a _Invalid_Line_Counter_=!_Invalid_Line_Counter_!+1
				)
			)
		)
	)
	
	call:resetErrorlevel
	
	if not "!_Invalid_Line_Counter_!"=="0" (
		echo: 
		echo There are !_Invalid_Line_Counter_! invalid lines in %config_filename%.
		echo:
		exit /b 100
	)
	
	call:resetErrorlevel

	for /f "tokens=1,*" %%a in (%config_filename%) do (
		REM Test if the first word is "set", with /I not case sensitive.
		echo %%a | findstr /I "^set">nul
		REM If there is no error, then proceed testing the variable and value name.
		if not errorlevel 1 (
			REM First we look for a equal symbol.
			echo %%b | findstr /I "=">nul
			REM If there is no error, then proceed setting the variable and value name.
			if not errorlevel 1 (
				REM FOR cycle can take apart this values with "=" delimiter.
				for /f "tokens=1,2 delims==" %%p in ("%%b") do (
					set %%p=%%q
					echo Variable [%%p] Valor [!%%p!]
				)
			)
		)
	)
	
	call:resetErrorlevel

	set _Copy_Param_List_=
	set _Call_Copy_Counter_=0
	for /f "tokens=1-4" %%a in (%config_filename%) do (
		REM Test if the first word is "copy", with /I not case sensitive.
		echo %%a | findstr /I "^copy">nul
		REM If there is no error, then proceed testing the parameters.
		if not errorlevel 1 (
			set copyParam1=%%b
			set copyParam2=%%c
			set copyParam3=%%d
			set _copyParam_Not_Def_=
			if not defined copyParam1 set _copyParam_Not_Def_=1
			if not defined copyParam2 set _copyParam_Not_Def_=1
			if not defined copyParam3 set _copyParam_Not_Def_=1
			
			REM If one parameter is not defined, exit with error.
			if defined _copyParam_Not_Def_ exit /b 101
			
			call:isPositiveValidNumber !copyParam1!
			if errorlevel 1 (
				echo !copyParam1! | findstr /I "x">nul
				if not errorlevel 1 (
					for /f "tokens=1,2 delims=x" %%p in ("!copyParam1!") do (
						set copyParam1_1=%%p
						set copyParam1_2=%%q
						
						set _copyParam_Not_Def_2_=
						if not defined copyParam1_1 set _copyParam_Not_Def_2_=1
						if not defined copyParam1_2 set _copyParam_Not_Def_2_=1
						
						REM If one parameter for rectangular list is not defined, exit with error.
						if defined _copyParam_Not_Def_2_ ( exit /b 102 )
						
						call:isPositiveValidNumber !copyParam1_1!
						if errorlevel 1 ( exit /b 103 )
						
						call:isPositiveValidNumber !copyParam1_2!
						if errorlevel 1 ( exit /b 104 )
					)
				) else ( exit /b 105 )
			)
			
			REM At this point we already know the copyParam1 is a valid parameter.
			REM Start Building the param array, separated by ":" symbol.
			set _Copy_Param_List_=!_Copy_Param_List_!!copyParam1! !copyParam2! !copyParam3!:
			set /a _Call_Copy_Counter_=!_Call_Copy_Counter_!+1
		)
	)

exit /b 0

REM ==========================================================================================================================================	
:parser_sub
	call:copyAndRenameTo %1 %2 %3
exit /b

REM ==========================================================================================================================================	
:parser_iter
set list=%1
set list=!list:"=!
	for /f "tokens=1,* delims=:" %%a in ("!list!") do (
		if not "%%a" == "" call :parser_sub %%a
		if not "%%b" == "" call :parser_iter "%%b"
	)
exit /b 
REM ==========================================================================================================================================	
:isPositiveValidNumber
@echo off
	echo %1|findstr /xr "[1-9][0-9]* 0" >nul &&(
	  REM echo %1 is a valid number
	) && (
		if %1 GTR 0 ( 
			REM echo %1 is REALLY a valid number 
		) else ( 
			REM echo %1 is NOT a valid number 
			exit /b 255
		)
	) || (
	  REM echo %1 is NOT a valid number
	)
exit /b

REM ==========================================================================================================================================	
:resetErrorlevel
exit /b 0

REM ==========================================================================================================================================	
:CheckValueAndAddToList
	set sizeToCheck=%1
			call:isPositiveValidNumber !sizeToCheck!
			if errorlevel 1 (
				set _error_value_=!sizeToCheck!
				echo !sizeToCheck! | findstr /I "x">nul
				if not errorlevel 1 (
					set _error_value_2_=!sizeToCheck!
					for /f "tokens=1,2 delims=x" %%p in ("!sizeToCheck!") do (
						set sizeToCheck_1=%%p
						set sizeToCheck_2=%%q
						
						set _sizeToCheck_Not_Def_2_=
						if not defined sizeToCheck_1 set _sizeToCheck_Not_Def_2_=1
						if not defined sizeToCheck_2 set _sizeToCheck_Not_Def_2_=1
						
						REM If one parameter for rectangular list is not defined, exit with error.
						if defined _sizeToCheck_Not_Def_2_ ( exit /b 108 )
						
						call:isPositiveValidNumber !sizeToCheck_1!
						if errorlevel 1 ( 
							set _error_value_=!sizeToCheck_1!
							exit /b 109 
						)
						
						call:isPositiveValidNumber !sizeToCheck_2!
						if errorlevel 1 ( 
							set _error_value_=!sizeToCheck_2!
							exit /b 109 
						)
						
						set rectangle_list=%rectangle_list% !sizeToCheck!
					)
				) else ( exit /b 110 )
			) else ( 
				set square_list=%square_list% !sizeToCheck!
			)
exit /b 

REM ==========================================================================================================================================	
endlocal