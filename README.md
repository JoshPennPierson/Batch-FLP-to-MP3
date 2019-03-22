Batch-FLP-to-MP3/WAV/OGG/FLAC/MIDI
==================================

I originally wrote this script to save myself time while exporting my album [Bringing Down The Fairy Tale](http://bdtft.com). Hopefully it helps you as well :)

This is an AutoHotkey script that allows for the exporting of multiple FLP files in Fl Studio to MP3/WAV/OGG/FLAC/MIDI. The script utilizes the [use command line to batch export](http://www.image-line.com/support/FLHelp/html/fformats_save_wavmidmp3.htm#commandline_export) that was implemented with FL Studio 12. In addition, this Autohotkey script provides a progress bar to track how many songs have been exported and it allows for the minimizing of FL Studio (whenever it is possible to make FL Studio minimized).

![App Screenshot](https://github.com/JoshPennPierson/Batch-FLP-to-MP3/blob/master/Graphics/FL_Studio_Batch_Export_2.0_2019-03-21_22-28-04.png)

If you have AutoHotkey installed, you can just run the .ahk file, otherwise, you'll need to run the .exe file.

Be aware that if trying to export to MIDI and the project isn't set up properly for MIDI export, you will get an error message within FL Studio and will need to manually click 'OK' to continue.

~~Make sure that none of your songs have the display project info turned on (F11 opens the project info window, uncheck 'show it on opening' if it is checked).~~