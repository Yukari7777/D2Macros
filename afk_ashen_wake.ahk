#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.


Numpad1::
F8::
loop,
{
	Send, b
	Sleep, 100
	Send, {s Down}
    Sleep, 100
    Send, {s Up}
	Sleep, 3800
	Continue
return
}

Numpad2::
F9::
Reload