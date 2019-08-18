#include Lib\Jxon.ahk
#include Lib\Socket.ahk
#include Lib\RemoteObj.ahk


serverAddress := "192.168.0.35"
serverPort := 8337
instaClient := new RemoteObjClient([serverAddress, serverPort])
sleep 1000
loop 5
{
loop 2
{
    status := instaClient.session("philhughesart")
    sleep 500
    ; msgbox % instaClient.STATUS " " instaClient.ACTIVITY
    ; msgbox % "status " status
    ; instaClient.kardashianComment()
    ; instaClient.kardashianComment()
    sleep 13000
    instaClient.browseFeed("4")
    ;instaClient.followTarget("")
    sleep 3000
    result := instaClient.browseRandomHashtag()
    sleep 5000
    ; instaClient.kardashianComment()
    sleep 10000
    ; instaClient.kardashianComment()
    sleep 1000
    instaClient.closeBrowser()
    sleep 300000
    status := instaClient.session("thomasthomas2211")
    sleep 100000
    result := instaClient.browseRandomHashtag()
    sleep 120000
    result := instaClient.browseRandomHashtag()
}
sleep 400000
}
; msgbox % instaClient.STATUS
; msgbox % result

^+r::Reload