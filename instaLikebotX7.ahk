SetWorkingDir %A_ScriptDir%
#NoEnv
#SingleInstance, force
SetTitleMatchMode, 2
#include JSON.ahk
#include CLR.ahk
#include control.ahk
; #include googleSheets.ahk
#include instagramAutomation.ahk

Start()

Start() {
Loop
{
	;SleepRand(200000, 5000000)
	cell = Sheet1!A1:G1
	global profile := RandChromeProfilePath(myAccessToken)
	;instaURL := "http://instagram.com/"
	instaURL := RandURL()
	CloseChrome()
	SleepRand(900,2100)
	OpenUrlChrome(instaURL, profile[1])
	Tooltip, sleeping - start(), 0, 900
	SleepRand(2333,3999) 
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
	Random, nLoop, 4, 14
	Loop % nLoop
	{
        ;SleepRand(10000, 200000)
		Random, n, 1, 3
		If n = 1
		{   
			Result := Unfollow() ; array(startTime, endTime, errorMsg, functionName) if Error endTime = 0
			SleepRand()
			response := Report(profile, Result, cell)
			SleepRand(5000, 17000)
		}
		Random, n, 1, 2
		If n = 1
		{
			Result := BrowseFeed()
			SleepRand(100,3300)
			response := Report(profile, Result, cell)
			SleepRand(10000,30000)
		}
		Random, n, 1, 2
		If n = 1
		{
			SleepRand(900,2500)
			Result := BrowseHashtags()
			SleepRand(300,3000)
			response := Report(profile, Result, cell)
			SleepRand(1200,3000)
			SleepRand(10000, 32000)
		}
		Random, n, 1, 2
		If n = 1
		{
			SleepRand(900,1200)
			Result := FollowFromGsheet()
			SleepRand()
			response := Report(profile, Result, cell)
			SleepRand(300, 3000)
			SleepRand(3000, 22000)
		}
        Random, n, 1, 2
		If n = 1
        {
            StartKardashianBot()
        }

	SleepRand(50000, 150000)
	}

	SleepRand(200000, 6000000)
	Random, n, 1, 2
	If n = 1
	{
		SleepRand(200000,6000000)
	}
	Reload
	}
}

FollowFromGsheet(loopN:=1, nLikes:=0) 
{
	
	functionName = FollowFromGsheet()
	ToolTip, FollowFromGsheet(), 0, 900
	FormatTime, startTime, ,yyyy-M-d HH:mm:ss tt
	liked = 0
	followed = 0
	outer:
	Loop % loopN
	{
		range1 := "A2:A"
		range2 := "H2:H"
		url := "https://sheets.googleapis.com/v4/spreadsheets/" influencer_sheetkey "/values/" range1  "?access_token=" myAccessToken
		influencerSheetData := UrlDownloadToVar(url)
		oArray := json.Load(influencerSheetData)
		random, row, 2, 178
		targetAccount := oArray.values[row][1]
		ToolTip, FollowFromGsheet() targetAccount %targetAccount%
		if (targetAccount = "") || (targetAccount = )
		{
			SleepRand(1200,2333)
			errorMsg := "targetAccount is blank for row " row
			Return % Array(functionName, startTime, errorMsg, 0,0,0) 
		}
		instaURL := "http://instagram.com/"targetAccount
		OpenUrlChrome(instaURL, profile[1])
		SleepRand(2333,7999)
		valid := CheckInstagramPage(1,1)
		If !valid
		{
			If A_Index < 6
				Continue
			ToolTip, FollowFromGsheet() PAGE NOT VALID ,0,900
			SleepRand(2200,3300)
			errorMsg := "page not valid for row " row " targetAccount " targetAccount
			Return % Array(functionName, startTime, errorMsg, 0,0,0) 
		}
		ToolTip, FollowFromGsheet() page valid Closing other tab, 0, 900
		SleepRand(333,999)
		Send ^{tab} 
		SleepRand()
		Send ^{F4}
		SleepRand()	
		ToolTip, FollowFromGsheet() click following btn, 0, 900
	}
		;OPEN FOLLOWING LIST
		SleepRand(1800,2800)
		PixelGetColor, pColour, 1080, 210
		SleepRand(300,900)
		While pColour = 0xFAFAFA
		{
			If A_Index > 5
			{
				ToolTip, FollowFromGsheet failed to open following - reloading, 0, 900
				SleepRand(1200,2200)
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
                SleepRand(2000,4000)
                CoordMode, Pixel, Screen
            }
            PixelGetColor, pColour, 1080, 210
		}
		MouseMove, 640, 440
		SleepRand()
		;SCROLL THE LIST OF FOLLOWERS RANDOMLY
		Loop
		{
			SleepRand(1000,2500)
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
				SleepRand(500,1000)
			}
			toFollow := loopN
			ToolTip, FollowFromGsheet() toFollow loop, 0, 900
			
			;CLICK PROFILE
			MouseGetPos, x, y
			SleepRand()
			x -= 287
			y -= 10
			MouseMove, x, y
			SleepRand()
			Click
			SleepRand(1500,2500)
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
					SleepRand(1900,2800)
					PixelGetColor, pColour, 1080, 210
				}
				PixelGetColor, pColour, 1080, 210
				If pColour = 0x262626
					SleepRand(10000,20000)

			SleepRand(500,1500)
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
            SleepRand(1900,900)
        }
        
        If nLikes = 0
            Random, nLikes, 2, 9
        liked := LikePostsN(nLikes)
        
		Send {BS}    
        SleepRand(1200,2800)
		Loop 3
		{
			MouseClick, WheelUP
			SleepRand()
		}
        ;click follow btn
        SleepRand(500,2500)
		Text:="|<Follow>*190$45.0TzAzzzs3ztbzzzDw7AsAlVz0Na0W80sXAl6F87CNaQm9DtnAna09z4Na8kVDs3Ak74NzUtb1sXU"
        if (ok:=FindText(736-400//2, 216-400//2, 400, 400, 0, 0, Text))
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
            Error := did not find follow button
        	Return % Array(functionName, startTime, Error, 0, liked, followed)
        }
        
        SleepRand(900,2300)
        Send {BS}
        SleepRand(900,2300)
    
		SleepRand(900, 2000)
	
	FormatTime, endTime, ,yyyy-M-d HH:mm:ss tt
	Return % Array(functionName, startTime, endTime, 0, liked, followed)
}

BrowseFeed(nLikes:=0) {
	functionName = BrowseFeed()
	FormatTime, startTime, ,yyyy-M-d HH:mm:ss tt
    ToolTip, %functionName% %startTime%, 0, 900
	SleepRand(2000,3000)
    if nLikes = 0
		Random, nLikes, 1, 3
	
    liked = 0

    Text:="|<insta logo>*147$22.3zz0zzz700CM00P00Aw0knkDkD1nUwA33kkAD60MwM1XkkAD30kw7C3kDkD0A0w003M00Nk03Xzzw3zz2"
    if (ok:=FindText(202-500//2, 100-500//2, 500, 500, 0, 0, Text))
    {
        CoordMode, Mouse
        X:=ok.1.1, Y:=ok.1.2, W:=ok.1.3, H:=ok.1.4, Comment:=ok.1.5, X+=W//2, Y+=H//2
        MouseMove, X, Y
        SleepRand()
        Click
        SleepRand(1500,3000)
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
		Random, s, 5, 20
			Loop % s
			{
				MouseClick, WheelDown
				SleepRand()
				MouseClick, WheelDown
				SleepRand(500,1500)
			}
			Text:="|<White Heart>*169$24.3s7k66MM83k4E1U2E002U001U001U001U001U001k003E0028004A00A600M300k1U1U0k300M60048002E001U0U"
            if (ok:=FindText(100-700//2, 100-600//2, 700, 900, 0, 0, Text))
            {	
				
        		CoordMode, Mouse
				X:=ok.1.1, Y:=ok.1.2, W:=ok.1.3, H:=ok.1.4, Comment:=ok.1.5, X+=W//2, Y+=H//2
				If Y < 330
				{   
					MouseMove, X, Y
					SleepRand()
					Click
					liked++
				}
				Else
				{
					Random, x, 30, 40
					Random, y, 30, 180
					SleepRand(1500,2599)
					X+=x
					Y+=y
					MouseMove, %X%, %Y%
					SleepRand(666,1300)
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
 
BrowseHashtags() {
	CoordMode, Pixel, Screen
	; go to instagram.com or click instagram home button
	; look for heart and click inside rectangle above
	;foundImg := FindImg("E:\Development\instabot\assets\search.png")
	ToolTip, BrowseHashtags() ,0,920
	functionName = BrowseHashtags()
	FormatTime, startTime, ,yyyy-M-d HH:mm:ss tt
	liked = 0
	followed = 0
	SleepRand(100,700)
	;  go to my profile
    Text:="|<my profile>*170$22.0Dk01VU0A301U604080E0U10204080M1U0kA01VU03w000000001zzsA00lU01g003U006000M001U006000M001U"
    if (ok:=FindText(1148-150//2, 100-150//2, 1500, 1500, 0, 0, Text))
    {
        CoordMode, Mouse
        X:=ok.1.1, Y:=ok.1.2, W:=ok.1.3, H:=ok.1.4, Comment:=ok.1.5, X+=W//2, Y+=H//2
        MouseMove, %X%, %Y%
        SleepRand()
        Click
        SleepRand(1500,3000)
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
	SleepRand(1000,2500)
	PixelGetColor, pColour, 1180, 170    
	While pColour = 0xFAFAFA        ; White background = no post is open
	{
		If A_Index > 5              ; Break loop after 5 tries
		{
			FormatTime, endTime, ,yyyy-M-d HH:mm:ss tt
			errorMsg := "Error: failed to open a post"
			Return % Array(functionName, startTime, endTime, errorMsg, 0,0,0) 
		}
        Tooltip, browsehashtags white bg,0,900
        SleepRand()                 ; Find new location of grid icon
        Text:="|<grid/posts>*175$12.TyzyWGmGzyWGmGzymGWGzy00U"
        if (ok:=FindText(531-500//2, 733-700//2, 700, 800, 0, 0, Text))
        {                           ; Shift coordinates to first photo square
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
            Click                    ; Click in region of first photo
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
	; Click in region of hashtags
	SleepRand(1000, 2500)
    CoordMode, Pixel, Screen
	PixelGetColor, pColour, 1180, 170
	SleepRand()
	While pColour = 0x7D7D7D        ; DARK GREY - post is open
	{
        SleepRand(500,1500)
        Tooltip, my post is open, 0, 900
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
		SleepRand(3600,5600)
		PixelGetColor, pColour, 1180, 170
        Tooltip, pColour %pColour%,0,900
        SleepRand(1000,2500)
	}
    SleepRand()

	random, n, 10, 30
	Loop %n%
	{
		MouseClick, WheelDown
		SleepRand()
	}
	SleepRand()
	ClickInstaPost(1)               ; CLICK ON A POST
	SleepRand(1777,2770)
	SleepRand()
	ToolTip, BrowseHashtags tab to target profile, 0, 900
	Send {Tab} 	; open profile by TABBING
	SleepRand()
	Send {Tab}
	SleepRand()
	Send {Enter}
	SleepRand(1100,2200)		
	PixelGetColor, pColour, 1180, 170
	SleepRand()
	While pColour = 0xFAFAFA 	; WHITE
	{
		outerLoopCount := A_Index
		If outerLoopCount > 5
		{
			ToolTip, BrowseHashtags() failed to open following - reloading, 0, 900
			SleepRand(1200,2200)
			FormatTime, endTime, ,yyyy-M-d HH:mm:ss tt
			errorMsg := failed to open post on target profile
			Return % Array(functionName, startTime, endTime, errorMsg, 0,0,0) 
			;Reload
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
	
		SleepRand(500, 1310)
		PixelGetColor, pColour, 1180, 170
	}
	
	SleepRand(500,2000)
	liked := LikePostsN()
	SleepRand(1500,3500)
	Send {BS}
	SleepRand(500,2500)

	Loop 5 ; scroll up to ensure we're at the top of the page again
	{
		MouseClick, WheelUp
		SleepRand()
	}
	SleepRand(1500,2500)
	Text:="|<Follow>*190$45.0TzAzzzs3ztbzzzDw7AsAlVz0Na0W80sXAl6F87CNaQm9DtnAna09z4Na8kVDs3Ak74NzUtb1sXU"
	if (ok:=FindText(600-400//2, 216-200//2, 500, 300, 0, 0, Text))
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
	
	SleepRand(900,1700)
	Send {BS}
	SleepRand(900,1700)
	Send {BS} ; back to last hashtag page

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
	SleepRand()
	Return % Array(functionName, startTime, endTime, 0, liked, followed)
}

Unfollow(nUnfollow := 1){
	functionName = Unfollow
    unfollowed = 0
	Tooltip, unfollow, 0,900
	FormatTime, startTime, ,yyyy-M-d HH:mm:ss tt
	;foundImg := FindImg("\assets\myprofile.png",,25)
    Text:="|<my profile>*170$22.0Dk01VU0A301U604080E0U10204080M1U0kA01VU03w000000001zzsA00lU01g003U006000M001U006000M001U"
    if (ok:=FindText(1148-150//2, 100-150//2, 1500, 1500, 0, 0, Text))
    {
        CoordMode, Mouse
        X:=ok.1.1, Y:=ok.1.2, W:=ok.1.3, H:=ok.1.4, Comment:=ok.1.5, X+=W//2, Y+=H//2
        MouseMove, %X%, %Y%
        SleepRand()
        Click
        SleepRand(800,1500)
        CoordMode, Pixel, Screen
    }
	Else
	{
		Tooltip, Unfollow() myprofile.png NOT found, 0,900
		SleepRand()
		errorMsg = myprofile.png NOT found
		Return % Array(startTime, 0, errorMsg, functionName)
	}
	SleepRand(800,1577)
	
    Text:="|<following>*144$59.A090002000U0G000000100Y0000007XV8QEVFQ7I8WF4V2X4FcUYY4Z9491F1989+G8G2W2GEGWYEY544YUZ58V8+8991++F2EI8WF488W4FcC4VkEF48R00000000020000000048000000007Y"
    if (ok:=FindText(834-150//2, 266-150//2, 150, 150, 0, 0, Text))
    {
        CoordMode, Mouse
        X:=ok.1.1, Y:=ok.1.2, W:=ok.1.3, H:=ok.1.4, Comment:=ok.1.5, X+=W//2, Y+=H//2
        MouseMove, %X%, %Y%
        SleepRand()
        Click
        SleepRand(500,1500)
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
		SleepRand(600,1210)
		PixelGetColor, pColour, 1180, 170
		SleepRand(100,900)
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
		Random, r, 5,35
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
    SleepRand(1000,1500)
    Text:="|<insta logo>*147$22.3zz0zzz700CM00P00Aw0knkDkD1nUwA33kkAD60MwM1XkkAD30kw7C3kDkD0A0w003M00Nk03Xzzw3zz2"
    if (ok:=FindText(202-500//2, 100-500//2, 500, 500, 0, 0, Text))
    {
        CoordMode, Mouse
        X:=ok.1.1, Y:=ok.1.2, W:=ok.1.3, H:=ok.1.4, Comment:=ok.1.5, X+=W//2, Y+=H//2
        MouseMove, X, Y
        SleepRand()
        Click
        SleepRand(1000,2500)
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