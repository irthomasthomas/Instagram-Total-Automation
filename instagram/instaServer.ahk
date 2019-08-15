#Persistent

#include InstaFunctions.ahk
#include kardashian.ahk
#include browsefeed.ahk
#include browsehashtags.ahk
#include Lib\Jxon.ahk
#include Lib\Socket.ahk
#include Lib\RemoteObj.ahk
; #include Lib\AhkDllThread.ahk
; #include Lib\ObjRegisterActive.ahk
tooltip, started, 0, 920
; Pub Obj to Com
worker := new InstaWorker()
; ObjRegisterActive(worker, "{93C04B39-0465-4460-8CA0-7BFFF481FF98}")

; Pub Obj to Socket
Bind_Addr := A_IPAddress1
Bind_Port := 8337
Server := new RemoteObj(worker, [Bind_Addr,Bind_Port])

SleepRand()    
return


class InstaWorker 
{


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
                if FileExist( "activity" )
                {	
                    FileRead, ACTIVITY, activity
                    ; IniRead, ACTIVITY, activity, General, ACTIVITY
                }
                ; TODO: make activity.ini
                return ACTIVITY
            }
            set 
            {   
                FileSetAttrib, -R, activity
                sleep 50
                FileDelete, activity
                sleep 100
                FileAppend, %value%, activity
                ; IniWrite, %value%, activity, General, ACTIVITY
                return ACTIVITY := value
            }
        }

        __New() {
            closeChrome()
            this.STATUS := "Ready"
        }
        
        closeBrowser() {
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
                    this.STATUS := "starting"
                    this.account := account
                    this.kardashianUrl := KardashianURL()
                    this.settings := settings(account)
                    this.chrome := this.settings[1]
                    this.targetSheet := this.settings[2]
                    this.kbot := new KardashianBot(account)
                    ; OpenUrlChrome("https://instagram.com", this.chrome)
                    this.targetsArray := this.targetAccounts()
                }
                catch e
                {
                    LogError(e)
                    return e
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
        

        openRandCommenter() {
            tooltip, openRandCommenter, 0, 930
            OpenCommenterProfile()
        }

        kardashianComment() {
                try {
                    this.kbot.commentLB(this.kardashianUrl,this.chrome)
                }
                catch e {
                    LogError(e)
                }
        }

        ; likePosts(n:=0) {
        ;     this.ACTIVITY := "Like Posts"
        ;     tooltip, likeposts, 0, 930
        ;     LikePostsN(n)
        ;     this.ACTIVITY := ""
        ; }

        browseRandomHashtag() {
            this.STATUS := "BUSY"
            this.ACTIVITY := "Browse Hashtag"
            try
            {
                BrowseHashtags(this)
            }
            catch e
            {
                LogError(e)
            }
            this.ACTIVITY := ""
            closeChrome()
            this.STATUS := "BUSY"
        }

        browseFeed(nlikes:=0) {
            this.STATUS := "BUSY"
            this.ACTIVITY := "Browsing Feed"
            try {
                liked := BrowseFeed(this.chrome, nlikes)          
            	FormatTime, time, ,yyyy-M-d HH:mm:ss tt  
                result := {liked: liked}
                instaReport(this.account, "browse_feed", result, time)
            }
            catch e {
                LogError(e)
                return e
            }
            this.ACTIVITY := ""
            this.STATUS := "Ready"
            return liked
        }

        followTarget(target) {
            this.STATUS := "BUSY"
            this.ACTIVITY := "Follower"
            try {
            	FormatTime, time, ,yyyy-M-d HH:mm:ss tt  
                liked := follow(target, this.account, this.chrome)
                result := {liked: liked}
                instaReport(this.account, "follow_target " + target, result, time )
            }
            catch e {
                LogError(e)
                return e
            }
            this.ACTIVITY := ""
            this.STATUS := "Ready"
            return "followed " target " and liked " liked " posts"
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
            this.ACTIVITY := "Unfollower "
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
^!p::Pause

; TODO: Unfollow()
; TODO: Kardashian Log
; TODO: LOG browse hashtag

