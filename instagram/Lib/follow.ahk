follow(target, account, chromePath)
{
	FormatTime, startTime, ,yyyy-M-d HH:mm:ss tt
	url := "https://instagram.com/"target
    OpenUrlChrome(url, chromePath)
	SleepRand(4333,9999)
	pageValid := CheckPage()
	If NOT pageValid
	{
	    throw { msg: "Error " pageValid, target:target, account:account } 
	}
	tooltip, page pageValid
	sleep 4000
	; If nLikes = 0
	Random, nLikes, 5, 25
	liked := LikePostsN(nLikes)
	SleepRand(1500,3500)
	FollowText:="|<Follow>*188$45.0DzAzzzs1ztbzzzDw7AsAlVz0Na0W80MnAlaF03C9aQG1DtlAnW49z6NaAkVDs3Ak74NzUtb1sXU"
	if (ok:=FindText(0, 0, A_ScreenWidth, A_ScreenHeight, 0, 0, FollowText))
	{
		CoordMode, Mouse
		X:=ok.1.1, Y:=ok.1.2, W:=ok.1.3, H:=ok.1.4, Comment:=ok.1.5, X+=W//2, Y+=H//2
	}
	Else
	{
	    throw { msg: "FollowBot: no follow btn ", target:target, account:account } 
	}
	MouseMove, X, Y
	SleepRand()
	Click
	SleepRand(1000,3000)
	CoordMode, Pixel, Screen
	return liked	
}