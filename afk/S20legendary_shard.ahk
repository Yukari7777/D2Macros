Glimmer := 26
; 제작 미광체 비용: 777
; 1사이클 만들때 필요한 미광체: 777 * 9 = 6993
; 1사이클 갈면 얻는 미광체: 2250
; 1사이클 당 미광체 변화량: 4743
; 따라서 2사이클당 한번씩 미광체를 구매하면 마르지 않는다.
Create := Glimmer * 2

Numpad3::ExitApp
Numpad2::
F9::Reload
Numpad1::
F8::{
	while true {
		Send "{w down}"
		Sleep 150
		Send "{w up}"
		Sleep 50
		Send "{e down}"
		Sleep 500
		Send "{e up}"
		Sleep 2500

		MouseMove 1200, 170, 0 ;라훌의 "전설조각 -> 미광체 구매 버튼"
		Sleep 800
		Loop Glimmer {
			Sleep 700
			Click
		}
		Sleep 300

		Loop Create {
			Send "{Del}" ;"수집품"
			Sleep 1000
			MouseMove 900, 400 ;"방어구"
			Sleep 300
			Click
			Sleep 800
			MouseMove 400, 630 ;"이벤트"
			Sleep 300
			Click
			Send "{Right}"
			MouseMove 720, 670 ;만들 아이템 위치
			Sleep 300
			Send "{Right}"
			Sleep 500
			Loop 9 {
				Click "Down"
				Sleep 3100
				Click "Up"
				Sleep 50
			}
			Send "i"
			Sleep 1300
			MouseMove 1400, 770 ;직방에 마우스 올리기
			Sleep 500
			MouseMove 1500, 770 ;첫번째 직방에 마우스 올리기
			Sleep 50
			Loop 9 {
				Send "{f down}"
				Sleep 1050
				Send "{f up}"
				Sleep 525
			}
		}

		Send "{Esc}"
		Sleep 500
		Send "{Esc}"
		Sleep 2000
	}
}