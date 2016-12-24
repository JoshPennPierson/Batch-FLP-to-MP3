Batch-FLP-to-MP3
================

I wrote this script to help me save time while exporting my album [Bringing Down The Fairy Tale](http://bdtft.com). Hopefully it helps you as well :)

This is an AutoHotkey script that allows for the exporting of multiple FLP files in Fl Studio to MP3.

It's been brought to my attention that with FL Studio 12 it is now possible to [use command line to batch export](http://www.image-line.com/support/FLHelp/html/fformats_save_wavmidmp3.htm#commandline_export). So if you're feeling up to it, I would use that since it provides more options and is way less likely to be buggy, but if you're looking for a simple solution, then hopefully this script provides what you need.

Instructions:

* Make sure that none of your songs have the display project info turned on (F11 opens the project info window, uncheck 'show it on opening' if it is checked).
* If you have AutoHotkey installed, you can just run the .ahk file, otherwise, you'll need to run the .exe file.
* FLP files can be anywhere within the folder that you choose, even many folders down.
* MP3s will be exported to each FLP project's folder and then moved to the selected output folder (so if the script is stopped while an MP3 is rendering, it won't get moved).

Features ideas (these aren't implemented currently):

* If people want to be able to export to WAV files as well, it shouldn't be too difficult to make an interface where you can choose either MP3, WAV (or possibly both).
* Checkbox at the start for running FL Studio minimized.
* Checkbox at the start to automatically overwrite duplicate songs (leaving off just skips that song).