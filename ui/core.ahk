screen_loading_mult := 1 ; adjust this if loading is slow.

F2::
Loop 4 { ;;한 사이클에 전조 2142 소모
	Send {e down}
	Sleep 2000 * (screen_loading_mult)
	Send {e up}

	send {Esc}
	MouseMove, 1200, 180, 0
	Sleep 2500 * (screen_loading_mult)

	Click, Right
	Sleep 1000 * (screen_loading_mult)

	MouseMove, 240, 440, 0
	Sleep 600
	Loop 49 {
		Click
		Sleep 650
	}

	send {Esc}
	Sleep 1000 * (screen_loading_mult)
	send {Esc}
	Sleep 2000 * (screen_loading_mult)

	send {w down}
	Sleep 3450
	send {w up}

	Sleep 500

	Send {e down}
	Sleep 2000 * (screen_loading_mult)
	Send {e up}
	Loop 8 {
		MouseMove, 1850, 680, 0
		Sleep 1000
		MouseMove, 1850, 580, 0
		Sleep 2000
		Click

		Sleep 600
		MouseMove, 1150, 470, 0
		Sleep 600
		Loop 9 {
			Click
			Sleep 650
		}

		Send i
		Sleep 1300 * (screen_loading_mult)

		MouseMove, 510, 390, 0
		Sleep 600
		MouseMove, 410, 390, 0
		Sleep 50

		Loop 9 {
			Send {f down}
			Sleep 1050
			Send {f up}
			Sleep 525
		}

		send {Esc}
		Sleep 1600
	}
	send {Esc}
	Sleep 2000 * (screen_loading_mult)

	send {s down}
	Sleep 4060
	send {s up}

	Sleep 500
}
return

F3::
MouseClick, left, , , , , U
Sleep 50
Send {f up}
Send {e up}
Sleep 50
Reload