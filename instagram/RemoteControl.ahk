#include Lib\Jxon.ahk
#include Lib\Socket.ahk
#include Lib\AhkDllThread.ahk
#include Lib\RemoteObj.ahk
#include InstaFunctions.ahk


; TODO: SPLIT OFF HTTP SERVER
; TODO: PAUSE
; TODO: ADD Live Computer Stats to html
; TODO: Add some controls to html
; TODO: Add some charts to html
; TODO: GDIP DRAW MOUSE HISTORY PATH

controller := new ControlServer()


Bind_Addr := A_IPAddress1
Bind_Port := 1339
Server := new RemoteObj(controller, [Bind_Addr,Bind_Port])    

class ControlServer {
    
    STATUS {
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

        ; MessageBox(m) {
        ;     AhkDllPath := A_ScriptDir "\AutoHotkeyMini.dll"
        ;     AhkThread := AhkDllThread(AhkDllPath)
        ;     cmd := "#include ControlFunctions.ahk `n scrollTest("
        ;     cmd .= " """ m """ "
        ;     cmd .= ")"
        ;     ; cmd := "MsgBox , , Title," . m . ", 7"
        ;     AhkThread.ahktextdll(cmd) 
        ;     ; MsgBox , , Title, %m%, 7
        ;     this.STATUS := "WORKING!"
        ;     return % this.STATUS
        ; }
    


    __Reload()
    {
        run, instaServer.ahk
    }

    __New()
    {
        ; Bind_Addr := A_IPAddress1
        ; Bind_Port2 := 1335
    }
    
    shortRoutine(account, speed:="slow") {

        ; TODO: something in socket causing script to lock-up
        AhkDllPath := A_ScriptDir "\AutoHotkeyMini.dll"
        AhkThread := AhkDllThread(AhkDllPath)
        cmd := "#include ControlFunctions.ahk `n shortRoutine("
        cmd .= " """ account """ "
        cmd .= ")"
        ; cmd := "MsgBox , , Title," . m . ", 7"
        AhkThread.ahktextdll(cmd) 
        ; MsgBox , , Title, %m%, 7
        this.STATUS := "BUSY"
        tooltip, shortroutine return, 0, 900
        ; return % this.STATUS
        ; resp := [speed, account]
        ; return resp
    }

    closeBrowser() {
        ; TODO: closeChrome may be playing up
        closeChrome()
    }

    midRoutine(speed:="slow") {

    }

    longRoutine(speed:="slow") {

    }
}

 */  ;socket

    ; Bind_Addr := A_IPAddress1
    ; Bind_Port2 := 1339
    ; myTcp := new SocketTCP()
    ; myTcp.onAccept := Func("OnTCPAccept")
    ; myTcp.Bind([Bind_Addr,Bind_Port2])
    ; myTcp.Listen()
    ; ; msgbox "iP " %Bind_Addr%
    ; Obj := {}
    ; return

    ; OnTCPAccept(this)
    ; {
    ;     newTcp := this.Accept()
    ;     newTcp.onRecv := func("OnTCPRecv")
    ;     newTcp.SendText("Connected")
    ; }

    ; OnTCPRecv(this)
    ; {
    ;     Text := this.RecvText()
    ;     if Text contains Reload
    ;         run, instaServer.ahk
    ;     else if Text contains Action
    ;         Query := Jxon_Load(Text)
    ;     if (Query.Action == "__Get")
    ;         RetVal := Obj[Query.Key]
    ;     else if (Query.Action == "__Set")
    ;         RetVal := obj[Query.Key] := Query.Value
    ;     else if (Query.Action == "__Call")
    ;         RetVal := Obj[Query.Name].Call(Obj, Query.Params*)
    ;     this.SendText(Jxon_Dump({"RetVal": RetVal}))
    ;     this.Disconnect()
    ;     ; msgbox % Text
    ; }



^+r::Reload
