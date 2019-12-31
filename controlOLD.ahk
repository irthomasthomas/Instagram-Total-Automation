#NoEnv
SendMode Input
SetWorkingDir %A_ScriptDir%
#SingleInstance,Force

ComObjError(false)
/* 
if FileExist( "c:\instabot\settings.dll" ) {
	asm := CLR_LoadLibrary("c:\instabot\settings.dll")
    obj := CLR_CreateObject(asm, "Settings")
	 */

if FileExist( "settings.dll" ) {
	FileCopy, settings.dll, c:\instabot\settings.dll
	Sleep 100
	asm := CLR_LoadLibrary("c:\instabot\settings.dll")
	; asm := CLR_LoadLibrary("settings.dll")
    obj := CLR_CreateObject(asm, "Settings")
	
    global client_id := obj.gcc()
	global client_secret := obj.gcs()
    global refresh_token := obj.grt()
	global ig_name := obj.gon()
	global influencer_sheetkey := obj.gis()
	global status_sheetkey:= obj.gss()
	;msgbox % " client_id " client_id " ig_name " ig_name " status_sheetkey " status_sheetkey
	
}
else
{
	MsgBox setting.dll not found
    ErrorGui("setting.dll file not found. Exiting...")
    ExitApp
}
;msgbox % " client_id " client_id " client_secret " client_secret " refresh_token " refresh_token
global myAccessToken := GetAccessCode(client_id, client_secret, refresh_token)
;msgbox myAccessToken %myAccessToken%
;
;append row and then update row
;

if FileExist( "settings.ini" ) {	
    FileCopy, settings.ini, c:\instabot\settings.ini
    IniRead, influencer_hotkey, settings.ini, General, influencer_hotkey
	IniRead, login_type, settings.ini, General, login_type
    IniRead, e_session_id, settings.ini, Session, session_id
	if (e_session_id) && (e_session_id <> "ERROR")
    {
        session_id := e_session_id
    }
	/* 
	if influencer_sheetkey <> ""
    {
        influencerWS := getWSnames(influencer_sheetkey, myAccessToken)
    }
	if % influencerWS.length()
    {
        loop, % influencerWS.length()
        {
            IniRead, influencerWS_bcg_%A_index%, settings.ini, Worksheets, influencerWS_bcg_%A_index%
            ;IniRead, hashtagsWS_txt_%A_index%, settings.ini, Worksheets, hashtagsWS_txt_%A_index%
        }
    }
	 */
}
else
{
	msgbox settings.ini not found
    ErrorGui("setting.ini file not found. Exiting...")
    ExitApp
}
    isLogged := 1
    goto, StartApp

StartApp:
{
}

FindImg(img, action:=1, lp:=5, sx:=180, sy:=70, ex:=1190, ey:=710, rand:=1, xr:=0, yr:=0,Debug:=False)
{
    Loop % lp
    {
        CoordMode, Pixel, Window
        ImageSearch, FoundX, FoundY, %sx%, %sy%, %ex%, %ey%, %img%
        CenterImgSrchCoords(img, FoundX, FoundY)	
        SleepRand(100,300)
        If rand
        {
            If xr = 0
                xr := 11
            If yr = 0
                yr := 11
            Random, FoundX, (FoundX-xr), (FoundX+xr)
            Sleep 10	
            Random, FoundY, (FoundY-yr), (FoundY+yr)
            Sleep 10
        }
    }
    Until ErrorLevel = 0
    If ErrorLevel = 0
    {
	If Debug = True
		msgbox % FoundX, FoundY
	If action = 1
	{
		MouseMove, %FoundX%, %FoundY%
		SleepRand()
		Click
	}
	Else If action = 2
	{
		MouseMove, %FoundX%, %FoundY%
		SleepRand()
		Click 2
	}
	Else If action = 3
	{
		MouseMove, %FoundX%, %FoundY%
	}
	SleepRand()
	Return True
    }
    Else
    {
        Return False
    }
    SleepRand()
}

CenterImgSrchCoords(File, ByRef CoordX, ByRef CoordY){
	; Tooltip, CenterImgSrchCoords, 0,1000
	; SleepRand(600,1100)
	static LoadedPic
	LastEL := ErrorLevel
	Gui, Pict:Add, Pic, vLoadedPic, %File%
	GuiControlGet, LoadedPic, Pict:Pos
	Gui, Pict:Destroy
	CoordX += LoadedPicW // 2
	CoordY += LoadedPicH // 2
	ErrorLevel := LastEL
}

SleepRand(s:=0,e:=0, debug:=False) {
	If s = 0
	{
		Random, s, 1, 11
	}
	If e  = 0
	{		
		Random, e, (s+10), (s+200)
	}
	Random, rand, %s%, %e%
	If debug
	{
		MsgBox % rand
	}
    If s > 100000
    {
	    cell = Sheet1!A1:G1
        aReport := Array("sleep", s)
		response := Report("", aReport, cell)
    }
	Sleep, %rand%
}

ErrorGui(string="Error while processing. Try again.")
{
    Gui, Destroy
            
    Gui, +lastFound +Owner +AlwaysOnTop -border -caption -ToolWindow
    Gui, Color, 000000
    Gui, margin, 40,20
    Gui, font, s18 cwhite
    Gui, Add, Text, center cWhite, %string%
    WinSet, TransColor, EE0000 175
    Gui, show, autosize

    ;showAndBreak(status_hotkey, operations_hotkey, wing_enter_hotkey, all_wings_hotkey)
    
    Gui, Destroy
    Suspend, Off
    Return
}

/* 

GuiClose:
GuiCancel:
GuiEscape:
    Gui, Destroy
    Suspend, Off 
 */