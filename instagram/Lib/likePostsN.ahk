LikePostsN(n:=0) {
	clicked = 0
    liked = 0
	Tooltip, LikePostsN, 0,900
	SleepRand(500,1700)
	If n > 0
		nLikes := n
	else
		random, nLikes, 5, 15
	While !clicked && (A_Index < 20)
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
			SleepRand(900,8000)
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
	random, r, 35, 55
	Loop % r
		MouseClick, WheelUP
	CoordMode, Pixel, Screen
	Tooltip, like posts finished,0,930
    Return % Array(liked,nLikes,count)
}