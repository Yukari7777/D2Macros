granade_key := A_Args[1]
ingame_sens := A_Args[2]

CONSTANT := 230
DELTA := CONSTANT / ingame_sens

Sleep 100
Click
Send granade_key
DllCall("mouse_event", "UInt", 0x01, "UInt", 0, "UInt", DELTA)