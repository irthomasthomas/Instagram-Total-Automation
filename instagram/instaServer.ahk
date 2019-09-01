#SingleInstance force
#include InstaFunctions.ahk
#include kardashian.ahk
#include browsefeed.ahk
#include browsehashtags.ahk
#include Lib\Jxon.ahk
#include Lib\Socket.ahk
#include Lib\RemoteObj.ahk

SetBatchLines, -1 ; Run script at maximum speed
SetWinDelay, -1
SetControlDelay, -1


; DetectHiddenWindows, On
; IfWinExist , NewNameOfWindow ;if script already running 
;  ExitApp
; WinSetTitle, %A_ScriptFullPath%,, NewNameOfWindow ;the hidden window of the script deafult name starts with the full path of the script.

; #include Lib\AhkDllThread.ahk
; #include Lib\ObjRegisterActive.ahk
tooltip, started, 0, 920
; Pub Obj to Com
worker := new InstaWorker()
; ObjRegisterActive(worker, "{93C04B39-0465-4460-8CA0-7BFFF481FF98}")

; msgbox %A_IPAddress1%
Bind_Addr := A_IPAddress1
Bind_Port := 8337
Server := new RemoteObj(worker, [Bind_Addr,Bind_Port])
FileAppend,,instaServerREADY
sleep 200
; FileRecycle,INTERRUPT
return

class InstaWorker 
{
        STATUS
        {
            get 
            {
                ; if FileExist( "instaServerREADY" ) 
                ; {	
                ;     STATUS := "READY"
                ; }
                ; else 
                ;     STATUS := "BUSY"
                return STATUS
            }
            set 
            {
                ; if value == "READY"
                ;     FileAppend,,instaServerREADY
                ; else
                ; {
                ;     FileDelete, instaServerREADY
                ; }
                ; IniWrite, %value%, status.ini, General, STATUS
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
            ; TODO: setting activity
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
            this.STATUS := "READY"
        }
        
        session(account:="")
        {
            if account == ""
            {
                closeChrome()
                this.account := ""
                this.STATUS := "READY"
            }
            else
            {
                    closeChrome()
                    this.STATUS := "starting"
                try
                {
                    this.account := account
                    this.kardashianUrl := KardashianURL()
                    this.settings := settings(account)
                    this.chrome := this.settings[1]
                    this.targetSheet := this.settings[2]
                    this.kbot := new KardashianBot(account)
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

        closeBrowser() {
            tooltip, closeChrome
            closeChrome()
        }

        openRandCommenter() {
            tooltip, openRandCommenter, 0, 930
            OpenCommenterProfile()
        }

        kardashianComment() {
            tooltip, kardashianComment, 0, 930
            this.STATUS := "BUSY"
            this.ACTIVITY := "Kardashian Strategy"
                try {
                    this.kbot.commentLB(this.kardashianUrl,this.chrome)
                }
                catch e {
                    LogError(e)
                }
            this.STATUS := "READY"
            this.ACTIVITY := "NONE"
            tooltip, kardashian finished, 0, 930

        }

        browseRandomHashtag() {
            tooltip, browseRandomHashtag, 0, 930
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
            this.STATUS := "READY"
            tooltip, browsehashtag finished, 0, 930
        }

        browseFeed(nlikes:=0) {
            tooltip, browsefeed, 0, 930
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
            this.STATUS := "READY"
            tooltip, browsefeed finished, 0, 930
        }

        followTarget(target) {
            tooltip, followTarget, 0, 930
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
            this.STATUS := "READY"
            SleepRand(10000,20000)
            tooltip,followtarget finished, 0, 930
            ; return "followed " target " and liked " liked " posts"
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

