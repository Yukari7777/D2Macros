#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.


Numpad1::
F8::
loop,
{
	MouseMove, 628, 674
	Sleep, 500
	Click
	MouseMove, 135, 377
	Sleep, 1000
	Click
	MouseMove, 132, 306
	Sleep, 100
	Click
	Sleep, 1000
	Continue
return
}

Numpad2::
F9::
Reload