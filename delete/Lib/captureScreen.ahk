
; test code that calls function
; ScreenshotFile:="c:\screenshot\image.jpg" ; most image formats work, such as bmp, gif, jpg, png, tif
; TakeScreenshot(ScreenshotFile)
; ExitApp

TakeScreenshot()
  ; beaucoup thanks to tic (Tariq Porter) for his GDI+ Library
  ; https://autohotkey.com/boards/viewtopic.php?t=6517
  ; https://github.com/tariqporter/Gdip/raw/master/Gdip.ahk
  {
  pToken:=Gdip_Startup()
  If (pToken=0)
  {
    MsgBox,4112,Fatal Error,Unable to start GDIP
    ExitApp
  }
  pBitmap:=Gdip_BitmapFromScreen()
  msgbox % " pbitmap " pBitmap
  If (pBitmap<=0)
  {
    MsgBox,4112,Fatal Error,pBitmap=%pBitmap% trying to get bitmap from the screen
    ExitApp
  }
  pBm:=get_bitmapfrom64(encoded)
  msgbox % " pbm " pBm
  ; ResConImg(pBitmapFile, NewWidth:="", NewHeight:="", NewName:="", NewExt:="", NewDir:="", PreserveAspectRatio:=true, BitDepth:=24) {

  ; TODO: DllCall("QueryPerformanceCounter", "Int64*", CounterBefore)
  ; Gdip_GetDimensions(pBitmap, w, h)
  ; w := (w // 4)
  ; ResConImg(pBitmap, w,,,,"c:\screenshots", false)
  ; Gdip_SaveBitmapToFile(pBitmap,FileName)
  ; DllCall("QueryPerformanceCounter", "Int64*", CounterAfter)
  ; DllCall("QueryPerformanceFrequency", "Int64*", Frequency)

  ; MsgBox % "Elapsed QPC time is " . (CounterAfter - CounterBefore)*1000/Frequency . " milliseconds"


  If (ErrorLevel<>0)
  {
    MsgBox,4112,Fatal Error,ErrorLevel=%ErrorLevel% trying to save bitmap to`n%FileName%
    ExitApp
  }
  Return pBm
  }
  ; change the line below to wherever you have the downloaded GDIP source code