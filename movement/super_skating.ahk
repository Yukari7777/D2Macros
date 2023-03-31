super_key := FileRead(Format("{1}\..\config\super.txt", A_ScriptDir))

Send 3
Sleep 500
Click "Right"
Sleep 50
Send "{Space Down}"
Send super_key
Send "{Space Up}"
Send 2