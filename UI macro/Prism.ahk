#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

loop_count := 6
craft_at_once := 3
gear_index := 0 ;0 = helmet, 4 = class armor
screen_loading_mult := 1 ; adjust this if loading is slow.

GLIMMER_COST := 777 + 1000 + 2500 + 3000

; 0 1 2 
; 3 4 5   <<< item position, default is  (9 - craft_at_once)
; 6 7 8
DISMENTLE_INDEX := 9 - craft_at_once

; 1400										270 + 125 * gear_index
; 1500 + Mod(DISMENTLE_INDEX, 3) * 100		270 + (125 * gear_index) + (100 * Floor(DISMENTLE_INDEX / 3) )
; 720 + (100 * gear_index)					870 <<< Witch Queen Campaign

validate() {
	return (loop_count * craft_at_once * GLIMMER_COST <= 250000) and (DISMENTLE_INDEX + craft_at_once <= 9)
}

Numpad1::
F8::
if not (loop_count * craft_at_once * GLIMMER_COST <= 250000 and DISMENTLE_INDEX + craft_at_once <= 9) {
	MsgBox, wrong config
	return
}

MsgBox, % "total craft: "(loop_count * craft_at_once)", glimmer cost: "(loop_count * craft_at_once * GLIMMER_COST)
Send i
Sleep 1000 * (screen_loading_mult)
Loop % (loop_count) {
	Send {Del} ;collection, position to craft
	Sleep 1000 * (screen_loading_mult)
	MouseMove, 900, 400, 0
	Sleep 300
	Click
	Sleep 800 * (screen_loading_mult)
	MouseMove, 430, 830, 0
	Sleep 300
	Click
	Sleep 300
	MouseMove, 1800, 880, 0
	Sleep 300
	Click
	Sleep 500

	MouseMove, 720 + (100 * gear_index), 870, 0
	Sleep 500
	Loop % (craft_at_once) { ;craft blue
		MouseClick, left, , , , 0, D
		Sleep 3100
		MouseClick, left, , , , , U
		Sleep 50
	}

	Send i
	Sleep 1300 * (screen_loading_mult)

	MouseMove, 1400, 270 + (125 * gear_index), 0 ; position item
	Sleep 600
	MouseMove, 1500 + Mod(DISMENTLE_INDEX, 3) * 100, 270 + (125 * gear_index) + (100 * Floor(DISMENTLE_INDEX / 3) ), 0
	Sleep 50

	Loop % (craft_at_once) { 
		Click, Right ; armor energy to 8
		Sleep 1350 * (screen_loading_mult)
		
		MouseMove, 500, 420
		Sleep 300
		Loop 3 { 
			MouseClick, left, , , , 0, D
			Sleep, 1200
			MouseClick, left, , , , , U
			Sleep 800
		}
		
		Send {Esc} ; dismentle item
		Sleep 500
		MouseMove, 1400, 270 + (125 * gear_index), 0
		Sleep 600
		MouseMove, 1500 + Mod(DISMENTLE_INDEX, 3) * 100, 270 + (125 * gear_index) + (100 * Floor(DISMENTLE_INDEX / 3) ), 0
		Sleep 50
		Send {f down}
		Sleep 1050
		Send {f up}
		Sleep 525
	}
}
return
MsgBox, done!


Numpad2::
F9::
MouseClick, left, , , , , U
Sleep 50
Send {f up}
Sleep 50
Reload