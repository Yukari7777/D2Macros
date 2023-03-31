granade_key := FileRead(Format("{1}\..\config\granade.txt", A_ScriptDir))
ingame_sens := FileRead(Format("{1}\..\config\ingame_sens.txt", A_ScriptDir))

CONSTANT := 230
DELTA := CONSTANT / ingame_sens

Sleep 100
Click
Send granade_key
DllCall("mouse_event", "UInt", 0x01, "UInt", 0, "UInt", DELTA)