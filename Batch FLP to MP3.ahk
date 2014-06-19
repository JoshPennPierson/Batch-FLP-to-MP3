;calibration
Run, calibration.flp ;Load FL Studio so that we can move the mouse to the correct position
Sleep, 1000 ;(wait 1 seconds)
MouseMove, 0, 0, 5 ;Get the mouse out of the way
Sleep, 1000 ;(wait 1 seconds)
Run, calibration.flp ;Load the calibration file to sample the pixels when the FL dialoge box says 'Project Loaded'
Sleep, 5000 ;(wait 3 seconds)
PixelGetColor, CalA, %WindowX%+20, %WindowY%+65
PixelGetColor, CalB, %WindowX%+21, %WindowY%+65
PixelGetColor, CalC, %WindowX%+22, %WindowY%+65
PixelGetColor, CalD, %WindowX%+23, %WindowY%+65
PixelGetColor, CalE, %WindowX%+24, %WindowY%+65
PixelGetColor, CalF, %WindowX%+25, %WindowY%+65
MouseMove, (A_ScreenWidth // 2), (A_ScreenHeight // 2), 5 ;Move mouse back

;User selects folder containing FLP files
FileSelectFolder, Directory, , 0, Select Folder Containing FLP Files
if Directory =
    Exit

;Creates a file containing the names of all the FLP files in the directory
FileAppend, % list_files(Directory), Directory.txt
count := 0
list_files(Directory)
{
	files =
	Loop %Directory%\*.flp, 0, 1
	{
		files = %files%%A_LoopFileFullPath%`n
	}
	return files
}

Loop
{
	MouseMove, 0, 0, 0 ;Get the mouse out of the way
	;Progress bar (currently not implemented)
	;Progress, %A_Index%, %CurrentSong%, Exporting to MP3..., Batch FLPs to MP3s

	;Get the path for the next FLP file
    FileReadLine, CurrentSong, %A_WorkingDir%/Directory.txt, %A_Index%
	
	;if we reach the end, stop this loop
	IF CurrentSong = %PreviousSong%
		Break
	
	;Open the FLP file with FL Studio
	Run, %CurrentSong%
	Sleep, 2000 ;(wait 2 seconds)
	
	;FL Studio needs to be full screen
	;Wait for project to load (done by detecting the pixels in the FL dialogue box that say 'Project Loaded')
	Loop {
		PixelGetColor, ColorA, %WindowX%+20, %WindowY%+65
		PixelGetColor, ColorB, %WindowX%+21, %WindowY%+65
		PixelGetColor, ColorC, %WindowX%+22, %WindowY%+65
		PixelGetColor, ColorD, %WindowX%+23, %WindowY%+65
		PixelGetColor, ColorE, %WindowX%+24, %WindowY%+65
		PixelGetColor, ColorF, %WindowX%+25, %WindowY%+65
		If ColorA = %CalA%
			If ColorB = %CalB%
				If ColorC = %CalC%
					If ColorD = %CalD%
						If ColorE = %CalE%
							If ColorF = %CalF%
								Break
	}

	;Start Exporting
	Send ^+{r}
	Sleep, 1000 ;(wait 1 seconds)
	Send {ENTER 2}
	Sleep, 1000 ;(wait 1 seconds)
	
	;get the coordinates for the center of the window
	WindowCenterX := WindowWidth/2+WindowX
	WindowCenterY := WindowHeight/2+WindowY
	
	;Get the pixel color in the middle of the screen, and only continue when that pixel changes (when the song is done exporting)
	PixelGetColor, ColorA, %WindowCenterX%, %WindowCenterY%
	;Wait until it is done exporting to continue (done by detecting the pixels in the FL dialogue box)
	Loop {
		PixelGetColor, ColorB, %WindowCenterX%, %WindowCenterY%
		If (ColorA <> ColorB)
			Break
	}
	
	Sleep, 1000 ;(wait 1 seconds)
	PreviousSong = %CurrentSong%
	
}

;Close FL Studio
SetTitleMatchMode 2
WinClose FL Studio

;Delete the directory file
FileDelete, %A_WorkingDir%/Directory.txt

MsgBox, All songs were exported.
Exitapp