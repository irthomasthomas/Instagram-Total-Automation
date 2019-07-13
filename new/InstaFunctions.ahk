#include CLR.ahk
#include JSON.ahk
#include FindTextFunctions.ahk

global client_id :=
global client_secret :=
global refresh_token :=
global influencer_sheetkey :=
global status_sheetkey :=

loadConfig()

global myAccessToken := googleAccessToken(client_id, client_secret, refresh_token)
OpenUrlChrome(URL, profile){
	;msgbox % "profile " profile " url " URL
	run, %profile% %URL%, , max
		  
}

loadConfig() {
	if FileExist( "settings.dll" ) {
	FileCopy, settings.dll, c:\instasettings.dll
	Sleep 1000
	asm := CLR_LoadLibrary("c:\instasettings.dll ")
    obj := CLR_CreateObject(asm, "Settings")
    global client_id := obj.gcc()
	global client_secret := obj.gcs()
    global refresh_token := obj.grt()
	global influencer_sheetkey := obj.gis()
	global status_sheetkey:= obj.gss()
	; msgbox % "yep client_id " client_id " ig_name " ig_name " influencer_sheetkey " influencer_sheetkey
	}
	else
	{
		MsgBox setting.dll not found
		ExitApp
	}
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
		ExitApp
	}
}

closeChrome() {
	; Get all hWnds (window IDs) created by chrome.exe processes.
	WinGet hWnds, List, ahk_exe chrome.exe
	;WinGet hWnds, List, ahk_exe opera.exe
	Loop, %hWnds%
	{
	  hWnd := % hWnds%A_Index% ; get next hWnd
	  PostMessage, 0x112, 0xF060,,, ahk_id %hWnd%
	}
}

kardashianURL(){
	Random, targetN, 1, 2
	If targetN = 1
	{
		URL=https://www.instagram.com/kyliejenner/
	}
	Else If targetN = 2
	{
		URL=https://www.instagram.com/kendalljenner/
	}
	Else URL=https://www.instagram.com/kimkardashian/
	return, URL
}

SleepRand(x:=0,y:=0, debug:=False) {
	If x = 0
	{
		Random, x, 1, 11
	}
	If y  = 0
	{		
		Random, y, %x%, (x+200)
	}
	Random, rand, %x%, %y%
	If debug
	{
		MsgBox % rand
	}
	Sleep, %rand%
}

chromeProfilePath(profile:=0)
{
	global myAccessToken
    sheetId := "1LBsGtFQu_G8h5_RHX96W36iRDPwn9si9FyUOwf_B4dU"
	range1 := "A:C"
	url := "https://sheets.googleapis.com/v4/spreadsheets/" sheetId "/values/" range1  "?access_token=" myAccessToken	
	oArray := json.Load(UrlDownloadToVar(url))
	if not profile
	{
		Random, row, 2, 5
		chromePath := oArray.values[row][2]
	}
	While !chromePath
	{
		chromePath := oArray.values[A_Index][1] = profile ? oArray.values[A_Index][2] : 
	}
	Return chromePath
    ; Return % Array(chromePath, userAccount,sheetId)
}

googleAccessToken(client_id, client_secret, refresh_token) 
{
    
	StringReplace, client_id, client_id, %A_SPACE%,, All
    StringReplace, client_secret, client_secret, %A_SPACE%,, All
    StringReplace, refresh_token, refresh_token, %A_SPACE%,, All
	;msgbox client_id %client_id% client_secret %client_secret% refresh_token %refresh_token% 
    
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

URLDownloadToVar(url) 
{
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
      return error
    }
}

ClickPost(postN){
	ToolTip, CLICK INSTA POST,0,930
	MouseMove, 650, 450
	SleepRand(100,1500)
	Loop 3
	{
		MouseClick, WheelDown
		SleepRand(100,1500)
		Text:="|<grid/posts>*175$12.TyzyWGmGzyWGmGzymGWGzy00U"
		if (ok:=FindText(531-500//2, 733-900//2, 700, 800, 0, 0, Text))
		{
			CoordMode, Mouse
			X:=ok.1.1, Y:=ok.1.2, W:=ok.1.3, H:=ok.1.4, Comment:=ok.1.5, X+=W//2, Y+=H//2
			Y2 := Round((Y/40))
			If Y2 <= 10
			{
				Sleep 500
				moveY := 10-Y2
				Loop %moveY%
				{
					Send {Up}
					Sleep 400
				}
			}
			Else
			{   
				Sleep 500
				moveY := Y2-10
				Loop %moveY%
				{
					Send {Down}
					Sleep 400
				}
			}
		}
		If postN = 1
		{
			Random,x,220,480
			Random,y,465,700
		}
		Else If postN = 2
		{
			Random,x,545,800
			Random,y,465,700
		}
		
			MouseMove, %x%, %y%
			SleepRand(150,1100)
			Click
			SleepRand(1500,2933)
			Text:="|<post a co>*207$71.0000000000001U10E00000003U20U000000051wT0S0QD5r0P6Na161AnAm0a8G404212F434EY81sA26W87wV8ECEM4B4E892EUEUE8G8UkPAn0X0aNYF10nsy1u0sS8W000000000000U"
			if (ok:=FindText(789-900//2, 674-900//2, 900, 900, 0, 0, Text))
			{
				CoordMode, Mouse
				X:=ok.1.1, Y:=ok.1.2, W:=ok.1.3, H:=ok.1.4, Comment:=ok.1.5, X+=W//2, Y+=H//2
				;Click, %X%, %Y%
				Return True
			}
			Else Continue
	}
	Return False
}

Report(profile, result, cell) {
	accountName := profile[2]
	account := 	; leave blank
	
	functionName := result[1]
	startTime := result[2]
	endTime := result[3]
	unfollowCount := result[4]
	liked := result[5]
	followed := result[6]
	comments := result[7]
		
	updateValues =  "%accountName%", "%account%", "%functionName%", "%startTime%", "%endTime%", "%unfollowCount%", "%liked%", "%followed%", %comments%
	response := GsheetAppendRow(status_sheetkey, myAccessToken, cell, updateValues)
	return response
}

LogError(e) {
	FormatTime, time, ,yyyy-M-d HH:mm:ss tt
	sheetkey := "1q7pJF4l0tIpEud62UwfHAOXbIFWQ8EQxN8wZCAWjv6Q"
	module := e.module, msg := e.msg, account := e.account
	updateValues = "%time%", "%module%", "%msg%", "%account%"
	response := GsheetAppendRow(sheetkey, myAccessToken, "Sheet1!A:E", updateValues)
	return response
}

GsheetAppendRow(SheetKey, accessToken, cell, values)
{
	url := "https://sheets.googleapis.com/v4/spreadsheets/" SheetKey "/values/" cell  ":append?includeValuesInResponse=true&valueInputOption=USER_ENTERED&access_token=" accessToken
	data = {"majorDimension":"ROWS","range":"%cell%","values":[[%values%]]}
	Return PutURL(url, data, "post")
}

PutURL(url, data, method:="put") {
	hObject:=ComObjCreate("WinHttp.WinHttpRequest.5.1")
	hObject.Open(method, url, false)
	hObject.SetRequestHeader("Content-Type", "application/json")
	hObject.Send(data)
	response := hObject.ResponseText
	hObject :=
	return response        
}
