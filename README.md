Batch-FLP-to-MP3
================

This is an AutoHotkey script that allows for the exporting of multiple FLP files in Fl Studio to MP3.

Instructions:

* Make sure that none of your songs have the display project info turned on (F11 opens the project info window, uncheck 'show it on opening' if it is checked).
* If there is already an MP3 file of the project in the FLP project folder, this application will not work past the point of reaching that song.
* If you have AutoHotkey installed, you can just run the .ahk file, otherwise, you'll need to run the .exe file.
* FLP files can be anywhere within the folder that you choose, even many folders down.
* MP3s will be exported to each FLP project's folder.
* <b>It is important that you don't move the mouse when it is up in the corner so that you don't affect the text in the FL Studio dialogue box. You also cannot be doing anything else while exporting, so it would be good to do this while you are away from the computer or sleeping.</b>
* The calibration.flp file will run first to determine the pixels in the dialogue box as they appear on your screen, and then you will be prompted to select a folder.

Bugs:

* I've only tested this at length once. It exported 17 songs in a row and then got stuck at the 18th, but that's still a lot of time saved.
* I also haven't tested it on other computers, so I don't actually know if it will work or not.

Future Features:

* If people want to be able to export to WAV files as well, it would be easy to make an interface where you can choose either MP3, WAV, or both.

I wrote this script to help me export my album [Bringing Down The Fairy Tale](http://bdtft.com). Hopefully it helps you as well :)
