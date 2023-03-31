; You need to set this value to the same as the ingame's
ingame_sens := 4
screen_width := 1920 ; Not supported yet
debug_mode := 0

CONSTANT := 230
; TLDR. it won't be perfect unless you're on higher resolution than 1080p.
;
; I think this value is kinda optimal value for 1080p environment.
; This is a test function for checking whether there's any height(Y axis) difference after multiple shots.
; And the test turns out the ideal DELTA for 1080p is somewhere between 57 pixels and 58 pixels. 
; As we cannot move mouse in the float units, error exist.

; Tested with this rocket: https://d2foundry.gg/w/3489657138?p=3809316345,3796465595,3436462433,344235611a,1607056502&m=1588595445&mw=0
; reference: https://www.youtube.com/watch?v=ItN-K-WSCkM
; https://gall.dcinside.com/mgallery/board/view/?id=destiny&no=2363675

DELTA := CONSTANT / ingame_sens
LAlt & T:: {
  Loop {
    Click
    DllCall("mouse_event", "UInt", 0x01, "UInt", 0, "UInt", DELTA)
    Sleep 5000
  }
  return
}



LAlt & CapsLock:: {
  Sleep 100
  Click
  Send "B"
  DllCall("mouse_event", "UInt", 0x01, "UInt", 0, "UInt", DELTA)
  return
}


F9::Reload