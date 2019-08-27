OpenUrlChrome(URL, profile) {
	If NOT WinExist("ahk_class Chrome_WidgetWin_1") 
    {
		run, %profile% %URL%, , max
	}
	Else
	{
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