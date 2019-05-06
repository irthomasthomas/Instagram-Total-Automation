#NoEnv  ; Do not check empty variables
#SingleInstance, force
;#Warn   ; Enable warnings to assist with common errors
SetWorkingDir %A_ScriptDir%
SetTitleMatchMode, 2
SetBatchLines, -1 ; Run script at maximum speed
SetWinDelay, -1
SetControlDelay, -1
SendMode, Input
#include FindTextFunctions.ahk


GetHashtags(imgFormat:=1, imgType:="o", igAccount:=0) {
	hashtag_sheetkey = 16yguXSFWUhrBMNs9BgxQM3xkKH3pcjhG-SaZ90xiEgA
	Category1 := Object()
	Category2 := Object()
	Category3 := Object()
    ;	msgbox % "GetHashtags " imgFormat " " imgType " " igAccount
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
		;msgbox % " GetHashtags() NPS "
		ranges := "NPS!A1:D"
		nCategories = 1
		;msgbox % " sheetkey " hashtag_sheetkey " accesstoken " myAccessToken " ranges " ranges
		hashtagSheetData := GetWorksheetRange(hashtag_sheetkey, myAccessToken, ranges)
		oArray := json.Load(hashtagSheetData)
		;msgbox % hashtagSheetData
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
		;msgbox % hashtagSheetData
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

StartKardashianBot() {
	functionName = KardashianBot
	FormatTime, startTime, ,yyyy-M-d HH:mm:ss tt
	cell = Sheet1!A1:G1
	global profile := RandChromeProfilePath(myAccessToken)
	OpenUrlChrome("",profile[1])
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
		Send ^l
		SleepRand()
		Send ^v
		SleepRand()
		Send {Enter}
		Tooltip, sleeping - start(), 0, 900
		SleepRand(2333,5999)		
		SleepRand()
		Random p, 1, 2
		ClickInstaPost(p)
        SleepRand(1000,3500)
        Random, r, 1, 3
        Loop % r
        {
            result := KardashianComment()
            If result
				comments++
			SleepRand(1700,11000)
			;response := Report(profile,result,cell)
        }
        
        SleepRand(500,2500)
        open := OpenCommenterProfile()
        If !open
        {
            Tooltip, OpenCommenterProfile Private Account, 0,900
            Send, {BS}
            SleepRand(200,500)
            Send, {BS}
            SleepRand(1100,1333)
            Send, {BS}
            SleepRand(900,1200)
            Send, {F5}
            SleepRand(1500,2500)
            FormatTime, EndTime, ,yyyy-M-d HH:mm:ss tt
            errorMsg = page not valid
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
	
KardashianComment(loops=1)
{
	functionName = KardashianComment
	Tooltip, KardashianComment, 0,900
	FormatTime, StartTime, ,yyyy-M-d HH:mm:ss tt
	Loop %loops%
	{
		SleepRand(100,1300)
		bluestar := FindImg("needles\bluestar.png",3)
		SleepRand(100,1300)
		smallbluetick := FindImg("needles\smallbluetick.png",3)
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
			; array(StartTime, EndTime, errorMsg, functionName) if Error endTime = 0
			;Return % Array(functionName, StartTime, endTime, 0, 0, 0, 1)
			Return True
		}
		Else
			Return False
			;Return % Array(functionName, StartTime, 0, 0, 0, 0)
	}
}

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
	pageValid := CheckInstagramPage()
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

QuickCheckInstaPage()
{
    Text:="|<>*147$22.3zz0zzz700CM00P00Aw0knkDkD1nUwA33kkAD60MwM1XkkAD30kw7C3kDkD0A0w003M00Nk03Xzzw3zz2"

    if (ok:=FindText(202-300//2, 100-300//2, 300, 300, 0, 0, Text))
    {
        Return True
    }
    Else    
        Return False
}

CheckInstagramPage(checkOwn:=1, checkBluetick:=0) {
    MouseMove, 400, 400
    SleepRand(500,900)
    MouseClick, WheelUp
    MouseClick, WheelUp
    SleepRand(500,1500)
	Tooltip, CheckInstagramPage, 0,900
    Text:="|<insta logo>*147$22.3zz0zzz700CM00P00Aw0knkDkD1nUwA33kkAD60MwM1XkkAD30kw7C3kDkD0A0w003M00Nk03Xzzw3zz2"
    if !(ok:=FindText(202-500//2, 100-500//2, 500, 500, 0, 0, Text))
		Return False
    Text:="|<grid/posts>*175$12.TyzyWGmGzyWGmGzymGWGzy00U"
    if !(ok:=FindText(531-500//2, 733-700//2, 700, 800, 0, 0, Text))
        Return False
    If checkBluetick
	{
		Text:="|<big blue tick>*188$18.0000z01zU7zs7zsDzwTzyTySTwySNyT3yTbyDzw7zs7zs1zU0z0000U"
		if (ok:=FindText(622-300//2, 216-300//2, 300, 300, 0, 0, Text))
			Return False
	}
    Text:="|<private>*153$48.z06000E0zU0000k0laqMltwQlbqMnxwyzb68UAlXz66BUQlzk66BVAlzk6673AlUk6673wwzk6671qQSU"
	if (ok:=FindText(730-70000//2, 444-70000//2, 70000, 70000, 0, 0, Text))
		Return False
	
	Text:="|<no posts>*161$71.0M00000000M01U000zk000M0300030k000k0C000A0k001k0M007k0y001U0k00M00600301U01U006006070020TU400C0C0041VU800Q0M00861UE00M0k00EM1UU00k1U00UU11001U300110220030600220440060A004408800A0M008A0kE00M0k00EA30U00k1k00UAA1003U3U010Dk200703002000400A06006000M00M0A006001U00k0Q007zzy003U0M0000000060U"
	if (ok:=FindText(675-150000//2, 453-150000//2, 150000, 150000, 0, 0, Text))
		Return False
	If checkOwn = 1
	{
		ToolTip, checkOwn is 2 , 0, 930
		SleepRand(1200,3300)
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

LikePostsN(n:=0) {
/*     
Returns the number of photos liked 
or returns False if photos have been liked already
*/    
    liked = 0
	Tooltip, LikePostsN, 0,900
	SleepRand(500,1700)
	If %n% > 0
		nLikes := %n%
	else
		random, nLikes, 3, 8
	
	ClickInstaPost(1)
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
	CoordMode, Pixel, Screen
    Return % Array(liked,nLikes,count)
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
	If !clicked
	{
		Send {BS}
		SleepRand(299,755)
		foundLoginBtn := FindImg("needles\login2.png",,20)
		If !foundLoginBtn {
			foundLoginBtn := FindImg("needles\login4.png")
		}
		If foundLoginBtn 
		{
			Tooltip, login btn found, 0,900
			SleepRand(2800,3500)
			foundLoginBtn2 := FindImg("needles\login3.png")
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

OpenUrlChrome(URL, profile){
	;msgbox % "profile " profile " url " URL
	run, %profile% %URL%, , max
		  
}

ClickInstaPost(n){
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
        SleepRand(100,1100)
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

/* 
RandChromeProfilePath()
{
	Random, chromeUser, 1, 4
	chromeUser := 3
    /* 
		if chromeUser = 1
		{
			browserPath ="C:\Program Files (x86)\Google\Chrome\Application\chrome.exe" --profile-directory="Profile 4" --disable-infobars
			name = thomasthomas2211
		}
		Else If chromeUser = 2 ;phil
		{
			browserPath ="C:\Program Files (x86)\Google\Chrome\Application\chrome.exe" --profile-directory="Profile 1" --disable-infobars
			name = philhughesart
		}
		Else If chromeUser = 3 ;nps
		{
			browserPath ="C:\Program Files (x86)\Google\Chrome\Application\chrome.exe" --profile-directory="Profile 2" --disable-infobars
			name = noplacetosit
		}
		Else If chromeUser = 4 ;bliss
		{
			browserPath ="C:\Program Files (x86)\Google\Chrome\Application\chrome.exe" --profile-directory="Profile 3" --disable-infobars
			name = blissMolecule
		}
	
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





;F10::StartTest()