#include Jxon.ahk
#include Socket.ahk
#include RemoteObj.ahk
#include Experiments\AhkDllThread.ahk
#singleInstance force


class InstaClient {

    __New() {
        
        serverAddr := "192.168.0.31"
        serverPort := 8337
        try {
            Bot := new RemoteObjClient([serverAddr, serverPort])
            }
        ; Bot.session("philhughesart")
        sleep 3000
        ; Bot.browseFeed(1)
    }

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
			return STATUS := value
		}
	}
}

; serverAddr := A_IPAddress1
client := new InstaClient
msgbox % "tests 2" client.STATUS
reload() {
    Bot.reload()
}

browsefeed() {
    sleep 500
    msgbox % "browsefeed tests2" Bot.STATUS
}

; AhkDllPath := A_ScriptDir "\AutoHotkeyMini.dll"
; hModule := DllCall("LoadLibrary","Str",AhkDllPath)
; DllCall(AhkDllPath "\ahktextdll","Str","#include tests.ahk `n reload()","Str","","Str","","Cdecl UPTR")
; MsgBox, End main thread
; DllCall("FreeLibrary","PTR",hModule)
; sleep 2000
/*  AhkDllPath := A_ScriptDir "\AutoHotkey.dll"
    hModule := DllCall("LoadLibrary","Str",AhkDllPath)
    DllCall(AhkDllPath "\ahkdll","Str","test.ahk","Str","","Str","","Cdecl UPTR")
    MsgBox, End main thread
    DllCall("FreeLibrary","PTR",hModule)
 */
; msgbox % Bot.STATUS
; AhkThread2 := AhkDllThread(AhkDllPath)
; AhkThread2.ahktextdll(Bot.run()) 
; client := new InstaClient

; ; y := ComObjActive("{93C04B39-0465-4460-8CA0-7BFFF481FF98}")
; ; msgbox % "ComObj STATUS " y.STATUS
; serverAddr := "192.168.0.31"
; serverPort := 8337
; try {
;     Bot := new RemoteObjClient([serverAddr, serverPort])
; }

; AhkDllPath := A_ScriptDir "\AutoHotkeyMini.dll"
; hModule := DllCall("LoadLibrary","Str",AhkDllPath)
; DllCall(AhkDllPath "\ahktextdll","Str","#include tests.ahk `n browsefeed()","Str","","Str","","Cdecl UPTR")
; MsgBox, browsefeed
; DllCall("FreeLibrary","PTR",hModule)
; loop 10
; {
;     sleep 2000
;     msgbox % "bot.status " Bot.STATUS
;     sleep 2000
;     msgbox % "CLIENT.status " client.STATUS
;     sleep 2000
; }
; serverPort1 := 8338
; RemoteControl := new RemoteObjClient([serverAddr, serverPort1])

; Bot.reload()
; SleepRand(2000,5000) 
; Bot := new RemoteObjClient([serverAddr, serverPort])  
; try {
;     state := Bot.session("philhughesart")
; }
; state := Bot.STATUS
; msgbox % state
/* 
SleepRand(1200,3300)
Loop 2
{
    Bot.browseFeed(2)
    SleepRand(2800,6800)
    ; Bot.unfollow()
    SleepRand(1333,9999)  
    loop 2
    {
        Bot.kardashianComment()
        SleepRand(2800,11000)
    }
    targets := Bot.targetAccounts()
    random, r, 1, targets.values.maxindex()
    target := targets.values[r][1]
    ; Bot.followTarget(target)

    SleepRand(2800,6800)
    ; Bot.browseRandomHashtagFeed()
    SleepRand(2800,16800)
    Bot.browseFeed(2)
    SleepRand(2800,6800)
    ; Bot.browseRandomHashtagFeed()
    SleepRand(2800,16800)
    ; Bot.browseFeed(4)
    ; SleepRand(28000,168000) 
}
Bot.session("noplacetosit")

loop 2
{
        SleepRand(20000,30000)
        random, i, 1, 4
        loop i
        {
            Bot.kardashianComment()
            Send {Esc}
            Bot.browseFeed(1)
            SleepRand(5000,30000)
        }
        SleepRand(20000,100000)
}
Bot.session("philhughesart")

loop 2
{
            Bot.browseFeed(3)
            SleepRand(10000,30000)
            Bot.kardashianComment()
            Send {Esc}
            SleepRand(10000,30000)
        SleepRand(10000,180000)
}

 */
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
; Bot.session("philhughesart")

; Bot.reload()
; FileAppend,,READY

; RemoteControl.reboot()
Sleep 1000
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


