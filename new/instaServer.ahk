#include InstaFunctions.ahk
#include kardashian.ahk
#include browsefeed.ahk

#include Jxon.ahk
#include Socket.ahk
#include RemoteObj.ahk
 
ObjToPublish := new InstaServer()
Bind_Addr := A_IPAddress1
Bind_Port := 8337
Server := new RemoteObj(ObjToPublish, [Bind_Addr,Bind_Port])
tooltip, started, 0, 920

class InstaServer {

        session(account) {
            closeChrome()
            this.account := account
            this.kardashianUrl := KardashianURL()
            this.settings := settings(account)
            this.chrome := this.settings[1]
            this.targetSheet := this.settings[2]
            this.kbot := new KardashianBot(account)
            OpenUrlChrome("https://instagram.com",this.chrome)
        }

        targets() {
            range := "A:A"
            url := "https://sheets.googleapis.com/v4/spreadsheets/" this.targetSheet "/values/" range  "?access_token=" myAccessToken
            this.targetsArray := json.Load(UrlDownloadToVar(url))
            return this.targetsArray
        }
        
        kdComment() {
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

        followTarget(target){
            try{
                return follow(target, this.account, this.chrome)
            }
            catch e {
                LogError(e)
            }
        }

        followBtn(){
            try {
                clickFollowButton()
                return True
            }
            catch e
            {
                throw e
            }
        }

        reload(){
            Reload
        }
    
}

^!r::Reload
