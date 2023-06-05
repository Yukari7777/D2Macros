InstallDir := RegRead("HKLM\SOFTWARE\AutoHotkey", "InstallDir", "")
AhkPath := InstallDir ? InstallDir "\v2\AutoHotkey.exe" : ""

invoke(dir, args*) {
  params := ""
  For v in args {
    params := Format("{1} {2}", params, v)
  }
  Run Format("{1} {2} {3}", AhkPath, dir, params)
}

super_key := FileRead(Format("{1}\config\super.txt", A_ScriptDir))
air_move_key := FileRead(Format("{1}\config\air_move.txt", A_ScriptDir))
granade_key := FileRead(Format("{1}\config\granade.txt", A_ScriptDir))
ingame_sens := FileRead(Format("{1}\config\ingame_sens.txt", A_ScriptDir))

F9::Reload

~LAlt & ~Tab::AltTab
~LAlt & ~Esc::Escape

~LAlt & ~CapsLock::invoke("movement/rocket_grapple.ahk", granade_key, ingame_sens)
~LAlt & ~T::invoke("movement/air_move_skating.ahk", air_move_key)
~LAlt & ~Q::invoke("movement/super_skating.ahk", super_key)
LAlt & Numpad1::invoke("ui/long_click.ahk")
LAlt & Numpad2::invoke("ui/long_press.ahk")