; Todo
; Make the status bar its own GUI so that you can close it.
; Give the script an exit button and have it delete any mp3s that are unfinished.

Gui, Add, Text, w400, This is a script for batch exporting FLP files to MP3.`n`nWritten by Josh Penn-Pierson.`nFind the source files at:
Gui, Add, Link, w400, <a href="https://github.com/BflySamurai/Batch-FLP-to-MP3">https://github.com/BflySamurai/Batch-FLP-to-MP3</a>

Gui, Add, Text, w400, For best use:`n1) In all the FLP file directories, remove any MP3s with the exact same name as the FLP (so that FL Studio does not ask if you want to overwrite duplicate file).`nExample: my_song_name.flp, my_song_name.mp3`n2) Clear our the desired output folder of any duplicates as well (best would just be to output to an empty folder).

Gui, Add, Text, w400, Notes:`n* Script last updated December, 2016.`n* I have only tested this with FL Studio 12 on Windows 10.`n* If you stop the script while it's rendering a song, it will leave behind the MP3 that was last rendering in the file directory for the FLP file.`n* You can minimize and maximize FL Studio (or enable Background Rendering) at any point, but leaving FL Studio maximized seems to make the script not be able to detect when the song is finished rendering (and thus won't move on to the next song).`n* You can manually abort a rendering song in the FL Studio interface and the script will continue to the next song (although the MP3 will still be left behind in the destination folder).`n* You can use your computer while running the script, but be aware that when FL Studio isn't rendering a song, pressing buttons has the possibility of interrupting this script. Also, you will notice that some of the FL Studio dialogue boxes will be popping up over whatever you're working on in between each render.`n* If the script tries to export a file that is the same name as a file that already exists in that directory, you will have to manually select "Yes" or "No" (leaving the file name how it is or changing it) and then press "Save". If you select "Cancel", the script won't be able to take back over since it's waiting for a song to finish rendering before starting another.`n* After the songs start rendering, if at any point a song isn't rendering, that means the script encountered an error (possibly a duplicate file) and you'll need to restart the script.`n

;Gui, Add, Checkbox, Checked vMinimized, Run FL Studio minimized (not running minimized is buggy)
;Gui, Add, Text
;Gui, Add, Checkbox, vOverwrite, Overwrite duplicate files (dangerous)
;Gui, Add, Text
Gui, Add, button, gStartExporting w400 h50, Start exporting FLPs to MP3s
Gui, Add, Text
Gui, Add, button, gStopExporting, Stop and exit

Gui, Show, AutoSize
winSetTitle, ahk_class AutoHotkeyGUI,, FL Studio Batch Export
return


Test:
	GuiControl,, MyProgress, +10
	Return

StartExporting:
	;Gui Destroy
	;Gui, Add, Progress, w280 h30 vMyProgress -Smooth , 0
	;Gui, Add, Button, w280 h20 gTest, Test
	;Gui, Show
	;winSetTitle, ahk_class AutoHotkeyGUI,, FL Studio Batch Export
	
	Export()
	Return

StopExporting:
	MsgBox, If a song is currently exporting, you can find it in its FLP directory (it won't be moved to the output directory with the other MP3s).
	ExitApp


Export()
{

	;User selects folder containing FLP files
	FileSelectFolder, Directory, , 0, Select directory containing FLP files (it will grab all the FLP files in the directory and its subdirectories).
	if Directory =
		Exit

	;User selects folder containing FLP files
	FileSelectFolder, ExportDirectory, , 0, Select directory to save Mp3s.
	if ExportDirectory =
		Exit

	MsgBox, 4, FL Studio Batch Export, Run the FL Studio minimized? (Not running minimized seems to have issues).
	IfMsgBox Yes
		Minimized := true
	else
		Minimized := false
		
	;MsgBox, 4,, Overwrite duplicate MP3s?
	;IfMsgBox Yes
	;	Overwrite := true
	;else
	;	Overwrite := false


	;Gather all the FLP files and store them in a variable
	FileList := Object()
	FileNames := Object()
	FileCount = 0
	Progress, a 0, Scanning files, Searching..., FL Studio Batch Export
	Loop Files, %Directory%\*.flp, R ; Recurse into subfolders
	{
		FileCount += 1 ; Arrays needs index starting at 1
		
		Progress, %a_index%, %a_loopfilename%, Collecting FLP Files..., FL Studio Batch Export
		
		FileList%Filecount% := A_LoopFileFullPath

		StringReplace, FileNameNoExt, A_LoopFileName, % "." . A_LoopFileExt ; Remove the extension
		FileNames%FileCount% := FileNameNoExt

	}
	Progress, Off


	Progress, a m x10 y10, Current Song, Song 0 of %FileCount%, FL Studio Batch Export ; Initialize progress bar in upper left

	Loop %FileCount%
	{
		; Open the FLP file with FL Studio
		File := FileList%A_Index%
		Run, %File%

		ThisTitle := FileNames%A_Index%
		SetTitleMatchMode, 2 ; Partially match the window title name to the file name
		WinWait, %ThisTitle% ; Wait for match
		
		Progress, , %ThisTitle%.mp3, Song %A_Index% of %FileCount%, FL Batch Export
			Percent := (A_Index / FileCount)*100 ; Calculate the percent of songs done
			Progress, %Percent% ; Set the position of the bar

		; Bring up FL Studio's MP3 export dialoge
		ControlSend, , {Control Down}{Shift Down}{r}{Control Up}{Shift Up}, FL Studio
		
		If Minimized
			WinMinimize, FL Studio ; Disable this if you don't want FL Studio to automatically minimize

		SetTitleMatchMode, 3 ; Fully match with window title name "Save As"
		WinWait, Save As	; Could potentially cause trouble with other windows labeled as "Save As"
		ControlSend, , {Enter}, Save As
		
		Sleep 20 ; Wait to see if the "Confirm Save As" box comes up
		SetTitleMatchMode, 3 ; Fully match with window title name "Confirm Save As"
		IF WinExists, Confirm Save As ; There's already a file in the directory with this name, so ask the user what to do
		{
			MsgBox, "1) Select 'Yes' or 'No' to overwrite old file. 2) press 'Cancel' or 'Save' (change the filename if you wish). If you chose 'Cancel', you will need to start the batch exporting over."
		}
		ELSE ; Continue exporting the song
		{
			SetTitleMatchMode, 2 ; Partially match with window title name "Rendering to"
			WinWait, Rendering to
			ControlSend, , {Enter}, Rendering to			
			
			Sleep, 1000 ; Make sure the song starts exporting before checking if it's done

			SetTitleMatchMode, 2 ; Partially match with window title name "<FileName>.flp - FL Studio"
			WinWait, %ThisTitle%.flp - FL Studio
			
			If Minimized
				WinMinimize, FL Studio ; Disable this if you don't want FL Studio to automatically minimize
			
			; Move the file to the chosen export directory
			StringTrimRight, FileMove, File, 4
			FileMove = %FileMove%.mp3
			FileMove, %FileMove%, %ExportDirectory%  ; Move the file without renaming it.
		}
	}


	Progress, Off
	
	;Close FL Studio
	SetTitleMatchMode, 2 ; Partially match with window title name "FL Studio"
	WinClose, FL Studio

	IfWinExist, Confirm ; If it asks you if you want to save changes when exiting FL Studio
		Send, , {Right Down}{Enter}{Right Up}

	Run, %ExportDirectory%

	Sleep, 200
	MsgBox, Finished exporting all FLPs to MP3s.
	ExitApp

}

GuiClose:
	ExitApp