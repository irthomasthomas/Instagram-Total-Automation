#SingleInstance Force
#include Lib\Jxon.ahk
#include Lib\Socket.ahk
#include Lib\RemoteObj.ahk

accounts := ["philhughesart", "thomasthomas2211","philhughesart", "thomasthomas2211"]


loop {
    sleep 100
    Tooltip, start botControl,0, 800
    sleep 3000
    If FileExist("instaServerREADY")
    {
        Tooltip, READY flag exists, 0, 800
        FileDelete,instaServerREADY
        Tooltip, READY flag deleted, 0, 800
        SleepRand(500,1500)
    }
    Else
    {
        Sleep 30000
        Continue
    }
    random, n, 1, accounts.Length()
    bootControl(accounts[n])
    
    tooltip, delete INTERRUPT flag
    FileAppend,,instaServerREADY
    sleep 400
    FileDelete,INTERRUPT
    Tooltip, sleeping
    SleepRand(100000,3000000)
}

bootControl(account)
{
    serverAddress := "192.168.0.36"
    serverPort := 8337
    instaClient := new RemoteObjClient([serverAddress, serverPort])
    tooltip, new instaclient
    sleep 3000
    try
        {
            instaClient.session(account)
        }
    catch e
        {
            run, bootControl.ahk
        }
    tooltip, instaclient session, 10, 900
    sleep 3000
    random, n, 2, instaClient.targetsArray.values.length()
    instaClient.followTarget(instaClient.targetsArray.values[n][1])
    sleeprand(10000,30000)
    random, n, 2, instaClient.targetsArray.values.length()
    instaClient.followTarget(instaClient.targetsArray.values[n][1])
    sleeprand(10000,30000)
    instaClient.browseRandomHashtag(2)
    tooltip, bootcontrol: finished browseHashtag
    sleeprand(10000,30000)
    instaClient.browseRandomHashtag(3)
    sleeprand(10000,30000)

    instaClient.browseRandomHashtag(3)
    sleeprand(10000,30000)

    tooltip, followtarget, 10, 900


    tooltip, followtarget end, 10, 900

    sleeprand1(instaClient,9000,32000)
    random, n, 1, 2
    if n == 1
        instaClient.kardashianComment(3)
    sleepRand1(instaClient,9000,35000)
    instaClient.kardashianComment(2)
    tooltip, kardashian 2, 10, 900

    	; 	FileDelete,instaServerREADY
		; FileAppend,,photoBotBUSY
    
    sleeprand1(instaClient,3000,23000)
    ; random, n, 2, instaClient.targetsArray.values.length()
    ; instaClient.followTarget(instaClient.targetsArray.values[n][1])
    
    random, n, 1, 7    
    random, r, 3, 9
    if n < 4 
        instaClient.browseRandomHashtag(3)
    else
        instaClient.browseFeed(r)
    tooltip, browse, 10, 900
    
    SleepRand1(instaClient,1000,30000)
    random, n, 1, 2
    if n == 1
        instaClient.kardashianComment(3)
    sleepRand1(instaClient,3000,30000)
    tooltip, kardashian 3, 10, 900

    random, n, 1, 7        
    if n < 4
        instaClient.browseFeed(n)
    else
        instaClient.browseRandomHashtag(3)
    tooltip, browse 2, 10, 900

    SleepRand1(instaClient,1000,30000)
    random, n, 1, 2
    if n == 1
    loop 3 {
        instaClient.kardashianComment(2)
        sleeprand1(instaClient,5000,35000)        
    }
    tooltip,kardashian 4, 10, 900

    result := instaClient.browseRandomHashtag(2)
    tooltip,browse 3, 10, 900

    sleeprand1(instaClient,3000,13000)

    instaClient.closeBrowser()    
    Tooltip, sleeping
    sleepRand1(instaClient,30000,60000)    

}

SleepRand1(instaClient, x:=0, y:=0) {
    Tooltip, sleeprand
     If FileExist("INTERRUPT")
    {
        Tooltip, INTERRUPT
        instaClient.closeBrowser()    
        random, s, 60000,120000
        Sleep %s%
        FileAppend,,instaServerREADY
        Sleep 1000
        FileDelete,INTERRUPT
        sleep 1000
        Run, bootControl.ahk
    }

	If x = 0
	{
		Random, x, 1, 11
	}
	If y  = 0
	{		
		Random, y, %x%, (x+200)
	}
	Random, rand, %x%, %y%
	if rand > 1000
	Sleep, %rand%
}

^+r::Reload