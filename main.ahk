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

Hotkey Format("!{1}", air_move_key), _ => invoke("movement/skating.ahk", air_move_key, 0)
Hotkey Format("!{1}", super_key), _ => invoke("movement/skating.ahk", super_key, 1)
Hotkey Format("^!{1}", air_move_key), _ => invoke("movement/flat_skating.ahk", air_move_key, 0)
Hotkey Format("^!{1}", super_key), _ => invoke("movement/flat_skating.ahk", super_key, 1)

!CapsLock::invoke("movement/rocket_grapple.ahk", granade_key, ingame_sens)
LAlt & Numpad1::invoke("ui/long_click.ahk")
LAlt & Numpad2::invoke("ui/long_press.ahk")