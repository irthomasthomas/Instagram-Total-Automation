#include kardashian.ahk
#include browsefeed.ahk
#include Jxon.ahk
#include Socket.ahk
#include RemoteObj.ahk

ObjToPublish := new instaServer()
Bind_Addr := A_IPAddress1
Bind_Port := 8337
; MsgBox, , Title, %Bind_Addr%, 3

Server := new RemoteObj(ObjToPublish, [Bind_Addr,Bind_Port])
; Call kardashian post comment "blissmolecule"

; __New(account){
;         this.account := account
;         this.url := KardashianURL()
;         this.chrome := chromeProfilePath(account)
;         this.comments := kComments()
;     }

class instaServer {
        
        LB(account) {
            this.bot := new KardashianBot(account)

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
            BrowseFeed()
        }
        followTarget(target){
            return follow(target, this.account)
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
