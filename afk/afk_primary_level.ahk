;#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
;SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

;씩씩이 1000
is_fullauto := false
fire_delay := 1200

Adjust() {
;   dx := 27.00
;   dy := 0
;   DllCall("mouse_event", "UInt", 0/x01, "UInt", 0 + dx, "UInt", 0 + dy) 
;   에러코드 Plum 유발하는듯
}

BypassAFK() {
	Send, {s Down}
	Sleep, 100
	Send, {s Up}
}

Numpad1::
F8::
loop {
	loop, 15 {
		if (is_fullauto) {
			Click, up
			Sleep, 100
			Click, down
			Sleep, 10000
		} else {
			loop, 10 {
				Click
				Sleep, % (fire_delay)
			}
		}
		BypassAFK()
	}
	; Send, b22
	Continue
}

Numpad2::
F9::
Click, up
Send, {s Up}
Reload