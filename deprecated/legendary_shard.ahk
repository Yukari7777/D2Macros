CoordMode,Mouse,Window

Glimmer := 20
Baryon := Glimmer * 4
Create := Glimmer * 2

f9::Reload
f8::
while true {
	Send {w down}
	Sleep 150
	Send {w up} 
	Sleep 50
	Send {e down}
	Sleep 500
	Send {e up}
	Sleep 2500
	
	MouseMove, 1166, 174, 0
	Sleep 800
	Loop, % (Glimmer) {
		Sleep 700
		Click
	}
	Sleep 300
	
	MouseMove, 1372, 174, 0
	Loop, % (Baryon) {
		Sleep 700
		Click
	}

	Loop % (Create) { ;만들고 갈기
		Send {Del}
		Sleep 1000
		MouseMove, 898, 402, 0
		Sleep 300
		Click
		Sleep 800
		MouseMove, 429, 833, 0
		Sleep 300
		Click
		Sleep 300
		MouseMove, 1815, 878, 0
		Sleep 300
		Click
		Sleep 500
		MouseMove, 1132, 883, 0
		Sleep 500
		Loop 9 {
			MouseClick, left, 1132, 883, , 0, D
			Sleep 3100
			MouseClick, left, , , , , U
			Sleep 50
		}
		Send i
		Sleep 1300
		MouseMove, 1397, 771, 0
		Sleep 600
		MouseMove, 1497, 769, 0
		Sleep 50
		Loop 9 {
			Send {f down}
			Sleep 1050
			Send {f up}
			Sleep 525
		}
	}
	
	Send {Esc}
	Sleep 500
	Send {Esc}
	Sleep 2000
}