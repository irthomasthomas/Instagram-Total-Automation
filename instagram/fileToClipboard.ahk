#Include Lib\Gdip_All.ahk
#include Lib\base64.ahk

F1:: gst()  ; example

gst() {   ; GetSelectedText or FilePath in Windows Explorer  by Learning one 

	IsClipEmpty := (Clipboard = "") ? 1 : 0

	if !IsClipEmpty {

		ClipboardBackup := ClipboardAll

		While !(Clipboard = "") {

			Clipboard =

			Sleep, 10

		}

	}

	Send, ^c

	ClipWait, 0.1

	ToReturn := Clipboard, Clipboard := ClipboardBackup
    
    pToken:=Gdip_Startup()
    pBitmap := Gdip_CreateBitmapFromFile(ToReturn)
    encoded := Gdip_EncodeBitmapTo64string(pBitmap, "png", 25)
    html := "<img src='data:image/png;base64," encoded "'/>"

    Gdip_DisposeImage(pBitmap)
    Gdip_Shutdown(pToken)
	if !IsClipEmpty

	ClipWait, 0.5, 1

	Clipboard := html
    Msgbox Done
}
