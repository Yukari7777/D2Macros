air_move_key := FileRead(Format("{1}\..\config\air_move.txt", A_ScriptDir))

Click
Sleep 50
Send "{Space Down}"
Send air_move_key
Send "{Space Up}"
Send 2