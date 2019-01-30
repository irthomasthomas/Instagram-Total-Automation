#NoEnv
;#include c:\instabot\JSON.ahk
;#include json2.ahk
;#include functions.ahk
;#include c:\instabot\CLR.ahk
SendMode Input
SetWorkingDir %A_ScriptDir%
#SingleInstance,Force

ComObjError(false)
/* 
if FileExist( "c:\instabot\settings.dll" ) {
	asm := CLR_LoadLibrary("c:\instabot\settings.dll")
    obj := CLR_CreateObject(asm, "Settings")
	 */

if FileExist( "settings.dll" )
{
	;FileCopy, c:\instabot\settings.dll, c:\instabot\
	Sleep 100
	;asm := CLR_LoadLibrary("e:\development\instabot\settings.dll")
	asm := CLR_LoadLibrary("c:\instabot\settings.dll")
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

;
;append row and then update row
;

if FileExist( "settings.ini" ) {	
    IniRead, influencer_hotkey, settings.ini, General, influencer_hotkey
	IniRead, login_type, settings.ini, General, login_type
    IniRead, e_session_id, settings.ini, Session, session_id
	if (e_session_id) && (e_session_id <> "ERROR")
    {
        session_id := e_session_id
    }
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
    ;ToolTip, control.ahk startapp(), 0, 900
    ;StartTest()
    ;SearchHashtag()
    ;BrowseFeed()
    ;FollowFromGsheet()
    ;Unfollow()
    ;Start()
    /* 
    gosub, HelpScreen
    Hotkey, %influencer_hotkey%, CheckInfluencerList
    Hotkey, F1, HelpScreen
    ;SetTimer, CheckWings, 60000
    return
     */
}

/* HelpScreen
HelpScreen:
{
    Gui, Destroy
    Gui, +lastFound +Owner +AlwaysOnTop -border -caption -ToolWindow
    Gui, Color, 000000
    Gui, margin, 20,20
    Gui, Font, s22 bold
    Gui, Add, Text, xm-2 cWhite section, Assistant 
    Gui, Font, s10 cLime normal
    Gui, Add, Text, xp+2 yp+32 , list of key commands
	
	Gui, Font, s22 bold
    Gui, Add, Text, xm cYellow section, F1
    Gui, Font, s11 normal
    Gui, Add, Text, ys cWhite w300, HELP SCREEN
	
	Gui, Font, s22 bold
    Gui, Add, Text, xm cYellow section, %influencer_hotkey%
    Gui, Font, s11 normal
    Gui, Add, Text, ys cWhite w300, List Influencers
	
	WinSet, TransColor, EE0000 175
    Gui, Show, Center autosize, InfluencerCheck
	
	return  
}
 */
 
 /* check influencers
CheckInfluencerList:
{
	Gui, Destroy    
    Suspend, On
    
    if influencer_sheetkey <> ""
    {
        msgalertcolor = cYellow
        msxtxtcolor = cWhite
    }
    else
    {
        ErrorGui()
        ExitApp
    }
	
	Gui, +lastFound +Owner +AlwaysOnTop -border -caption -ToolWindow
    Gui, Color, 000000
    Gui, margin, 40,20
    Gui, font, s18 cwhite
    Gui, Add, Text, center cWhite, .... Scanning Influencer Sheet ....
    WinSet, TransColor, EE0000 175
    Gui, Show, Center autosize, ScanInfluencers
	
	;myAccessToken := GetAccessCode(client_id, client_secret, refresh_token)
	;myrange := "A2%3AA"
	myrange := "A2:A"	
    influencerSheetData := GetWorksheetRange(influencer_sheetkey, myAccessToken, myrange)
	oArray := json.Load(influencerSheetData)
	
	output := json.Dump(oArray)
	Gui, Destroy
	msgbox % oArray.values.1.1
	Loop % oArray.values.MaxIndex()
	{
		target := % oArray.values[A_Index][1]
		;MsgBox % "Element number " . A_Index . " is " . oArray.values.[A_Index].1
		MsgBox % target
	}
	
	; msgbox % oArray.values.3.1
	; msgbox % output

}
 */

UpdateGSheetCell(SheetKey, accessToken, cell, value)
{
	
	url := "https://sheets.googleapis.com/v4/spreadsheets/" SheetKey "/values/" cell  "?includeValuesInResponse=true&valueInputOption=RAW&access_token=" accessToken
	data = {"majorDimension":"ROWS","range":"%cell%","values":[["%value%"]]}
	Clipboard = %url%
	Return PutURL(url, data)
}

GsheetAppendRow(SheetKey, accessToken, cell, values)
{
 /* 
	url := "https://sheets.googleapis.com/v4/spreadsheets/" SheetKey "/values/" cell  ":append?includeValuesInResponse=true&valueInputOption=RAW&access_token=" accessToken
	 */
	 
	url := "https://sheets.googleapis.com/v4/spreadsheets/" SheetKey "/values/" cell  ":append?includeValuesInResponse=true&valueInputOption=USER_ENTERED&access_token=" accessToken
	data = {"majorDimension":"ROWS","range":"%cell%","values":[[%values%]]}
	
	Return PutURL(url, data, "post")
}

UpdateStatusSheet(result, accessToken, cell="Sheet1!A1:F1") {	
	status := GsheetAppendRow(status_sheetkey, accessToken, cell, result)
	Return status
}

GetWorksheetRange(SheetKey, accessToken, ranges)
{
	url := "https://sheets.googleapis.com/v4/spreadsheets/" sheetkey "/values/" ranges "?access_token=" accessToken
    sheetBatch := URLDownloadToVar(url)
	Return sheetBatch
}

URLDownloadToVar(url) {
    if url <> ""
    {
        hObject:=ComObjCreate("WinHttp.WinHttpRequest.5.1")
        hObject.Open("GET", url)
        hObject.Send()
        response := hObject.ResponseText
        hObject :=
        return response
    }
    else
    {
        ErrorGui("ERROR! Exiting...")
        ExitApp
    }
}

PutURL(url, data, method:="put") {
    if url <> ""
    {
        hObject:=ComObjCreate("WinHttp.WinHttpRequest.5.1")
        hObject.Open(method, url, false)
		hObject.SetRequestHeader("Content-Type", "application/json")
        hObject.Send(data)
        response := hObject.ResponseText
        hObject :=
        return response
    }
    else
    {
        ErrorGui("ERROR! Exiting...")
        ExitApp
    }
}

GetAccessCode(client_id, client_secret, refresh_token) 
{
    StringReplace, client_id, client_id, %A_SPACE%,, All
    StringReplace, client_secret, client_secret, %A_SPACE%,, All
    StringReplace, refresh_token, refresh_token, %A_SPACE%,, All
    aURL := "https://www.googleapis.com/oauth2/v3/token"
    aPostData := "client_id=" client_id "&client_secret=" client_secret "&refresh_token=" refresh_token "&grant_type=refresh_token"
    oHTTP := ComObjCreate("WinHttp.WinHttpRequest.5.1")
    oHTTP.Open("POST", aURL , False)
    oHTTP.SetRequestHeader("Content-Type", "application/x-www-form-urlencoded")
    oHTTP.Send(aPostData)
    data1 := oHTTP.ResponseText
    parsedAToken := JSON.Load(data1, true)
    parsedAccessToken := parsedAToken.access_token
    oHTTP :=
    return parsedAccessToken
}

FindImg(img, action:=1, lp:=5, sx:=180, sy:=70, ex:=1190, ey:=710, rand:=1, xr:=0, yr:=0, Debug:=False)
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

SleepRand(s:=0,e:=0) {
    ; 
	If s = 0
	{
		Random, s, 1, 11
	}
	If e  = 0
	{		
		Random, e, %s%, (s+200)
	}
	Random, rand, %s%, %e%
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