;; Implements https://github.com/ImPleby/QoL-Macros/tree/main/Destiny%202
;; Try not to invoke immediately after swapping to sword. At least wait about 0.5 seconds
key := A_Args[1]
delay := A_Args[2] == 1 ? 35 : 10

Send Format("{{1} {2}}", key, "Up")

Click "Right Down"
Sleep 35
Click "Right Up"
Sleep 35
Send "{Space Down}"
Sleep 35
Send "{Space Up}"
Sleep delay
Send Format("{{1} {2}}", key, "Down")
Sleep delay
Send Format("{{1} {2}}", key, "Up")