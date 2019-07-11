SetWorkingDir %A_ScriptDir%
#NoEnv
#SingleInstance, force
SetTitleMatchMode, 2
#include JSON.ahk
#include CLR.ahk
;#include control1.ahk
#include Socket.ahk
#include RemoteObj.ahk
; #include instagramAutomation.ahk
#include Jxon.ahk
#include FindTextFunctions.ahk

global client_id :=
global client_secret :=
global refresh_token :=
global influencer_sheetkey :=
global status_sheetkey :=

setupConfigs()

global myAccessToken := GetAccessCode(client_id, client_secret, refresh_token)

Start()

Start() {
Loop
{
	serverAddress := "192.168.0.30"
	serverPort := 1338
	Remote := new RemoteObjClient([serverAddress, serverPort])
	Remote.print_to_python("active1: " active1)
	
	/* 
		loop
		{
			; active1 := Remote.check_active("instaLikeBot","start")
			Remote.print_to_python("active1: " active1)

			if (active1 != "instaLikeBot") && (active1 != instaLikeBot)
			{
				Remote.print_to_python("instaLikeBot: connection 1 refused")
				Sleep 25000
			}
			Else
			{
				Sleep 25000
				active2 := Remote.check_active("instaLikeBot","start")
				Remote.print_to_python("active2: " active2)
				if (active2 != "instaLikeBot") && (active2 != instaLikeBot)
				{
					Remote.print_to_python("instaLikeBot: connection 2 refused")
					Sleep 25000
				}
				Else
				{
					Remote.print_to_python("instalikeBot: CONNECTED")
					break
				}
			}
		}
	*/	;SleepRand(200000, 5000000)
		;msgbox,,,ACTIVE,60
		; Remote.check_active("instaLikeBot","end")
		;Sleep 220000

	cell = Sheet1!A1:G1
	; Remote.print_to_python("access token: "+ myAccessToken)
	global profile := RandChromeProfilePath(myAccessToken)
	global instaURL := "https://instagram.com/"
	;instaURL := RandURL()
	CloseChrome()
	Tooltip, sleeping - start(), 0, 900
	SleepRand(1333,2999)

	/* LOGIN ROUTINE
		foundLoginBtn := FindImg("E:\Development\instabot\assets\login2.png",,10)
		If !foundLoginBtn {
			;Tooltip, Start() login not found, 0,900
			foundLoginBtn := FindImg("E:\Development\instabot\assets\login4.png",,10)
			}
		If foundLoginBtn {
			;Tooltip, Start() login btn found, 0,900
			SleepRand(2800,3500)
			foundLoginBtn2 := FindImg("E:\Development\instabot\assets\login3.png")
			SleepRand(450,900)
		If foundLoginBtn2 {
				}
			}
		SleepRand(800, 1500)
		Send {BS}
		SleepRand(300,1300)
		Send {BS}
		SleepRand(333,1500)
		Send {BS}
		SleepRand(1300,2500)
		 */
	
	
	SleepRand()
	Random, nLoop, 2, 4
	Loop % nLoop
	{
		Random, n, 1, 4
		If n = 0
		{   
			Result := Unfollow() ; array(startTime, endTime, errorMsg, functionName) if Error endTime = 0
			SleepRand()
			response := Report(profile, Result, cell)
			SleepRand(2000, 7000)
		}
		Random, n, 1, 3
		If n = 0
		{
			Tooltip, >BrowseFeed- start(), 0, 900
			Result := BrowseFeed()
			SleepRand()
			response := Report(profile, Result, cell)
			SleepRand(100,3000)
		}
		Random, n, 1, 3
		If n = 1
		{
			Result := BrowseHashtags(profile[2])
			response := Report(profile, Result, cell)
		}
		Random, n, 1, 3
		If n = 1 ;follow from gsheet
		{
			range1 := profile[2]"!A2:A"
			url := "https://sheets.googleapis.com/v4/spreadsheets/" influencer_sheetkey "/values/" range1  "?access_token=" myAccessToken
			oArray := json.Load(UrlDownloadToVar(url))
			random, row, 2, oArray.values.MaxIndex()
			targetAccount := oArray.values[row][1]

			results := follow(targetAccount, profile)
			SleepRand()
			response := Report(profile, results, cell)

		}
        Random, n, 1, 3
		If n = 1
        {
			Random, l, 2, 4
			Loop % l
            	kardashianBot()
        }
	CloseChrome()	
	Remote.check_active("instaLikeBot","end")
	ToolTip, sleeping
	SleepRand(10000, 30000)
	}
	Tooltip, sleeping
	Random, n, 1, 2
	if n = 1
	{
		SleepRand(10000, 30000)
	}
	Random, n, 1, 6
	if n = 0
	{
		SleepRand(100000, 6000000)
	}
	Random, n, 1, 6
	If n = 0
	{
		SleepRand(100000,6000000)
	}
	Remote.check_active("instaLikeBot","end")
	Sleep 1600
	Reload
	}
}

CloseChrome() {
	; Get all hWnds (window IDs) created by chrome.exe processes.
	WinGet hWnds, List, ahk_exe chrome.exe
	;WinGet hWnds, List, ahk_exe opera.exe
	Loop, %hWnds%
	{
	  hWnd := % hWnds%A_Index% ; get next hWnd
	  PostMessage, 0x112, 0xF060,,, ahk_id %hWnd%
	}
}

setupConfigs() {
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
		ErrorGui("setting.dll file not found. Exiting...")
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
		ErrorGui("setting.ini file not found. Exiting...")
		ExitApp
	}
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

RandURL(){
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

ClickPost2(n){
	ToolTip, CLICK INSTA POST,0,930
	MouseMove, 650, 450
	SleepRand(100,1500)
	MouseClick, WheelDown
	SleepRand(100,1500)
	postN := n
	;posts 400
	; 638
	/* 
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
 */
	PixelGetColor, pColour, 1180, 170
	While pColour = 0xFAFAFA 	; WHITE
		{

			Text:="|<grid/posts>*175$12.TyzyWGmGzyWGmGzymGWGzy00U"
			if (ok:=FindText(531-700//2, 733-700//2, 700, 800, 0, 0, Text))            
			{
				X:=ok.1.1, Y:=ok.1.2, W:=ok.1.3, H:=ok.1.4, Comment:=ok.1.5, X+=W//2, Y+=H//2 
				If Y > 600
				{
					Loop 3
						MouseClick, WheelDown
					
					ok:=FindText(531-700//2, 733-700//2, 700, 800, 0, 0, Text)
					X:=ok.1.1, Y:=ok.1.2, W:=ok.1.3, H:=ok.1.4, Comment:=ok.1.5, X+=W//2, Y+=H//2 
					
				}
				ClickPost(1)
			}
			Else
			{
				MouseClick, WheelDown
			}
			SleepRand(1500, 3310)
			PixelGetColor, pColour, 1180, 170
			If A_Index > 8
				break
		}


	If postN = 1
	{
        Random,x,220,480
        Random,y,465,700
		SleepRand()
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
		Else Return False
		
	}
	Else If postN = 2
	{
        Loop 3
        {
            Random,x,545,800
	        Random,y,465,700
            MouseMove, %x%, %y%
            SleepRand(100,800)
            Click
            SleepRand(1600,2600)
            Text:="|<post a co>*207$71.0000000000001U10E00000003U20U000000051wT0S0QD5r0P6Na161AnAm0a8G404212F434EY81sA26W87wV8ECEM4B4E892EUEUE8G8UkPAn0X0aNYF10nsy1u0sS8W000000000000U"
			if (ok:=FindText(789-900//2, 674-900//2, 900, 900, 0, 0, Text))
			{
				CoordMode, Mouse
				X:=ok.1.1, Y:=ok.1.2, W:=ok.1.3, H:=ok.1.4, Comment:=ok.1.5, X+=W//2, Y+=H//2
				;Click, %X%, %Y%
				Return True
			}
			Else Return False
        }
	}
	/* 
	Else If postN = 3
	{
		Random,x,880,1220
		Random,y,465,700
		MouseMove, %x%, %y%
		SleepRand()
		Click
		SleepRand(1000,3500)
		foundImg := FindImg("needles\comment3.png",3)
		If !foundImg
		{
			SleepRand(300,900)
			foundImg := FindImg("needles\comment3.png",3)
		}
		If !foundImg
		{
			Random,y,795,925
			SleepRand(200,500)
			MouseMove, %x%, %y%
			SleepRand(233,333)
			Click
			SleepRand(433,733)
			If !foundImg
			{
				Return False
			}
			Else Return True
		}
		Else Return True
	}
	 */

	Else If postN = 4
	{
		MouseMove, 380, 810
		SleepRand(200,499)
		Click
		SleepRand(100,200)
		Click
		SleepRand(200,400)
	}
	Else If postN = 5
	{
		MouseMove, 650, 810
		Sleep 200
		Click
		Sleep 200
	}
}


ClickPost(n){
	ToolTip, CLICK INSTA POST,0,930
	MouseMove, 650, 450
	SleepRand(100,1500)
	MouseClick, WheelDown
	SleepRand(100,1500)
	postN = %n%
	;posts 400
	; 638
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
		SleepRand()
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
		Else Return False
		
	}
	Else If postN = 2
	{
        Loop 3
        {
            Random,x,545,800
	        Random,y,465,700
            MouseMove, %x%, %y%
            SleepRand(100,800)
            Click
            SleepRand(1600,2600)
            Text:="|<post a co>*207$71.0000000000001U10E00000003U20U000000051wT0S0QD5r0P6Na161AnAm0a8G404212F434EY81sA26W87wV8ECEM4B4E892EUEUE8G8UkPAn0X0aNYF10nsy1u0sS8W000000000000U"
			if (ok:=FindText(789-900//2, 674-900//2, 900, 900, 0, 0, Text))
			{
				CoordMode, Mouse
				X:=ok.1.1, Y:=ok.1.2, W:=ok.1.3, H:=ok.1.4, Comment:=ok.1.5, X+=W//2, Y+=H//2
				;Click, %X%, %Y%
				Return True
			}
			Else Return False
        }
	}
	/* 
	Else If postN = 3
	{
		Random,x,880,1220
		Random,y,465,700
		MouseMove, %x%, %y%
		SleepRand()
		Click
		SleepRand(1000,3500)
		foundImg := FindImg("needles\comment3.png",3)
		If !foundImg
		{
			SleepRand(300,900)
			foundImg := FindImg("needles\comment3.png",3)
		}
		If !foundImg
		{
			Random,y,795,925
			SleepRand(200,500)
			MouseMove, %x%, %y%
			SleepRand(233,333)
			Click
			SleepRand(433,733)
			If !foundImg
			{
				Return False
			}
			Else Return True
		}
		Else Return True
	}
	 */

	Else If postN = 4
	{
		MouseMove, 380, 810
		SleepRand(200,499)
		Click
		SleepRand(100,200)
		Click
		SleepRand(200,400)
	}
	Else If postN = 5
	{
		MouseMove, 650, 810
		Sleep 200
		Click
		Sleep 200
	}
}

kardashianBot() {
	functionName = KardashianBot
	FormatTime, startTime, ,yyyy-M-d HH:mm:ss tt
	cell = Sheet1!A1:G1
	global profile := RandChromeProfilePath(myAccessToken)
	;OpenUrlChrome("",profile[1])

	ToolTip, KardashianBot, 0, 900
	SleepRand(1500,3400)
	comments = 0
	likes = 0
	Random, r, 2, 5
	Loop % r
    {
		ToolTip, Loop, 0, 900
		SleepRand(3000,6000)
		instaURL := RandURL()
		Clipboard := instaURL
		SleepRand()

		If WinExist("ahk_class Chrome_WidgetWin_1") 
		{
			WinActivate
			SleepRand(1500,3000)
			Send ^l
			SleepRand(100)
			Send ^v
			SleepRand(100)
			Send {Enter}
			SleepRand(2600,4600)
		}
		Else
		{
			OpenUrlChrome(instaURL, profile[1])
			SleepRand(3200,9300)
		}
		
		Tooltip, sleeping - start(), 0, 900
		SleepRand(2333,5999)		
		SleepRand()
		Random p, 1, 2
		
		clicked := ClickPost(p)
		If !clicked
			Continue

        SleepRand(1000,3500)
        Random, r, 1, 3
        Loop % r
        {
            result := KardashianComment()
            If result
				comments++
			Else
				Continue
			SleepRand(1700,11000)
			;response := Report(profile,result,cell)
        }
        
        SleepRand(500,2500)
        open := OpenCommenterProfile()
        If !open
        {
            Continue
        }
        liked := LikePostsN()
		Send {BS}
		SleepRand(1000,2500)
    }
	
	
	
	FormatTime, endTime, ,yyyy-M-d HH:mm:ss tt
			;  array(StartTime, EndTime, errorMsg, functionName) if Error endTime = 0
	;MsgBox, % liked[1] " " comments
	result := Array(functionName, startTime, endTime, 0, liked[1], 0, comments)
	response := Report(profile,result,cell)	
	SleepRand(10000, 20000)
	
}

KardashianComment(loops=1)
{
	functionName = KardashianComment
	Tooltip, KardashianComment, 0,900
	FormatTime, StartTime, ,yyyy-M-d HH:mm:ss tt
	Loop %loops%
	{
		SleepRand(100,1300)

		Text:="|<small blue tick>*183$12.2E3kDwDwzbNCQSyzDwDw3k2EU"
		smallbluetick:=FindText(920-150//2, 137-150//2, 150, 150, 0, 0, Text)
		If !smallbluetick
		{
			Return False
		}
		ELSE
		{ ; leave comment 
			Random p, 1, 2
			ClickPost(p)
			SleepRand(699, 1999)
		}
		commentText := RandComment()
		posted := PostComment(commentText)
		FormatTime, endTime, ,yyyy-M-d HH:mm:ss tt
		If posted
		{
			; array(StartTime, EndTime, errorMsg, functionName) if Error endTime = 0
			;Return % Array(functionName, StartTime, endTime, 0, 0, 0, 1)
			Return True
		}
		Else
			Return False
			;Return % Array(functionName, StartTime, 0, 0, 0, 0)
	}
}

OpenCommenterProfile() {
	FormatTime, StartTime, ,yyyy-M-d HH:mm:ss tt
	functionName = OpenCommenterProfile
	Tooltip, OpenCommenterProfile, 0,900
	Loop 3 		; LOAD MORE
	{
		Text:="|<load more>*204$66.U0001000000U0001000000U7VsR0hkwKSU8G4X0n92MVU8E4V0W92EVU8EwV0W92EzU8F4V0W92EUU8G4V0W92EUU8GAX0W92EVzbVoR0W8wESU"
		if (ok:=FindText(865-150000//2, 373-150000//2, 150000, 150000, 0, 0, Text))
		{
			CoordMode, Mouse
			X:=ok.1.1, Y:=ok.1.2, W:=ok.1.3, H:=ok.1.4, Comment:=ok.1.5, X+=W//2, Y+=H//2
            SleepRand()
            MouseMove, X, Y
            SleepRand()
            Click
            SleepRand()
            MouseClick, WheelUp
            SleepRand(10,500)
		}
	}
	PixelGetColor, pColour, 1180, 170
	While pColour = 0x7D7D7D  ;  GREY = a post is open
	{
		If A_Index > 5 ; click next arrow
		{	
            Text:="|<right arrow>*162$14.zzszy7zUzw7zUzw7zUzw7zUzw7zUzsDw3y1z0zUTkDs7w3y1zUzsTyDzzzs"
            if (ok:=FindText(1163-500//2, 388-500//2, 500, 500, 0, 0, Text))
            {
                CoordMode, Mouse
                X:=ok.1.1, Y:=ok.1.2, W:=ok.1.3, H:=ok.1.4, Comment:=ok.1.5, X+=W//2, Y+=H//2
                SleepRand()
                MouseMove, %X%, %Y%
                SleepRand()
                Click
            }
		}
		If A_Index > 10
		{
			FormatTime, EndTime, ,yyyy-M-d HH:mm:ss tt
			errorMsg := error clicking on hashtags
			Return % Array(functionName, StartTime, errorMsg, 0,0,0) 
		}
        SleepRand()
        Text:="|<white heart>*169$24.3s7k66MM83k4E1U2E002U001U001U001U001U001k003E0028004A00A600M300k1U1U0k300M60048002E001U0U"
        if !(ok:=FindText(776-7000//2, 553-7000//2, 7000, 7000, 0, 0, Text))
        {
            Text:="|<red heart>*187$24.3s7k7yTsDzzwTzzyTzzyzzzzzzzzzzzzzzzzzzzzTzzyTzzyDzzwDzzw7zzs3zzk1zzU0Ty00Dw007s003k001U0U"
            if !(ok:=FindText(776-7000//2, 631-7000//2, 7000, 7000, 0, 0, Text))
            {
			    Return False
                ;errorMsg := did not find heart on kardashian post
                ;Return % Array(functionName, StartTime, errorMsg, 0,0,0) 
            }
        }
        CoordMode, Mouse
        X:=ok.1.1, Y:=ok.1.2, W:=ok.1.3, H:=ok.1.4, Comment:=ok.1.5, X+=W//2, Y+=H//2
        Random, r, 80, 250
        Y -= r
        SleepRand()
        MouseMove, %X%, %Y%
        SleepRand()
        Loop 4
        {
            MouseClick, WheelDown
            SleepRand()
        }
        Click ; CLICK ON REGION WITH ACCOUNT NAMES
        SleepRand(900,1900)
		PixelGetColor, pColour, 1180, 170 ; 			Pixel colour should change
	}
	done = 0
	SleepRand(900, 1900)
    Loop 3
        MouseClick, WheelUP
    SleepRand()
	pageValid := CheckPage()
	If pageValid
        Return True
    Else
        Return False
	/* 
	FormatTime, EndTime, ,yyyy-M-d HH:mm:ss tt
	Return % Array(functionName, StartTime, EndTime,done)
	Tooltip, OpenCommenterProfile() Finished OpenCommenterProfile, 0,900
     */
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
		clicked := ClickPost2(1)
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
			/* 
	        SleepRand(1000, 2500)
			Random, n, 1, 8
			if (n = 1) ;skip photo sometimes to appear more human
			{
				nLikes++
				Text:="|<RIGHT ARROW>*162$14.zzszy7zUzw7zUzw7zUzw7zUzw7zUzsDw3y1z0zUTkDs7w3y1zUzsTyDzzzs"
				if (ok:=FindText(1163-500//2, 388-500//2, 500, 500, 0, 0, Text))
				{
					CoordMode, Mouse
					X:=ok.1.1, Y:=ok.1.2, W:=ok.1.3, H:=ok.1.4, Comment:=ok.1.5, X+=W//2, Y+=H//2
					SleepRand()
                    MouseMove, %X%, %Y%
                    SleepRand()
                    Click
                    SleepRand(1000,3000)
				}
				Continue
			}
			 */
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

RandComment(){
	Tooltip, RandComment, 0,900
	SleepRand(399,999)
	Random, commentNumber, 1, 40	
	Sleep 2000
	;comments
	{
	If commentNumber = 1
		{
			commentText := "lb x"
		}   
		 Else If commentNumber = 2   
		{
				commentText := "lb please!"
		}
		 Else If commentNumber = 3
		 {
			  commentText := "LB First"
		 }
		 Else If commentNumber = 4
		 {
		 commentText := "first pls"
		 }
		 Else If commentNumber = 5
		 {
			   commentText := "lb lb lb"
		 }
		 Else If commentNumber = 6
		 {
			  commentText := " lb please x"
		 }
		 Else If commentNumber = 7
		 {
				commentText := "lb cb fb"
		 }
		 Else If commentNumber = 8
		 {
			commentText := "lb"
		 }
		 Else If commentNumber = 9
		 {
			commentText := "first" 
		}
		 Else If commentNumber = 10
		 {
			commentText := "FIRST lb cb"
		 }
		 Else If commentNumber = 11
		 {
			commentText := "FIRST lb"
		 }
		Else If commentNumber = 12
		 {
			commentText := "FIRST please!"
		 }
		Else If commentNumber = 13
		{
			commentText := "LB cb"
		 }
		Else If commentNumber = 14
		{
			commentText := "lb please"
		}	
		Else If commentNumber = 15
		{
			commentText := "lb f4f"
		}
		Else If commentNumber = 16
		{
			commentText := "LB"	
		}
		Else If commentNumber = 17
		{
			commentText := "FIRST"
		}
		Else If commentNumber = 18
		{
			commentText := "lb cb first"
		}
		Else If commentNumber = 19
		{
			commentText := "ROW"
		}
		Else If commentNumber = 20
		{
		commentText := "lb"
		}
		Else If commentNumber = 21
		{
			commentText := "lb"
		}
		Else If commentNumber = 22
		{
			commentText := "lb NOW"
		}
		Else If commentNumber = 23
		{
			commentText := " lb"
		}
		Else If commentNumber = 24
		{
			commentText := "LB"
		}
		Else If commentNumber = 25
		{ 
			commentText := "ROW"
		}
		Else If commentNumber = 26
		{
			commentText := "lb FB F4F"
		}
		Else If commentNumber = 27
		{
			commentText := "FB LF"
		}
		Else If commentNumber = 28
		{
			commentText := "FIRST LB"
		}
		Else If commentNumber = 29
		{
			commentText := " LB CB"
		}
		Else If commentNumber = 30
		{
			commentText := "ROW lb now"
		}
		Else If commentNumber = 31
		{
			commentText := "LB  now"
		}
		Else If commentNumber = 32
		{
			commentText := "LB CB 1"
		}
		Else If commentNumber = 33
		{
			commentText := "LB"
		}
		Else If commentNumber = 34
		{
			commentText := "LB CB"
		}
		Else If commentNumber = 35
		{
			commentText := "lb now"
		}
		Else If commentNumber = 36
		{
			commentText := "ROW"
		}
		Else If commentNumber = 37
		{
			commentText := "lb please"
			}
		Else If commentNumber = 38
		{
			commentText := "lb ROW"
		}
		Else If commentNumber = 39
		{
			commentText := "lb first please"
		}
		Else If commentNumber = 40
		{
			commentText := "first only please"
		}
	}
		Return, commentText
}

PostComment(cText){
	clicked := ClickInstaCommentBox()
	If !clicked
	{
		Send {BS}
		SleepRand(299,755)
		Random,r,1,2
		ClickPost(r)
		SleepRand(1000,1955)
		clicked := ClickInstaCommentBox()
		If !clicked
			Return False
	}
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

GetHashtags(imgFormat:=1, imgType:="o", igAccount:=0) {
	hashtag_sheetkey = 16yguXSFWUhrBMNs9BgxQM3xkKH3pcjhG-SaZ90xiEgA
	Category1 := Object()
	Category2 := Object()
	Category3 := Object()
    ; msgbox % "GetHashtags " imgFormat " " imgType " " igAccount
	If igAccount = philhughesart
	{
		nCategories = 3
		ranges := "PHA!A1:D"
		hashtagSheetData := GetWorksheetRange(hashtag_sheetkey, myAccessToken, ranges)
		oArray := json.Load(hashtagSheetData)
		If imgType = o
		{
			for i in oArray.values
			{
				If oArray.values[i][4] = "Art"
					Category1.Insert(oArray.values[i][1])
				Else If oArray.values[i][4] = "Scene"
					Category2.Insert(oArray.values[i][1])
				Else If oArray.values[i][4] = "Oil Painting"
					Category3.Insert(oArray.values[i][1])
			}
		}
		Else If imgType = d
		{
			for i in oArray.values
			{
				If oArray.values[i][4] = "Art"
					Category1.Insert(oArray.values[i][1])
				Else If oArray.values[i][4] = "Scene"
					Category2.Insert(oArray.values[i][1])
				Else If oArray.values[i][4] = "Drawing"
					Category3.Insert(oArray.values[i][1])
			}	
		}
		ELSE If imgType = w
		{
			for i in oArray.values
			{
				If oArray.values[i][4] = "Art"
					Category1.Insert(oArray.values[i][1])
				Else If oArray.values[i][4] = "Scene"
					Category2.Insert(oArray.values[i][1])
				Else If oArray.values[i][4] = "Watercolour"
					Category3.Insert(oArray.values[i][1])
			}
		}
	}
	Else If (igAccount = "noplacetosit") || (igAccount = noplacetosit)
	{
		ranges := "NPS!A1:D"
		nCategories = 1
		hashtagSheetData := GetWorksheetRange(hashtag_sheetkey, myAccessToken, ranges)
		oArray := json.Load(hashtagSheetData)
		For i in oArray.values
		{
			Category1.Insert(oArray.values[i][1])
		}	
	}
	Else If igAccount in TT,T,thomasthomas2211 
	{
		nCategories = 1
		ranges := "TT!A1:D"
		hashtagSheetData := GetWorksheetRange(hashtag_sheetkey, myAccessToken, ranges)
		oArray := json.Load(hashtagSheetData)
		
		For i in oArray.values
		{
			Category1.Insert(oArray.values[i][1])
		}
	}
	Else If (igAccount = "b") || (igAccount = "bliss") || (igAccount = "bm") || (igAccount = "blissMolecule") || (igAccount = b)
	{
		;msgbox % " GetHashtags() blissMolecule "
		nCategories = 1
		ranges := "BM!A1:D"
		;msgbox % " sheetkey " hashtag_sheetkey " accesstoken " myAccessToken " ranges " ranges
		hashtagSheetData := GetWorksheetRange(hashtag_sheetkey, myAccessToken, ranges)
		; msgbox % "hashtagsheetdata: " hashtagSheetData
		oArray := json.Load(hashtagSheetData)
		
		For i in oArray.values
		{
			Category1.Insert(oArray.values[i][1])
		}
		
	}

	Loop % Category1.MaxIndex()
	{
		cat1Deck%A_Index% := Category1[A_Index]
	}
	Loop % Category1.MaxIndex()
	{
		random, pos, 1, Category1.MaxIndex()
		temp := cat1Deck%A_Index%
		cat1Deck%A_Index% := cat1Deck%pos%
		cat1Deck%pos% := temp
	}
	Loop % Category2.MaxIndex()
	{
		cat2Deck%A_Index% := Category2[A_Index]
	}
	Loop % Category2.MaxIndex()
	{
		random, pos, 1, Category2.MaxIndex()
		temp := cat2Deck%A_Index%
		cat2Deck%A_Index% := cat2Deck%pos%
		cat2Deck%pos% := temp
	}
	Loop % Category3.MaxIndex()
	{
		cat3Deck%A_Index% := Category3[A_Index]
	}
	Loop % Category3.MaxIndex()
	{
		random, pos, 1, Category3.MaxIndex()
		temp := cat3Deck%A_Index%
		cat3Deck%A_Index% := cat3Deck%pos%
		cat3Deck%pos% := temp
	}
	
	If nCategories = 1
	{
		Loop 27
		{
			s.=cat1Deck%A_Index%
		}
	}
	Else If nCategories = 2
	{
		Loop 14
		{
			s.=cat1Deck%A_Index%
		}
		Loop 13
		{
			s.=cat2Deck%A_Index%
		}
	}
	Else If nCategories = 3
	{
		Loop 9
		{
			s.= cat1Deck%A_Index% . cat2Deck%A_Index% . cat3Deck%A_Index%
		}
	}
	
	return % s

}

OpenUrlChrome(URL, profile){
	;msgbox % "profile " profile " url " URL
	run, %profile% %URL%, , max
		  
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

RandChromeProfilePath(accessToken, profile:=0)
{
	if not profile
		Random, row, 2, 5
    sheetId := "1LBsGtFQu_G8h5_RHX96W36iRDPwn9si9FyUOwf_B4dU"
	range1 := "A" . row ":C" . row
	url := "https://sheets.googleapis.com/v4/spreadsheets/" sheetId "/values/" range1  "?access_token=" accessToken
	sheetData := UrlDownloadToVar(url)
    Sleep 100
	oArray := json.Load(sheetData)
    userAccount := oArray.values[1][1]
    Sleep 100
    chromePath := oArray.values[1][2]
	sheetId := oArray.values[1][3]
	
    Return % Array(chromePath, userAccount,sheetId)
}

follow(target, profile)
{
	; Follow a target profile 
	; Like n posts
	FormatTime, startTime, ,yyyy-M-d HH:mm:ss tt
	/* 	try  ; Attempts to execute code.
		{
			HelloWorld()
			MakeToast()
		}
		catch e  ; Handles the first error/exception raised by the block above.
		{
			MsgBox, An exception was thrown!`nSpecifically: %e%
			Exit
		}

		HelloWorld()  ; Always succeeds.
		{
			MsgBox, Hello, world!
		}

		MakeToast()  ; Always fails.
		{
			; Jump immediately to the try block's error handler:
			throw A_ThisFunc " is not implemented, sorry"
		} 
		*/



	instaURL := "https://instagram.com/"target
	OpenUrlChrome(instaURL, profile[1])
	SleepRand(4333,9999)
	; valid := CheckPage(1,1)
	pageValid := CheckPage()
	If !pageValid 
	{
		Error := "NOT FOUND: " target
		Return % Array(functionName, startTime, Error, 0, liked[1], followed)
	}
		
	
	; If nLikes = 0
	Random, nLikes, 5, 25
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
		Tooltip, error finding follow btn,0,930
		Error := did not find follow button
		Return % Array(functionName, startTime, Error, 0, liked[1], followed)
	}

	FormatTime, endTime, ,yyyy-M-d HH:mm:ss tt
	
	Return % Array("follow", startTime, endTime, 0, liked, followed)
}

FollowFromGsheet(loopN:=1, nLikes:=0, profileArray:=0) 
{
	global profile
	global instaURL
	; OpenUrlChrome(instaURL, profile[1])
	functionName = FollowFromGsheet()
	ToolTip, FollowFromGsheet(), 0, 900
	FormatTime, startTime, ,yyyy-M-d HH:mm:ss tt
	liked = 0
	followed = 0
	outer:
	Loop % loopN
	{
		range1 := profileArray[2]"!A2:A"
		url := "https://sheets.googleapis.com/v4/spreadsheets/" influencer_sheetkey "/values/" range1  "?access_token=" myAccessToken
		influencerSheetData := UrlDownloadToVar(url)
		oArray := json.Load(influencerSheetData)
		endRow := oArray.values.MaxIndex()
		random, row, 2, %endRow%
		targetAccount := oArray.values[row][1]

		ToolTip, FollowFromGsheet() targetAccount %targetAccount%
		if (targetAccount = "") || (targetAccount = )
		{
			SleepRand()
			errorMsg := "targetAccount is blank for row " row
			Return % Array(functionName, startTime, errorMsg, 0,0,0) 
		}
		instaURL := "https://instagram.com/"targetAccount
		OpenUrlChrome(instaURL, profile[1])
		SleepRand(4333,9999)
		valid := CheckPage(1,1)
		If !valid
		{
			If A_Index < 6
				Continue
			ToolTip, FollowFromGsheet() PAGE NOT VALID ,0,900
			SleepRand(1100,2300)
			errorMsg := "page not valid for row " row " targetAccount " targetAccount
			Return % Array(functionName, startTime, errorMsg, 0,0,0) 
		}
		ToolTip, FollowFromGsheet() page valid Closing other tab, 0, 900
		SleepRand(833,1999)
		Send ^{tab} 
		SleepRand(900,1900)
		Send ^{F4}
		SleepRand(900,1900)	
		ToolTip, FollowFromGsheet() click following btn, 0, 900
	}
		;OPEN FOLLOWING LIST
		SleepRand(1800,2800)
		PixelGetColor, pColour, 1080, 210
		SleepRand()
		While pColour = 0xFAFAFA
		{
			If A_Index > 5
			{
				ToolTip, FollowFromGsheet failed to open following - reloading, 0, 900
				SleepRand(1200,4200)
				errorMsg = failed to open following list, BG colour still 0xFAFAFA
				Return % Array(functionName, startTime, errorMsg, 0,0,0) 
			}
			needle:="|<following>*144$59.A090002000U0G000000100Y0000007XV8QEVFQ7I8WF4V2X4FcUYY4Z9491F1989+G8G2W2GEGWYEY544YUZ58V8+8991++F2EI8WF488W4FcC4VkEF48R00000000020000000048000000007Y"
            if (ok:=FindText(834-150//2, 266-150//2, 150, 150, 0, 0, needle))
            {
                CoordMode, Mouse
                X:=ok.1.1, Y:=ok.1.2, W:=ok.1.3, H:=ok.1.4, Comment:=ok.1.5, X+=W//2, Y+=H//2
                MouseMove, %X%, %Y%
                SleepRand()
                Click
                SleepRand(2000,5000)
                CoordMode, Pixel, Screen
            }
            PixelGetColor, pColour, 1080, 210
		}
		MouseMove, 640, 440
		SleepRand()
		;SCROLL THE LIST OF FOLLOWERS RANDOMLY
		Loop
		{
			SleepRand(1000,3500)
			Text:="|<Follow>*189$45.zzzzzzzs3ztbzzz0TzAzzztzUtb1WADs3Ak4F074Na8W80tnAnaF9zCNaQk1DsXAl649z0Na0sXDw7AsD4TzzzzzzzU"
			if (ok:=FindText(810-150//2, 359-300//2, 150, 300, 0, 0, Text))
			{
				CoordMode, Mouse
				X:=ok.1.1, Y:=ok.1.2, W:=ok.1.3, H:=ok.1.4, Comment:=ok.1.5, X+=W//2, Y+=H//2
				MouseMove %X%, %Y%
				CoordMode, Pixel, Screen
			}
			Else
			{
				errorMsg = failed to find follow button
				Return % Array(functionName, startTime, errorMsg, 0,0,0) 
			}
			If A_Index = 1
				Random, r, 1, 35
			Else
				Random, r, 3, 6
			ToolTip, FollowFromGsheet() `n Scroll Follower List n` wheeldown loop %r%
			Loop %r%
			{
				MouseClick, WheelDown
				SleepRand(500,1500)
			}
			toFollow := loopN
			ToolTip, FollowFromGsheet() toFollow loop, 0, 900
			
			;CLICK PROFILE
			;MouseGetPos, x, y
			SleepRand()
			X -= 287
			Y -= 10
			MouseMove, X, Y
			SleepRand()
			MouseGetPos, x, y
			SleepRand()
			ToolTip % x " " y
			SleepRand(1200,3300)
			Click
			SleepRand(1500,3500)
			;Check if story with grey background is displayed
				PixelGetColor, pColour, 1080, 210
				SleepRand()
				If pColour = 0x262626 ; a story is open. Try to close it
				{ 
					ToolTip, FollowFromGsheet A story is on screen
					Send {Tab}
					SleepRand()
					Send {Tab}
					SleepRand()
					Send {Enter}				
					SleepRand(1900,5800)
					PixelGetColor, pColour, 1080, 210
				}
				PixelGetColor, pColour, 1080, 210
				If pColour = 0x262626
					SleepRand(10000,20000)

			SleepRand(1500,3500)
			valid := CheckPage(1,1)
			If !valid
			{
				Tooltip FollowFromGsheet PAGE NOT VALID, 0, 930
				SleepRand()
				Send {BS}
				Continue
			}
			Else
				Break
		}

        Text:="|<grid/posts>*175$12.TyzyWGmGzyWGmGzymGWGzy00U"
        if (ok:=FindText(531-500//2, 733-700//2, 700, 800, 0, 0, Text))
        {
            ClickPost(1)
            SleepRand(1900,2900)
        }
        
        If nLikes = 0
            Random, nLikes, 5, 13
        liked := LikePostsN(nLikes)
        
		Send {ESC}    
        SleepRand(1200,2800)
		Loop 3
		{
			MouseClick, WheelUP
			SleepRand()
		}
        ;click follow btn
        SleepRand(1500,3500)
		Text:="|<Follow>*190$45.0TzAzzzs3ztbzzzDw7AsAlVz0Na0W80sXAl6F87CNaQm9DtnAna09z4Na8kVDs3Ak74NzUtb1sXU"
        if (ok:=FindText(736-400//2, 216-400//2, 400, 400, 0, 0, Text))
        {
            CoordMode, Mouse
            X:=ok.1.1, Y:=ok.1.2, W:=ok.1.3, H:=ok.1.4, Comment:=ok.1.5, X+=W//2, Y+=H//2
            MouseMove, X, Y
            SleepRand()
            Click
			SleepRand(1000,5000)
            followed++
            CoordMode, Pixel, Screen
        }
        Else
        {
            Error := did not find follow button
        	Return % Array(functionName, startTime, Error, 0, liked[1], followed)
        }
        
        SleepRand(1900,5300)
        Send {BS}
        SleepRand(900,5300)
    
		SleepRand(900, 4000)
	
	FormatTime, endTime, ,yyyy-M-d HH:mm:ss tt
	Return % Array(functionName, startTime, endTime, 0, liked, followed)
}

BrowseFeed(nLikes:=0) {
	global profile
	global instaURL
	functionName = BrowseFeed()
	FormatTime, startTime, ,yyyy-M-d HH:mm:ss tt
    ToolTip, %functionName% %startTime%, 0, 900
	If WinExist("ahk_class Chrome_WidgetWin_1") 
	{
		WinActivate
		SleepRand(2200,3700)
		Send ^l
		SleepRand(100)
		Send ^v
		SleepRand(100)
		Send {Enter}
		SleepRand(2600,4600)
	}
	Else
	{
		OpenUrlChrome(instaURL, profile[1])
		SleepRand(4200,6300)
	}
	SleepRand(3000,6000)
    if nLikes = 0
		Random, nLikes, 2, 8
	
    liked = 0

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
    }
	Else
    {
        errorMsg = homeBtn.png NOT found
        Return % Array(functionName, startTime, errorMsg, 0,0,0) 
    }
	MouseMove, 350, 350
	SleepRand()
	
	While liked < nLikes
	{
		Random, s, 4, 10
			Loop % s
			{
				MouseClick, WheelDown
				SleepRand()
				MouseClick, WheelDown
				SleepRand(400,1500)
			}
			Text:="|<White Heart>*169$24.3s7k66MM83k4E1U2E002U001U001U001U001U001k003E0028004A00A600M300k1U1U0k300M60048002E001U0U"
            if (ok:=FindText(100-700//2, 100-600//2, 700, 900, 0, 0, Text))
            {	
				
        		CoordMode, Mouse
				X:=ok.1.1, Y:=ok.1.2, W:=ok.1.3, H:=ok.1.4, Comment:=ok.1.5, X+=W//2, Y+=H//2
				If Y < 330
				{   
					MouseMove, X, Y
					SleepRand(200,1200)
					Click
					liked++
				}
				Else
				{
					Random, x, 30, 40
					Random, y, 30, 180
					SleepRand(300,2599)
					X+=x
					Y+=y
					MouseMove, %X%, %Y%
					SleepRand(333,1300)
					Click 2	
					SleepRand()
					liked++
				}
				CoordMode, Pixel, Screen
            }
		SleepRand(333,3333)
	}
	FormatTime, endTime, ,yyyy-M-d HH:mm:ss tt
	Return % Array(functionName, startTime, endTime, 0, liked, 0)
}
 
BrowseHashtags(igAccount) {
	functionName = BrowseHashtags()	
	Random,n,1,3
	If n = 1
	imgType := "d"
	Else If n = 2
	imgType := "o"
	Else
	imgType := "w"
	hashtagString := GetHashtags(imgFormat, imgType, igAccount)
	hashtagArray := StrSplit(hashtagString, "#")
	url := "https://www.instagram.com/explore/tags/" hashtagArray[2]
	Clipboard := url
	
	CoordMode, Pixel, Screen
	ToolTip, BrowseHashtags() ,0,920
	FormatTime, startTime, ,yyyy-M-d HH:mm:ss tt
	likedTotal = 0
	followedTotal = 0
	SleepRand(100,700)
		/* 										;  go to my profile
		Text:="|<my profile>*170$22.0Dk01VU0A301U604080E0U10204080M1U0kA01VU03w000000001zzsA00lU01g003U006000M001U006000M001U"
		if (ok:=FindText(1148-150//2, 100-150//2, 1500, 1500, 0, 0, Text))
		{
			CoordMode, Mouse
			X:=ok.1.1, Y:=ok.1.2, W:=ok.1.3, H:=ok.1.4, Comment:=ok.1.5, X+=W//2, Y+=H//2
			MouseMove, %X%, %Y%
			SleepRand()
			Click
			SleepRand(1500,5000)
			CoordMode, Pixel, Screen
		}
		Else
		{
			FormatTime, endTime, ,yyyy-M-d HH:mm:ss tt
			errorMsg := not found myprofile.png
			Return % Array(functionName, startTime, endTime, errorMsg, 0,0,0) 
		}	
		ToolTip, BrowseHashtags() open first post,0, 920
		Loop 4
			MouseClick, WheelUP
		SleepRand(1000,4500)
		PixelGetColor, pColour, 1180, 170    
		While pColour = 0xFAFAFA       		 	; White background = no post is open
		{
			If A_Index > 5              		; Break loop after 5 tries
			{
				FormatTime, endTime, ,yyyy-M-d HH:mm:ss tt
				errorMsg := "Error: failed to open a post"
				Return % Array(functionName, startTime, endTime, errorMsg, 0,0,0) 
			}
			Tooltip, browsehashtags white bg,0,900
			SleepRand()               			; Find new location of grid icon
			Text:="|<grid/posts>*175$12.TyzyWGmGzyWGmGzymGWGzy00U"
			if (ok:=FindText(531-500//2, 733-700//2, 700, 800, 0, 0, Text))
			{                           		; Shift coordinates to first photo square
				CoordMode, Mouse
				X:=ok.1.1, Y:=ok.1.2, W:=ok.1.3, H:=ok.1.4, Comment:=ok.1.5, X+=W//2, Y+=H//2 
				Random, r, 34, 302
				X := X - r
				Random, r, 60, 260
				Y := Y + r
				If Y > 650
					Y = 650
				MouseMove, %X%, %Y%
				SleepRand()
				Click              		    		  ; Click in region of first photo
				SleepRand(1500,3500)
				CoordMode, Pixel, Screen
			}
			Else
			{
				Send {Down}
				SleepRand()
				Continue
			}
			SleepRand(500,1500)
			PixelGetColor, pColour, 1180, 170
		}
		SleepRand(500,1500)
													; Click in region of hashtags
		MouseMove, 960, 330
		Loop, 7
		{
			SleepRand()
			MouseClick, WheelUP
		}
		SleepRand(500,1000)
		Text:="|<>*162$8.4U8WzmEYzoF8G8"
		While !(ok:=FindText(972-150000//2, 344-150000//2, 150000, 150000, 0, 0, Text))
		{
			Tooltip, not found hashtag,0,900
			sleeprand(1400,2400)
			Text1:="|<right arrow>*162$14.zzszy7zUzw7zUzw7zUzw7zUzw7zUzsDw3y1z0zUTkDs7w3y1zUzsTyDzzzs"
				if (ok1:=FindText(1163-500//2, 388-500//2, 500, 500, 0, 0, Text1))
				{
					Tooltip, click right arrow ,0,900
					sleeprand(500,2000)
					CoordMode, Mouse
					X:=ok1.1.1, Y:=ok1.1.2, W:=ok1.1.3, H:=ok1.1.4, Comment:=ok1.1.5, X+=W//2, Y+=H//2
					SleepRand()
					MouseMove, %X%, %Y%
					SleepRand()
					Click
					SleepRand(500,2000)
					CoordMode, Pixel, Screen
					MouseMove, 960, 330
					Loop, 7
					{
						SleepRand()
						MouseClick, WheelUP
					}
				}
		}
		Tooltip, hashtag found or after while loop,0,900

		SleepRand(1000, 2500)
		CoordMode, Pixel, Screen
		PixelGetColor, pColour, 1180, 170
		SleepRand()
		While pColour = 0x7D7D7D        			; DARK GREY - post is open
		{
			SleepRand(1000,2500)
			Tooltip, my post is open, 0, 900
			/* 
			If A_Index > 10              ; click next arrow to try a different post
			{
				Text:="|<right arrow>*162$14.zzszy7zUzw7zUzw7zUzw7zUzw7zUzsDw3y1z0zUTkDs7w3y1zUzsTyDzzzs"
				if (ok:=FindText(1163-500//2, 388-500//2, 500, 500, 0, 0, Text))
				{
					CoordMode, Mouse
					X:=ok.1.1, Y:=ok.1.2, W:=ok.1.3, H:=ok.1.4, Comment:=ok.1.5, X+=W//2, Y+=H//2
					SleepRand()
					MouseMove, %X%, %Y%
					SleepRand()
					Click
					SleepRand(1500,3000)
					CoordMode, Pixel, Screen
				}
			}
			
			If A_Index > 15             ; Give up trying to open hashtags
			{
				FormatTime, endTime, ,yyyy-M-d HH:mm:ss tt
				errorMsg := error clicking on hashtags
				Return % Array(functionName, startTime, endTime, errorMsg, 0,0,0) 
			}
			Tooltip, BrowseHashtags Tab down, 0, 900
			SleepRand()
			Random, r, 23, 37
			SleepRand()
			Loop %r%
			{
				Send {Tab}
				SleepRand()
			}
			Send {Enter}
			SleepRand(2600,5600)
			PixelGetColor, pColour, 1180, 170
			Tooltip, pColour %pColour%,0,900
			SleepRand(500,2500)
		}
		SleepRand()
	 */	

	Random, r, 2, 3
	Loop % r
	{
		If WinExist("ahk_class Chrome_WidgetWin_1") 
		{
			WinActivate
			SleepRand(2200,3700)
			Send ^l
			SleepRand(100)
			Send ^v
			SleepRand(100)
			Send {Enter}
			SleepRand(2600,4600)
		}
		Else
		{
			OpenUrlChrome(url, profile[1])
			SleepRand(4200,6300)
		}
		Text:="|<Follow>*190$45.0TzAzzzs3ztbzzzDw7AsAlVz0Na0W80sXAl6F87CNaQm9DtnAna09z4Na8kVDs3Ak74NzUtb1sXU"
		If !(ok:=FindText(600-400//2, 216-200//2, 500, 300, 0, 0, Text))
		{
			Random, n, 3, 9
			url := "https://www.instagram.com/explore/tags/" hashtagArray[%n%]
			Continue

		}

		followed = 0
		random, n, 5, 35
		Loop % n
		{
			MouseClick, WheelDown
			SleepRand()
		}
		SleepRand()
		ToolTip start loop ClickPost, 0, 900
		SleepRand(777,1770)

		clicked := ClickPost(1)
		If !clicked
			Continue
		
		SleepRand(1777,3770)
		
		ToolTip, BrowseHashtags tab to target profile, 0, 900

		Send {Tab} 						; open profile by TABBING
		SleepRand()
		Send {Tab}
		SleepRand()
		Send {Enter}
		SleepRand(1100,5200)
		PixelGetColor, pColour, 1180, 170
		SleepRand()

		pageValid := CheckPage()
		If !pageValid
			Continue

		While pColour = 0xFAFAFA 	; WHITE
		{
			outerLoopCount := A_Index
			If outerLoopCount > 8
			{
				Continue
				/* 
				ToolTip, BrowseHashtags() failed to open following - reloading, 0, 900
				FormatTime, endTime, ,yyyy-M-d HH:mm:ss tt
				errorMsg := failed to open post on target profile
				Return % Array(functionName, startTime, endTime, errorMsg, 0,0,0) 
				 */
			}

			Text:="|<grid/posts>*175$12.TyzyWGmGzyWGmGzymGWGzy00U"
			if (ok:=FindText(531-700//2, 733-700//2, 700, 800, 0, 0, Text))            
			{
				X:=ok.1.1, Y:=ok.1.2, W:=ok.1.3, H:=ok.1.4, Comment:=ok.1.5, X+=W//2, Y+=H//2 
				If Y > 600
				{
					Loop 3
						MouseClick, WheelDown
					
					ok:=FindText(531-700//2, 733-700//2, 700, 800, 0, 0, Text)
					X:=ok.1.1, Y:=ok.1.2, W:=ok.1.3, H:=ok.1.4, Comment:=ok.1.5, X+=W//2, Y+=H//2 
					
				}
				ClickPost(1)
			}
			Else
			{
				MouseClick, WheelDown
			}
			SleepRand(1500, 3310)
			PixelGetColor, pColour, 1180, 170
		}
		
		SleepRand(1500,3000)
		
		liked := LikePostsN()
		likedTotal += liked[1]
		SleepRand(1500,3500)
		Send {ESC}
		SleepRand(1500,5500)

		Send {Home}
		SleepRand(1500,3500)

		pageValid := CheckPage()
			If !pageValid
				Continue
		
		Text:="|<Follow>*190$45.0TzAzzzs3ztbzzzDw7AsAlVz0Na0W80sXAl6F87CNaQm9DtnAna09z4Na8kVDs3Ak74NzUtb1sXU"
		if (ok:=FindText(600-400//2, 216-200//2, 500, 300, 0, 0, Text))
		{
			CoordMode, Mouse
			X:=ok.1.1, Y:=ok.1.2, W:=ok.1.3, H:=ok.1.4, Comment:=ok.1.5, X+=W//2, Y+=H//2
			MouseMove, X, Y
			SleepRand()
			Click     
			SleepRand(1000,2000) 
			followed++     
			followedTotal += followed
			CoordMode, Pixel, Screen 
		}        
		
		SleepRand(900,2700)
		
		;msgbox % liked[3]
		/* 
		Loop % (liked[3]+4)
		{
			SleepRand(900,1400)
			Send {BS} ; back to last hashtag page
		}
		*/
		Send ^l
		SleepRand()
		Send ^v
		SleepRand()
		Send {Enter}
		SleepRand(2600,3600)
	}

	Text:="|<insta logo>*147$22.3zz0zzz700CM00P00Aw0knkDkD1nUwA33kkAD60MwM1XkkAD30kw7C3kDkD0A0w003M00Nk03Xzzw3zz2"
    if (ok:=FindText(202-500//2, 100-500//2, 500, 500, 0, 0, Text))
    {
        CoordMode, Mouse
        X:=ok.1.1, Y:=ok.1.2, W:=ok.1.3, H:=ok.1.4, Comment:=ok.1.5, X+=W//2, Y+=H//2
        MouseMove, X, Y
        SleepRand()
        Click
		SleepRand(1000,3000)
        CoordMode, Pixel, Screen
    }
	SleepRand()
	FormatTime, endTime, ,yyyy-M-d HH:mm:ss tt
	;msgbox % "liked[1] " liked[1] " liked[2] " liked[2] " liked[3] " liked[3] " followed " followedTotal " likedTotal " likedTotal
	Return % Array(functionName, startTime, endTime, 0, liked[1], followed)
}

Unfollow(nUnfollow := 1){
	functionName = Unfollow
    unfollowed = 0
	Tooltip, unfollow, 0,900
	FormatTime, startTime, ,yyyy-M-d HH:mm:ss tt
	SleepRand(1500,3500)
	; CLICK MY PROFILE BTN
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
    }
	Else
	{
		Tooltip, Unfollow() myprofile.png NOT found, 0,900
		SleepRand()
	    FormatTime, endTime, ,yyyy-M-d HH:mm:ss tt	
		errorMsg = myprofile.png NOT found
		Return % Array(startTime, 0, errorMsg, functionName)
	}
	SleepRand(1800,4577)
	; OPEN FOLLOWING LIST
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
    }
	Else
    {
		errorMsg = following.png NOT found
		Return % Array(functionName, startTime, errorMsg, 0,0,0) 
	}
	{ ; SCROLL THE LIST OF FOLLOWERS
		SleepRand(1500,2500)
		;xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
		Random, x, 531,818
        Random, y, 333,564
        MouseMove, %x%, %y%
		SleepRand()
		Random, r, 5,25
		Loop %r%
		{
			MouseClick, WheelDown
			SleepRand(150,750)
		}
		SleepRand(300,1200)
		
		; CLICK FOLLOWING BTN TO UNFOLLOW
        While unfollowed < nUnfollow
        {
            If A_Index > 5
            {
                Tooltip, unfollow failed 5 attempts, 0,900
                errorMsg = Failed to unfollow. No blue found after clicking
			    Return % Array(functionName, startTime, errorMsg, 0,0,0) 
            }
            Random, x, 761,835
            Random, y, 304,573
            MouseMove, %x%, %y%
            SleepRand()
            Click
            SleepRand(1000,3000)
            Text:="|<unfollow>*190$61.MM0703A000AA0601a00066Pblkn3X6P3DvtwNXtbBVbAlrAniPgkn6MlaNXBqMNXAMnAlbjCQlaCtaRlr7wMn3sn7kvUyANUsNVkQm"
            if (ok:=FindText(675-150000//2, 484-150000//2, 150000, 150000, 0, 0, Text))
            {
                CoordMode, Mouse
                X:=ok.1.1, Y:=ok.1.2, W:=ok.1.3, H:=ok.1.4, Comment:=ok.1.5, X+=W//2, Y+=H//2
                MouseMove, X, Y
                SleepRand()
                Click
                SleepRand(1000,2000)
                unfollowed++
                CoordMode, Pixel, Screen
            }
        }
	}
    Send, {BS}
    SleepRand(1500,4500)
	; GO TO INSTA HOME PAGE
    Text:="|<insta logo>*147$22.3zz0zzz700CM00P00Aw0knkDkD1nUwA33kkAD60MwM1XkkAD30kw7C3kDkD0A0w003M00Nk03Xzzw3zz2"
    if (ok:=FindText(202-500//2, 100-500//2, 500, 500, 0, 0, Text))
    {
        CoordMode, Mouse
        X:=ok.1.1, Y:=ok.1.2, W:=ok.1.3, H:=ok.1.4, Comment:=ok.1.5, X+=W//2, Y+=H//2
        MouseMove, X, Y
        SleepRand()
        Click
        SleepRand(2000,4500)
        CoordMode, Pixel, Screen
    }
    FormatTime, endTime, ,yyyy-M-d HH:mm:ss tt
	Return % Array(functionName, startTime, endTime, unfollowed)
}

FindHeartClick() {
	Tooltip, FindHeartClick, 0,1000
	CoordMode, Pixel, Window
    Text:="|<White Heart>*169$24.3s7k66MM83k4E1U2E002U001U001U001U001U001k003E0028004A00A600M300k1U1U0k300M60048002E001U0U"
    if (ok:=FindText(100-700//2, 100-600//2, 700, 900, 0, 0, Text))
    {
        X:=ok.1.1, Y:=ok.1.2, W:=ok.1.3, H:=ok.1.4, Comment:=ok.1.5, X+=W//2, Y+=H//2
        MouseMove, X, Y
        SleepRand()
        Click
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

/* 
GsheetAppendRow(SheetKey, accessToken, cell, values)
{ 
    url =
    url .= "https://sheets.googleapis.com/v4/spreadsheets/" SheetKey
    url .= "/values/" cell  ":append?includeValuesInResponse=true&"
    url .= "valueInputOption=USER_ENTERED&insertDataOption=INSERT_ROWS&access_token=" accessToken
    data = {"majorDimension":"ROWS","range":"%cell%","values":[[%values%]]}
    return PutURL(url, data, "post")
}

 */

GsheetAppendRow(SheetKey, accessToken, cell, values)
{
 
	url := "https://sheets.googleapis.com/v4/spreadsheets/" SheetKey "/values/" cell  ":append?includeValuesInResponse=true&valueInputOption=USER_ENTERED&access_token=" accessToken
	data = {"majorDimension":"ROWS","range":"%cell%","values":[[%values%]]}
	Return PutURL(url, data, "post")
/* 	

    {
    "range": "Sheet1!A1:E1",
    "majorDimension": "ROWS",
    "values": [
        ["Data", 123.45, true, "=MAX(D2:D4)", "10"]
    ],
    }

    {
    "range": "Sheet1!A1:E1",
    "majorDimension": "ROWS",
    "values": [
        ["Door", "$15", "2", "3/15/2016"],
        ["Engine", "$100", "1", "3/20/2016"],
    ],
    }
 */
}

GetWorksheetRange(SheetKey, accessToken, ranges)
{
	url := "https://sheets.googleapis.com/v4/spreadsheets/" sheetkey "/values/" ranges "?access_token=" accessToken
    sheetBatch := URLDownloadToVar(url)
	return sheetBatch
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

^!r::Reload

#p::Pause ; Pressing Win+P once will pause the script. Pressing it again will unpause.