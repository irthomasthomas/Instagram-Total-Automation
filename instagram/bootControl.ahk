#include Lib\Jxon.ahk
#include Lib\Socket.ahk
#include Lib\RemoteObj.ahk


serverAddress := "192.168.0.31"
serverPort := 8337
instaClient := new RemoteObjClient([serverAddress, serverPort])
sleep 1000
status := instaClient.session("thomasthomas2211")
sleep 500
; msgbox % instaClient.STATUS " " instaClient.ACTIVITY
; msgbox % "status " status

instaClient.browseFeed()

;instaClient.followTarget("")
result := instaClient.browseRandomHashtag()
sleep 5000
instaClient.kardashianComment()
sleep 10000
instaClient.kardashianComment()
sleep 1000
instaClient.closeBrowser()

; msgbox % instaClient.STATUS
; msgbox % result

^+r::Reload