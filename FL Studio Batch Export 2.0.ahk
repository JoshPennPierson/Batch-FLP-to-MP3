; This script utilizes the command line exporting options that FL Studio provides (https://www.image-line.com/support/flstudio_online_manual/html/fformats_save_export.htm)

global appFileName
global progressBar
global exportData
global abortAll
global destination = True
global minimizedFL = False
global minimizedFLPopup = False
global totalFileCount = 0
global currentFileCount = 0
global percent = 0
CreateGui1()
Return  ; Stop from running anything below here when first running the script


GuiClose:
	ExitApp

DestinationFolder:
	Gui, Submit, NoHide
	If (Radio1){
		destination = True
	}
	Else If (Radio2){
		destination = False
	}
	Return

StartExport:
	Gui, Submit, NoHide  ; Submit the states of the GUI boxes
	If (mp3 or wav or ogg or flac or midi) {
		Export(mp3, wav, ogg, flac, midi, destination, minimizedFL, minimizedFLPopup)
	}
	Else {
		msgbox Select at least one export type
	}
	
GuiClose()
{
	ExitApp
}
	
CreateGui1()
{
	Gui, Add, Text, x8 y8, Select Export Types
	Gui, Add, Checkbox, vmp3, mp3
	Gui, Add, Checkbox, vwav, wav
	Gui, Add, Checkbox, vogg, ogg
	Gui, Add, Checkbox, vflac, flac
	Gui, Add, Checkbox, vmidi, midi
	Gui, Add, Text
	Gui, Add, Text, x130 y8, Additional Options
	Gui, Add, Radio, Checked gDestinationFolder vRadio1, Export to destination folder
	Gui, Add, Radio, gDestinationFolder vRadio2, Export to project folders
	Gui, Add, Text
	Gui, Add, Checkbox, vminimizedFL, Minimize FL Studio when possible
	Gui, Add, Checkbox, vminimizedFLPopup, Minimize Fl Studio render popup
	Gui, Add, Text, x20,  WARNING: Make sure to remove any files in the destination`rfolder with the same name as the FL Studio Project files or`rthey will be overwritten and cannot be recovered.
	Gui, Add, Text, x20,  NOTE: Close FL Studio before starting batch export.
	Gui, Add, button, gStartExport w200 h50, Start Exporting

	Gui, Show, AutoSize, FL Studio Batch Export 2.0
	Return
}

CreateGui2()
{
	Gui, Destroy
	Gui Add, Progress, vprogressBar w350 h25 Border, 0
	;Progress, Song 1 of %fileCount%, FL Studio Batch Export 2.0 ; Initialize progress bar in upper left
	Gui Add, Text, vexportData, Exporting song %currentFileCount% of %totalFileCount%
	Gui, Add, button, gAbortAll vabortAll, Abort all remaining songs
	Gui, Show, AutoSize, FL Studio Batch Export 2.0
}

CreateGui3(thisText)
{
	Gui, Destroy
	Gui Add, Text,, %thisText%
	Gui, Add, button, gGuiClose, Close
	Gui, Show, AutoSize, FL Studio Batch Export 2.0
}

AssocQueryApp(Ext)
{
	; This script finds the file path of the executable associated with a given file extension
	; Script source: https://autohotkey.com/board/topic/54927-regread-associated-program-for-a-file-extension/
	RegRead, type, HKCU, Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\.%Ext%, Application
	If !ErrorLevel { ;Current user has overridden default setting
		RegRead, act, HKCU, Software\Classes\Applications\%type%\shell
		If ErrorLevel
			act = open
		RegRead, cmd, HKCU, Software\Classes\Applications\%type%\shell\%act%\command
		}
	Else {           ;Default setting
		RegRead, type, HKCR, .%Ext%
		RegRead, act , HKCR, %type%\shell
		If ErrorLevel
			act = open
	RegRead, cmd , HKCR, %type%\shell\%act%\command
	}
	Return cmd
}

AbortAll() {
	Process, Close, %appFileName%
	thisText = Export has been aborted.`n%currentFileCount% of %totalFileCount% songs were exported.
	CreateGui3(thisText)
	Return
}

Export(mp3, wav, ogg, flac, midi, destination, minimizedFL, minimizedFLPopup)
{
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	;; Figure out folder path for the FL Studio Exe ;;
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


	;;;;; Find the app file path ;;;;;
	rawAppFilePath := AssocQueryApp("flp")

	;;;;; Extract the file path ;;;;;

	charCount = 0  ; Initialize counter variable
	quoteCount = 0  ; Initialize counter variable
	Loop, Parse, rawAppFilePath
	{
		charCount += 1
		If (A_LoopField == """")  ; Looks to see if the character is a double quote mark
			quoteCount += 1
		If (quoteCount == 2)  ; Only measure number of characters between (and including) first set of double quotes
			Break
	}
	appFilePath := SubStr(rawAppFilePath, 1, charCount)  ; Grab all characters between (and including) first set of double quotes


	;;;;; Extract the folder path and the file name ;;;;;

	lastBackslashPos = 1
	posCounter = 1
	Loop, Parse, appFilePath
	{
		If (A_LoopField == "\")   ; Find the last backslash
			lastBackslashPos := posCounter
		posCounter += 1
	}
	appFolderPath := SubStr(appFilePath, 1, lastBackslashPos-1)""""  ; Append a double quote to the end
	appFileName := SubStr(appFilePath, lastBackslashPos+1, StrLen(appFilePath)-lastBackslashPos-1)  ; Remove double quote at the end


	;;;;;;;;;;;;;;;;;;;;;;;;;;
	;; Select source folder ;;
	;;;;;;;;;;;;;;;;;;;;;;;;;;
	
	FileSelectFolder, sourceDirectory, , 0, Select directory containing FLP files (the script will export FLP files in the directory and subdirectories).
	If sourceDirectory =
		Exit
	
	
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	;; Select destination folder ;;
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	
	destinationDirectory =
	If (destination == True)
	{
		FileSelectFolder, destinationDirectory, , 0, Select directory to export files to.
		If destinationDirectory =
			Exit
	}
	
	
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	;; Build command line script ;;
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	
	exportTypeList = 
	If (mp3)
		exportTypeList = mp3
	If (wav)
		If (exportTypeList == "")
			exportTypeList = wav
		Else
			exportTypeList = %exportTypeList%,wav
	If (ogg)
		If (exportTypeList == "")
			exportTypeList = ogg
		Else
			exportTypeList = %exportTypeList%,ogg
	If (flac)
		If (exportTypeList == "")
			exportTypeList = flac
		Else
			exportTypeList = %exportTypeList%,flac
	If (midi)
		If (exportTypeList == "")
			exportTypeList = mid
		Else
			exportTypeList = %exportTypeList%,mid
	
	script = %appFileName% /R /E%exportTypeList% /F"%sourceDirectory%"
	if (destination == True)
		script = %script% /O"%destinationDirectory%"
	script = %script%`n
	
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	;; Run command line script ;;
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	
	DetectHiddenWindows, On
	run, %comspec% /K cd /d %appFolderPath% && %script% ,, Hide
	WinWait, %comspec%,, 2  ; Wait for the command prompt to open
	WinWait, ahk_exe %appFileName%,, 2  ; Wait for FL Studio to open
	If ErrorLevel {
		msgbox, Error launching FL Studio:`n%appFolderPath%`n%script%
	}
	ControlSend,, exit`n, %comspec%  ; Close the command prompt
	
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	;; Calculate how many songs there are to export ;;
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	
	Loop Files, %sourceDirectory%\*.flp, R ; Recurse into sub-folders
	{
		totalFileCount += 1
	}
	
	CreateGui2()

	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	;; Keep track of song count and minimize FL ;;
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	
	SetTitleMatchMode, 2 ; Partially match with window title name
	
	Loop %totalFileCount%
	{
	; Minimize FL if needed
	If (minimizedFL)
		IfWinExist ahk_class TFruityLoopsMainForm
			WinMinimize
	
	; Wait for the rendering popup to show
	WinWait, Rendering to
	
	; Minimize FL if needed
	If (minimizedFL)
		IfWinExist ahk_class TFruityLoopsMainForm
			WinMinimize
	; Minimize FL render popup if needed
	if (minimizedFLPopup)
		IfWinExist ahk_class TWAVRenderForm
			WinMinimize
	
	; Update GUI
	currentFileCount += 1
	percent := (currentFileCount / totalFileCount)*100
	GuiControl,, progressBar, %percent%
	GuiControl,, exportData, Exporting song %currentFileCount% of %totalFileCount%

	; Wait for the rendering popup to go away
	WinWaitClose, Rendering to
	}
	

	
	CreateGui3("All files have finished exporting.")
	
	Return
}