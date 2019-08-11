#singleInstance force

#include InstaFunctions.ahk
#include kardashian.ahk
#include browsefeed.ahk
#include browsehashtags.ahk

#include Lib\Jxon.ahk
#include Lib\Socket.ahk
#include Lib\RemoteObj.ahk
#include Lib\AhkDllThread.ahk
#include Lib\ObjRegisterActive.ahk
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
        
        ACTIVITY
        {
            get 
            {
                if FileExist( "status.ini" )
                {	
                    IniRead, ACTIVITY, status.ini, General, ACTIVITY
                }
                ; TODO: make activity.ini
                return ACTIVITY
            }
            set 
            {
                IniWrite, %value%, status.ini, General, ACTIVITY
                return ACTIVITY := value
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
                this.STATUS := "READY"
                sleep 5000
            }
            
        }

        closeBrowser(){
            tooltip, closeChrome
            closeChrome()
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
                try {
                    this.kbot.commentLB(this.kardashianUrl,this.chrome)
                }
                catch e {
                    LogError(e)
                }
        }

        openRandCommenter() {
            tooltip, openRandCommenter, 0, 930
            OpenCommenterProfile()
        }

        likePosts(n:=0) {
            this.ACTIVITY := "Like Posts"
            tooltip, likeposts, 0, 930
            LikePostsN(n)
            this.ACTIVITY := ""
        }

        browseRandomHashtagFeed() {
            this.ACTIVITY := "Browse Random Tag"
            try
            {
                BrowseHashtags(this.account)
                
            }
            catch e
            {
                LogError(e)
            }
            this.ACTIVITY := ""

        }

        browseFeed(nlikes:=0) {
            this.ACTIVITY := "Browsing Feed"

            try {
                liked := BrowseFeed(this.chrome,nlikes)          
            	FormatTime, time, ,yyyy-M-d HH:mm:ss tt  
                result := {liked: liked}
                instaReport(this.account, "browse_feed", result, time)
            }
            catch e {
                LogError(e)
            }
            this.ACTIVITY := ""
        }

        followTarget(target) {
            this.ACTIVITY := "Follow Target from G-Sheets"
            try {
            	FormatTime, time, ,yyyy-M-d HH:mm:ss tt  
                liked := follow(target, this.account, this.chrome)
                result := {liked: liked}
                instaReport(this.account, "follow_target " + target, result, time )
            }
            catch e {
                LogError(e)
            }
            this.ACTIVITY := ""
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
            this.STATUS := "RELOAD"
            closeChrome()
            Reload
        }

        unfollow() {
            this.STATUS := "BUSY"
            this.ACTIVITY := "Unfollow Rand"
            SleepRand(3000, 5500)
            FormatTime, time, ,yyyy-M-d HH:mm:ss tt  
            try {
                unfollowed := UnfollowRandomAccount()
                result := {unfollowed: 1}
                instaReport(this.account, "unfollow ", result, time )
            }
            catch e {
                LogError(e)
            }
            this.STATUS := "READY"
            this.ACTIVITY := ""
        }
}

^!r::Reload

; TODO: Unfollow()
; TODO: Kardashian Log
; TODO: LOG browse hashtag

