SetWorkingDir %A_ScriptDir%
#NoEnv
#SingleInstance, force
SetTitleMatchMode, 2
#include JSON.ahk
#include CLR.ahk
#include control.ahk
#include instagramAutomation.ahk

Start()

Start() {
Loop
{
	cell = Sheet1!A1:G1
	global profile := RandChromeProfilePath()
	;instaURL := "http://instagram.com/"
	instaURL := RandURL()
	CloseChrome()
	SleepRand(900,2100)
	OpenUrlChrome(instaURL, profile[1])
	Tooltip, sleeping - start(), 0, 900
	SleepRand(1333,2999) 
	
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
		
	SleepRand()
	Random, nLoop, 6, 14
	Loop % nLoop
	{
        ;SleepRand(10000, 200000)
		Random, n, 1, 1
		If n = 0
		{   
			Result := Unfollow() ; array(startTime, endTime, errorMsg, functionName) if Error endTime = 0
			SleepRand()
			response := Report(profile, Result, cell)
			SleepRand(5000, 17000)
		}
		Random, n, 1, 1
		If n = 0
		{   ;Broken not opening profile
			SleepRand(1300, 2200)
			Result := BrowseFeed()
			SleepRand(100,3300)
			response := Report(profile, Result, cell)
			SleepRand(5000, 12000)
		}
		Random, n, 1, 1
		If n = 1
		{   ; Broken
			SleepRand(900,2500)
			Result := BrowseHashtags()
			SleepRand(300,3000)
			response := Report(profile, Result, cell)
			SleepRand(1200,3000)
			SleepRand(1000, 12000)
		}
		Random, n, 1, 1
		If n = 0
		{
			SleepRand(900,1200)
			Result := FollowFromGsheet()
			SleepRand()
			response := Report(profile, Result, cell)
			SleepRand(300, 3000)
			SleepRand(3000, 22000)
		}
        Random, n, 1, 1
        If n = 0
        {
            StartKardashianBot()
        }
	SleepRand(10000, 20000)
	}
     
    /* 
	result := KardashianComment()
	response := Report(profile,result,cell)
	SleepRand(500,5000)
	result := LikeCommentersPosts(3)
	response := Report(profile,result,cell)	
     */
	SleepRand(10000, 20000)
	}
	SleepRand(122000, 1222000)
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
		valid := CheckInstagramPage()
		If !valid
		{
			ToolTip, FollowFromGsheet() PAGE NOT VALID ,0,900
			SleepRand(2200,3300)
			errorMsg := "page not valid  for row " row " targetAccount " targetAccount
			Return % Array(functionName, startTime, errorMsg, 0,0,0) 
		}
		ToolTip, FollowFromGsheet() page valid Closing other tab, 0, 900
		SleepRand(333,999)
		Send ^{tab} 
		SleepRand()
		Send ^{F4}
		SleepRand()	
		ToolTip, FollowFromGsheet() click following btn, 0, 900
			
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
                SleepRand(1000,2000)
                CoordMode, Pixel, Screen
            }
            PixelGetColor, pColour, 1080, 210
		}
		MouseMove, 640, 440
		SleepRand()
		;SCROLL THE LIST OF FOLLOWERS RANDOMLY
		Random, r, 1, 35
		ToolTip, FollowFromGsheet() `n Scroll Follower List n` wheeldown loop %r%
		Loop %r%
		{
            MouseClick, WheelDown
            SleepRand()
		}
		toFollow := loopN
		ToolTip, FollowFromGsheet() toFollow loop, 0, 900
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
        ;CLICK PROFILE
        MouseGetPos, x, y
        SleepRand()
        x -= 287
        y -= 10
        MouseMove, x, y
        SleepRand()
        Click
        SleepRand(500,1500)
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
                SleepRand(900,1800)
                PixelGetColor, pColour, 1080, 210
            }
            PixelGetColor, pColour, 1080, 210
            If pColour = 0x262626
                SleepRand(20000,30000)

        SleepRand(500,1500)
        valid := CheckInstagramPage()
        If !valid
        {
            Tooltip FollowFromGsheet PAGE NOT VALID, 0, 930
            SleepRand(1200,3300)
            Continue outer
        }
        Text:="|<grid/posts>*175$12.TyzyWGmGzyWGmGzymGWGzy00U"
        if (ok:=FindText(531-500//2, 733-700//2, 700, 800, 0, 0, Text))
        {
            ClickInstaPost(1)
            SleepRand(600,1900)
        }
        
        If nLikes = 0
            Random, nLikes, 2, 9
        LikePostsN(nLikes)
    /* 
        Random, r, 1,4
        If r > 1
        {
            FindHeartClick()
            SleepRand()
            liked+=1
        }
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
        ;like n posts
       
        ToolTip, FollowFromGsheet Liking %nLikes% posts,0,900
        Loop % nLikes
        {
            Random, r, 1, 3
            If r = 1    ; skip photo
            {
                nLikes+=1
                SleepRand(1200,2300)
            }
            Else If r = 2   ; click heart
            {
                SleepRand(1300,2300)
                FindHeartClick()
                SleepRand()
                liked++
            }
            Else            ; Double click photo
            {
                SleepRand(1100,2300)
                Random, X, 237,681
                Random, Y, 306,677
                MouseMove, %X%, %Y%
                SleepRand()
                Click 2
                SleepRand()
                liked++
            }
            Random, X, 1103, 1138
            Random, Y, 479, 515
            MouseMove, X, Y
            SleepRand()
            Click
            SleepRand(800,1899)
        }
    */
        Send {BS}    
        SleepRand(1200,2800)
        
        ;click follow btn
        Text:="|<Follow>*190$45.0TzAzzzs3ztbzzzDw7AsAlVz0Na0W80sXAl6F87CNaQm9DtnAna09z4Na8kVDs3Ak74NzUtb1sXU"
        if (ok:=FindText(736-400//2, 216-400//2, 400, 400, 0, 0, Text))
        {
            CoordMode, Mouse
            X:=ok.1.1, Y:=ok.1.2, W:=ok.1.3, H:=ok.1.4, Comment:=ok.1.5, X+=W//2, Y+=H//2
            MouseMove, X, Y
            SleepRand()
            Click
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
	}
	FormatTime, endTime, ,yyyy-M-d HH:mm:ss tt
	Return % Array(functionName, startTime, endTime, 0, liked, followed)
}

BrowseFeed(loopN:=1, nLikes:=0) {
	functionName = BrowseFeed()
	FormatTime, startTime, ,yyyy-M-d HH:mm:ss tt
    ToolTip, %functionName% %startTime%, 0, 900
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
        SleepRand()
        CoordMode, Pixel, Screen
    }
	Else
    {
        errorMsg = homeBtn.png NOT found
        Return % Array(functionName, startTime, errorMsg, 0,0,0) 
    }
	Random, r, 1, 15
    Loop r
        MouseClick, WheelDown

	While liked < nLikes
	{
		SleepRand(400,2000)
		ImageSearch, FoundX, FoundY, 170, 150, 220, 870, \assets\whiteHeart.png
		SleepRand(666, 1500)
		While ErrorLevel != 0
		{
			ToolTip, BrowseFeed() while loop, 0, 900
			If A_Index > 15
			{
				errorMsg = no whiteHeart.png found
				Return % Array(functionName, startTime, errorMsg, 0,0,0) 
			}
			Random, s, 3, 6
			Loop % s
			{
				MouseClick, WheelDown
				SleepRand()
			}
			SleepRand(250, 1600)
            
            Text:="|<White Heart>*169$24.3s7k66MM83k4E1U2E002U001U001U001U001U001k003E0028004A00A600M300k1U1U0k300M60048002E001U0U"
            if (ok:=FindText(100-700//2, 100-600//2, 700, 900, 0, 0, Text))
            {
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
                    liked += 1
                 }
            }
		}
		SleepRand(333,3333)
	}
    Text:="|<insta logo>*147$22.3zz0zzz700CM00P00Aw0knkDkD1nUwA33kkAD60MwM1XkkAD30kw7C3kDkD0A0w003M00Nk03Xzzw3zz2"
    if (ok:=FindText(202-500//2, 100-500//2, 500, 500, 0, 0, Text))
    {
        CoordMode, Mouse
        X:=ok.1.1, Y:=ok.1.2, W:=ok.1.3, H:=ok.1.4, Comment:=ok.1.5, X+=W//2, Y+=H//2
        MouseMove, X, Y
        SleepRand()
        Click
        SleepRand()
        CoordMode, Pixel, Screen
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
        SleepRand()
        CoordMode, Pixel, Screen
    }
    Else
    {
        FormatTime, endTime, ,yyyy-M-d HH:mm:ss tt
        errorMsg := not found myprofile.png
        Return % Array(functionName, startTime, errorMsg, 0,0,0) 
    }	
	                                ; Open first post
	ToolTip, BrowseHashtags() open first post,0, 920
    Loop 4
        MouseClick, WheelUP
	SleepRand(500,1500)
	PixelGetColor, pColour, 1180, 170    
	While pColour = 0xFAFAFA        ; White background = no post is open
	{
		If A_Index > 5              ; Break loop after 5 tries
		{
			FormatTime, endTime, ,yyyy-M-d HH:mm:ss tt
			errorMsg := "Error: failed to open a post"
			Return % Array(functionName, startTime, endTime, errorMsg, 0,0,0) 
		}
    /* 
        Text:="|<grid icon>*175$12.TyzyWGmGzyWGmGzymGWGzy00U"
        If (ok:=FindText(531-500//2, 733-700//2, 700, 800, 0, 0, Text))
        {
            X:=ok.1.1, Y:=ok.1.2, W:=ok.1.3, H:=ok.1.4, Comment:=ok.1.5, X+=W//2, Y+=H//2
                                            ; Move page a little up or down
            If Y < 380
                Send, {Up}
            Else
                Loop 2
                {
                    Send, {Down}
                    SleepRand()
                }
        }
        Else
        {
            Send, {Down}
            SleepRand()
            Continue
        }       
    */  
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
            SleepRand(500,1500)
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
		; IF still no change move cursor to next photo region
        /* 
            X+=300
            SleepRand()
            MouseMove, %X%, %Y%
            SleepRand(700,1200)
            Click
            SleepRand()
            PixelGetColor, pColour, 1180, 170
         */
	}
	                                ; Click in region of hashtags
	SleepRand(500, 1500)
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
                SleepRand(500,1500)
            }
		}
		If A_Index > 15             ; Give up trying to open hashtags
		{
			FormatTime, endTime, ,yyyy-M-d HH:mm:ss tt
			errorMsg := error clicking on hashtags
			Return % Array(functionName, startTime, errorMsg, 0,0,0) 
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
		SleepRand(2600,3600)
		PixelGetColor, pColour, 1180, 170
        Tooltip, pColour %pColour%,0,900
        SleepRand(1000,2500)
	}
    SleepRand()
	Random, r, 1, 3                  ; Scroll down hashtag feed
	Loop, %r%
	{
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
     /* 
		While pColour = 0xFAFAFA    ; WHITE
		{
			ToolTip, BrowseHashtags() pColour 0xFAFAFA, 0, 900
			If A_Index > 5
			{
				ToolTip, BrowseHashtags() failed to open  - reloading, 0, 900
				SleepRand(1200,2200)
				FormatTime, endTime, ,yyyy-M-d HH:mm:ss tt
				errorMsg := BrowseHashtags failed clicking on post in hashtag feed
				Return % Array(functionName, startTime, errorMsg, 0,0,0) 
			}
			Tooltip, BrowseHashtags() bgColour FAFAFA try again
			Random, x, 202, 1072
			Random, y, 219, 650
			MouseMove, %x%, %y%
			SleepRand(300,1100)
			Click
			SleepRand(800,2800)
			PixelGetColor, pColour, 1180, 170
		}
 */
		; open profile by TABBING
		ToolTip, BrowseHashtags tab to target profile, 0, 900
		;While pColour = 0x3F3F3F ; GREY
		
			Send {Tab}
			SleepRand()
			Send {Tab}
			SleepRand()
			Send {Enter}
			SleepRand(1100,2200)
			
		; open first image in profile
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
				Return % Array(functionName, startTime, errorMsg, 0,0,0) 
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
        /* 
			foundImg := FindImg("\assets\postsIcon.png",3)
			SleepRand()
			While !foundImg
			{
				MouseClick, WheelUp
				SleepRand()
				MouseClick, WheelUp
				SleepRand()
				foundImg := FindImg("\assets\postsIcon.png",3)
				SleepRand()
				If A_Index > 20
				{
					ToolTip, BrowseHashtags() failed to find postsIcon.png, 0, 900
					SleepRand(1200,2200)
					FormatTime, endTime, ,yyyy-M-d HH:mm:ss tt
					errorMsg := failed to find postsIcon.png
					Return % Array(functionName, startTime, errorMsg, 0,0,0) 
				}
			}
             
			Text:="|<grid/posts>*175$12.TyzyWGmGzyWGmGzymGWGzy00U"
            if (ok:=FindText(531-500//2, 733-700//2, 700, 800, 0, 0, Text))
            {
                X:=ok.1.1, Y:=ok.1.2, W:=ok.1.3, H:=ok.1.4, Comment:=ok.1.5, X+=W//2, Y+=H//2 
                sY := Y+35
                eY := Y+235
                Random, X, 237,681
                Random, Y, sY,eY
                SleepRand()
                MouseMove, %X%, %Y%
                SleepRand()
                Click

            }
        */
			SleepRand(500, 1310)
			PixelGetColor, pColour, 1180, 170
		}
		; Click on the > button
    /* 
		Random, X, 1103, 1138
		Random, Y, 479, 515
		MouseMove, %x%, %y%	
		SleepRand()
		Click
		SleepRand(200,500)
 */
		; browse profile like photos
        /* 
		Random, nLikes, 1, 5
		ToolTip, BrowseHashtags() Liking %nLikes% posts,0,900
		Loop % nLikes
		{ 
			Random, r, 1, 3 ; action to take
			If r = 1 ; don't like / no action
			{
				;nLikes+=1
				SleepRand(1200,2300)
			}
			If r = 2 ; click heart
			{
				SleepRand(1300,2300)
				FindHeartClick()
				liked+=1
			}
			If r = 3 ; double click img
			{
				SleepRand(1100,2300)
				Random, X, 237,681
				Random, Y, 306,650
				MouseMove, %X%, %Y%
				SleepRand()
				Click 2
				SleepRand()
				liked+=1
			}
			; click next arrow
			Text:="|<right arrow>*162$14.zzszy7zUzw7zUzw7zUzw7zUzw7zUzsDw3y1z0zUTkDs7w3y1zUzsTyDzzzs"
            if (ok:=FindText(1163-500//2, 388-500//2, 500, 500, 0, 0, Text))
            {
                CoordMode, Mouse
                X:=ok.1.1, Y:=ok.1.2, W:=ok.1.3, H:=ok.1.4, Comment:=ok.1.5, X+=W//2, Y+=H//2
                SleepRand()
                MouseMove, %X%, %Y%
                SleepRand()
                Click
                SleepRand(500,1500)
            }
		}
     */
		LikePostsN()
        SleepRand()
        Text:="|<insta logo>*147$22.3zz0zzz700CM00P00Aw0knkDkD1nUwA33kkAD60MwM1XkkAD30kw7C3kDkD0A0w003M00Nk03Xzzw3zz2"
        if (ok:=FindText(202-500//2, 100-500//2, 500, 500, 0, 0, Text))
        {   
            CoordMode, Mouse
            X:=ok.1.1, Y:=ok.1.2, W:=ok.1.3, H:=ok.1.4, Comment:=ok.1.5, X+=W//2, Y+=H//2
            MouseMove, X, Y
            SleepRand()
            Click
            CoordMode, Pixel, Screen
        }
		SleepRand(500,1200)
        Loop 5 ; scroll up to ensure we're at the top of the page again
		{
            MouseClick, WheelUp
            SleepRand()
		}
        Text:="|<Follow>*190$45.0TzAzzzs3ztbzzzDw7AsAlVz0Na0W80sXAl6F87CNaQm9DtnAna09z4Na8kVDs3Ak74NzUtb1sXU"
        if (ok:=FindText(841-200//2, 216-200//2, 150000, 150000, 0, 0, Text))
        {
            CoordMode, Mouse
            X:=ok.1.1, Y:=ok.1.2, W:=ok.1.3, H:=ok.1.4, Comment:=ok.1.5, X+=W//2, Y+=H//2
            MouseMove, X, Y
            SleepRand()
            Click      
            followed++     
            CoordMode, Pixel, Screen 
        }        
		SleepRand(900,1700)
		Send {BS}
		SleepRand(900,1700)
		Send {BS} ; back to last hashtag page
	}
		;msgbox near end send bs
	Text:="|<insta logo>*147$22.3zz0zzz700CM00P00Aw0knkDkD1nUwA33kkAD60MwM1XkkAD30kw7C3kDkD0A0w003M00Nk03Xzzw3zz2"
    if (ok:=FindText(202-500//2, 100-500//2, 500, 500, 0, 0, Text))
    {
        CoordMode, Mouse
        X:=ok.1.1, Y:=ok.1.2, W:=ok.1.3, H:=ok.1.4, Comment:=ok.1.5, X+=W//2, Y+=H//2
        MouseMove, X, Y
        SleepRand()
        Click
        CoordMode, Pixel, Screen
    }
	SleepRand()
	FormatTime, endTime, ,yyyy-M-d HH:mm:ss tt
	SleepRand()
	Return % Array(functionName, startTime, endTime, 0, liked, followed)
}

Unfollow(Lp := 1){
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
        While unfollowed < Lp
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
            SleepRand()
                        ; confirmation box should be on screen
			SleepRand(200,500)
            Text:="|<unfollow>*190$61.MM0703A000AA0601a00066Pblkn3X6P3DvtwNXtbBVbAlrAniPgkn6MlaNXBqMNXAMnAlbjCQlaCtaRlr7wMn3sn7kvUyANUsNVkQm"
            if (ok:=FindText(675-150000//2, 484-150000//2, 150000, 150000, 0, 0, Text))
            {
                CoordMode, Mouse
                X:=ok.1.1, Y:=ok.1.2, W:=ok.1.3, H:=ok.1.4, Comment:=ok.1.5, X+=W//2, Y+=H//2
                MouseMove, X, Y
                SleepRand()
                Click
                unfollowed++
                SleepRand(500,1000)
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
        SleepRand()
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

/* 	
KardashianComment(loops=1)
{
	functionName = KardashianComment
	Tooltip, KardashianComment, 0,900
	FormatTime, startTime, ,yyyy-M-d HH:mm:ss tt
	Loop %loops%
	{
		SleepRand()
		SleepRand(1100,2300)
		bluestar := FindImg("E:\Development\instabot\assets\bluestar.png",3)
		SleepRand(1100,2300)
		smallbluetick := FindImg("E:\Development\instabot\assets\smallbluetick.png",3)
		If !bluestar && !smallbluetick
		{
			Send {BS}
			SleepRand(300,1000)
			Send {BS}
			SleepRand(300,1000)
			Send {BS}
			SleepRand(300,1000)
			Send {BS}
			SleepRand(2500,3500)
			ClickInstaPost(1)
			SleepRand(350,1350)
		}
		ELSE
		{ ; leave comment 
		Random p, 1, 2
		ClickInstaPost(p)
		SleepRand(699, 1999)
		}
		commentText := RandComment()
		posted := PostComment(commentText)
		FormatTime, endTime, ,yyyy-M-d HH:mm:ss tt
		If posted
		{
			; array(startTime, endTime, errorMsg, functionName) if Error endTime = 0
			Return % Array(functionName, startTime, endTime, 0, 0, 0, 1)
		}
		Else
			Return % Array(functionName, startTime, 0, 0, 0, 0)
	}
}
 */

/* 
FindImgCoords(img, lp:=5, sx:=180, sy:=65, ex:=1178, ey:=711, Debug:=False ) 
{
	Loop % lp
	{
		CoordMode, Pixel, Window
		ImageSearch, FoundX, FoundY, %sx%, %sy%, %ex%, %ey%, %img%
		CenterImgSrchCoords(img, FoundX, FoundY)	
	}
	Until ErrorLevel = 0
	If ErrorLevel = 0
	{
		If Debug = True
			msgbox % FoundX, FoundY
		Return True
	}
	Else
	{
		Return False
	}
	SleepRand()
}
 */
/*  
LikeCommentersPosts(todo) {
	FormatTime, startTime, ,yyyy-M-d HH:mm:ss tt
	functionName = LikeCommentersPosts
	Tooltip, LikeCommentersPosts, 0,900
	Loop 3
	{
		; LOAD MORE
		Text:="|<>*204$66.U0001000000U0001000000U7VsR0hkwKSU8G4X0n92MVU8E4V0W92EVU8EwV0W92EzU8F4V0W92EUU8G4V0W92EUU8GAX0W92EVzbVoR0W8wESU"
		if (ok:=FindText(865-150000//2, 373-150000//2, 150000, 150000, 0, 0, Text))
		{
			CoordMode, Mouse
			X:=ok.1.1, Y:=ok.1.2, W:=ok.1.3, H:=ok.1.4, Comment:=ok.1.5, X+=W//2, Y+=H//2
			Click, %X%, %Y%
		}
	}
	PixelGetColor, pColour, 1180, 170
	While pColour = 0x7D7D7D  ;  GREY
	{
		If A_Index > 5 ; click next arrow
		{	
            Text:="|<>*162$14.zzszy7zUzw7zUzw7zUzw7zUzw7zUzsDw3y1z0zUTkDs7w3y1zUzsTyDzzzs"
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
			FormatTime, endTime, ,yyyy-M-d HH:mm:ss tt
			errorMsg := error clicking on hashtags
			Return % Array(functionName, startTime, errorMsg, 0,0,0) 
		}
		Random, x, 830, 950
		Random, y, 310, 530
		MouseMove, %x%, %y%
		SleepRand()
		Click ; CLICK ON REGION WITH ACCOUNT NAMES
		SleepRand(500,1300)
		PixelGetColor, pColour, 1180, 170 ; 			Pixel colour should change
	}
	done = 0
	SleepRand(333, 666)
	pageValid := CheckInstagramPage()
	if !pageValid
		{
		Tooltip, LikeCommentersPosts Private Account, 0,900
		Send, {BS}
		SleepRand(200,500)
		Send, {BS}
		SleepRand(1100,1333)
		Send, {F5}
		SleepRand(4500,6500)
		done += 1
		FormatTime, endTime, ,yyyy-M-d HH:mm:ss tt
		errorMsg = page not valid
		Return % Array(functionName, startTime, errorMsg)
		}

	While done < todo
	{
		Tooltip, LikeCommentersPosts() Not Private , 0,900
		SleepRand(300,1400)
		liked := LikePostsN()
		done += 1
		Sleep, 333
		Send, {BS}
		Sleep, 333
	}
	FormatTime, endTime, ,yyyy-M-d HH:mm:ss tt
	Return % Array(functionName, startTime, endTime,done)
	Tooltip, LikeCommentersPosts() Finished LikeCommentersPosts, 0,900
}
 */
 /* 
CheckInstagramPage(checkOwn:=1) {
    MouseMove, 400, 400
    SleepRand()
    MouseClick, WheelUp
    MouseClick, WheelUp
    SleepRand()
	Tooltip, CheckInstagramPage, 0,900
	; instagram logo 
	Text:="|<>*147$22.3zz0zzz700CM00P00Aw0knkDkD1nUwA33kkAD60MwM1XkkAD30kw7C3kDkD0A0w003M00Nk03Xzzw3zz2"
	if !(ok:=FindText(202-70000//2, 100-70000//2, 70000, 70000, 0, 0, Text))
		Return False

	; private
	Text:="|<>*153$48.z06000E0zU0000k0laqMltwQlbqMnxwyzb68UAlXz66BUQlzk66BVAlzk6673AlUk6673wwzk6671qQSU"
	if (ok:=FindText(730-70000//2, 444-70000//2, 70000, 70000, 0, 0, Text))
		Return False

	; No 
	Text:="|<>*161$34.00zw0007zs000k0k00C01k0Tk03y3w003wM0000P00000w03w03k0zw0D070s0w0k0k3k703UD0M060w1U0M3k400UD0E020w10083k601UD0M060w0k0k3k3U70D07Vs0w07y03k07U0C"
	if (ok:=FindText(675-150000//2, 516-150000//2, 150000, 150000, 0, 0, Text))
		Return False
	
	If checkOwn = 1
	{
		ToolTip, checkOwn is 2 , 0, 930
		SleepRand(2200,3300)
		; isThomas := FindImg("E:\Development\instabot\assets\thomasthomas.png",3)
		Text:="|<>*151$57.3s0DU0600Nzk7z00k03Q71kQ0S01v0QA1k7k0Tk1X063y0Dy0AM0kwk3n01U06660MM0A00k0k030300A0600M0M01U0k030600M0600M1U0600k030M01U0600M600M00k031U0600600Ms03U00k03A00k00600P00A000k03zzXzy0600Q"
		if (ok:=FindText(742-150000//2, 216-150000//2, 150000, 150000, 0, 0, Text))
			Return False
	
		; phil
		Text:="|<>*158$71.1z00000000003y00000000007s0000000000DU0000000000C00000000000A00000000000M00000000000k00000008001U000000Ds0030000000zk0060000007zU00A000000Tzz00M000000zzz00k000003zzzo1U000007zzzs300001sTzzzk600007xzzztUA0000Dzzzzs0A0000zzzzzy0M0001zzzzzw0k0007zzzzzs1U000Dzzzzzk30000TzzzzzU60000zzzzzz0A0000zzzzzz"
		if (ok:=FindText(357-150000//2, 218-150000//2, 150000, 150000, 0, 0, Text))
			Return False

		; isNPS
		Text:="|<>*149$71.00000001U0000000000300000000000600000000000A00000000000M000Nw0DUAy0k7k0ry1zkPz1Vzs7sA71kw6330sTUAA1Vk66A0kq0Mk1X04A01XA0lU360AM0D6M1X06A0MkDyAk360AM0lVyANU6A0Mk1X30Mn0AM0lU36A0la0Mk1X04AM1XA0kk670MMk73M1VkQD1UlkS7k31zkPy1Vzg7U60y0nk31wA000001U000000000030000008"
		if (ok:=FindText(566-150000//2, 218-150000//2, 150000, 150000, 0, 0, Text))
			Return False
		; bliss
		Text:="|<>*148$71.k03300000001U0660000000300A00000000600M00000000A00k00000000Mw1VUT07k6T3ry333zUzsBzDsA66C33UkS7nUAAAM360ks7608MMk0A01UAA0Mkls0S030MM0lVVz0Tk60kk1X31zUTsA1VU3660DU3sM3306AA03U0sk660MMMk3A0lUAC0kklk6Q1X0MS31VVkMQ660krw331zkTwA1Vbk661y0TUM32"
		if (ok:=FindText(566-150000//2, 217-150000//2, 150000, 150000, 0, 0, Text))
			Return False	
	}
	Return True
}
 */
/*  
LikePostsN(n:=0) {
	Tooltip, LikePostsN, 0,900
	SleepRand(400,1100)
	If %n% > 0
	{
	nLikes := %n%
	}
	else
	{
	random, nLikes, 1, 3
	}
	ClickInstaPost(1)
	;WHITE HEART
	Text:="|<>*169$24.3s7k66MM83k4E1U2E002U001U001U001U001U001k003E0028004A00A600M300k1U1U0k300M60048002E001U0U"
	If (ok:=FindText(843-1000//2, 653-1000//2, 1000, 1000, 0, 0, Text))
		Loop %nLikes%
		{
	        SleepRand(1100, 3500)
			Random, n, 1, 8
			if (n = 1) ;skip photo
			{
				nLikes++
				Text:="|<>*162$14.zzszy7zUzw7zUzw7zUzw7zUzw7zUzsDw3y1z0zUTkDs7w3y1zUzsTyDzzzs"
				if (ok:=FindText(1163-500//2, 388-500//2, 500, 500, 0, 0, Text))
				{
					CoordMode, Mouse
					X:=ok.1.1, Y:=ok.1.2, W:=ok.1.3, H:=ok.1.4, Comment:=ok.1.5, X+=W//2, Y+=H//2
					SleepRand()
                    MouseMove, %X%, %Y%
                    SleepRand()
                    Click
				}
				Continue
			}
			Random, r, 1, 3
			If r = 1 ; click heart
			{
				CoordMode, Mouse
				X:=ok.1.1, Y:=ok.1.2, W:=ok.1.3, H:=ok.1.4, Comment:=ok.1.5, X+=W//2, Y+=H//2
				Random, w, -5, 5
				X += w
				Random, w, -5, 5
				Y += w
                MouseMove, %X%, %Y%
                SleepRand()
				Click
			}
			Else ;double click image
			{
				Random, X, 231,761
				Random, Y, 189,677
				MouseMove, %X%, %Y%
				SleepRand()
				Click 2	
			}
			;GREY RIGHT ARROW
			Text:="|<>*162$14.zzszy7zUzw7zUzw7zUzw7zUzw7zUzsDw3y1z0zUTkDs7w3y1zUzsTyDzzzs"
			if (ok:=FindText(1163-500//2, 388-500//2, 500, 500, 0, 0, Text))
			{
				CoordMode, Mouse
				X:=ok.1.1, Y:=ok.1.2, W:=ok.1.3, H:=ok.1.4, Comment:=ok.1.5, X+=W//2, Y+=H//2
				Click, %X%, %Y%
			}
		}
	Else
	{
		Send {BS}
		Return False
	}
}
 */


/*  
ClickInstaCommentBox(){
	CoordMode, Pixel, Windows
	Tooltip, clickInstaCommentBox , 0,900
	SleepRand(200,333)
	foundImg := FindImg("E:\Development\instabot\assets\comment3.png")
	If foundImg
	{
		;FoundX+=15
		Return True
	}
	ELSE
	{
		Return False
	}
}
 */
/*  
PostComment(cText){
	clicked := ClickInstaCommentBox()
	If !clicked
	{
		CheckInstagramPage()
		Send {BS}
		SleepRand(299,755)
		foundLoginBtn := FindImg("E:\Development\instabot\assets\login2.png",,20)
		If !foundLoginBtn {
			foundLoginBtn := FindImg("E:\Development\instabot\assets\login4.png")
		}
		If foundLoginBtn 
		{
			Tooltip, login btn found, 0,900
			SleepRand(2800,3500)
			foundLoginBtn2 := FindImg("E:\Development\instabot\assets\login3.png")
			SleepRand(450,900)
			If foundLoginBtn2 
			{
				SleepRand(650, 1500)
				Send {BS}
				SleepRand(444,600)
				Send {BS}
				SleepRand(333,400)
				Send {BS}
				SleepRand(1300,2200)
			}
		}
		Random,r,1,2
		ClickInstaPost(r)
		SleepRand(499,955)
		clicked := ClickInstaCommentBox()
		If !clicked
			Return False
	}
	SleepRand()
	clipboard := % cText
	SleepRand(100, 322)
	send ^v
	SleepRand(100, 322)
	send {return}
	SleepRand(100,300)
	;clipboard :=
	SleepRand(323,563)
	Tooltip, END PostComment, 0,900
	Return True
}
 */
/* 
OpenUrlChrome(URL, profile){
	run, %profile% %URL%, , max
		  
}
 */
/* 
ClickInstaPost(n){
	MouseMove, 650, 450
	SleepRand()
	MouseClick, WheelDown
	SleepRand()
	postN = %n%
	If postN = 1
	{
	Random,x,175,450
	Random,y,620,710
	MouseMove, %x%, %y%

	sleep 200
	Click
	SleepRand(333,933)
	foundImg := FindImg("E:\Development\instabot\assets\comment3.png",3)
	If !foundImg
	{
		SleepRand(333,933)
		foundImg := FindImg("E:\Development\instabot\assets\comment3.png",3)
	}
	If !foundImg
	{
		Random,x,175,450
		Random,y, 620, 710
		MouseMove, %x%, %y%
		SleepRand(233,333)
		Click
		SleepRand(333,555)
		foundImg := FindImg("E:\Development\instabot\assets\comment3.png",3)
		If !foundImg
		{
			Return False
		}
		Else Return True
	}
	}
	Else If postN = 2
	{
	Random,x,495,765
	Random,y,620,745
	MouseMove, %x%, %y%
	SleepRand(100,400)
	Click
	SleepRand(600,1100)
	foundImg := FindImg("E:\Development\instabot\assets\comment3.png",3)
	If !foundImg
	{
		SleepRand(800,1100)
		foundImg := FindImg("E:\Development\instabot\assets\comment3.png",3)
	}
	If !foundImg
	{
	Random,y,795,925
	SleepRand(100,300)
	MouseMove, %x%, %y%
	SleepRand(233,333)
	Click
	SleepRand(433,733)
	foundImg := FindImg("E:\Development\instabot\assets\comment3.png",3)
	If !foundImg
		{
			Return False
		}
	Else Return True
	}
	Else Return True
	}
	
	Else If postN = 3
	{
		Random,x,815,1090
		Random,y,620,745
		MouseMove, %x%, %y%
		SleepRand(100,400)
		Click
		SleepRand(500,900)
		foundImg := FindImg("E:\Development\instabot\assets\comment3.png",3)
		If !foundImg
		{
			SleepRand(300,900)
			foundImg := FindImg("E:\Development\instabot\assets\comment3.png",3)
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
 */
/*  
RandURL(){
	Random, targetN, 1, 3
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
 */
/*  
RandChromeProfilePath(){
	Random, chromeUser, 1, 4

	if chromeUser = 1
	{
		browserPath ="C:\Program Files\Google\Chrome\Application\chrome.exe" --profile-directory="Profile 16" --disable-infobars
		name = thomasthomas2211
	}
	Else If chromeUser = 2 ;phil
	{
		browserPath ="C:\Program Files\Google\Chrome\Application\chrome.exe" --profile-directory="Profile 13" --disable-infobars
		name = philhughesart
	}
	Else If chromeUser = 3 ;nps
	{
		browserPath ="C:\Program Files\Google\Chrome\Application\chrome.exe" --profile-directory="Profile 14" --disable-infobars
		name = noplacetosit
	}
	Else If chromeUser = 4 ;bliss
	{
		browserPath ="C:\Program Files\Google\Chrome\Application\chrome.exe" --profile-directory="Profile 15" --disable-infobars
		name = blissMolecule
	}
	Return % Array(browserPath,chromeUser,name)
}
 */
/*  
CloseChrome() {
	Sleep, 1000
	; Get all hWnds (window IDs) created by chrome.exe processes.
	WinGet hWnds, List, ahk_exe chrome.exe
	;WinGet hWnds, List, ahk_exe opera.exe
	Loop, %hWnds%
	{
	  hWnd := % hWnds%A_Index% ; get next hWnd
	  PostMessage, 0x112, 0xF060,,, ahk_id %hWnd%
	}
	 Sleep, 1000
}
 */
 /* 
LoopTab(x) {	
	Tooltip, LoopTab, 0,900
	Sleep, 11
	Sleep, 10
	loop, % x
	{
	send {tab} 
	Sleep, 20
	}
	Sleep, 10
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
			commentText := "lb "
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
			commentText := "lb please "
		}	
		Else If commentNumber = 15
		{
			commentText := "lb f4f"
		}
		Else If commentNumber = 16
		{
			commentText := "LB  ☯"	
		}
		Else If commentNumber = 17
		{
			commentText := "FIRST ☯"
		}
		Else If commentNumber = 18
		{
			commentText := "lb cb first ☯"
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
			commentText := " lb ☯"
		}
		Else If commentNumber = 24
		{
			commentText := "LB  ☯"
		}
		Else If commentNumber = 25
		{ 
			commentText := "ROW. ☯ NOW"
		}
		Else If commentNumber = 26
		{
			commentText := "lb FB F4F ☯"
		}
		Else If commentNumber = 27
		{
			commentText := "FB LF ☯"
		}
		Else If commentNumber = 28
		{
			commentText := "FIRST LB ☯"
		}
		Else If commentNumber = 29
		{
			commentText := " LB CB ☯"
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
			commentText := "LB ☯"
		}
		Else If commentNumber = 34
		{
			commentText := "LB CB ☯"
		}
		Else If commentNumber = 35
		{
			commentText := "lb now ☯"
		}
		Else If commentNumber = 36
		{
			commentText := "ROW ☯"
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

ExitScript(){
	CloseChrome()
	ExitApp
}
 */



