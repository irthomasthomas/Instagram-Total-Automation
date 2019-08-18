#Persistent
#Include Lib\Gdip_All.ahk
#include Lib\base64.ahk
#include Lib\ObjRegisterActive.ahk

global encoded = ""
ObjRegisterActive(screen, "{93C04B39-0465-4460-8CA0-7BFFF481FF98}")

SetTimer, screenshot, 2500

class screen {
    encoded {
        get {
            return encoded
        }
    }
}

TakeScreenshot()
    {
        global encoded  
        ; beaucoup thanks to tic (Tariq Porter) for his GDI+ Library
        ; https://autohotkey.com/boards/viewtopic.php?t=6517
        ; https://github.com/tariqporter/Gdip/raw/master/Gdip.ahk
        pToken:=Gdip_Startup()
        If (pToken=0)
        {
            MsgBox,4112,Fatal Error,Unable to start GDIP
            ExitApp
        }
        pBitmap:=Gdip_BitmapFromScreen()
        If (pBitmap<=0)
        {
            MsgBox,4112,Fatal Error,pBitmap=%pBitmap% trying to get bitmap from the screen
            ExitApp
        }
        encoded:=Gdip_EncodeBitmapTo64string(pBitmap, "png")

        If (ErrorLevel<>0)
        {
            MsgBox,4112,Fatal Error,ErrorLevel=%ErrorLevel% trying to save bitmap to`n%FileName%
            ExitApp
        }
        Gdip_DisposeImage(pBitmap)

            ;   encoded
    }

screenshot:
TakeScreenshot()
return