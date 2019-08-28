OpenUrlChrome(URL, profile) {
	If NOT WinExist("ahk_class Chrome_WidgetWin_1") 
    {
		tooltip, OpenURLChrome: window exist
		run, %profile% %URL%, , max
	}
	Else
	{
		tooltip, OpenURLChrome: window not exist
		clipboard := URL
		SleepRand(10,500)
		Send {Ctrl down}l{Ctrl up}
		SleepRand(200,800)
		Send {Ctrl down}v{Ctrl up}
		SleepRand()
		Send {Enter}
		SleepRand(1000,3000)
	}	  
	SleepRand(2000,5000)
	return
}