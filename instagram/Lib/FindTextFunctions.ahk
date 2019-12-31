;/*
;===========================================
;  FindText - Capture screen image into text and then find it
;  https://autohotkey.com/boards/viewtopic.php?f=6&t=17834
;
;  Author  :  FeiYue
;  Version :  6.7
;  Date    :  2019-04-13
;
;  Usage:
;  1. Capture the image to text string.
;  2. Test find the text string on full Screen.
;  3. When test is successful, you may copy the code
;     and paste it into your own script.
;     Note: Copy the "FindText()" function and the following
;     functions and paste it into your own script Just once.
;
;  Note:
;     After upgrading to v6.0, the search scope using WinAPI's
;     upper left corner X, Y coordinates, and width, height.
;     This will be better understood and used.
;
;===========================================
;  Introduction of function parameters:
;
;  returnArray := FindText(
;      X --> the search scope's upper left corner X coordinates
;    , Y --> the search scope's upper left corner Y coordinates
;    , W --> the search scope's Width
;    , H --> the search scope's Height
;    , Character "0" fault-tolerant in percentage --> 0.1=10%
;    , Character "_" fault-tolerant in percentage --> 0.1=10%
;    , Text --> can be a lot of text parsed into images, separated by "|"
;    , ScreenShot --> if the value is 0, the last screenshot will be used
;    , FindAll --> if the value is 0, Just find one result and return
;    , JoinText --> if the value is 1, Join all Text for combination lookup
;    , offsetX --> Set the max text offset for combination lookup
;    , offsetY --> Set the max text offset for combination lookup
;  )
;
;  The range used by AHK is determined by the upper left
;  corner and the lower right corner: (x1, y1, x2, y2),
;  it can be converted to: FindText(x1, y1, x2-x1+1, y2-y1+1, ...).
;
;  return a second-order array contains the [X,Y,W,H,Comment] of Each Find,
;  if no image is found, the function returns 0.
;
;===========================================
;*/

if (A_IsCompiled or A_LineFile!=A_ScriptFullPath)
  Goto, ft_End

ft_Start:

IfNotEqual, ft_ToolTip_Text,, Goto, ft_Main_Window
#NoEnv
#SingleInstance force
SetBatchLines, -1
Menu, Tray, Add
Menu, Tray, Add, FinText, ft_Main_Window
if (!A_IsCompiled and A_LineFile=A_ScriptFullPath)
{
  Menu, Tray, Default, FinText
  Menu, Tray, Click, 1
  Menu, Tray, Icon, Shell32.dll, 23
}
; The capture range can be changed by adjusting the numbers
;----------------------------
  ft_ww:=35, ft_hh:=12
;----------------------------
ft_nW:=2*ft_ww+1, ft_nH:=2*ft_hh+1
Gosub, ft_MakeCaptureWindow
Gosub, ft_MakeMainWindow
Gosub, ft_Load_ToolTip_Text
return

ft_Load_ToolTip_Text:
ft_ToolTip_Text=
(LTrim
Capture   = Initiate Image Capture Sequence
Test      = Test Results of Code
Copy      = Copy Code to Clipboard
AddFunc   = Additional FindText() in Copy
U         = Cut the Upper Edge by 1
U3        = Cut the Upper Edge by 3
L         = Cut the Left Edge by 1
L3        = Cut the Left Edge by 3
R         = Cut the Right Edge by 1
R3        = Cut the Right Edge by 3
D         = Cut the Lower Edge by 1
D3        = Cut the Lower Edge by 3
SelR      = Red component of the selected color
SelG      = Green component of the selected color
SelB      = Blue component of the selected color
DiffR     = Red Difference which Determines Black or White Pixel Conversion (0-255)
DiffG     = Green Difference which Determines Black or White Pixel Conversion (0-255)
DiffB     = Blue Difference which Determines Black or White Pixel Conversion (0-255)
Auto      = Automatic Cutting Edge
Similar   = Adjust color similarity as Equivalent to The Selected Color
Similar2  = Adjust color similarity as Equivalent to The Selected Color
SelColor  = The selected color
SelGray   = Gray value of the selected color
Threshold = Gray Threshold which Determines Black or White Pixel Conversion (0-255)
GrayDiff  = Gray Difference which Determines Black or White Pixel Conversion (0-255)
UsePos    = Use position instead of color value to suit any color
Modify    = Allows Modify the Black and White Image
Reset     = Reset to Original Captured Image
Comment   = Optional Comment used to Label Code ( Within <> )
SplitAdd  = Using Markup Segmentation to Generate Text Library
AllAdd    = Append Another FindText Search Text into Previously Generated Code
OK        = Create New FindText Code for Testing
Close     = Close the Window Don't Do Anything
Gray2Two      = Converts Image Pixels from Grays to Black or White
GrayDiff2Two  = Converts Image Pixels from Gray Difference to Black or White
Color2Two     = Converts Image Pixels from Color to Black or White
ColorPos2Two  = Converts Image Pixels from Color Position to Black or White
ColorDiff2Two = Converts Image Pixels from Color Difference to Black or White
)
return

ft_Main_Window:
Gui, ft_Main:Show, Center
return

ft_MakeMainWindow:
Gui, ft_Main:Default
Gui, +AlwaysOnTop
Gui, Margin, 15, 15
Gui, Color, DDEEFF
Gui, Font, s6 bold, Verdana
Gui, Add, Edit, xm w660 r25 vft_MyPic -Wrap -VScroll
Gui, Font, s12 norm, Verdana
Gui, Add, Button, w220 gft_MainRun, Capture
Gui, Add, Button, x+0 wp gft_MainRun, Test
Gui, Add, Button, x+0 wp gft_MainRun Section, Copy
Gui, Font, s10
Gui, Add, Text, xm, Click Text String to See ASCII Search Text in the Above
Gui, Add, Checkbox, xs yp w220 r1 -Wrap Checked vft_AddFunc, Additional FindText() in Copy
Gui, Font, s12 cBlue, Verdana
Gui, Add, Edit, xm w660 h350 vft_scr Hwndft_hscr -Wrap HScroll
Gui, Show,, Capture Image To Text And Find Text Tool
;---------------------------------------
OnMessage(0x100, Func("ft_EditEvents1"))  ; WM_KEYDOWN
OnMessage(0x201, Func("ft_EditEvents2"))  ; WM_LBUTTONDOWN
OnMessage(0x200, Func("ft_ShowToolTip"))  ; WM_MOUSEMOVE
return

ft_EditEvents1()
{
  ListLines, Off
  if (A_Gui="ft_Main" && A_GuiControl="ft_scr")
    SetTimer, ft_ShowPic, -100
}

ft_EditEvents2()
{
  ListLines, Off
  if (A_Gui="ft_Capture")
    ft_WM_LBUTTONDOWN()
  else
    ft_EditEvents1()
}

ft_ShowPic:
ListLines, Off
Critical
ControlGet, i, CurrentLine,,, ahk_id %ft_hscr%
ControlGet, s, Line, %i%,, ahk_id %ft_hscr%
GuiControl, ft_Main:, ft_MyPic, % Trim(ASCII(s),"`n")
return

ft_ShowToolTip()
{
  ListLines, Off
  global ft_ToolTip_Text
  static CurrControl, PrevControl, _TT
  CurrControl := A_GuiControl
  if (CurrControl != PrevControl)
  {
    PrevControl := CurrControl
    ToolTip
    if (CurrControl != "")
      SetTimer, ft_DisplayToolTip, -500
  }
  return

  ft_DisplayToolTip:
  ListLines, Off
  MouseGetPos,,, _TT
  WinGetClass, _TT, ahk_id %_TT%
  if (_TT = "AutoHotkeyGUI")
  {
    ToolTip, % RegExMatch(ft_ToolTip_Text, "m`n)^"
      . StrReplace(CurrControl,"ft_") . "\K\s*=.*", _TT)
      ? StrReplace(Trim(_TT,"`t ="),"\n","`n") : ""
    SetTimer, ft_RemoveToolTip, -5000
  }
  return

  ft_RemoveToolTip:
  ToolTip
  return
}

ft_MainRun:
k:="ft_" . A_GuiControl
WinMinimize
Gui, Hide
DetectHiddenWindows, Off
Gui, +LastFound
WinWaitClose, % "ahk_id " WinExist()
if IsLabel(k)
  Gosub, %k%
Gui, ft_Main: Show
GuiControl, ft_Main: Focus, ft_scr
return

ft_Copy:
GuiControlGet, s,, ft_scr
GuiControlGet, r,, ft_AddFunc
if (r != 1)
  s:=RegExReplace(s,"\n\K[\s;=]+ Copy The[\s\S]*")
Clipboard:=StrReplace(s,"`n","`r`n")
s=
return

ft_Capture:
Gui, ft_Mini:Default
Gui, +LastFound +AlwaysOnTop -Caption +ToolWindow +E0x08000000
Gui, Color, Red
d:=2, w:=ft_nW+2*d, h:=ft_nH+2*d, i:=w-d, j:=h-d
Gui, Show, Hide w%w% h%h%
s=0-0 %w%-0 %w%-%h% 0-%h% 0-0
s=%s%  %d%-%d% %i%-%d% %i%-%j% %d%-%j% %d%-%d%
WinSet, Region, %s%
;------------------------------
Hotkey, $*RButton, ft_RButton_Off, On
ListLines, Off
CoordMode, Mouse
ft_oldx:=ft_oldy:=""
Loop {
  Sleep, 50
  MouseGetPos, x, y
  if (ft_oldx=x and ft_oldy=y)
    Continue
  ft_oldx:=x, ft_oldy:=y
  ;---------------
  Gui, Show, % "NA x" (x-w//2) " y" (y-h//2)
  ToolTip, % "The Capture Position : " x "," y
    . "`nFirst click RButton to start capturing"
    . "`nSecond click RButton to end capture"
} Until GetKeyState("RButton", "P")
KeyWait, RButton
ft_px:=x, ft_py:=y, ft_oldx:=ft_oldy:=""
Loop {
  Sleep, 50
  MouseGetPos, x, y
  if (ft_oldx=x and ft_oldy=y)
    Continue
  ft_oldx:=x, ft_oldy:=y
  ;---------------
  ToolTip, % "The Capture Position : " ft_px "," ft_py
    . "`nFirst click RButton to start capturing"
    . "`nSecond click RButton to end capture"
} Until GetKeyState("RButton", "P")
KeyWait, RButton
ToolTip
ListLines, On
Gui, Destroy
WinWaitClose
ft_cors:=ft_getc(ft_px,ft_py,ft_ww,ft_hh)
Hotkey, $*RButton, ft_RButton_Off, Off
Goto, ft_ShowCaptureWindow
ft_RButton_Off:
return

ft_ShowCaptureWindow:
ft_cors.Event:="", ft_cors.Result:=""
;--------------------------------
Gui, ft_Capture:Default
k:=ft_nW*ft_nH+1
Loop, % ft_nW
  GuiControl,, % ft_C_[k++], 0
Loop, 6
  GuiControl,, Edit%A_Index%
GuiControl,, ft_Modify, % ft_Modify:=0
GuiControl,, ft_GrayDiff, 50
GuiControl, Focus, ft_Threshold
Gosub, ft_Reset
Gui, Show, Center
DetectHiddenWindows, Off
Gui, +LastFound
WinWaitClose, % "ahk_id " WinExist()
;--------------------------------
if InStr(ft_cors.Event,"OK")
{
  if !A_IsCompiled
  {
    FileRead, s, %A_LineFile%
    s:=SubStr(s, s~="i)\n[;=]+ Copy The")
  } else s:=""
  GuiControl, ft_Main:, ft_scr, % ft_cors.Result "`n" s
  ft_cors.Result:=s:=""
  return
}
if InStr(ft_cors.Event,"Add")
  ft_add(ft_cors.Result, 0), ft_cors.Result:=""
return

ft_WM_LBUTTONDOWN()
{
  global
  ListLines, Off
  Critical
  MouseGetPos,,,, j
  IfNotInString, j, progress
    return
  Gui, ft_Capture:Default
  MouseGetPos,,,, j, 2
  For k,v in ft_C_
    if (v=j)
    {
      if (k>ft_nW*ft_nH)
      {
        GuiControlGet, i,, %v%
        GuiControl,, %v%, % i ? 0:100
      }
      else if (ft_Modify and ft_bg!="")
      {
        c:=ft_ascii[k], ft_ascii[k]:=c="0" ? "_" : c="_" ? "0" : c
        c:=c="0" ? "White" : c="_" ? "Black" : ft_WindowColor
        Gosub, ft_SetColor
      }
      else
      {
        c:=ft_cors[k], ft_cors.SelPos:=k
        r:=(c>>16)&0xFF, g:=(c>>8)&0xFF, b:=c&0xFF
        GuiControl,, ft_SelGray, % (r*38+g*75+b*15)>>7
        GuiControl,, ft_SelColor, %c%
        GuiControl,, ft_SelR, %r%
        GuiControl,, ft_SelG, %g%
        GuiControl,, ft_SelB, %b%
      }
      return
    }
}

ft_getc(px, py, ww, hh)
{
  xywh2xywh(px-ww,py-hh,2*ww+1,2*hh+1,x,y,w,h)
  if (w<1 or h<1)
    return, 0
  bch:=A_BatchLines
  SetBatchLines, -1
  ;--------------------------------------
  GetBitsFromScreen(x,y,w,h,Scan0,Stride,1)
  ;--------------------------------------
  cors:=[], k:=0, nW:=2*ww+1, nH:=2*hh+1
  lls:=A_ListLines=0 ? "Off" : "On"
  ListLines, Off
  fmt:=A_FormatInteger
  SetFormat, IntegerFast, H
  Loop, %nH% {
    j:=py-hh+A_Index-1
    Loop, %nW% {
      i:=px-ww+A_Index-1, k++
      if (i>=x and i<=x+w-1 and j>=y and j<=y+h-1)
        c:=NumGet(Scan0+0,(j-y)*Stride+(i-x)*4,"uint")
          , cors[k]:="0x" . SubStr(0x1000000|c,-5)
      else
        cors[k]:="0xFFFFFF"
    }
  }
  SetFormat, IntegerFast, %fmt%
  ListLines, %lls%
  cors.LeftCut:=Abs(px-ww-x)
  cors.RightCut:=Abs(px+ww-(x+w-1))
  cors.UpCut:=Abs(py-hh-y)
  cors.DownCut:=Abs(py+hh-(y+h-1))
  SetBatchLines, %bch%
  return, cors
}

ft_Test:
GuiControlGet, s, ft_Main:, ft_scr
s:="`n#NoEnv`nMenu, Tray, Click, 1`n"
  . "Gui, _ok_:Show, Hide, _ok_`n"
  . s "`nExitApp`n#SingleInstance off`n"
if (!A_IsCompiled) and InStr(s,"MCode(")
{
  ft_Exec(s)
  DetectHiddenWindows, On
  WinWait, _ok_ ahk_class AutoHotkeyGUI,, 3
  if !ErrorLevel
    WinWaitClose, _ok_ ahk_class AutoHotkeyGUI
}
else
{
  CoordMode, Mouse
  t:=A_TickCount, RegExMatch(s,"\[\d+,\s*\d+\]",r)
  RegExMatch(s,"=""\K[^$\n]+\$\d+\.[\w+/]+",v)
  k:=FindText(0, 0, A_ScreenWidth, A_ScreenHeight, 0, 0, v)
  X:=k.1.1, Y:=k.1.2, W:=k.1.3, H:=k.1.4, X+=W//2, Y+=H//2
  MsgBox, 4096,, % "Time:`t" (A_TickCount-t) " ms`n`n"
    . "Pos:`t" r "  " X ", " Y "`n`n"
    . "Result:`t" (k ? "Success !":"Failed !"), 3
  (k) and MouseTip(X, Y)
  k:=""
}
return

ft_Exec(s)
{
  Ahk:=A_IsCompiled ? A_ScriptDir "\AutoHotkey.exe":A_AhkPath
  s:=RegExReplace(s, "\R", "`r`n")
  Try {
    shell:=ComObjCreate("WScript.Shell")
    oExec:=shell.Exec(Ahk " /f /ErrorStdOut *")
    oExec.StdIn.Write(s)
    oExec.StdIn.Close()
  }
  catch {
    f:=A_Temp "\~test1.tmp", s:="`r`n FileDelete, " f "`r`n" s
    FileDelete, %f%
    FileAppend, %s%, %f%
    Run, %Ahk% /f "%f%",, UseErrorLevel
  }
}

ft_MakeCaptureWindow:
ft_WindowColor:="0xCCDDEE"
Gui, ft_Capture:Default
Gui, +LastFound +AlwaysOnTop +ToolWindow
Gui, Margin, 15, 15
Gui, Color, %ft_WindowColor%
Gui, Font, s14, Verdana
Gui, -Theme
w:=800//ft_nW, h:=(A_ScreenHeight-300)//ft_nH, w:=h<w ? h-1:w-1
Loop, % ft_nW*(ft_nH+1) {
  i:=A_Index, j:=i=1 ? "" : Mod(i,ft_nW)=1 ? "xm y+1" : "x+1"
  j.=i>ft_nW*ft_nH ? " cRed BackgroundFFFFAA":""
  Gui, Add, Progress, w%w% h%w% %j%
}
WinGet, s, ControlListHwnd
ft_C_:=StrSplit(s,"`n"), s:=""
Loop, % ft_nW*(ft_nH+1)
  Control, ExStyle, -0x20000,, % "ahk_id " ft_C_[A_Index]
Gui, +Theme
Gui, Add, Button, xm+95  w45 gft_Run, U
Gui, Add, Button, x+0    wp gft_Run, U3
;--------------
Gui, Add, Text,   x+42 yp+3 Section, Gray
Gui, Add, Edit,   x+3 yp-3 w60 vft_SelGray ReadOnly
Gui, Add, Text,   x+15 ys, Color
Gui, Add, Edit,   x+3 yp-3 w120 vft_SelColor ReadOnly
Gui, Add, Text,   x+15 ys, R
Gui, Add, Edit,   x+3 yp-3 w60 vft_SelR ReadOnly
Gui, Add, Text,   x+5 ys, G
Gui, Add, Edit,   x+3 yp-3 w60 vft_SelG ReadOnly
Gui, Add, Text,   x+5 ys, B
Gui, Add, Edit,   x+3 yp-3 w60 vft_SelB ReadOnly
;--------------
Gui, Add, Button, xm     w45 gft_Run, L
Gui, Add, Button, x+0    wp gft_Run, L3
Gui, Add, Button, x+15   w70 gft_Run, Auto
Gui, Add, Button, x+15   w45 gft_Run, R
Gui, Add, Button, x+0    wp gft_Run Section, R3
Gui, Add, Button, xm+95  w45 gft_Run, D
Gui, Add, Button, x+0    wp gft_Run, D3
;------------------
Gui, Add, Tab3,   ys-8 -Wrap, Gray|GrayDiff|Color|ColorPos|ColorDiff
Gui, Tab, 1
Gui, Add, Text,   x+15 y+15, Gray Threshold
Gui, Add, Edit,   x+15 w100 vft_Threshold
Gui, Add, Button, x+15 yp-3 gft_Run Default, Gray2Two
Gui, Tab, 2
Gui, Add, Text,   x+15 y+15, Gray Difference
Gui, Add, Edit,   x+15 w100 vft_GrayDiff, 50
Gui, Add, Button, x+15 yp-3 gft_Run, GrayDiff2Two
Gui, Tab, 3
Gui, Add, Text,   x+15 y+15, Similarity 0
Gui, Add, Slider
  , x+0 w100 vft_Similar gft_Run Page1 NoTicks ToolTip Center, 100
Gui, Add, Text,   x+0, 100
Gui, Add, Button, x+15 yp-3 gft_Run, Color2Two
Gui, Tab, 4
Gui, Add, Text,   x+15 y+15, Similarity 0
Gui, Add, Slider
  , x+0 w100 vft_Similar2 gft_Run Page1 NoTicks ToolTip Center, 100
Gui, Add, Text,   x+0, 100
Gui, Add, Button, x+15 yp-3 gft_Run, ColorPos2Two
Gui, Tab, 5
Gui, Add, Text,   x+15 y+15, R
Gui, Add, Edit,   x+3 w70 vft_DiffR Limit3
Gui, Add, UpDown, vft_dR Range0-255
Gui, Add, Text,   x+10, G
Gui, Add, Edit,   x+3 w70 vft_DiffG Limit3
Gui, Add, UpDown, vft_dG Range0-255
Gui, Add, Text,   x+10, B
Gui, Add, Edit,   x+3 w70 vft_DiffB Limit3
Gui, Add, UpDown, vft_dB Range0-255
Gui, Add, Button, x+12 yp-3 gft_Run, ColorDiff2Two
Gui, Tab
;------------------
Gui, Add, Checkbox, xm   gft_Run vft_Modify, Modify
Gui, Add, Button, x+5    yp-3 gft_Run, Reset
Gui, Add, Text,   x+15   yp+3, Comment
Gui, Add, Edit,   x+5    w132 vft_Comment
Gui, Add, Button, x+10   yp-3 gft_Run, SplitAdd
Gui, Add, Button, x+10   gft_Run, AllAdd
Gui, Add, Button, x+10   w80 gft_Run, OK
Gui, Add, Button, x+10   gft_Run, Close
Gui, Show, Hide, Capture Image To Text
return

ft_Run:
Critical
k:=A_GuiControl
k:= k="L" ? "LeftCut"  : k="L3" ? "LeftCut3"
  : k="R" ? "RightCut" : k="R3" ? "RightCut3"
  : k="U" ? "UpCut"    : k="U3" ? "UpCut3"
  : k="D" ? "DownCut"  : k="D3" ? "DownCut3" : k
Gui, +OwnDialogs
k:=InStr(k,"ft_") ? k : "ft_" k
if IsLabel(k)
  Gosub, %k%
return

ft_Close:
Gui, Cancel
return

ft_Modify:
GuiControlGet, ft_Modify
return

ft_Similar:
ft_Similar2:
ListLines, Off
GuiControl,, % InStr(A_ThisLabel,"2")
  ? "ft_Similar":"ft_Similar2", % %A_ThisLabel%
return

ft_SetColor:
c:=c="White" ? 0xFFFFFF : c="Black" ? 0x000000
  : ((c&0xFF)<<16)|(c&0xFF00)|((c&0xFF0000)>>16)
SendMessage, 0x2001, 0, c,, % "ahk_id " . ft_C_[k]
return

ft_Reset:
if !IsObject(ft_ascii)
  ft_ascii:=[], ft_gs:=[]
ft_left:=ft_right:=ft_up:=ft_down:=k:=0, ft_bg:=""
Loop, % ft_nW*ft_nH {
  ft_ascii[++k]:=1, c:=ft_cors[k]
  ft_gs[k]:=(((c>>16)&0xFF)*38+((c>>8)&0xFF)*75+(c&0xFF)*15)>>7
  Gosub, ft_SetColor
}
Loop, % ft_cors.LeftCut
  Gosub, ft_LeftCut
Loop, % ft_cors.RightCut
  Gosub, ft_RightCut
Loop, % ft_cors.UpCut
  Gosub, ft_UpCut
Loop, % ft_cors.DownCut
  Gosub, ft_DownCut
return

ft_Gray2Two:
GuiControl, Focus, ft_Threshold
GuiControlGet, ft_Threshold
if (ft_Threshold="")
{
  ft_pp:=[]
  Loop, 256
    ft_pp[A_Index-1]:=0
  Loop, % ft_nW*ft_nH
    if (ft_ascii[A_Index]!="")
      ft_pp[ft_gs[A_Index]]++
  ft_Threshold:=ft_GetThreshold(ft_pp)
  GuiControl,, ft_Threshold, %ft_Threshold%
}
ft_Threshold:=Round(ft_Threshold)
ft_color:="*" ft_Threshold, k:=i:=0
Loop, % ft_nW*ft_nH {
  if (ft_ascii[++k]="")
    Continue
  if (ft_gs[k]<=ft_Threshold)
    ft_ascii[k]:="0", c:="Black", i++
  else
    ft_ascii[k]:="_", c:="White", i--
  Gosub, ft_SetColor
}
ft_bg:=i>0 ? "0":"_"
return

ft_GetThreshold(pp)
{
  IP:=IS:=0
  Loop, 256
    k:=A_Index-1, IP+=k*pp[k], IS+=pp[k]
  NewThreshold:=Floor(IP/IS)
  Loop, 20 {
    Threshold:=NewThreshold
    IP1:=IS1:=0
    Loop, % Threshold+1
      k:=A_Index-1, IP1+=k*pp[k], IS1+=pp[k]
    IP2:=IP-IP1, IS2:=IS-IS1
    if (IS1!=0 and IS2!=0)
      NewThreshold:=Floor((IP1/IS1+IP2/IS2)/2)
    if (NewThreshold=Threshold)
      Break
  }
  return, NewThreshold
}

ft_GrayDiff2Two:
GuiControlGet, ft_GrayDiff
if (ft_GrayDiff="")
{
  MsgBox, 4096, Tip
    , `n  Please Set Gray Difference First !  `n, 1
  Return
}
if (ft_left=ft_cors.LeftCut)
  Gosub, ft_LeftCut
if (ft_right=ft_cors.RightCut)
  Gosub, ft_RightCut
if (ft_up=ft_cors.UpCut)
  Gosub, ft_UpCut
if (ft_down=ft_cors.DownCut)
  Gosub, ft_DownCut
ft_GrayDiff:=Round(ft_GrayDiff)
ft_color:="**" ft_GrayDiff, k:=i:=0, n:=ft_nW
Loop, % ft_nW*ft_nH {
  if (ft_ascii[++k]="")
    Continue
  j:=ft_gs[k]+ft_GrayDiff
  if ( ft_gs[k-1]>j   or ft_gs[k+1]>j
    or ft_gs[k-n]>j   or ft_gs[k+n]>j
    or ft_gs[k-n-1]>j or ft_gs[k-n+1]>j
    or ft_gs[k+n-1]>j or ft_gs[k+n+1]>j )
      ft_ascii[k]:="0", c:="Black", i++
  else
    ft_ascii[k]:="_", c:="White", i--
  Gosub, ft_SetColor
}
ft_bg:=i>0 ? "0":"_"
return

ft_Color2Two:
ft_ColorPos2Two:
GuiControlGet, c,, ft_SelColor
if (c="")
{
  MsgBox, 4096, Tip
    , `n  Please Select a Color First !  `n, 1
  return
}
ft_UsePos:=InStr(A_ThisLabel,"ColorPos2Two") ? 1:0
GuiControlGet, n,, ft_Similar
n:=Round(n/100,2), ft_color:=c "@" n
n:=Floor(9*255*255*(1-n)*(1-n)), k:=i:=0
ft_rr:=(c>>16)&0xFF, ft_gg:=(c>>8)&0xFF, ft_bb:=c&0xFF
Loop, % ft_nW*ft_nH {
  if (ft_ascii[++k]="")
    Continue
  c:=ft_cors[k], r:=((c>>16)&0xFF)-ft_rr
    , g:=((c>>8)&0xFF)-ft_gg, b:=(c&0xFF)-ft_bb
  if (3*r*r+4*g*g+2*b*b<=n)
    ft_ascii[k]:="0", c:="Black", i++
  else
    ft_ascii[k]:="_", c:="White", i--
  Gosub, ft_SetColor
}
ft_bg:=i>0 ? "0":"_"
return

ft_ColorDiff2Two:
GuiControlGet, c,, ft_SelColor
if (c="")
{
  MsgBox, 4096, Tip
    , `n  Please Select a Color First !  `n, 1
  return
}
GuiControlGet, ft_dR
GuiControlGet, ft_dG
GuiControlGet, ft_dB
ft_rr:=(c>>16)&0xFF, ft_gg:=(c>>8)&0xFF, ft_bb:=c&0xFF
n:=Format("{:06X}",(ft_dR<<16)|(ft_dG<<8)|ft_dB)
ft_color:=StrReplace(c "-" n,"0x"), k:=i:=0
Loop, % ft_nW*ft_nH {
  if (ft_ascii[++k]="")
    Continue
  c:=ft_cors[k], r:=(c>>16)&0xFF, g:=(c>>8)&0xFF, b:=c&0xFF
  if ( Abs(r-ft_rr)<=ft_dR
    and Abs(g-ft_gg)<=ft_dG
    and Abs(b-ft_bb)<=ft_dB )
      ft_ascii[k]:="0", c:="Black", i++
  else
    ft_ascii[k]:="_", c:="White", i--
  Gosub, ft_SetColor
}
ft_bg:=i>0 ? "0":"_"
return

ft_gui_del:
ft_ascii[k]:="", c:=ft_WindowColor
Gosub, ft_SetColor
return

ft_LeftCut3:
Loop, 3
  Gosub, ft_LeftCut
return

ft_LeftCut:
if (ft_left+ft_right>=ft_nW)
  return
ft_left++, k:=ft_left
Loop, %ft_nH% {
  Gosub, ft_gui_del
  k+=ft_nW
}
return

ft_RightCut3:
Loop, 3
  Gosub, ft_RightCut
return

ft_RightCut:
if (ft_left+ft_right>=ft_nW)
  return
ft_right++, k:=ft_nW+1-ft_right
Loop, %ft_nH% {
  Gosub, ft_gui_del
  k+=ft_nW
}
return

ft_UpCut3:
Loop, 3
  Gosub, ft_UpCut
return

ft_UpCut:
if (ft_up+ft_down>=ft_nH)
  return
ft_up++, k:=(ft_up-1)*ft_nW
Loop, %ft_nW% {
  k++
  Gosub, ft_gui_del
}
return

ft_DownCut3:
Loop, 3
  Gosub, ft_DownCut
return

ft_DownCut:
if (ft_up+ft_down>=ft_nH)
  return
ft_down++, k:=(ft_nH-ft_down)*ft_nW
Loop, %ft_nW% {
  k++
  Gosub, ft_gui_del
}
return

ft_getwz:
ft_wz:=""
if (ft_bg="")
  return
k:=0
Loop, %ft_nH% {
  v:=""
  Loop, %ft_nW%
    v.=ft_ascii[++k]
  ft_wz.=v="" ? "" : v "`n"
}
return

ft_Auto:
Gosub, ft_getwz
if (ft_wz="")
{
  MsgBox, 4096, Tip
    , `nPlease Click Color2Two or Gray2Two First !, 1
  return
}
While InStr(ft_wz, ft_bg) {
  if (ft_wz~="^" ft_bg "+\n")
  {
    ft_wz:=RegExReplace(ft_wz,"^" ft_bg "+\n")
    Gosub, ft_UpCut
  }
  else if !(ft_wz~="m`n)[^\n" ft_bg "]$")
  {
    ft_wz:=RegExReplace(ft_wz,"m`n)" ft_bg "$")
    Gosub, ft_RightCut
  }
  else if (ft_wz~="\n" ft_bg "+\n$")
  {
    ft_wz:=RegExReplace(ft_wz,"\n\K" ft_bg "+\n$")
    Gosub, ft_DownCut
  }
  else if !(ft_wz~="m`n)^[^\n" ft_bg "]")
  {
    ft_wz:=RegExReplace(ft_wz,"m`n)^" ft_bg)
    Gosub, ft_LeftCut
  }
  else Break
}
ft_wz:=""
return

ft_OK:
ft_AllAdd:
ft_SplitAdd:
Gosub, ft_getwz
if ft_wz=
{
  MsgBox, 4096, Tip
    , `nPlease Click Color2Two or Gray2Two First !, 1
  return
}
if InStr(ft_color,"@") and (ft_UsePos)
{
  StringSplit, r, ft_color, @
  k:=i:=j:=0
  Loop, % ft_nW*ft_nH {
    if (ft_ascii[++k]="")
      Continue
    i++
    if (k=ft_cors.SelPos)
    {
      j:=i
      Break
    }
  }
  if (j=0)
  {
    MsgBox, 4096, Tip
      , Please select the core color again !, 3
    return
  }
  ft_color:="#" . j . "@" . r2
}
GuiControlGet, ft_Comment
ft_cors.Event:=A_ThisLabel
if InStr(A_ThisLabel, "SplitAdd")
{
  if InStr(ft_color,"#")
  {
    MsgBox, 4096, Tip
      , % "Can't be used in ColorPos mode, "
      . "because it can cause position errors", 3
    return
  }
  SetFormat, IntegerFast, d
  ft_bg:=StrLen(StrReplace(ft_wz,"_"))
    > StrLen(StrReplace(ft_wz,"0")) ? "0":"_"
  s:="", k:=ft_nW*ft_nH+1+ft_left
    , i:=0, w:=ft_nW-ft_left-ft_right
  Loop, % w {
    i++
    GuiControlGet, j,, % ft_C_[k++]
    if (j=0 and A_Index<w)
      Continue
    v:=RegExReplace(ft_wz,"m`n)^(.{" i "}).*","$1")
    ft_wz:=RegExReplace(ft_wz,"m`n)^.{" i "}"), i:=0
    While InStr(v, ft_bg) {
      if (v~="^" ft_bg "+\n")
        v:=RegExReplace(v,"^" ft_bg "+\n")
      else if !(v~="m`n)[^\n" ft_bg "]$")
        v:=RegExReplace(v,"m`n)" ft_bg "$")
      else if (v~="\n" ft_bg "+\n$")
        v:=RegExReplace(v,"\n\K" ft_bg "+\n$")
      else if !(v~="m`n)^[^\n" ft_bg "]")
        v:=RegExReplace(v,"m`n)^" ft_bg)
      else Break
    }
    if v!=
      s.=ft_towz(ft_color, v, SubStr(ft_Comment,1,1))
    ft_Comment:=SubStr(ft_Comment, 2)
  }
  ft_cors.Result:=s
  Gui, Hide
  return
}
s:=ft_towz(ft_color, ft_wz, ft_Comment)
if InStr(A_ThisLabel, "AllAdd")
{
  ft_cors.Result:=s
  Gui, Hide
  return
}
x:=ft_px-ft_ww+ft_left+(ft_nW-ft_left-ft_right)//2
y:=ft_py-ft_hh+ft_up+(ft_nH-ft_up-ft_down)//2
s:=StrReplace(s, "Text.=", "Text:=")
s=
(
t1:=A_TickCount
%s%
if (ok:=FindText(0, 0, A_ScreenWidth, A_ScreenHeight, 0, 0, Text))
{
  CoordMode, Mouse
  X:=ok.1.1, Y:=ok.1.2, W:=ok.1.3, H:=ok.1.4, Comment:=ok.1.5, X+=W//2, Y+=H//2
  ; Click, `%X`%, `%Y`%
}

MsgBox, 4096, `% ok.MaxIndex(), `% "Time:``t" (A_TickCount-t1) " ms``n``n"
  . "Pos:``t[%x%, %y%]  " X ", " Y "``n``n"
  . "Result:``t" (ok ? "Success ! " Comment : "Failed !")

for i,v in ok
  if i<=2
    MouseTip(v.1+v.3//2, v.2+v.4//2)

)
ft_cors.Result:=s
Gui, Hide
return

ft_towz(color,wz,comment="")
{
  SetFormat, IntegerFast, d
  wz:=StrReplace(StrReplace(wz,"0","1"),"_","0")
  wz:=(InStr(wz,"`n")-1) "." bit2base64(wz)
  return, "`nText.=""|<" comment ">" color "$" wz """`n"
}

ft_add(s, rn=1)
{
  global ft_hscr
  if (rn=1)
    s:="`n" s "`n"
  s:=RegExReplace(s,"\R","`r`n")
  ControlGet, i, CurrentCol,,, ahk_id %ft_hscr%
  if i>1
    ControlSend,, {Home}{Down}, ahk_id %ft_hscr%
  Control, EditPaste, %s%,, ahk_id %ft_hscr%
}

ft_End:
Trim("")


;===== Copy The Following Functions To Your Own Code Just once =====


;--------------------------------
; FindText - Capture screen image into text and then find it
;--------------------------------
; X, Y --> the search scope's upper left corner coordinates
; W, H --> the search scope's Width and Height
; err1, err0 --> character "0" or "_" fault-tolerant in percentage
; Text --> can be a lot of text parsed into images, separated by "|"
; ScreenShot --> if the value is 0, the last screenshot will be used
; FindAll --> if the value is 0, Just find one result and return
; JoinText --> if the value is 1, Join all Text for combination lookup
; offsetX, offsetY --> Set the Max text offset for combination lookup
; ruturn --> a second-order array contains the [X,Y,W,H,Comment] of Each Find
;--------------------------------

FindText( x, y, w, h, err1, err0, text, ScreenShot=1
  , FindAll=1, JoinText=0, offsetX=20, offsetY=10 )
{
  xywh2xywh(x,y,w,h,x,y,w,h)
  if (w<1 or h<1)
    return, 0
  bch:=A_BatchLines
  SetBatchLines, -1
  ;-------------------------------
  GetBitsFromScreen(x,y,w,h,Scan0,Stride,ScreenShot,zx,zy)
  ;-------------------------------
  sx:=x-zx, sy:=y-zy, sw:=w, sh:=h
  , arr:=[], info:=[], allv:=""
  Loop, Parse, text, |
  {
    v:=A_LoopField
    IfNotInString, v, $, Continue
    comment:="", e1:=err1, e0:=err0
    ; You Can Add Comment Text within The <>
    if RegExMatch(v,"<([^>]*)>",r)
      v:=StrReplace(v,r), comment:=Trim(r1)
    ; You can Add two fault-tolerant in the [], separated by commas
    if RegExMatch(v,"\[([^\]]*)]",r)
    {
      v:=StrReplace(v,r), r1.=","
      StringSplit, r, r1, `,
      e1:=r1, e0:=r2
    }
    StringSplit, r, v, $
    color:=r1, v:=r2
    StringSplit, r, v, .
    w1:=r1, v:=base64tobit(r2), h1:=StrLen(v)//w1
    if (r0<2 or h1<1 or w1>sw or h1>sh or StrLen(v)!=w1*h1)
      Continue
    mode:=InStr(color,"-") ? 4 : InStr(color,"#") ? 3
      : InStr(color,"**") ? 2 : InStr(color,"*") ? 1 : 0
    if (mode=4)
    {
      color:=StrReplace(color,"0x")
      StringSplit, r, color, -
      color:="0x" . r1, n:="0x" . r2
    }
    else
    {
      color:=RegExReplace(color,"[*#]") . "@"
      StringSplit, r, color, @
      color:=mode=3 ? ((r1-1)//w1)*Stride+Mod(r1-1,w1)*4 : r1
      n:=Round(r2,2)+(!r2), n:=Floor(9*255*255*(1-n)*(1-n))
    }
    StrReplace(v,"1","",len1), len0:=StrLen(v)-len1
    e1:=Round(len1*e1), e0:=Round(len0*e0)
    info.Push( [StrLen(allv),w1,h1,len1,len0,e1,e0
      ,mode,color,n,comment] ), allv.=v
  }
  if (allv="")
  {
    SetBatchLines, %bch%
    return, 0
  }
  num:=info.MaxIndex(), VarSetCapacity(input, num*7*4)
  , VarSetCapacity(gs, sw*sh)
  , VarSetCapacity(ss, sw*sh), k:=StrLen(allv)*4
  , VarSetCapacity(s1, k), VarSetCapacity(s0, k)
  , allpos_max:=FindAll ? 1024 : 1
  , VarSetCapacity(allpos, allpos_max*4)
  ;-------------------------------------
  Loop, 2 {
  if (JoinText)
  {
    mode:=info.1.8, color:=info.1.9, n:=info.1.10
    , w1:=-1, h1:=info.1.3, comment:="", k:=0
    Loop, % num {
      i:=A_Index, w1+=info[i].2+1, comment.=info[i].11
      Loop, 7
        NumPut(info[i][A_Index], input, 4*(k++), "int")
    }
    ok:=PicFind( mode,color,n,offsetX,offsetY
      ,Scan0,Stride,sx,sy,sw,sh,gs,ss,allv,s1,s0
      ,input,num*7,allpos,allpos_max )
    Loop, % ok
      pos:=NumGet(allpos, 4*(A_Index-1), "uint")
      , rx:=(pos&0xFFFF)+zx, ry:=(pos>>16)+zy
      , arr.Push( [rx,ry,w1,h1,comment] )
  }
  else
  {
    For i,j in info
    {
      mode:=j.8, color:=j.9, n:=j.10, comment:=j.11
      , w1:=j.2, h1:=j.3, v:=SubStr(allv, j.1+1, w1*h1)
      Loop, 7
        NumPut(j[A_Index], input, 4*(A_Index-1), "int")
      NumPut(0, input, "int")
      ok:=PicFind( mode,color,n,offsetX,offsetY
        ,Scan0,Stride,sx,sy,sw,sh,gs,ss,v,s1,s0
        ,input,7,allpos,allpos_max )
      Loop, % ok
        pos:=NumGet(allpos, 4*(A_Index-1), "uint")
        , rx:=(pos&0xFFFF)+zx, ry:=(pos>>16)+zy
        , arr.Push( [rx,ry,w1,h1,comment] )
    }
  }
  if (err1=0 and err0=0 and !arr.MaxIndex())
  {
    err1:=err0:=0.1
    For i,j in info
      if (j.6=0 and j.7=0)
        j.6:=Round(j.4*err1), j.7:=Round(j.5*err0)
  }
  else Break
  }
  SetBatchLines, %bch%
  return, arr.MaxIndex() ? arr:0
}

PicFind(mode, color, n, offsetX, offsetY
  , Scan0, Stride, sx, sy, sw, sh
  , ByRef gs, ByRef ss, ByRef text, ByRef s1, ByRef s0
  , ByRef input, num, ByRef allpos, allpos_max)
{
  static MyFunc, Ptr:=A_PtrSize ? "UPtr" : "UInt"
  if !MyFunc
  {
    x32:="5557565383EC788B8424CC0000008BBC24CC000000C7442"
    . "424000000008B40048B7F148944243C8B8424CC000000897C2"
    . "42C8BBC24CC0000008B40088B7F18894424348B8424CC00000"
    . "0897C24308B400C89C6894424288B8424CC0000008B401039C"
    . "6894424200F4DC68944241C8B8424D000000085C00F8E15010"
    . "0008BB424CC0000008B44242489F78B0C868B7486048B44870"
    . "88974241085C0894424180F8ED700000089CD894C2414C7442"
    . "40C00000000C744240800000000C744240400000000890C248"
    . "D76008DBC27000000008B5C24108B7424088B4C24148B54240"
    . "C89DF89F029F101F78BB424C000000001CE85DB7E5E8B0C248"
    . "9EB893C2489D7EB198BAC24C800000083C70483C00189548D0"
    . "083C101390424742C83BC248C0000000389FA0F45D0803C063"
    . "175D48BAC24C400000083C70483C00189549D0083C30139042"
    . "475D48B7424100174241489DD890C2483442404018BB424B00"
    . "000008B442404017424088BBC24A4000000017C240C3944241"
    . "80F8554FFFFFF83442424078B442424398424D00000000F8FE"
    . "BFEFFFF83BC248C000000030F84A00600008B8424A40000008"
    . "BB424A80000000FAF8424AC0000008BBC248C0000008D2CB08"
    . "B8424B00000008BB424A4000000F7D885FF8D0486894424100"
    . "F84F702000083BC248C000000010F845F08000083BC248C000"
    . "000020F84130900008B8424900000008B9C24940000000FB6B"
    . "C24940000000FB6B42490000000C744241800000000C744242"
    . "400000000C1E8100FB6DF0FB6D08B84249000000089D10FB6C"
    . "4894424088B842494000000C1E8100FB6C029C101D08904248"
    . "B442408894C24408B4C240801D829D9894424088D043E894C2"
    . "40489F129F9894424148BBC24B40000008B8424B0000000894"
    . "C240C89E98B6C2440C1E00285FF894424380F8EBA0000008BB"
    . "424B000000085F60F8E910000008B8424A00000008B5424240"
    . "39424BC00000001C8034C243889CF894C244003BC24A000000"
    . "0EB3D8D76008DBC2700000000391C247C3D394C24047F37394"
    . "C24087C3189F30FB6F33974240C0F9EC3397424140F9DC183C"
    . "00483C20121D9884AFF39F8741E0FB658020FB648010FB6303"
    . "9DD7EBE31C983C00483C201884AFF39F875E28BBC24B000000"
    . "0017C24248B4C24408344241801034C24108B442418398424B"
    . "40000000F8546FFFFFF8B8424B00000002B44243C8944240C8"
    . "B8424B40000002B442434894424600F884D0900008B4424288"
    . "BBC24C40000008B74243CC744241000000000C744243800000"
    . "000C7442434000000008D3C8789C583EE01897C246C8974247"
    . "48B44240C85C00F88E70000008B7C24388B8424AC000000BE0"
    . "0000000C704240000000001F8C1E0108944246889F82B84249"
    . "C0000000F49F08B84249C000000897424640FAFB424B000000"
    . "001F8894424708974245C8DB6000000008B04240344241089C"
    . "1894424088B442430394424200F84AA0100008B5C241C89C60"
    . "38C24BC00000031C08B54242C85DB0F8EC8010000897424048"
    . "B7C2420EB2D39C77E1C8BB424C80000008B1C8601CB803B007"
    . "40B836C240401782B8D74260083C0013944241C0F849101000"
    . "039C57ECF8BB424C40000008B1C8601CB803B0174BE83EA017"
    . "9B9830424018B04243944240C0F8D68FFFFFF83442438018BB"
    . "424B00000008B44243801742410394424600F8DEFFEFFFF8B4"
    . "C243483C47889C85B5E5F5DC250008B8424900000008BB424B"
    . "4000000C744240C00000000C744241400000000C1E8100FB6C"
    . "08904248B8424900000000FB6C4894424040FB684249000000"
    . "0894424088B8424B0000000C1E00285F68944242489E88BAC2"
    . "4940000000F8E24FEFFFF8B9C24B000000085DB7E758B9C24A"
    . "00000008B7424148BBC24A000000003B424BC00000001C3034"
    . "424248944241801C78D76008DBC27000000000FB643020FB64"
    . "B012B04242B4C24040FB6132B5424080FAFC00FAFC98D04400"
    . "FAFD28D04888D045039C50F930683C30483C60139DF75C98BB"
    . "C24B0000000017C24148B4424188344240C01034424108B742"
    . "40C39B424B40000000F8566FFFFFFE985FDFFFF85ED7E358B7"
    . "424088BBC24BC00000031C08B54242C8D1C378BB424C400000"
    . "08B0C8601D9803901740983EA010F8890FEFFFF83C00139C57"
    . "5E683BC24D0000000070F8EAA0100008B442474030424C7442"
    . "44007000000896C2444894424288B8424CC00000083C020894"
    . "4243C8B44243C8B9424B00000008B7C24288B0029C28944245"
    . "08B84249800000001F839C20F4EC289C68944244C39FE0F8C0"
    . "90100008B44243C8B700C8B78148B6808897424148B7010897"
    . "C245489C7897424248BB424B40000002B700489F08B7424703"
    . "9C60F4EC68BB424C4000000894424188B47FC89442404C1E00"
    . "201C6038424C8000000894424588B4424648B7C2428037C245"
    . "C3B442418894424040F8F8700000085ED7E268B8C24BC00000"
    . "08B54242431C08D1C398B0C8601D9803901740583EA01784A8"
    . "3C00139C575EA8B4424148B4C245439C8747E85C07E7A8B9C2"
    . "4BC000000896C244831C08B6C245801FBEB0983C0013944241"
    . "4745C8B54850001DA803A0074EC83E90179E78B6C244890834"
    . "424040103BC24B00000008B442404394424180F8D79FFFFFF8"
    . "3442428018B4424283944244C0F8D4CFFFFFF830424018B6C2"
    . "4448B04243944240C0F8D7EFCFFFFE911FDFFFF8B4424288B7"
    . "4245083442440078344243C1C8D4430FF894424288B4424403"
    . "98424D00000000F8F7FFEFFFF8B6C24448B7C24348B0424038"
    . "424A80000008BB424D40000000B4424688D4F01398C24D8000"
    . "0008904BE0F8ED8FCFFFF85ED7E278B7424088BBC24BC00000"
    . "08B8424C40000008D1C378B74246C8B1083C00401DA39F0C60"
    . "20075F283042401894C24348B04243944240C0F8DDEFBFFFFE"
    . "971FCFFFF89F68DBC27000000008B8424B0000000038424A80"
    . "000002B44243C894424248B8424AC000000038424B40000002"
    . "B442434398424AC000000894424380F8F520400008B8424A40"
    . "000008BB424A80000000FAF8424AC000000C74424180000000"
    . "08D04B0038424900000008BB424A0000000894424348B44242"
    . "4398424A80000000F8F2B0100008B8424AC000000C1E010894"
    . "4243C8B442434894424148B8424A8000000894424088B44241"
    . "40FB67C060289C52BAC2490000000893C240FB67C0601897C2"
    . "4040FB63C068B44241C85C00F8E140100008B4424308944241"
    . "08B44242C8944240C31C0EB5D394424207E4A8B9C24C800000"
    . "08B0C8301E90FB6540E020FB65C0E012B14242B5C24040FB60"
    . "C0E0FAFD20FAFDB29F98D14520FAFC98D149A8D144A3994249"
    . "4000000720C836C2410017865908D74260083C0013944241C0"
    . "F84A3000000394424287E9D8B9C24C40000008B0C8301E90FB"
    . "6540E020FB65C0E012B14242B5C24040FB60C0E0FAFD20FAFD"
    . "B29F98D14520FAFC98D149A8D144A3B9424940000000F865BF"
    . "FFFFF836C240C010F8950FFFFFF834424080183442414048B4"
    . "42408394424240F8DF6FEFFFF838424AC000000018BBC24A40"
    . "000008B442438017C24343B8424AC0000000F8DA0FEFFFF8B4"
    . "C241883C4785B5E89C85F5DC250008D7426008B7C24188B442"
    . "43C0B4424088B9C24D40000008D4F013B8C24D80000008904B"
    . "B0F8D84FAFFFF894C2418EB848B8424900000008B8C24B4000"
    . "000C7042400000000C74424040000000083C001C1E00789C78"
    . "B8424B0000000C1E00285C98944240889E889FD0F8ECFF8FFF"
    . "F8B9424B000000085D27E5F8B8C24A00000008B5C2404039C2"
    . "4BC00000001C1034424088944240C038424A000000089C70FB"
    . "651020FB641010FB6316BC04B6BD22601C289F0C1E00429F00"
    . "1D039C50F970383C10483C30139F975D58BBC24B0000000017"
    . "C24048B44240C83042401034424108B342439B424B40000007"
    . "582E94CF8FFFF8B8424B0000000C7042400000000C74424040"
    . "0000000C1E002894424088B8424B400000085C00F8E9200000"
    . "08B8424B000000085C07E6F8B8C24A00000008B5C24048BB42"
    . "4B800000001E9036C240801DE039C24BC000000896C240C03A"
    . "C24A00000000FB651020FB6410183C1040FB679FC83C60183C"
    . "3016BC04B6BD22601C289F8C1E00429F801D0C1F8078846FFC"
    . "643FF0039CD75CC8BB424B0000000017424048B6C240C83042"
    . "401036C24108B0424398424B40000000F856EFFFFFF83BC24B"
    . "4000000020F8E80F7FFFF8B8424BC000000038424B00000008"
    . "BAC24B800000003AC24B0000000C7442404010000008944240"
    . "88B8424B400000083E8018944240C8B8424B000000083C0018"
    . "944241083BC24B0000000027E798B44241089E92B8C24B0000"
    . "0008B5C240889EA8D34288D45FE8904240FB642010FB63A038"
    . "4249000000039F87C360FB67A0239F87C2E0FB6790139F87C2"
    . "60FB63E39F87C1F0FB63939F87C180FB6790239F87C100FB67"
    . "EFF39F87C080FB67E0139F87D04C643010183C20183C30183C"
    . "10183C6013B0C2475A3834424040103AC24B00000008B44240"
    . "48BB424B0000000017424083944240C0F8558FFFFFFE98FF6F"
    . "FFF83C47831C95B89C85E5F5DC2500090909090909090"
    x64:="4157415641554154555756534881EC88000000488B84245"
    . "0010000488BB42450010000448B94245801000089542428448"
    . "944240844898C24E80000008B40048B76144C8BBC244001000"
    . "04C8BB42448010000C74424180000000089442430488B84245"
    . "00100008974241C488BB424500100008B40088B76188944243"
    . "C488B842450010000897424388B400C89C789442440488B842"
    . "4500100008B401039C7894424100F4DC74585D289442454488"
    . "B84245001000048894424200F8ECB000000488B442420448B0"
    . "8448B68048B400885C0894424040F8E940000004489CE44890"
    . "C244531E431FF31ED0F1F8400000000004585ED7E614863142"
    . "4418D5C3D0089F848039424380100004589E0EB1D0F1F0083C"
    . "0014D63D94183C0044183C1014883C20139C34789149E74288"
    . "3F9034589C2440F45D0803A3175D783C0014C63DE4183C0048"
    . "3C6014883C20139C34789149F75D844012C2483C50103BC241"
    . "80100004403A42400010000396C24047582834424180748834"
    . "424201C8B442418398424580100000F8F35FFFFFF83F9030F8"
    . "43D0600008B8424000100008BBC24080100000FAF842410010"
    . "0008BB424000100008D3CB88B842418010000F7D885C9448D2"
    . "C860F841101000083F9010F842008000083F9020F84BF08000"
    . "08B742428C744240400000000C74424180000000089F0440FB"
    . "6CEC1E8104589CC0FB6D84889F08B7424080FB6D44189DB89F"
    . "0440FB6C64889F1C1E8100FB6CD89D60FB6C08D2C0A8B94242"
    . "00100004129C301C3438D040129CE4529C48904248B8424180"
    . "10000C1E00285D2894424080F8E660100004C89BC244001000"
    . "0448BBC24180100004585FF0F8E91040000488B8C24F800000"
    . "04863C74C6354241831D24C03942430010000488D440102EB3"
    . "A0F1F80000000004439C37C4039CE7F3C39CD7C384539CC410"
    . "F9EC044390C240F9DC14421C141880C124883C2014883C0044"
    . "139D70F8E2D040000440FB6000FB648FF440FB648FE4539C37"
    . "EBB31C9EBD58B5C2428448B8C242001000031ED4531E44889D"
    . "84189DB0FB6DB0FB6F48B84241801000041C1EB10450FB6DBC"
    . "1E0024585C98904240F8EA10000004C89BC24400100004C89B"
    . "42448010000448B7C2408448BB424180100004585F67E60488"
    . "B8C24F80000004D63D44C039424300100004863C74531C94C8"
    . "D440102410FB600410FB648FF410FB650FE4429D829F10FAFC"
    . "029DA0FAFC98D04400FAFD28D04888D04504139C7430F93040"
    . "A4983C1014983C0044539CE7FC4033C244501F483C5014401E"
    . "F39AC2420010000758C4C8BBC24400100004C8BB4244801000"
    . "08B8424180100002B4424308904248B8424200100002B44243"
    . "C894424680F88540800008B7C24404D89F5488BAC243001000"
    . "0448B7424104C89FEC74424040000000048C74424280000000"
    . "0C74424200000000089F883E801498D4487044189FF4889442"
    . "4088B44243083E801894424788B042485C00F88D9000000488"
    . "B5C24288B8424100100004D89EC448B6C245401D8C1E010894"
    . "4247089D82B8424F000000089C7B8000000000F49C731FF894"
    . "4246C0FAF842418010000894424648B8424F000000001D8894"
    . "42474908B442404897C24188D1C388B4424384139C60F84AB0"
    . "000004189C131C04585ED448B44241C7F36E9C30000000F1F4"
    . "0004139CE7E1B418B148401DA4863D2807C150000740B4183E"
    . "901782E0F1F4400004883C0014139C50F8E920000004139C78"
    . "9C17ECC8B148601DA4863D2807C15000174BD4183E80179B74"
    . "883C701393C240F8D7AFFFFFF4D89E54883442428018B9C241"
    . "8010000488B442428015C2404394424680F8DFCFEFFFF8B4C2"
    . "42089C84881C4880000005B5E5F5D415C415D415E415FC3458"
    . "5FF7E278B4C241C4C8B4424084889F28B0201D84898807C050"
    . "001740583E90178934883C2044939D075E583BC24580100000"
    . "70F8EE60100008B442478488B8C24500100000344241844896"
    . "C2450448BAC241801000044897C24404883C1204889742410C"
    . "744243C07000000448974244448897C24484989CF895C247C8"
    . "9C64C89642430418B074489EA29C28944245C8B8424E800000"
    . "001F039C20F4EC239F0894424580F8CD0000000418B47148BB"
    . "C2420010000412B7F0449635FFC458B4F08458B670C8944246"
    . "08B442474458B771039C70F4FF8488B44241048C1E3024C8D1"
    . "41848035C24308B442464448D04068B44246C39F84189C37F7"
    . "2904585C97E234489F131D2418B04924401C04898807C05000"
    . "1740583E90178464883C2014139D17FE28B4424604139C40F8"
    . "4AA0000004585E40F8EA100000089C131D2EB0D4883C201413"
    . "9D40F8E8E0000008B04934401C04898807C05000074E483E90"
    . "179DF4183C3014501E84439DF7D8F83C601397424580F8D6EF"
    . "FFFFF488B7C2448448B7C2440448B742444448B6C2450488B7"
    . "424104C8B6424304883C701393C240F8D97FDFFFFE918FEFFF"
    . "F6690037C240844017C241883442404014401EF8B442404398"
    . "424200100000F854DFBFFFF4C8BBC2440010000E996FCFFFF8"
    . "B44245C8344243C074983C71C8D7406FF8B44243C398424580"
    . "100000F8F87FEFFFF448B7C2440448B742444448B6C2450488"
    . "B7C24488B5C247C488B7424104C8B64243048634424208B542"
    . "418039424080100004C8B9C24600100000B5424708D4801398"
    . "C2468010000418914830F8E9AFDFFFF4585FF7E1D4C8B44240"
    . "84889F08B104883C00401DA4C39C04863D2C64415000075EB4"
    . "883C701393C24894C24200F8DBAFCFFFFE93BFDFFFF0F1F440"
    . "0008B842418010000038424080100002B442430894424308B8"
    . "42410010000038424200100002B44243C39842410010000894"
    . "424440F8F230400008B8424000100008BBC24080100000FAF8"
    . "42410010000448B642440448B6C24544C8B8C24F8000000C74"
    . "42420000000008D04B8034424288944243C8B4424303984240"
    . "80100000F8F2F0100008B8424100100008B6C243CC1E010894"
    . "424408B8424080100008904248D450289EF2B7C24284585ED4"
    . "898450FB61C018D45014898410FB61C014863C5410FB634010"
    . "F8E140100008B442438894424188B44241C8944240431C0EB6"
    . "244395424107E4E418B0C8601F98D5102448D41014863C9410"
    . "FB60C094863D24D63C0410FB61411470FB6040129F10FAFC94"
    . "429DA4129D80FAFD2450FAFC08D1452428D14828D144A39542"
    . "4087207836C241801786B4883C0014139C50F8E9E000000413"
    . "9C44189C27E96418B0C8701F98D5102448D41014863C9410FB"
    . "60C094863D24D63C0410FB61411470FB6040129F10FAFC9442"
    . "9DA4129D80FAFD2450FAFC08D1452428D14828D144A3B54240"
    . "80F864BFFFFFF836C2404010F8940FFFFFF8304240183C5048"
    . "B0424394424300F8DEDFEFFFF83842410010000018BBC24000"
    . "100008B442444017C243C3B8424100100000F8D9CFEFFFFE97"
    . "CFBFFFF0F1F0048634424208B5424400B1424488BBC2460010"
    . "0008D48013B8C24680100008914870F8D56FBFFFF830424018"
    . "3C504894C24208B0424394424300F8D82FEFFFFEB93448B5C2"
    . "428448B84242001000031DB8B84241801000031F6448B94241"
    . "80100004183C30141C1E3074585C08D2C85000000000F8E8CF"
    . "9FFFF4585D27E57488B8C24F80000004C63CE4C038C2430010"
    . "0004863C74531C0488D4C01020FB6110FB641FF440FB661FE6"
    . "BC04B6BD22601C24489E0C1E0044429E001D04139C3430F970"
    . "4014983C0014883C1044539C27FCC01EF4401D683C3014401E"
    . "F399C24200100007595E91CF9FFFF8B8C24200100008B84241"
    . "801000031DB31F6448B8C241801000085C98D2C85000000007"
    . "E7D4585C97E694C63C6488B8C24F80000004863C74D89C24C0"
    . "38424300100004C0394242801000031D2488D4C0102440FB61"
    . "90FB641FF4883C104440FB661FA6BC04B456BDB264101C3448"
    . "9E0C1E0044429E04401D8C1F8074188041241C60410004883C"
    . "2014139D17FC401EF4401CE83C3014401EF399C24200100007"
    . "58383BC2420010000020F8E6CF8FFFF4863B424180100008B9"
    . "C24180100008BBC2420010000488D5601448D67FFBF0100000"
    . "04889D0480394243001000048038424280100004889D58D53F"
    . "D4C8D6A0183BC241801000002488D1C067E7E4989C04D8D5C0"
    . "5004989D94929F04889E90FB610440FB650FF035424284439D"
    . "27C44440FB650014439D27C3A450FB6104439D27C31450FB61"
    . "14439D27C28450FB650FF4439D27C1E450FB650014439D27C1"
    . "4450FB651FF4439D27C0A450FB651014439D27D03C60101488"
    . "3C0014983C1014883C1014983C0014C39D8759383C7014801F"
    . "54889D84139FC0F8562FFFFFFE989F7FFFF31C9E9FAF8FFFF9"
    . "0909090909090909090909090"
    MCode(MyFunc, A_PtrSize=8 ? x64:x32)
  }
  return, DllCall(&MyFunc, "int",mode, "uint",color
    , "uint",n, "int",offsetX, "int",offsetY, Ptr,Scan0
    , "int",Stride, "int",sx, "int",sy, "int",sw, "int",sh
    , Ptr,&gs, Ptr,&ss, "AStr",text, Ptr,&s1, Ptr,&s0
    , Ptr,&input, "int",num, Ptr,&allpos, "int",allpos_max)
}

xywh2xywh(x1,y1,w1,h1,ByRef x,ByRef y,ByRef w,ByRef h)
{
  SysGet, zx, 76
  SysGet, zy, 77
  SysGet, zw, 78
  SysGet, zh, 79
  left:=x1, right:=x1+w1-1, up:=y1, down:=y1+h1-1
  left:=left<zx ? zx:left, right:=right>zx+zw-1 ? zx+zw-1:right
  up:=up<zy ? zy:up, down:=down>zy+zh-1 ? zy+zh-1:down
  x:=left, y:=up, w:=right-left+1, h:=down-up+1
}

GetBitsFromScreen(x, y, w, h, ByRef Scan0, ByRef Stride
  , ScreenShot=1, ByRef zx="", ByRef zy="", bpp=32)
{
  static bits, oldx, oldy, oldw, oldh
  static Ptr:=A_PtrSize ? "UPtr" : "UInt", PtrP:=Ptr "*"
  if (ScreenShot or x<oldx or y<oldy
    or x+w>oldx+oldw or y+h>oldy+oldh)
  {
    oldx:=x, oldy:=y, oldw:=w, oldh:=h, ScreenShot:=1
    VarSetCapacity(bits, w*h*4)
  }
  Scan0:=&bits, Stride:=((oldw*bpp+31)//32)*4, zx:=oldx, zy:=oldy
  if (!ScreenShot or w<1 or h<1)
    return
  win:=DllCall("GetDesktopWindow", Ptr)
  hDC:=DllCall("GetWindowDC", Ptr,win, Ptr)
  mDC:=DllCall("CreateCompatibleDC", Ptr,hDC, Ptr)
  ;-------------------------
  VarSetCapacity(bi, 40, 0), NumPut(40, bi, 0, "int")
  NumPut(w, bi, 4, "int"), NumPut(-h, bi, 8, "int")
  NumPut(1, bi, 12, "short"), NumPut(bpp, bi, 14, "short")
  ;-------------------------
  if hBM:=DllCall("CreateDIBSection", Ptr,mDC, Ptr,&bi
    , "int",0, PtrP,ppvBits, Ptr,0, "int",0, Ptr)
  {
    oBM:=DllCall("SelectObject", Ptr,mDC, Ptr,hBM, Ptr)
    DllCall("BitBlt", Ptr,mDC, "int",0, "int",0, "int",w, "int",h
      , Ptr,hDC, "int",x, "int",y, "uint",0x00CC0020|0x40000000)
    DllCall("RtlMoveMemory", Ptr,Scan0, Ptr,ppvBits, Ptr,Stride*h)
    DllCall("SelectObject", Ptr,mDC, Ptr,oBM)
    DllCall("DeleteObject", Ptr,hBM)
  }
  DllCall("DeleteDC", Ptr,mDC)
  DllCall("ReleaseDC", Ptr,win, Ptr,hDC)
}

MCode(ByRef code, hex)
{
  bch:=A_BatchLines
  SetBatchLines, -1
  VarSetCapacity(code, len:=StrLen(hex)//2)
  lls:=A_ListLines=0 ? "Off" : "On"
  ListLines, Off
  Loop, % len
    NumPut("0x" SubStr(hex,2*A_Index-1,2),code,A_Index-1,"uchar")
  ListLines, %lls%
  Ptr:=A_PtrSize ? "UPtr" : "UInt", PtrP:=Ptr . "*"
  DllCall("VirtualProtect",Ptr,&code, Ptr,len,"uint",0x40,PtrP,0)
  SetBatchLines, %bch%
}

base64tobit(s)
{
  Chars:="0123456789+/ABCDEFGHIJKLMNOPQRSTUVWXYZ"
    . "abcdefghijklmnopqrstuvwxyz"
  SetFormat, IntegerFast, d
  StringCaseSense, On
  lls:=A_ListLines=0 ? "Off" : "On"
  ListLines, Off
  Loop, Parse, Chars
  {
    i:=A_Index-1, v:=(i>>5&1) . (i>>4&1)
      . (i>>3&1) . (i>>2&1) . (i>>1&1) . (i&1)
    s:=StrReplace(s,A_LoopField,v)
  }
  ListLines, %lls%
  StringCaseSense, Off
  s:=SubStr(s,1,InStr(s,"1",0,0)-1)
  s:=RegExReplace(s,"[^01]+")
  return, s
}

bit2base64(s)
{
  s:=RegExReplace(s,"[^01]+")
  s.=SubStr("100000",1,6-Mod(StrLen(s),6))
  s:=RegExReplace(s,".{6}","|$0")
  Chars:="0123456789+/ABCDEFGHIJKLMNOPQRSTUVWXYZ"
    . "abcdefghijklmnopqrstuvwxyz"
  SetFormat, IntegerFast, d
  lls:=A_ListLines=0 ? "Off" : "On"
  ListLines, Off
  Loop, Parse, Chars
  {
    i:=A_Index-1, v:="|" . (i>>5&1) . (i>>4&1)
      . (i>>3&1) . (i>>2&1) . (i>>1&1) . (i&1)
    s:=StrReplace(s,v,A_LoopField)
  }
  ListLines, %lls%
  return, s
}

ASCII(s)
{
  if RegExMatch(s,"\$(\d+)\.([\w+/]+)",r)
  {
    s:=RegExReplace(base64tobit(r2),".{" r1 "}","$0`n")
    s:=StrReplace(StrReplace(s,"0","_"),"1","0")
  }
  else s=
  return, s
}

; You can put the text library at the beginning of the script,
; and Use Pic(Text,1) to add the text library to Pic()'s Lib,
; Use Pic("comment1|comment2|...") to get text images from Lib

Pic(comments, add_to_Lib=0)
{
  static Lib:=[]
  if (add_to_Lib)
  {
    re:="<([^>]*)>[^$]+\$\d+\.[\w+/]+"
    Loop, Parse, comments, |
      if RegExMatch(A_LoopField,re,r)
        Lib[Trim(r1)]:=r
    Lib[""]:=""
  }
  else
  {
    Text:=""
    Loop, Parse, comments, |
      Text.="|" . Lib[Trim(A_LoopField)]
    return, Text
  }
}

PicN(Number)
{
  return, Pic( RegExReplace(Number, ".", "|$0") )
}

; Use PicX(Text) to automatically cut into multiple characters
; Can't be used in ColorPos mode, because it can cause position errors

PicX(Text)
{
  if !RegExMatch(Text,"\|([^$]+)\$(\d+)\.([\w+/]+)",r)
    return, Text
  w:=r2, v:=base64tobit(r3), Text:=""
  c:=StrLen(StrReplace(v,"0"))<=StrLen(v)//2 ? "1":"0"
  wz:=RegExReplace(v,".{" w "}","$0`n")
  SetFormat, IntegerFast, d
  While InStr(wz,c) {
    While !(wz~="m`n)^" c)
      wz:=RegExReplace(wz,"m`n)^.")
    i:=0
    While (wz~="m`n)^.{" i "}" c)
      i++
    v:=RegExReplace(wz,"m`n)^(.{" i "}).*","$1")
    wz:=RegExReplace(wz,"m`n)^.{" i "}")
    if v!=
      Text.="|" r1 "$" i "." bit2base64(v)
  }
  return, Text
}

; Screenshot and retained as the last screenshot.

ScreenShot()
{
  n:=150000
  xywh2xywh(-n,-n,2*n+1,2*n+1,x,y,w,h)
  GetBitsFromScreen(x,y,w,h,Scan0,Stride,1)
}

FindTextOCR(nX, nY, nW, nH, err1, err0, Text, Interval=20)
{
  OCR:="", RightX:=nX+nW-1, ScreenShot()
  While (ok:=FindText(nX, nY, nW, nH, err1, err0, Text, 0))
  {
    For k,v in ok
    {
      ; X is the X coordinates of the upper left corner
      ; and W is the width of the image have been found
      x:=v.1, y:=v.2, w:=v.3, h:=v.4, comment:=v.5
      ; We need the leftmost X coordinates
      if (A_Index=1 or x<LeftX)
        LeftX:=x, LeftY:=y, LeftW:=w, LeftH:=h, LeftOCR:=comment
      else if (x=LeftX)
      {
        Loop, 100
        {
          err:=A_Index/100
          if FindText(x, y, w, h, err, err, Text, 0)
          {
            LeftX:=x, LeftY:=y, LeftW:=w, LeftH:=h, LeftOCR:=comment
            Break
          }
          if FindText(LeftX, LeftY, LeftW, LeftH, err, err, Text, 0)
            Break
        }
      }
    }
    ; If the interval exceeds the set value, add "*" to the result
    OCR.=(A_Index>1 and LeftX-nX-1>Interval ? "*":"") . LeftOCR
    ; Update nX and nW for next search
    nX:=LeftX+LeftW-1, nW:=RightX-nX+1
  }
  return, OCR
}

; Reordering the objects returned from left to right,
; from top to bottom, ignore slight height difference

SortOK(ok, dy=10) {
  if !IsObject(ok)
    return, ok
  SetFormat, IntegerFast, d
  For k,v in ok
  {
    x:=v.1+v.3//2, y:=v.2+v.4//2
    y:=A_Index>1 and Abs(y-lasty)<dy ? lasty : y, lasty:=y
    n:=(y*150000+x) "." k, s:=A_Index=1 ? n : s "-" n
  }
  Sort, s, N D-
  ok2:=[]
  Loop, Parse, s, -
    ok2.Push( ok[(StrSplit(A_LoopField,".")[2])] )
  return, ok2
}

; Reordering according to the nearest distance

SortOK2(ok, px, py) {
  if !IsObject(ok)
    return, ok
  SetFormat, IntegerFast, d
  For k,v in ok
  {
    x:=v.1+v.3//2, y:=v.2+v.4//2
    n:=((x-px)**2+(y-py)**2) "." k
    s:=A_Index=1 ? n : s "-" n
  }
  Sort, s, N D-
  ok2:=[]
  Loop, Parse, s, -
    ok2.Push( ok[(StrSplit(A_LoopField,".")[2])] )
  return, ok2
}

; Prompt mouse position in remote assistance

MouseTip(x="", y="") {
  if (x="")
  {
    VarSetCapacity(pt,16,0), DllCall("GetCursorPos","ptr",&pt)
    x:=NumGet(pt,0,"uint"), y:=NumGet(pt,4,"uint")
  }
  x:=Round(x-10), y:=Round(y-10), w:=h:=2*10+1
  ;-------------------------
  Gui, _MouseTip_: +AlwaysOnTop -Caption +ToolWindow +Hwndmyid +E0x08000000
  Gui, _MouseTip_: Show, Hide w%w% h%h%
  ;-------------------------
  dhw:=A_DetectHiddenWindows
  DetectHiddenWindows, On
  d:=4, i:=w-d, j:=h-d
  s=0-0 %w%-0 %w%-%h% 0-%h% 0-0
  s=%s%  %d%-%d% %i%-%d% %i%-%j% %d%-%j% %d%-%d%
  WinSet, Region, %s%, ahk_id %myid%
  DetectHiddenWindows, %dhw%
  ;-------------------------
  Gui, _MouseTip_: Show, NA x%x% y%y%
  Loop, 4 {
    Gui, _MouseTip_: Color, % A_Index & 1 ? "Red" : "Blue"
    Sleep, 500
  }
  Gui, _MouseTip_: Destroy
}


/***** C source code of machine code *****

int __attribute__((__stdcall__)) PicFind(
  int mode, unsigned int c, unsigned int n
  , int offsetX, int offsetY, unsigned char * Bmp
  , int Stride, int sx, int sy, int sw, int sh
  , unsigned char * gs, char * ss, char * text
  , int * s1, int * s0, int * input, int num
  , unsigned int * allpos, int allpos_max)
{
  int o, i, j, x, y, r, g, b, rr, gg, bb, max, e1, e0, ok;
  int o1, x1, y1, w1, h1, sx1, sy1, len1, len0, err1, err0;
  int o2, x2, y2, w2, h2, sx2, sy2, len21, len20, err21, err20;
  int r_min, r_max, g_min, g_max, b_min, b_max;
  //----------------------
  ok=0; w1=input[1]; h1=input[2];
  len1=input[3]; len0=input[4];
  err1=input[5]; err0=input[6];
  max=len1>len0 ? len1 : len0;
  //----------------------
  // Generate Lookup Table
  for (j=0; j<num; j+=7)
  {
    o=o1=o2=input[j]; w2=input[j+1]; h2=input[j+2];
    for (y=0; y<h2; y++)
    {
      for (x=0; x<w2; x++)
      {
        i=(mode==3) ? y*Stride+x*4 : y*sw+x;
        if (text[o++]=='1')
          s1[o1++]=i;
        else
          s0[o2++]=i;
      }
    }
  }
  // Color Position Mode
  // This mode is not support combination lookup
  // only used to recognize multicolored Verification Code
  if (mode==3)
  {
    sx1=sx+sw-w1; sy1=sy+sh-h1;
    for (y=sy; y<=sy1; y++)
    {
      for (x=sx; x<=sx1; x++)
      {
        o=y*Stride+x*4; e1=err1; e0=err0;
        j=o+c; rr=Bmp[2+j]; gg=Bmp[1+j]; bb=Bmp[j];
        for (i=0; i<max; i++)
        {
          if (i<len1)
          {
            j=o+s1[i]; r=Bmp[2+j]-rr; g=Bmp[1+j]-gg; b=Bmp[j]-bb;
            if (3*r*r+4*g*g+2*b*b>n && (--e1)<0)
              goto NoMatch3;
          }
          if (i<len0)
          {
            j=o+s0[i]; r=Bmp[2+j]-rr; g=Bmp[1+j]-gg; b=Bmp[j]-bb;
            if (3*r*r+4*g*g+2*b*b<=n && (--e0)<0)
              goto NoMatch3;
          }
        }
        allpos[ok++]=y<<16|x;
        if (ok>=allpos_max)
          goto Return1;
        NoMatch3:
        continue;
      }
    }
    goto Return1;
  }
  // Generate Two Value Image
  o=sy*Stride+sx*4; j=Stride-4*sw; i=0;
  if (mode==0)  // Color Mode
  {
    rr=(c>>16)&0xFF; gg=(c>>8)&0xFF; bb=c&0xFF;
    for (y=0; y<sh; y++, o+=j)
      for (x=0; x<sw; x++, o+=4, i++)
      {
        r=Bmp[2+o]-rr; g=Bmp[1+o]-gg; b=Bmp[o]-bb;
        ss[i]=(3*r*r+4*g*g+2*b*b<=n) ? 1:0;
      }
  }
  else if (mode==1)  // Gray Threshold Mode
  {
    c=(c+1)*128;
    for (y=0; y<sh; y++, o+=j)
      for (x=0; x<sw; x++, o+=4, i++)
        ss[i]=(Bmp[2+o]*38+Bmp[1+o]*75+Bmp[o]*15<c) ? 1:0;
  }
  else if (mode==2)  // Gray Difference Mode
  {
    for (y=0; y<sh; y++, o+=j)
    {
      for (x=0; x<sw; x++, o+=4, i++)
      {
        gs[i]=(Bmp[2+o]*38+Bmp[1+o]*75+Bmp[o]*15)>>7;
        ss[i]=0;
      }
    }
    sx1=sw-2; sy1=sh-2;
    for (y=1; y<=sy1; y++)
      for (x=1; x<=sx1; x++)
      {
        i=y*sw+x; j=gs[i]+c;
        if ( gs[i-1]>j || gs[i+1]>j
          || gs[i-sw]>j || gs[i+sw]>j
          || gs[i-sw-1]>j || gs[i-sw+1]>j
          || gs[i+sw-1]>j || gs[i+sw+1]>j )
            ss[i]=1;
      }
  }
  else // (mode==4) Color Difference Mode
  {
    r=(c>>16)&0xFF; g=(c>>8)&0xFF; b=c&0xFF;
    rr=(n>>16)&0xFF; gg=(n>>8)&0xFF; bb=n&0xFF;
    r_min=r-rr; g_min=g-gg; b_min=b-bb;
    r_max=r+rr; g_max=g+gg; b_max=b+bb;
    for (y=0; y<sh; y++, o+=j)
      for (x=0; x<sw; x++, o+=4, i++)
      {
        r=Bmp[2+o]; g=Bmp[1+o]; b=Bmp[o];
        ss[i]=(r>=r_min && r<=r_max
            && g>=g_min && g<=g_max
            && b>=b_min && b<=b_max) ? 1:0;
      }
  }
  // Start Lookup
  sx1=sw-w1; sy1=sh-h1;
  for (y=0; y<=sy1; y++)
  {
    for (x=0; x<=sx1; x++)
    {
      o=y*sw+x; e1=err1; e0=err0;
      if (e0==len0)
      {
        for (i=0; i<len1; i++)
          if (ss[o+s1[i]]!=1 && (--e1)<0)
            goto NoMatch1;
      }
      else
      {
        for (i=0; i<max; i++)
        {
          if (i<len1 && ss[o+s1[i]]!=1 && (--e1)<0)
            goto NoMatch1;
          if (i<len0 && ss[o+s0[i]]!=0 && (--e0)<0)
            goto NoMatch1;
        }
      }
      //------------------
      if (num>7)
      {
        x1=x+w1-1; y1=y-offsetY; if (y1<0) y1=0;
        for (j=7; j<num; j+=7)
        {
          o2=input[j]; w2=input[j+1]; h2=input[j+2];
          len21=input[j+3]; len20=input[j+4];
          err21=input[j+5]; err20=input[j+6];
          sx2=sw-w2; i=x1+offsetX; if (i<sx2) sx2=i;
          sy2=sh-h2; i=y+offsetY; if (i<sy2) sy2=i;
          for (x2=x1; x2<=sx2; x2++)
          {
            for (y2=y1; y2<=sy2; y2++)
            {
              o1=y2*sw+x2; e1=err21; e0=err20;
              for (i=0; i<len21; i++)
              {
                if (ss[o1+s1[o2+i]]!=1 && (--e1)<0)
                  goto NoMatch2;
              }
              if (e0!=len20)
              {
                for (i=0; i<len20; i++)
                  if (ss[o1+s0[o2+i]]!=0 && (--e0)<0)
                    goto NoMatch2;
              }
              goto MatchOK;
              NoMatch2:
              continue;
            }
          }
          goto NoMatch1;
          MatchOK:
          x1=x2+w2-1;
        }
      }
      //------------------
      allpos[ok++]=(sy+y)<<16|(sx+x);
      if (ok>=allpos_max)
        goto Return1;
      // Clear the image that has been found
      for (i=0; i<len1; i++)
        ss[o+s1[i]]=0;
      NoMatch1:
      continue;
    }
  }
  Return1:
  return ok;
}

*/

;================= The End =================

;