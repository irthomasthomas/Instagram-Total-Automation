#include CLR.ahk
#include JSON.ahk
#include FindTextFunctions.ahk

global client_id :=
global client_secret :=
global refresh_token :=
global influencer_sheetkey :=
global status_sheetkey :=
global comment_sheetkey := "1eWbBKYwzBxRRrNUrEWB--AefZHZT1K-eXj5_7vDtO-o"

loadConfig()

global myAccessToken := googleAccessToken(client_id, client_secret, refresh_token)


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

;CHROME
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

OpenUrlChrome(URL, profile){
	;msgbox % "profile " profile " url " URL
	run, %profile% %URL%, , max
		  
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

; ON PAGE
scrollProfilePage(){
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
}

ClickPost(postN){
	ToolTip, CLICK INSTA POST,0,930
	MouseMove, 650, 450
	SleepRand(100,1500)
	
	Loop 3
	{
		scrollProfilePage()

		If postN = 1
		{
			Random, x, 220, 480
			Random, y, 465, 700
		}
		Else If postN = 2
		{
			Random, x, 545, 800
			Random, y, 465, 700
		}
			MouseMove, x, y
			SleepRand(150, 1100)
			Click
			SleepRand(1500, 2933)
			Text:="|<post a co>*207$71.0000000000001U10E00000003U20U000000051wT0S0QD5r0P6Na161AnAm0a8G404212F434EY81sA26W87wV8ECEM4B4E892EUEUE8G8UkPAn0X0aNYF10nsy1u0sS8W000000000000U"
			if !(ok:=FindText(789-900//2, 674-900//2, 900, 900, 0, 0, Text))
			Continue
			ToolTip, CLICKED OK,0,930
			SleepRand(500,2000)
			Return True
	}
	Return False
}

ClickInstaCommentBox(){
	CoordMode, Pixel, Windows
	Tooltip, clickInstaCommentBox , 0,900
	SleepRand(200,333)
	Text:="|<post a co>*207$71.0000000000001U10E00000003U20U000000051wT0S0QD5r0P6Na161AnAm0a8G404212F434EY81sA26W87wV8ECEM4B4E892EUEUE8G8UkPAn0X0aNYF10nsy1u0sS8W000000000000U"
	if (ok:=FindText(789-900//2, 674-900//2, 900, 900, 0, 0, Text))
	{
		CoordMode, Mouse
		X:=ok.1.1, Y:=ok.1.2, W:=ok.1.3, H:=ok.1.4, Comment:=ok.1.5, X+=W//2, Y+=H//2
		Click, %X%, %Y%
		Return True
	}
	Else
		Return False
}

PostComment(cText){
	clicked := ClickInstaCommentBox()
	; If !clicked
	; {
	; 	Send {BS}
	; 	SleepRand(299,755)
	; 	Random,r,1,2
	; 	ClickPost(r)
	; 	SleepRand(1000,1955)
	; 	clicked := ClickInstaCommentBox()
	; 	If !clicked
	; 		Return False
	; }
	SleepRand()
	clipboard := % cText
	SleepRand(1000, 2322)
	send ^v
	SleepRand(1100, 3222)
	send {return}
	SleepRand(1323,2563)
	Tooltip, END PostComment, 0,900
	Return True
}

OpenCommenterProfile() {
	MouseMove, 950, 250
	SleepRand()
	Text:="|<load more>*167$23.0Ds01kQ0A060k06300640U4E104U20/040Q080M0E0kzzVU1030207040O080Y0E140U4A00MA01UA06071k03y0E"
	loop 10 
	{
		MouseClick, WheelDown
		SleepRand()
		if (ok:=FindText(0, 0, A_ScreenWidth, A_ScreenHeight, 0, 0, Text))
		{
			X:=ok.1.1, Y:=ok.1.2, W:=ok.1.3, H:=ok.1.4, Comment:=ok.1.5, X+=W//2, Y+=H//2
			break
		}
		else continue
	}
	MouseMove, X, Y
	SleepRand()
	Click
	SleepRand()
	Loop 4
		MouseClick, WheelDown
	SleepRand()
	PixelGetColor, pColour, 1180, 170
	While (pColour = 0x7D7D7D) && (A_Index < 10)   ;  GREY = a post is open
	{
		Text:="|<white heart>*169$24.3s7k66MM83k4E1U2E002U001U001U001U001U001k003E0028004A00A600M300k1U1U0k300M60048002E001U0U"
        if !(ok:=FindText(776-7000//2, 553-7000//2, 7000, 7000, 0, 0, Text))
        {
            Text:="|<red heart>*187$24.3s7k7yTsDzzwTzzyTzzyzzzzzzzzzzzzzzzzzzzzTzzyTzzyDzzwDzzw7zzs3zzk1zzU0Ty00Dw007s003k001U0U"
            if !(ok:=FindText(776-7000//2, 631-7000//2, 7000, 7000, 0, 0, Text))
            {
			}
		}
		CoordMode, Mouse
        X:=ok.1.1, Y:=ok.1.2, W:=ok.1.3, H:=ok.1.4, Comment:=ok.1.5, X+=W//2, Y+=H//2
        Random, r, 80, 250
        Y -= r
        SleepRand()
        MouseMove, X, Y
        SleepRand()
		Click ; CLICK ON REGION WITH ACCOUNT NAMES
        SleepRand(900,1900)
		PixelGetColor, pColour, 1180, 170 ; 
	}
}

CheckPage(checkOwn:=0, checkBluetick:=0) {
    MouseMove, 400, 400
    SleepRand(500,900)
    MouseClick, WheelUp
    MouseClick, WheelUp
    SleepRand(500,1500)
	Tooltip, CheckPage, 0,900

	Text:="|<private>*153$48.z06000E0zU0000k0laqMltwQlbqMnxwyzb68UAlXz66BUQlzk66BVAlzk6673AlUk6673wwzk6671qQSU"
	if (ok:=FindText(730-70000//2, 444-70000//2, 70000, 70000, 0, 0, Text))
		Return False
	
	Text:="|<no posts>*161$71.0M00000000M01U000zk000M0300030k000k0C000A0k001k0M007k0y001U0k00M00600301U01U006006070020TU400C0C0041VU800Q0M00861UE00M0k00EM1UU00k1U00UU11001U300110220030600220440060A004408800A0M008A0kE00M0k00EA30U00k1k00UAA1003U3U010Dk200703002000400A06006000M00M0A006001U00k0Q007zzy003U0M0000000060U"
	if (ok:=FindText(675-150000//2, 453-150000//2, 150000, 150000, 0, 0, Text))
		Return False
	
	If checkBluetick
	{
		Text:="|<big blue tick>*188$18.0000z01zU7zs7zsDzwTzyTySTwySNyT3yTbyDzw7zs7zs1zU0z0000U"
		if (ok:=FindText(622-300//2, 216-300//2, 300, 300, 0, 0, Text))
			Return False
	}

    Text:="|<>*160$30.7zzzsD000wQ000CQ003Cs007bs0S7bs1zX7s3zk7s7Vs7sD0w7sC0Q7sQ0C7sQ0C7sQ0C7sQ0C7sC0Q7sD0w7s7Vs7s3zk7s1zU7s0S07s0007Q000CQ000CD000wU"
	if (ok:=FindText(202-500//2, 100-500//2, 500, 500, 0, 0, Text))
	{
		Return False
	}

	Text:="|<followers>*159$41.0000000Y0000018000002E000004VtWAS/94N6N6MGMGQa4kYUYd89191BKTm2G2+sU44a4QlU894MlV6EG7VX1sU0000002"
	if !(ok:=FindText(715-500//2, 265-500//2, 500, 500, 0, 0, Text))
		Return False

	If checkOwn = 1
	{
		ToolTip, checkOwn is 2 , 0, 930
		SleepRand(1200,3300)

		Text:="|<THOMAS>*156$60.00000000001y07s01U067zUTy03U0C73kQD07U0SC1ks70DU0yA0kk30zU3yQ0tk3VvU7i00k031XU6C01k0703U0C01k0703U0C03U0C03U0C0700Q03U0C0C00s03U0C0w03k03U0C1s07U03U0C3k0D003U0C7U0S003U0CD00w003U0CC00s003U0CTztzzU3U0CTztzzU3U0C0000000000U"
		if (ok:=FindText(743-120//2, 217-115//2, 110, 135, 0, 0, Text))
			Return False

		Text:="|<PHIL>*158$71.1z00000000003y00000000007s0000000000DU0000000000C00000000000A00000000000M00000000000k00000008001U000000Ds0030000000zk0060000007zU00A000000Tzz00M000000zzz00k000003zzzo1U000007zzzs300001sTzzzk600007xzzztUA0000Dzzzzs0A0000zzzzzy0M0001zzzzzw0k0007zzzzzs1U000Dzzzzzk30000TzzzzzU60000zzzzzz0A0000zzzzzz"
		if (ok:=FindText(600-900//2, 217-350//2, 300, 350, 0, 0, Text))
			Return False

		Text:="|<NPS>*149$71.00000001U0000000000300000000000600000000000A00000000000M000Nw0DUAy0k7k0ry1zkPz1Vzs7sA71kw6330sTUAA1Vk66A0kq0Mk1X04A01XA0lU360AM0D6M1X06A0MkDyAk360AM0lVyANU6A0Mk1X30Mn0AM0lU36A0la0Mk1X04AM1XA0kk670MMk73M1VkQD1UlkS7k31zkPy1Vzg7U60y0nk31wA000001U000000000030000008"
		if (ok:=FindText(566-300//2, 218-300//2, 300, 300, 0, 0, Text))
			Return False

		Text:="|<BLISS>*148$71.k03300000001U0660000000300A00000000600M00000000A00k00000000Mw1VUT07k6T3ry333zUzsBzDsA66C33UkS7nUAAAM360ks7608MMk0A01UAA0Mkls0S030MM0lVVz0Tk60kk1X31zUTsA1VU3660DU3sM3306AA03U0sk660MMMk3A0lUAC0kklk6Q1X0MS31VVkMQ660krw331zkTwA1Vbk661y0TUM32"
		if (ok:=FindText(566-200//2, 217-200//2, 300, 300, 0, 0, Text))
			Return False	
	}
	Return True
}

; REPORTING
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
	msg := e.msg, account := e.account
	updateValues = "%time%", "%msg%", "%account%"
	response := GsheetAppendRow(sheetkey, myAccessToken, "Sheet1!A:E", updateValues)
	return response
}

;GOOGLE SHEETS
gsheet(SheetKey, accessToken, ranges)
{
	url := "https://sheets.googleapis.com/v4/spreadsheets/" sheetkey "/values/" ranges "?access_token=" accessToken
    sheetBatch := URLDownloadToVar(url)
	return sheetBatch
}

GsheetAppendRow(SheetKey, accessToken, cell, values)
{
	url := "https://sheets.googleapis.com/v4/spreadsheets/" SheetKey "/values/" cell  ":append?includeValuesInResponse=true&valueInputOption=USER_ENTERED&access_token=" accessToken
	data = {"majorDimension":"ROWS","range":"%cell%","values":[[%values%]]}
	Return PutURL(url, data, "post")
}

googleAccessToken(client_id, client_secret, refresh_token) 
{
	StringReplace, client_id, client_id, %A_SPACE%,, All
    StringReplace, client_secret, client_secret, %A_SPACE%,, All
    StringReplace, refresh_token, refresh_token, %A_SPACE%,, All
	aURL := "https://www.googleapis.com/oauth2/v3/token"
    aPostData := "client_id=" client_id 
	aPostData .= "&client_secret=" client_secret 
	aPostData .= "&refresh_token=" refresh_token 
	aPostData .= "&grant_type=refresh_token"
    oHTTP := ComObjCreate("WinHttp.WinHttpRequest.5.1")
    oHTTP.Open("POST", aURL , False)
    oHTTP.SetRequestHeader("Content-Type", "application/x-www-form-urlencoded")
    oHTTP.Send(aPostData)
    response := oHTTP.ResponseText
	parsedAToken := JSON.Load(response, true)
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

PutURL(url, data, method:="put") {
	hObject:=ComObjCreate("WinHttp.WinHttpRequest.5.1")
	hObject.Open(method, url, false)
	hObject.SetRequestHeader("Content-Type", "application/json")
	hObject.Send(data)
	response := hObject.ResponseText
	hObject :=
	return response        
}

kComments(){
	global comment_sheetkey
    global myAccessToken
    ranges := "A:A"
    try {
    commentsheet := gsheet(comment_sheetkey, myAccessToken, ranges)
	oArray := json.Load(commentsheet)
    }
    catch e
    {
        throw e
    }
	return oArray
}

follow(target, account)
{
	FormatTime, startTime, ,yyyy-M-d HH:mm:ss tt
	url := "https://instagram.com/"target
	closeChrome()
    OpenUrlChrome(url, chromeProfilePath(account))
	SleepRand(4333,9999)
	pageValid := CheckPage()
	If !pageValid
	{
	    throw { msg: "FollowBot: Not valid " target, account:account } 
	}
	; If nLikes = 0
	Random, nLikes, 5, 20
	liked := LikePostsN(nLikes)
	SleepRand(500,1500)
	Text:="|<Follow>*188$45.0DzAzzzs1ztbzzzDw7AsAlVz0Na0W80MnAlaF03C9aQG1DtlAnW49z6NaAkVDs3Ak74NzUtb1sXU"
	if (ok:=FindText(0, 0, A_ScreenWidth, A_ScreenHeight, 0, 0, Text))
	{
		CoordMode, Mouse
		X:=ok.1.1, Y:=ok.1.2, W:=ok.1.3, H:=ok.1.4, Comment:=ok.1.5, X+=W//2, Y+=H//2
		MouseMove, X, Y
		SleepRand()
		Click
		SleepRand(1000,3000)
		followed++
		CoordMode, Pixel, Screen
	}
	Else
	{
	    throw { msg: "FollowBot: no follow btn " target, account:account } 
	}
	return liked	
}


LikePostsN(n:=0) {
	clicked = 0
    liked = 0
	Tooltip, LikePostsN, 0,900
	SleepRand(500,1700)
	If n > 0
		nLikes := n
	else
		random, nLikes, 3, 8
	While !clicked
	{
		clicked := ClickPost(1)
	}
	Text:="|<WHITE HEART>*169$24.3s7k66MM83k4E1U2E002U001U001U001U001U001k003E0028004A00A600M300k1U1U0k300M60048002E001U0U"
    if !(ok:=FindText(776-300//2, 631-900//2, 350, 600, 0, 0, Text))
    {
        Return False
    }
    ELse
	{	
		CoordMode, Mouse
        X:=ok.1.1, Y:=ok.1.2, W:=ok.1.3, H:=ok.1.4, Comment:=ok.1.5, X+=W//2, Y+=H//2
        Loop %nLikes%
		{
			Random, r, 1, 3
			If r = 1 ; click heart
			{
				X:=ok.1.1, Y:=ok.1.2, W:=ok.1.3, H:=ok.1.4, Comment:=ok.1.5, X+=W//2, Y+=H//2
				Random, w, -5, 5
				X += w
				Random, w, -5, 5
				Y += w
                MouseMove, %X%, %Y%
                SleepRand()
				Click
                SleepRand(500,1500)
                liked++
			}
			Else ;double click image
			{
				Random, X, 340,700
				Random, Y, 190,650
				MouseMove, %X%, %Y%
				SleepRand()
				Click 2	
                SleepRand(500,1500)
                liked++
			}
			count := A_Index
			;GREY RIGHT ARROW
			Text:="|<>*162$14.zzszy7zUzw7zUzw7zUzw7zUzw7zUzsDw3y1z0zUTkDs7w3y1zUzsTyDzzzs"
			if (ok:=FindText(1163-500//2, 388-500//2, 500, 500, 0, 0, Text))
			{
                SleepRand(100,500)
				CoordMode, Mouse
				X:=ok.1.1, Y:=ok.1.2, W:=ok.1.3, H:=ok.1.4, Comment:=ok.1.5, X+=W//2, Y+=H//2
				MouseMove, %X%, %Y%
                SleepRand()
                Click
                SleepRand(1000,2500)
			}
			Else
				Break
		}
    }
	Send {Esc}
	SleepRand()
	Loop 10
		MouseClick, WheelUP
	CoordMode, Pixel, Screen
	Tooltip, like posts finished,0,930
    Return % Array(liked,nLikes,count)
}