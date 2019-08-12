
startWorker()
{
    try
    {
        worker := ComObjActive("{93C04B39-0465-4460-8CA0-7BFFF481FF98}")
    }
    catch e
    {
        ; TODO: msgbox % "error creating worker ComObj " e
    }
    sleep 1000
    try
    {
        state := worker.STATUS
    }
    catch e
    {
        msgbox "error startworker: FAILED getting worker.STATUS"%e%
    }
    sleep 500
    ; if state != "BUSY"
    return worker
}    


shortRoutine(account) {
        short := [5000, 15000]
        med := [20000, 45000]
        long := [61000, 180000]
        breakShort := [520000, 1800000]
        breakLong := [1800000, 3800000]
        worker := startWorker()
        sleep 100
        ; TODO: 
        worker.session(account)
        worker.STATUS := "BUSY"
        sleep 3000
        ; worker.session()
        loop 1
        {
            sleep 1000
            worker.SleepRand(short)
            worker.kardashianComment()
            worker.SleepRand(short)
            worker.browseFeed("1")
            random, a, 1, 2
            random, r, 1,3
            if a == 1
            {
                worker.browseFeed(r)
            }
            worker.SleepRand(med)
            random, b, 1, 2
            if b == 1
            {
                random, n, 1, 4
                loop % n
                {
                    worker.kardashianComment()
                    worker.SleepRand(med)
                    worker.SleepRand(med)
                }
            }
            
            worker.browseRandomHashtagFeed()
        }
        targets := worker.targetAccounts()
        random, r, 1, targets.values.maxindex()
        target := targets.values[r][1]
        worker.followTarget(target)
        ; worker.session("")
        worker.closeBrowser()
        worker.STATUS := "READY"
        
        ; SleepRand(2800,6800)
        ; ; Bot.unfollow()
        ; SleepRand(1333,9999)  
        ; loop 2
        ; {
        ;     Bot.kardashianComment()
        ;     SleepRand(2800,11000)
        ; }
        ; targets := Bot.targetAccounts()
        ; random, r, 1, targets.values.maxindex()
        ; target := targets.values[r][1]
        ; ; Bot.followTarget(target)

        ; SleepRand(2800,6800)
        ; SleepRand(2800,16800)
        ; Bot.browseFeed(2)
        ; SleepRand(2800,6800)
}