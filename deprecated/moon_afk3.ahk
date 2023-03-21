#SingleInstance, Force

Numpad1::
F8::
loop,
{
    Send, b
    Sleep, 100
    Send, {s Down}
    Sleep, 100
    Send, {s Up}
    Sleep, 100
    Send, v
    Sleep, 100
    Continue
}
Return

Numpad2::
F9::
Reload