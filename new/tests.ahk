#include Jxon.ahk
#include Socket.ahk
#include RemoteObj.ahk
#include Experiments\AhkDllThread.ahk
#singleInstance force

; socket client
    ; Bind_Addr := A_IPAddress1
    ; msgbox % Bind_Addr
    serverAddr := "192.168.0.31"
    serverPort := 1339
    Controller := new RemoteObjClient([serverAddr, serverPort])
    sleep 1000
    ; Controller.__Reload()
    AhkDllPath := A_ScriptDir "\AutoHotkeyMini.dll"
    AhkThread := AhkDllThread(AhkDllPath)
    AhkThread.ahktextdll("msgbox % Controller.STATUS") 
    
    ; Sock := new SocketTCP()
    ; Sock.Connect([serverAddr,serverPort])
    ; Sock.SendText("Reload")
    ; ; Sock.SendText(Jxon_Dump(Obj))
    ; resp := Sock.RecvText()
    ; if resp contains "Action"
    ; resp := Jxon_Load(resp).RetVal
    ; Sock.Disconnect()
    ; msgbox % resp


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
			return STATUS := value
		}
	}
}

AhkDllPath := A_ScriptDir "\AutoHotkeyMini.dll"
AhkThread2 := AhkDllThread(AhkDllPath)
AhkThread2.ahktextdll("#include tests2.ahk") 
client := new InstaClient
loop 10
{
    msgbox % "CLIENT.status " client.STATUS
    sleep 2000
}
/*  AhkDllPath := A_ScriptDir "\AutoHotkey.dll"
    hModule := DllCall("LoadLibrary","Str",AhkDllPath)
    DllCall(AhkDllPath "\ahkdll","Str","test.ahk","Str","","Str","","Cdecl UPTR")
    ; DllCall(AhkDllPath "\ahktextdll","Str","#include tests2.ahk `n browsefeed()","Str","","Str","","Cdecl UPTR")
    MsgBox, End main thread
    DllCall("FreeLibrary","PTR",hModule)
 */
; y := ComObjActive("{93C04B39-0465-4460-8CA0-7BFFF481FF98}")
; msgbox % "ComObj STATUS " y.STATUS

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
SleepRand(x:=0,y:=0) {
	If x = 0
	{
		Random, x, 1, 11
	}
	If y  = 0
	{		
		Random, y, %x%, (x+200)
	}
	Random, rand, %x%, %y%
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

^+r::ReloadScript()

