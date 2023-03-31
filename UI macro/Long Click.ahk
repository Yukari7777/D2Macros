#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

duration := 7000

Capslock::
F8::
loop,
{
	Click, Down
	Sleep, duration
	Click, Up
	Sleep, 300
	Continue
return
}

Numpad2::
F9::
Reload