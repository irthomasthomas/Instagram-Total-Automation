#singleInstance force
#include Lib\CLR.ahk
#include Lib\JSON.ahk
#include Lib\FindTextFunctions.ahk
#include googlesheets.ahk


global client_id :=
global client_secret :=
global refresh_token :=
global influencer_sheetkey :=
global status_sheetkey :=
global comment_sheetkey := "1eWbBKYwzBxRRrNUrEWB--AefZHZT1K-eXj5_7vDtO-o"

; TODO: Check for error messages
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
			msgbox settings.ini
			session_id := e_session_id
		}
	}
	else
	{
		msgbox settings.ini not found
		ExitApp
	}
}


SleepRand(x:=0,y:=0) {
	; TODO: SET AN INTERRUPT VARIABLE IN MEMORY
	If FileExist("INTERRUPT")
	{
		sleep 100
		Run, instaServer.ahk
	}

	If x = 0
	{
		Random, x, 1, 11
	}
	If y  = 0
	{		
		Random, y, %x%, (x+200)
	}
	Random, rand, %x%, %y%
	if rand > 1000
	Sleep, %rand%
}

;CHROME
closeChrome() {
	tooltip, closeChrome
	WinGet hWnds, List, ahk_exe chrome.exe
	Loop, %hWnds%
	{
	  hWnd := % hWnds%A_Index% ; get next hWnd
	  PostMessage, 0x112, 0xF060,,, ahk_id %hWnd%
	}
}

settings(profile)
{
	global myAccessToken
    sheetId := "1LBsGtFQu_G8h5_RHX96W36iRDPwn9si9FyUOwf_B4dU"
	range1 := "A:D"
	url := "https://sheets.googleapis.com/v4/spreadsheets/" sheetId "/values/" range1  "?access_token=" myAccessToken	
	oArray := json.Load(UrlDownloadToVar(url))
	;TODO sqlite
	while !settings
	{
		settings := oArray.values[A_Index][1] = profile ? [oArray.values[A_Index][2],oArray.values[A_Index][3]] : 
		if A_Index > 20
	        throw { msg: "could not fetch settings from gsheet ", account: profile } 
	}
	Return settings
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
		Tooltip
		Return True
	}
	tooltip
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
	SleepRand()
	clipboard := % cText
	SleepRand(1000, 2322)
	send ^v
	SleepRand(600, 1222)
	send {return}
	SleepRand(323,1563)
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
	;TODO checkpage hardcode
    MouseMove, 400, 400
    SleepRand(500,900)
    MouseClick, WheelUp
    MouseClick, WheelUp
    SleepRand(500,1500)
	Tooltip, CheckPage, 0,900

	Text:="|<private>*153$48.z06000E0zU0000k0laqMltwQlbqMnxwyzb68UAlXz66BUQlzk66BVAlzk6673AlUk6673wwzk6671qQSU"
	if (ok:=FindText(730-70000//2, 444-70000//2, 70000, 70000, 0, 0, Text))
	{
		Return "private"
	}
		
	
	Text:="|<no posts>*161$71.0M00000000M01U000zk000M0300030k000k0C000A0k001k0M007k0y001U0k00M00600301U01U006006070020TU400C0C0041VU800Q0M00861UE00M0k00EM1UU00k1U00UU11001U300110220030600220440060A004408800A0M008A0kE00M0k00EA30U00k1k00UAA1003U3U010Dk200703002000400A06006000M00M0A006001U00k0Q007zzy003U0M0000000060U"
	if (ok:=FindText(675-150000//2, 453-150000//2, 150000, 150000, 0, 0, Text))
		Return "no posts"
	
	If checkBluetick
	{
		Text:="|<big blue tick>*188$18.0000z01zU7zs7zsDzwTzyTySTwySNyT3yTbyDzw7zs7zs1zU0z0000U"
		if (ok:=FindText(622-300//2, 216-300//2, 300, 300, 0, 0, Text))
			Return "no blue tick"
	}

    Text:="|<insta home>*160$30.7zzzsD000wQ000CQ003Cs007bs0S7bs1zX7s3zk7s7Vs7sD0w7sC0Q7sQ0C7sQ0C7sQ0C7sQ0C7sC0Q7sD0w7s7Vs7s3zk7s1zU7s0S07s0007Q000CQ000CD000wU"
	if (ok:=FindText(202-500//2, 100-500//2, 500, 500, 0, 0, Text))
	{
		Return "no home btn found"
	}

	; Text:="|<followers>*144$62.A08U0000004028000000100W0000000E08U000000D728C8MFlMt28W4F68WMFF18W2FWEY44EG8UYYbt0l44W88dF0E2F18W2+IE40I8W8F1229151kW3UEUQECU"
	; if !(ok:=FindText(0, 0, A_ScreenWidth, A_ScreenHeight, 0, 0, Text))
	; 	Return "no followers btn"

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

clickInstaHomeBtn() {
	Send {Esc}
	Loop 10
	{
		MouseClick, WheelUp
		SleepRand(170,770)
	}
	Text:="|<insta logo>*147$22.3zz0zzz700CM00P00Aw0knkDkD1nUwA33kkAD60MwM1XkkAD30kw7C3kDkD0A0w003M00Nk03Xzzw3zz2"
    if (ok:=FindText(202-500//2, 100-500//2, 500, 500, 0, 0, Text))
    {
        CoordMode, Mouse
        X:=ok.1.1, Y:=ok.1.2, W:=ok.1.3, H:=ok.1.4, Comment:=ok.1.5, X+=W//2, Y+=H//2
        MouseMove, X, Y
        SleepRand()
        Click
        SleepRand(1500,5000)
        CoordMode, Pixel, Screen
		Return True
    }
	Else
    {
        throw { msg: "BrowseFeed: homebtn not found ", account:"" } 
    }
}

; REPORTING
instaReport(account, activity, result, time) {
            liked := (result.HasKey("liked")) ? result.liked : ""
            followed := result.HasKey("followed") ? result.followed : ""
            commented := result.HasKey("commented") ? result.commented : ""
            unfollowed := result.HasKey("unfollowed") ? result.unfollowed : ""
        
            updateValues = "%account%", "%activity%", "%time%", "%unfollowed%", "%liked%", "%followed%", "%commented%"

        	response := GsheetAppendRow(status_sheetkey, myAccessToken, "Sheet1!A1", updateValues)
            return response
}

; LogError(e) {
; 	FormatTime, time, ,yyyy-M-d HH:mm:ss tt
; 	sheetkey := "1q7pJF4l0tIpEud62UwfHAOXbIFWQ8EQxN8wZCAWjv6Q"
; 	msg := e.msg, account := e.account
; 	updateValues = "%time%", "%msg%", "%account%"
; 	response := GsheetAppendRow(sheetkey, myAccessToken, "Sheet1!A:E", updateValues)
; 	; return response
; }

URLDownloadToVar(url) 
{
    if url != ""
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
	; ^ correct
    ranges := "A:A"
	commentsheet := gsheet(comment_sheetkey, myAccessToken, ranges)
	; msgbox %commentsheet%
	; ^ correct
	oArray := json.Load(commentsheet)

    ; try {
    ; 	commentsheet := gsheet(comment_sheetkey, myAccessToken, ranges)
	; 	msgbox %commentsheet%
	; 	oArray := json.Load(commentsheet)
    ; }
    ; catch e
    ; {
    ;     throw e
    ; }
	return oArray
}

clickFollowButton() {
	Text:="|<Follow>*188$45.0DzAzzzs1ztbzzzDw7AsAlVz0Na0W80MnAlaF03C9aQG1DtlAnW49z6NaAkVDs3Ak74NzUtb1sXU"
	if (ok:=FindText(0, 0, A_ScreenWidth, A_ScreenHeight, 0, 0, Text))
	{
		CoordMode, Mouse
		X:=ok.1.1, Y:=ok.1.2, W:=ok.1.3, H:=ok.1.4, Comment:=ok.1.5, X+=W//2, Y+=H//2
		MouseMove, X, Y
		SleepRand()
		Click
		SleepRand(1000,3000)
		CoordMode, Pixel, Screen
	}
	Else
	{
	    throw { msg: "FollowBot: no follow btn " } 
	}
}

clickMyProfileButton() {
	Text:="|<my profile>*170$22.0Dk01VU0A301U604080E0U10204080M1U0kA01VU03w000000001zzsA00lU01g003U006000M001U006000M001U"
    if (ok:=FindText(1148-150//2, 100-150//2, 1500, 1500, 0, 0, Text))
    {
        CoordMode, Mouse
        X:=ok.1.1, Y:=ok.1.2, W:=ok.1.3, H:=ok.1.4, Comment:=ok.1.5, X+=W//2, Y+=H//2
        MouseMove, %X%, %Y%
        SleepRand()
        Click
        SleepRand(1800,4500)
        CoordMode, Pixel, Screen
		return True
    }
	Else
	{ 
		return False
	}
}

clickFollowingButton() {
	Text:="|<following>*144$59.A090002000U0G000000100Y0000007XV8QEVFQ7I8WF4V2X4FcUYY4Z9491F1989+G8G2W2GEGWYEY544YUZ58V8+8991++F2EI8WF488W4FcC4VkEF48R00000000020000000048000000007Y"
    if (ok:=FindText(834-150//2, 266-150//2, 150, 150, 0, 0, Text))
    {
        CoordMode, Mouse
        X:=ok.1.1, Y:=ok.1.2, W:=ok.1.3, H:=ok.1.4, Comment:=ok.1.5, X+=W//2, Y+=H//2
        MouseMove, %X%, %Y%
        SleepRand()
        Click
        SleepRand(1500,4500)
        CoordMode, Pixel, Screen
		Return True
    }
	Else
    {
		Return False
	}
}

scrollFollowerList(scroll:=False) {
	If !scroll 
		Random, scroll, 5, 25	
	Random, X, 531, 818
	Random, Y, 333, 564
	MouseMove, X, Y
	SleepRand()
	Loop %scroll% 
	{
		MouseClick, WheelDown
		SleepRand(150,750)
	}
}

UnfollowRandomAccount() {
	SleepRand()
	clickedMyProfile := clickMyProfileButton()
	SleepRand(1500,5000)
	clickedFollowing := clickFollowingButton()

	SleepRand(1500,5000)
	scrollFollowerList()
	SleepRand(500,2300)
	Text:="|<unfollow>*158$66.zU0n0003000zU0n0000000k1kn3X4PBkvk3sn7lCHDtzzaAnANCHANXzaAnANenANXk6AnANenANXk6AnAMvXANXk3sn7klXANzk1kn3UlXAMv000000000030000000001z0000000000yU"
	if (ok:=FindText(675-150000//2, 484-150000//2, 150000, 150000, 0, 0, Text))
	{
		CoordMode, Mouse
		X:=ok.1.1, Y:=ok.1.2, W:=ok.1.3, H:=ok.1.4, Comment:=ok.1.5, X+=W//2, Y+=H//2
		MouseMove, X, Y
		SleepRand()
		Click
		SleepRand(700,2100)
		Text:="|<unfollow confirm>*195$60.kk0C06M000kk0M06M000knQyD6MSNnknyyzaNzNnknaMlaNXBqkn6MlaNXBKkn6MlaNXBKsn6MlaNX7Qzn6MzaNz7QDX6MD6MS6AU"
		if (ok:=FindText(675-150000//2, 484-150000//2, 150000, 150000, 0, 0, Text))
		{
			X:=ok.1.1, Y:=ok.1.2, W:=ok.1.3, H:=ok.1.4, Comment:=ok.1.5, X+=W//2, Y+=H//2
			MouseMove, X, Y
			SleepRand()
			Click
			SleepRand(700,2100)
		}
		CoordMode, Pixel, Screen
		clicked := True
	}
	
	else
		clicked := False
	SleepRand(500,1400)

	try
	{
		clickInstaHomeBtn()
	}
	catch e
	{
		LogError(e)
	}

	return clicked

}