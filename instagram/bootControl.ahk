#SingleInstance Force
#include Lib\Jxon.ahk
#include Lib\Socket.ahk
#include Lib\RemoteObj.ahk

accounts := ["philhughesart", "noplacetosit", "thomasthomas2211"]

loop {
    sleep 100
    Tooltip, start botControl,0, 800
    If FileExist("INTERRUPT")
    {
        Tooltip, INTERRUPT flag exists, 0, 800
        sleep 30000
        Continue
    }
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
    FileAppend,,instaServerREADY

    sleep 400
    FileDelete,INTERRUPT
    Tooltip, sleeping
    SleepRand(100000,300000)
}

bootControl(account)
{
    serverAddress := "192.168.0.36"
    serverPort := 8337
    instaClient := new RemoteObjClient([serverAddress, serverPort])
    try
        {
            instaClient.session(account)
        }
    catch e
        {
            run, bootControl.ahk
        }

    random, r, 2, 7
    loop %r%
    {
        SleepRand(10000,40000)
        instaClient.kardashianComment()
    }

    random, n, 2, instaClient.targetsArray.values.length()
    instaClient.followTarget(instaClient.targetsArray.values[n][1])
    sleeprand(9000,32000)
    random, n, 1, 2
    if n == 1
        instaClient.kardashianComment()
    sleepRand(9000,35000)
    instaClient.kardashianComment()
    sleeprand(3000,23000)
    ; random, n, 2, instaClient.targetsArray.values.length()
    ; instaClient.followTarget(instaClient.targetsArray.values[n][1])
    
    random, n, 1, 7    
    random, r, 3, 9
    if n < 4 
        result := instaClient.browseRandomHashtag()
    else
        instaClient.browseFeed(r)
    
    SleepRand(1000,30000)
    random, n, 1, 2
    if n == 1
        instaClient.kardashianComment(2)
    sleepRand(3000,30000)

    random, n, 1, 7        
    if n < 4
        instaClient.browseFeed(n)
    else
        result := instaClient.browseRandomHashtag(5)

    SleepRand(1000,30000)
    random, n, 1, 2
    if n == 1
    loop 3 {
        instaClient.kardashianComment()
        sleeprand(5000,35000)        
    }
    result := instaClient.browseRandomHashtag(2)
    sleeprand(3000,13000)
    instaClient.closeBrowser()    
    Tooltip, sleeping
    sleepRand(30000,60000)    

}
; msgbox % instaClient.STATUS
; msgbox % result

^+r::Reload