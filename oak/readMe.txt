These functions log some properties of Oak to track its performance & failures.
All inputs are optional - you can click-and-run each of the functions.

By default, the functions modify the file projects/sonia/utils/oak/oakLog.txt - you can change this destination via optional input.

To log Oak performance when the server is online:
> checkOak.m: timed performance tests - opening .mat file, opening .nifti file, and checking softlinks via isdir().

To report a failure to connect to the server (a two-step process, since our log lives on the server):
> oakFailure.m: makes a local .mat file logging the connection failure you're currently experiencing.
> reportFailure.m: when the server is back up, adds your recent failure to the oakLog.txt on the server.

The functions additionally log who you are (via initials) and if you're mounting the server (by checking for a '/Volumes/projects') or connected to it directly (by checking for a '/share/kalanit'). You can add an option note, e.g. 'This is the 4th time this morning that the server has gone down.'

