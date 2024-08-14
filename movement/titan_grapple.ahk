#SingleInstance Ignore
;; https://gall.dcinside.com/mgallery/board/view/?id=destiny&no=2505356
;; Titan, having an enemy aimed at that'll be killed with one tap.
uncharged_melee_key := A_Args[1]
granade_key := A_Args[1]
Send Format("{{1} {2}}", uncharged_melee_key, "Up")
Send Format("{{1} {2}}", granade_key, "Up")
Send "{Space Up}"

Send Format("{{1} {2}}", uncharged_melee_key, "Down")
Sleep 10
Click "Down"
Sleep 5
Send Format("{{1} {2}}", uncharged_melee_key, "Up")
Sleep 10
Click "Up"
Sleep 100
Send Format("{{1} {2}}", granade_key, "Down")
Sleep 10
Send Format("{{1} {2}}", granade_key, "Up")
Sleep 10
Send "{Space Down}"
Sleep 10
Send "{Space Up}"