#singleInstance force

#include InstaFunctions.ahk
#include kardashian.ahk
#include browsefeed.ahk
#include browsehashtags.ahk

#include Jxon.ahk
#include Socket.ahk
#include RemoteObj.ahk
#include Experiments\AhkDllThread.ahk
#include Experiments\ObjRegisterActive.ahk
tooltip, started, 0, 920

; Pub Obj to Com
worker := new InstaWorker()
ObjRegisterActive(worker, "{93C04B39-0465-4460-8CA0-7BFFF481FF98}")

; Pub Obj to Socket
; Bind_Addr := A_IPAddress1
; Bind_Port := 8337
; Server := new RemoteObj(worker, [Bind_Addr,Bind_Port])

SleepRand()    
return


class InstaWorker {

        STATUS
        {
            get 
            {
                if FileExist( "status.ini" ) 
                {	
                    IniRead, STATUS, status.ini, General, STATUS
                }
                return STATUS
            }
            set 
            {
                IniWrite, %value%, status.ini, General, STATUS
                return STATUS := value
            }
        }

        __New(){
        }

        scrollTest(m) {
        tooltip, scrolltest, 0, 920
            Loop 5
            {
                this.session(m)
                this.STATUS := "BUSY"
                MouseMove, 350, 350
	            SleepRand()	
                Random, s, 25, 50
                Loop % s
                {
                    MouseClick, WheelDown
                    SleepRand(300,1400)
                }
                this.STATUS := "FREE"
                sleep 5000
            }
            
        }

        session(account:="") 
        {
            if account == ""
            {
                closeChrome()
                this.account := ""
                return this.STATUS := "READY"
            }
            else
            {
                try
                {
                    closeChrome()
                    this.account := account
                    this.kardashianUrl := KardashianURL()
                    this.settings := settings(account)
                    this.chrome := this.settings[1]
                    this.targetSheet := this.settings[2]
                    this.kbot := new KardashianBot(account)
                    ;msgbox % this.settings " " this.account " " this.chrome
                    OpenUrlChrome("https://instagram.com", this.chrome)
                    this.targetsArray := this.targetAccounts()
                    ; this.STATUS := "inactive"
                    return this.STATUS := "NEW SESSION"
                }
                catch e
                {
                    LogError(e)
                }
            }
            
        }

        targetAccounts() {
            if this.targetsArray
            {
                return this.targetsArray
            }
            range := "A:A"
            url := "https://sheets.googleapis.com/v4/spreadsheets/" this.targetSheet "/values/" range  "?access_token=" myAccessToken
            targetsArray := json.Load(UrlDownloadToVar(url))
            return targetsArray
        }
        
        kardashianComment() {
            this.STATUS := "BUSY"
                try {
                    this.kbot.commentLB(this.kardashianUrl,this.chrome)
                }
                catch e {
                    LogError(e)
                }
            this.STATUS := "FREE"

        }

        openRandCommenter() {
            tooltip, openRandCommenter, 0, 930
            OpenCommenterProfile()
        }

        likePosts(n:=0) {
            this.STATUS := "BUSY"
            tooltip, likeposts, 0, 930
            LikePostsN(n)
            this.STATUS := "FREE"
        }

        browseRandomHashtagFeed() {
            this.STATUS := "BUSY"            
            try
            {
                BrowseHashtags(this.account)
                
            }
            catch e
            {
                LogError(e)
            }
            this.STATUS := "FREE"                
        }

        browseFeed(nlikes:=0) {
            this.STATUS := "BUSY"
            try {
                liked := BrowseFeed(this.chrome,nlikes)          
            	FormatTime, time, ,yyyy-M-d HH:mm:ss tt  
                result := {liked: liked}
                instaReport(this.account, "browse_feed", result, time)
            }
            catch e {
                LogError(e)
            }
            this.STATUS := "FREE"                
        }

        followTarget(target) {
            this.STATUS := "BUSY"            
            try {
            	FormatTime, time, ,yyyy-M-d HH:mm:ss tt  
                liked := follow(target, this.account, this.chrome)
                result := {liked: liked}
                instaReport(this.account, "follow_target " + target, result, time )
            }
            catch e {
                LogError(e)
            }
            this.STATUS := "FREE"                

        }

        SleepRand(sleeps) {
            SleepRand(sleeps[1], sleeps[2])
        }

        sleepBot() {
            SleepRand()
        }

        followBtn() {
            try {
                clickFollowButton()
                return True
            }
            catch e
            {
                throw e
            }
        }

        reload() {
            msgbox reload
            this.STATUS := "RELOAD"
            closeChrome()
            Reload
        }

        unfollow() {
            FileDelete READY
            SleepRand(3000, 5500)
            FormatTime, time, ,yyyy-M-d HH:mm:ss tt  
            try {
                unfollowed := UnfollowRandomAccount()
                result := {unfollowed: 1}
                instaReport(this.account, "unfollow ", result, time )
                FileAppend,,READY
            }
            catch e {
                LogError(e)
                FileAppend,,READY
            }

        }
}

^!r::Reload

; TODO: Unfollow()
; TODO: Kardashian Log
; TODO: LOG browse hashtag

