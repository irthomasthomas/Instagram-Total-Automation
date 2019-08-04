#include InstaFunctions.ahk
#include kardashian.ahk
#include browsefeed.ahk
#include browsehashtags.ahk

#include Jxon.ahk
#include Socket.ahk
#include RemoteObj.ahk

; py1 socket client > socket server > interrupt true 
ObjToPublish := new InstaServer()
Bind_Addr := A_IPAddress1
Bind_Port := 8337
Server := new RemoteObj(ObjToPublish, [Bind_Addr,Bind_Port])
tooltip, started, 0, 920
SleepRand()    

class InstaServer {

        session(account) 
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
            }
            catch e
            {
                LogError(e)
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
            tooltip, likeposts, 0, 930
            LikePostsN(n)
        }

        browseRandomHashtagFeed() {
            try
            {
                BrowseHashtags(this.account)
            }
            catch e
            {
                LogError(e)
            }
        }

        browseFeed(nlikes:=0) {
            try {
                liked := BrowseFeed(this.chrome,nlikes)          
            	FormatTime, time, ,yyyy-M-d HH:mm:ss tt  
                result := {liked: liked}
                instaReport(this.account, "browse_feed", result, time)
            }
            catch e {
                LogError(e)
            }
        }

        followTarget(target) {
            try {
            	FormatTime, time, ,yyyy-M-d HH:mm:ss tt  
                liked := follow(target, this.account, this.chrome)
                result := {liked: liked}
                instaReport(this.account, "follow_target " + target, result, time )
            }
            catch e {
                LogError(e)
            }
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
            Reload
        }

        unfollow() {
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

        }
}

^!r::Reload

; TODO: Unfollow()
; TODO: Kardashian Log
; TODO: LOG browse hashtag

