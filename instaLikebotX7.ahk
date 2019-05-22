SetWorkingDir %A_ScriptDir%
#NoEnv
#SingleInstance, force
SetTitleMatchMode, 2
#include JSON.ahk
#include CLR.ahk
#include control.ahk
#include Socket.ahk
#include RemoteObj.ahk
#include instagramAutomation.ahk
#include Jxon.ahk

Start()

Start() {
Loop
{
	serverAddress := "192.168.0.26"
	serverPort := 1337
	Remote := new RemoteObjClient([serverAddress, serverPort])
	loop
	{
		active1 := Remote.check_active("instaLikeBot","start")
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
	;SleepRand(200000, 5000000)
	msgbox,,,ACTIVE,60
	Sleep 1000
	Remote.check_active("instaLikeBot","end")
	Sleep 220000
	Reload

	cell = Sheet1!A1:G1
	global profile := RandChromeProfilePath(myAccessToken)
	instaURL := "http://instagram.com/"
	;instaURL := RandURL()
	CloseChrome()
	SleepRand(1900,3100)
	OpenUrlChrome(instaURL, profile[1])
	Tooltip, sleeping - start(), 0, 900
	SleepRand(2333,5999)
	/* 
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
        ;SleepRand(10000, 200000)
		Random, n, 1, 4
		If n = 1
		{   
			Result := Unfollow() ; array(startTime, endTime, errorMsg, functionName) if Error endTime = 0
			SleepRand()
			response := Report(profile, Result, cell)
			SleepRand(2000, 7000)
		}
		Random, n, 1, 3
		If n = 1
		{
			Result := BrowseFeed()
			SleepRand()
			response := Report(profile, Result, cell)
			SleepRand(2000,7000)
		}
		Random, n, 1, 3
		If n = 1
		{
			SleepRand(100,1500)
			Result := BrowseHashtags(profile[2])
			SleepRand(300,1000)
			response := Report(profile, Result, cell)
			SleepRand(1000, 7000)
		}
		Random, n, 1, 3
		If n = 1
		{
			Random, l, 1, 3
			Loop % l
			{
				SleepRand(900,1200)
				Result := FollowFromGsheet(,,profile)
				SleepRand()
				response := Report(profile, Result, cell)
				SleepRand(300, 3000)
				SleepRand(3000, 22000)
			}
		}
        Random, n, 1, 3
		If n = 1
        {
			Random, l, 2, 4
			Loop % l
            	StartKardashianBot()
        }
	CloseChrome()	
	Remote.check_active("instaLikeBot","end")
	Sleep 60000
	ToolTip, sleeping
	;SleepRand(40000, 150000)
	}
	Tooltip, sleeping
	Random, n, 1, 3
	if n = 0
	{
		SleepRand(100000, 6000000)
	}
	Random, n, 1, 3
	If n = 0
	{
		SleepRand(100000,6000000)
	}
	Remote.check_active("instaLikeBot","end")
	Sleep 160000
	Reload
	}
}

FollowFromGsheet(loopN:=1, nLikes:=0, profileArray:=0) 
{

	functionName = FollowFromGsheet()
	ToolTip, FollowFromGsheet(), 0, 900
	FormatTime, startTime, ,yyyy-M-d HH:mm:ss tt
	liked = 0
	followed = 0
	outer:
	Loop % loopN
	{
		range1 := profileArray[2]"!A2:A"
		;msgbox % range1
		range2 := "H2:H"
		url := "https://sheets.googleapis.com/v4/spreadsheets/" influencer_sheetkey "/values/" range1  "?access_token=" myAccessToken
		influencerSheetData := UrlDownloadToVar(url)
		;msgbox %influencerSheetData%
		oArray := json.Load(influencerSheetData)
		endRow := oArray.values.MaxIndex()
		random, row, 2, %endRow%
		;msgbox % "endRow " endRow " row " row 
		targetAccount := oArray.values[row][1]
		ToolTip, FollowFromGsheet() targetAccount %targetAccount%
		if (targetAccount = "") || (targetAccount = )
		{
			SleepRand()
			errorMsg := "targetAccount is blank for row " row
			Return % Array(functionName, startTime, errorMsg, 0,0,0) 
		}
		instaURL := "http://instagram.com/"targetAccount
		OpenUrlChrome(instaURL, profile[1])
		SleepRand(4333,9999)
		valid := CheckInstagramPage(1,1)
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
			Text:="|<following>*144$59.A090002000U0G000000100Y0000007XV8QEVFQ7I8WF4V2X4FcUYY4Z9491F1989+G8G2W2GEGWYEY544YUZ58V8+8991++F2EI8WF488W4FcC4VkEF48R00000000020000000048000000007Y"
            if (ok:=FindText(834-150//2, 266-150//2, 150, 150, 0, 0, Text))
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
			valid := CheckInstagramPage(1,1)
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
            ClickInstaPost(1)
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
	functionName = BrowseFeed()
	FormatTime, startTime, ,yyyy-M-d HH:mm:ss tt
    ToolTip, %functionName% %startTime%, 0, 900
	SleepRand(3000,6000)
    if nLikes = 0
		Random, nLikes, 1, 5
	
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
	
	SleepRand(1000,4000)
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
	functionName = BrowseHashtags()
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
			OpenUrlChrome(url, profile[1])
			SleepRand(3200,9300)
		}
		Text:="|<Follow>*190$45.0TzAzzzs3ztbzzzDw7AsAlVz0Na0W80sXAl6F87CNaQm9DtnAna09z4Na8kVDs3Ak74NzUtb1sXU"
		If !(ok:=FindText(600-400//2, 216-200//2, 500, 300, 0, 0, Text))
		{
			Random, n, 3, 9
			url := "https://www.instagram.com/explore/tags/" hashtagArray[%n%]
			Continue

		}

		;liked = 0
		followed = 0
		SleepRand(1900,3500)
		random, n, 5, 35
		Loop % n
		{
			MouseClick, WheelDown
			SleepRand()
		}
		SleepRand()
		ToolTip start loop clickinstapost, 0, 900
		SleepRand(777,1770)

		clicked := ClickInstaPost(1)               ; CLICK ON A POST
		If !clicked
			Continue
		
		SleepRand(1777,5770)
		
		ToolTip, BrowseHashtags tab to target profile, 0, 900

		;THIS IS WHERE FOLLOWING HASHTAG BUTTON
		Send {Tab} 						; open profile by TABBING
		SleepRand()
		Send {Tab}
		SleepRand()
		Send {Enter}
		SleepRand(1100,5200)
		PixelGetColor, pColour, 1180, 170
		SleepRand()

		pageValid := CheckInstagramPage()
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
				ClickInstaPost(1)
			}
			Else
			{
				Loop 1
				{
					MouseClick, WheelDown
				}
			}
			SleepRand(1500, 4310)
			PixelGetColor, pColour, 1180, 170
		}
		
		SleepRand(1500,3000)
		
		liked := LikePostsN()
		likedTotal += liked[1]
		;msgbox % "liked[1] " liked[1] " liked[2] " liked[2] " liked[3] " liked[3] " followed " followedTotal " likedTotal " likedTotal

		SleepRand(1500,3500)
		Send {ESC}
		SleepRand(1500,5500)

		Send {Home}
		SleepRand(1500,3500)

		pageValid := CheckInstagramPage()
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
	;foundImg := FindImg("\assets\myprofile.png",,25)
	SleepRand(1500,3500)
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
	PixelGetColor, pColour, 1180, 170
	SleepRand()
	While pColour = 0xFAFAFA ; BG is still white
	{
		foundImg := FindImg("\assets\following.png")
		SleepRand()
		PixelGetColor, pColour, 1180, 170
		SleepRand(100,1900)
		If A_Index > 5
		{
			errorMsg = Error bgColour did not change from 0xFAFAFA after clicking following.png
			Return % Array(functionName, startTime, errorMsg, 0,0,0) 
		}
	}
	; by now the list of followers should be on screen 
	{
		; scroll the list 
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
		
		                    ; click on a following btn
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
	;msgbox client_id %client_id% client_secret %client_secret% refresh_token %refresh_token% 
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

^!r::Reload

#p::Pause ; Pressing Win+P once will pause the script. Pressing it again will unpause.