startWorker()
{
    try
    {
        worker := ComObjActive("{93C04B39-0465-4460-8CA0-7BFFF481FF98}")
    }
    catch e
    {
        msgbox %e%
    }
    sleep 1000
    try
    {
        state := worker.STATUS
    }
    catch e
    {
        msgbox %e%
    }
    sleep 500
    ; if state != "BUSY"
    return worker
}    

scrollTest(name) {
    worker := startWorker()
    try 
    {
        working := worker.scrollTest(name)
    }
    catch e 
    {
        msgbox %e%
    }
}

shortRoutine(account) {
        short := [5000, 15000]
        med := [20000, 45000]
        long := [61000, 180000]
        breakShort := [520000, 1800000]
        breakLong := [1800000, 3800000]
        worker := startWorker()
        sleep 100
        worker.session(account)
        worker.STATUS := "BUSY"
        sleep 3000
        ; worker.session()
        loop 1
        {
            sleep 1000
            worker.SleepRand(short)
            worker.browseFeed("1")
            worker.SleepRand(med)
            loop 2
            {
                worker.kardashianComment()
                worker.SleepRand(med)
            }
            worker.browseRandomHashtagFeed()
        }
        targets := worker.targetAccounts()
        random, r, 1, targets.values.maxindex()
        target := targets.values[r][1]
        worker.followTarget(target)
        worker.session("")
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