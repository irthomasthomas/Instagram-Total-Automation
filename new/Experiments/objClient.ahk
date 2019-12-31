#include Jxon.ahk
#include Socket.ahk
#include RemoteObj.ahk
#include AhkDllThread.ahk

#singleInstance force

serverAddr := "192.168.0.30"
serverPort := 8337
serverPort2 := 1337
Remote := new RemoteObjClient([serverAddr, serverPort])
; y := ComObjActive("{93C04B39-0465-4460-8CA0-7BFFF481FF98}")

class InstaClient {
	STATUS 
	{
		get {
			if FileExist( "status.ini" ) {	
				IniRead, STATUS, status.ini, General, STATUS
			}
			return STATUS
		}
		set {
			IniWrite, %value%, status.ini, General, STATUS
			return STATUS
		}
	}
}
client := new InstaClient

msgbox % Remote.STATUS ;READY
msgbox % client.STATUS ;READY
sleep 500
AhkThread1 := AhkDllThread(AhkDllPath)
AhkThread1.ahktextdll(Remote.start())
; Remote.start()
AhkThread2 := AhkDllThread(AhkDllPath)
AhkThread2.ahktextdll("msgbox % InstaClient.STATUS")
msgbox % client.STATUS ;READY

; msgbox % Remote.STATUS
Remote.reloadScript()
sleep 3000
msgbox % client.STATUS ;READY
; MSGBOX % Remote.STATUS

; try {
;     Bot := new RemoteObjClient([serverAddr, serverPort])
; }
Sleep 1000
; serverPort1 := 8338
; RemoteControl := new RemoteObjClient([serverAddr, serverPort1])

; Bot.reload()
; SleepRand(2000,5000) 
; Bot := new RemoteObjClient([serverAddr, serverPort])  
; try {
;     state := Bot.session()
; }

; msgbox % Bot.getStatus()

SleepRand(x:=0,y:=0, debug:=False) {
	If x = 0
	{
		Random, x, 1, 11
	}
	If y  = 0
	{		
		Random, y, %x%, (x+200)
	}
	Random, rand, %x%, %y%
	If debug
	{
		MsgBox % rand
	}
	Sleep, %rand%
}

ReloadScript() {
; FileAppend,,INTERRUPT
Bot.session()

Bot.reload()
FileAppend,,READY

; RemoteControl.reboot()
Sleep 4000
Reload
}

; SetTitleMatchMode, 2
; DetectHiddenWindows, On
; script_id := WinExist("[color=red]hk.ahk[/color] ahk_class AutoHotkey")

; ; Force the script to update its Pause/Suspend checkmarks.
; SendMessage, 0x211,,,, ahk_id %script_id%  ; WM_ENTERMENULOOP
; SendMessage, 0x212,,,, ahk_id %script_id%  ; WM_EXITMENULOOP

; ; Get script status from its main menu.
; mainMenu := DllCall("GetMenu", "uint", script_id)
; fileMenu := DllCall("GetSubMenu", "uint", mainMenu, "int", 0)
; isPaused := DllCall("GetMenuState", "uint", fileMenu, "uint", 4, "uint", 0x400) >> 3 & 1
; isSuspended := DllCall("GetMenuState", "uint", fileMenu, "uint", 5, "uint", 0x400) >> 3 & 1
; DllCall("CloseHandle", "uint", fileMenu)
; DllCall("CloseHandle", "uint", mainMenu)

; MsgBox Paused: %isPaused%`nSuspended: %isSuspended%

^+r::Reload
; ^+r::ReloadScript()

