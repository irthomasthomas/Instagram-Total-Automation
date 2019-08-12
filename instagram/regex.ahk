
; Haystack = <img src="img/background1.png">
FileRead, Haystack, index.html
Needle = \<img src\s*=\s*"(.+?)"
; Needle = \<img.+src\=(?:\"|\')(.+?)(?:\"|\')(?:.+?)\>

FoundPos := RegExMatch(Haystack, Needle , OutputVar)
msgbox % OutputVar

clipboard := OutputVar

if OutputVar == """<img src="img/logo.png""""
{
    msgbox true
}
; msgbox % <img src="img/logo.png"
Haystack := "The Quick Brown Fox Jumps Over the Lazy Dog"
Needle := "the"

; MsgBox % InStr(Haystack, Needle, false, 1, 2) ; case insensitive search, return start position of second occurence
; MsgBox % InStr(Haystack, Needle, true) 