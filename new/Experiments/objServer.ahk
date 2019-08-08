#include Jxon.ahk
#include Socket.ahk
#include RemoteObj.ahk
#include AhkDllThread.ahk
#include ObjRegisterActive.ahk

;TODO: py1 socket client > socket server > interrupt true 
ObjToPublish := new InstaServer()
Bind_Addr := A_IPAddress1
Bind_Port := 8337
Server := new RemoteObj(ObjToPublish, [Bind_Addr,Bind_Port])

;TODO:  ObjRegisterActive(Server, "{93C04B39-0465-4460-8CA0-7BFFF481FF98}")
ObjRegisterActive(ObjToPublish, "{93C04B39-0465-4460-8CA0-7BFFF481FF98}")

; msgbox % Bind_Addr
tooltip, started, 0, 920
Sleep 100  
FileAppend,,READY
return

class InstaServer {

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
        
        start() 
        {
            ; AhkThread2 := AhkDllThread(AhkDllPath)
            ; AhkThread2.ahktextdll(STATUS := "2")
            this.STATUS := "BUSY"
            
            AhkThread := AhkDllThread(AhkDllPath)
            AhkThread.ahktextdll(this.runLong())
        }

        runLong() 
        {
            sleep 10000
            this.STATUS := "READY"
        }

        session() 
        {
            try
            {
                ; this.STATUS := "inactive"
                return this.STATUS
            }
            catch e
            {
            }
            
        }

        reloadScript() {
            this.STATUS := "RELOAD"
            Reload
        }

}

^!r::Reload
