BrowseFeed(chromeProfile,nlikes:=0) {
	instaURL = "https://instagram.com"
    tooltip, browsefeed, 900, 0
    SleepRand(1000,3000)
	If !WinExist("ahk_class Chrome_WidgetWin_1") 
    {
	    OpenUrlChrome(instaURL, chromeProfile)
        SleepRand(2900,7100)
    }
    if !nlikes
	    Random, nLikes, 2, 8
    liked = 0
    Send {Esc}
    SleepRand(500,1500)
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
        throw { msg: "BrowseFeed: homebtn not found ", account:"" } 
    }
	MouseMove, 350, 350
	SleepRand()	
	While liked < nLikes
	{
		Random, s, 5, 10
        Loop % s
        {
            MouseClick, WheelDown
            SleepRand(300,1400)
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
                SleepRand(300,1599)
                X+=x
                Y+=y
                MouseMove, X, Y
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
    Return liked
	; Return % Array(functionName, startTime, endTime, 0, liked, 0)
}