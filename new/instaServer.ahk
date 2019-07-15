#include kardashian.ahk
#include browsefeed.ahk
#include Jxon.ahk
#include Socket.ahk
#include RemoteObj.ahk

ObjToPublish := new InstaServer()
Bind_Addr := A_IPAddress1
Bind_Port := 8337
Server := new RemoteObj(ObjToPublish, [Bind_Addr,Bind_Port])
msgbox

class InstaServer {
        session(account) {
            this.account := account
            this.url := KardashianURL()
            this.chrome := chromeProfilePath(account)
            this.comments := kComments()
        }
        kdComment() {
            this.bot := new KardashianBot(this.account)
                try {
                    this.bot.commentLB(this.account)
                }
                catch e {
                    LogError(e)
                }
        }
        openRandCommenter() {
            OpenCommenterProfile()
        }
        browseFeed() {
            try {
                BrowseFeed()            
            }
            catch e {
                LogError(e)
            }
        }
        followTarget(target){
            return follow(target, this.account)
        }
        reload(){
            Reload
        }
    
}

; OpenCommenterProfile()
; ; BrowseFeed()
; range1 := profile[2]"!A2:A"
; url := "https://sheets.googleapis.com/v4/spreadsheets/" influencer_sheetkey "/values/" range1  "?access_token=" myAccessToken
; oArray := json.Load(UrlDownloadToVar(url))
; random, row, 2, oArray.values.MaxIndex()
; targetAccount := oArray.values[row][1]

; results := follow(targetAccount, profile)
; SleepRand()
; response := Report(profile, results, cell)
