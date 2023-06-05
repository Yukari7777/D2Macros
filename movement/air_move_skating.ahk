;; Try not to invoke immediately after swapping to sword. At least wait about 0.5 seconds
air_move_key := A_Args[1]

Click "Down Right"
Sleep 120
Click "Up Right"
Send "{Space}"
Sleep 10
Send air_move_key 