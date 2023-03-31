InstallDir := RegRead("HKLM\SOFTWARE\AutoHotkey", "InstallDir", "")
AhkPath := InstallDir ? InstallDir "\v2\AutoHotkey.exe" : ""

F8::Reload
F12::Run Format("{1} {2}", AhkPath, "test.ahk")