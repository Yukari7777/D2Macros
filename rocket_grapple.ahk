#SingleInstance, Force

; You need to set this value to the same as the ingame's
ingame_sens := 4 

; This needs to be adjusted for maximize reliability
; The value was induced initally as 268(67 * 4)
; Tested with this rocket: https://d2foundry.gg/w/3489657138?p=3809316345,3796465595,3436462433,598607952,1607056502&m=1588595445&mw=0
; I need to enhance that rocket first though.
CONSTANT := 270 
DELTA := CONSTANT / ingame_sens

CapsLock::
Click
Send, B
DllCall("mouse_event", "UInt", 0x01, "UInt", 0, "UInt", DELTA)

F9::
Reload

F8::
MsgBox, % "DELTA "(DELTA)