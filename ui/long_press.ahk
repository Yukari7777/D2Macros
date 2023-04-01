description := "What key to press? `ndefault key is F"
key := InputBox(description, "What key to press", "", "f").value
description := "Please enter the delay in milliseconds. `nRecommended value: 1050, 3050, 5050(default) `nPress RClick, F9, Numpad2 to escape"
duration := InputBox(description, "Set delay", "", 5050).value

loop {
	Send Format("{{1} down}", key)
	Sleep duration
	Send Format("{{1} up}", key)
	Sleep 300
	Continue
}

~RButton::
Numpad2::
F9:: {
	Send Format("{{1} up}", key)
	ExitApp 0
}