#include Jxon.ahk
#include Socket.ahk
#include RemoteObj.ahk
#include AhkDllThread.ahk
#singleInstance force

serverAddr := A_IPAddress1
sleep 1000
serverPort := 8337
sleep 1000
Remote := new RemoteObjClient([serverAddr, serverPort])
sleep 1000
msgbox % Remote.STATUS ;READY/RELOAD
sleep 1000
AhkThread := AhkDllThread(AhkDllPath)
sleep 1000
AhkThread.ahktextdll(Remote.start())
sleep 1000
msgbox % Remote.STATUS ;READY
Remote.reloadScript()
sleep 3000
msgbox % Remote.STATUS ;RELOAD

^+r::Reload

