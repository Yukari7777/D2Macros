#SingleInstance Ignore
;; Implements https://github.com/ImPleby/QoL-Macros/tree/main/Destiny%202
;; Try not to invoke immediately after swapping to sword. At least wait about 0.5 seconds
key := A_Args[1]
Send Format("{{1} {2}}", key, "Up")

Send "{Space Down}"
Sleep 5
Send "{Space Up}"
Sleep 5
Click "Down"
Sleep 5
Click "Up"
Sleep 5
Send "{Space Down}"
Sleep 5
Send "{Space Up}"
Sleep 5
Send Format("{{1} {2}}", key, "Down")
Sleep 5
Send Format("{{1} {2}}", key, "Up")