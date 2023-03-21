#SingleInstance, Force

ingame_sens := 4

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