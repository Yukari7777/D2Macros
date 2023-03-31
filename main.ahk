InstallDir := RegRead("HKLM\SOFTWARE\AutoHotkey", "InstallDir", "")
AhkPath := InstallDir ? InstallDir "\v2\AutoHotkey.exe" : ""

invoke(dir) {
  Run Format("{1} {2}", AhkPath, dir)
}

F9::Reload
LAlt & CapsLock::invoke("movement/rocket_grapple.ahk")
LAlt & T::invoke("movement/air_move_skating.ahk")
LAlt & Q::invoke("movement/super_skating.ahk")