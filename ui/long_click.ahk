description := "Please enter the delay in milliseconds. `nRecommended value: 1000, 3000, 7000(default) `nPress RClick, F9, Numpad2 to escape"
duration := InputBox(description, "Long Click: set delay", "", 7000).value

loop {
	Click "Down"
	Sleep duration
	Click "Up"
	Sleep 300
	Continue
} 

F9::
~RButton::
Numpad2:: {
	Click "Up"
	ExitApp 0
}