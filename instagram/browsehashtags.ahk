SetBatchLines, -1 ; Run script at maximum speed
SetWinDelay, -1
SetControlDelay, -1

GetHashtags(imgFormat:=1, imgType:="o", igAccount:=0) {
	; TODO: Move to sqlite
	hashtag_sheetkey = 16yguXSFWUhrBMNs9BgxQM3xkKH3pcjhG-SaZ90xiEgA
	Category1 := Object()
	Category2 := Object()
	Category3 := Object()
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
		nCategories = 1
		ranges := "BM!A1:D"
		hashtagSheetData := GetWorksheetRange(hashtag_sheetkey, myAccessToken, ranges)
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

BrowseHashtags(this) {
	; TODO: Move to sqlite
	functionName = BrowseHashtags()
	Random,n,1,3
	If n = 1
		imgType := "d"
	Else If n = 2
		imgType := "o"
	Else
		imgType := "w"
	hashtagString := GetHashtags(imgFormat, imgType, this.account)
	hashtagArray := StrSplit(hashtagString, "#")
	url := "https://www.instagram.com/explore/tags/" hashtagArray[2]
	tooltip, %url%, 100,800
	Clipboard := url
	CoordMode, Pixel, Screen
	; ToolTip, BrowseHashtags() , 0, 920
	FormatTime, startTime, ,yyyy-M-d HH:mm:ss tt
	likedTotal = 0
	followedTotal = 0
	SleepRand(2000,3700)
	Random, r, 2, 3
	; TODO: Loop % r
	Loop 1
	{
		If WinExist("ahk_class Chrome_WidgetWin_1") 
		{
			sleep 1000
			WinActivate
			sleep 1000
			Send ^l
			sleep 1200
			Send ^v
			sleep 1200
			Send {Enter}
			SleepRand(2600,4600)
		}
		Else
		{
			OpenUrlChrome(url, this.chrome)
			SleepRand(4200,6300)
		}
		sleep 4000
		Text:="|<Follow>*190$45.0TzAzzzs3ztbzzzDw7AsAlVz0Na0W80sXAl6F87CNaQm9DtnAna09z4Na8kVDs3Ak74NzUtb1sXU"
		If !(ok:=FindText(600-400//2, 216-200//2, 500, 300, 0, 0, Text))
		{
			Random, n, 3, 9
			url := "https://www.instagram.com/explore/tags/" hashtagArray[%n%]
			Continue
		}
		followed = 0
		random, n, 5, 10
		ToolTip start loop mouse, 0, 900
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
		If NOT pageValid
			Continue

		While pColour = 0xFAFAFA ; WHITE
		{
			
			If A_Index > 15
		        throw { msg: "BrowseHashtags: failed opening photo ", account:this.account } 

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
		
		Send ^l
		SleepRand()
		Send ^v
		SleepRand()
		Send {Enter}
		SleepRand(2600,3600)
	}
    clickInstaHomeBtn()
	; Text:="|<insta logo>*147$22.3zz0zzz700CM00P00Aw0knkDkD1nUwA33kkAD60MwM1XkkAD30kw7C3kDkD0A0w003M00Nk03Xzzw3zz2"
    ; if (ok:=FindText(202-500//2, 100-500//2, 500, 500, 0, 0, Text))
    ; {
    ;     CoordMode, Mouse
    ;     X:=ok.1.1, Y:=ok.1.2, W:=ok.1.3, H:=ok.1.4, Comment:=ok.1.5, X+=W//2, Y+=H//2
    ;     MouseMove, X, Y
    ;     SleepRand()
    ;     Click
	; 	SleepRand(1000,3000)
    ;     CoordMode, Pixel, Screen
    ; }
	SleepRand()
	FormatTime, endTime, ,yyyy-M-d HH:mm:ss tt
	; TODO: Return % Array(functionName, startTime, endTime, 0, liked[1], followed)
}

