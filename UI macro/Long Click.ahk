#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

Adjust() {
;   dx := 27.00
;   dy := 0
;   DllCall("mouse_event", "UInt", 0/x01, "UInt", 0 + dx, "UInt", 0 + dy) 
;   에러코드 Plum 유발하는듯
}

Capslock::
F8::
loop,
{
	Click, Down
	Sleep, 1500
	Click, Up
	Sleep, 300
	Continue
return
}

Numpad2::
F9::
Reload