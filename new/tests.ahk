#include Jxon.ahk
#include Socket.ahk
#include RemoteObj.ahk

serverAddr := "192.168.0.31"
serverPort := 8337
Bot := new RemoteObjClient([serverAddr, serverPort])
; Bot.reload()
; SleepRand(2000,5000) 
; Bot := new RemoteObjClient([serverAddr, serverPort]) 
Sleep 2300
Loop
{
    Bot.session("philhughesart")
    SleepRand()
    random, i, 1, 3
    loop %i%
    {
        Bot.kdComment()
        Send {Esc}
        SleepRand(1000,1800)
        Bot.browseFeed(3)
        SleepRand(5000,11000)

    }
    SleepRand(20000,30000)
    Bot.session("thomasthomas2211")
    random, i, 1, 4
    loop i
    {
        Bot.kdComment()
        Send {Esc}
        Bot.browseFeed(1)
        SleepRand(5000,30000)
    }
    SleepRand(20000,100000)
    Bot.session("noplacetosit")
    random, i, 1, 4
    loop i
    {
        Bot.browseFeed(1)
        SleepRand(10000,30000)
        Bot.kdComment()
        Send {Esc}
        SleepRand(10000,30000)
    }
    SleepRand(10000,180000)
}

SleepRand(x:=0,y:=0, debug:=False) {
	If x = 0
	{
		Random, x, 1, 11
	}
	If y  = 0
	{		
		Random, y, %x%, (x+200)
	}
	Random, rand, %x%, %y%
	If debug
	{
		MsgBox % rand
	}
	Sleep, %rand%
}

^!r::Reload
