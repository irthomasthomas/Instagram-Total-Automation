#include Lib\Jxon.ahk
#include Lib\Socket.ahk
; #include Lib\AhkDllThread.ahk
#include Lib\RemoteObj.ahk
; #include InstaFunctions.ahk

; serverAddress := A_IPAddress1
serverAddress := "192.168.0.31"
serverPort := 8337
instaClient := new RemoteObjClient([serverAddress, serverPort])
sleep 1000
; status := instaClient.session("thomasthomas2211")
sleep 500
msgbox % instaClient.STATUS " " instaClient.ACTIVITY
; msgbox % "status " status
; instaClient.browseFeed(5)
;instaClient.followTarget("")
; instaClient.browseRandomHashtag()
sleep 100
msgbox % instaClient.STATUS
; msgbox % result
