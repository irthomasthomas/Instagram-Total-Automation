#include Jxon.ahk
#include Socket.ahk
#include RemoteObj.ahk
#include AhkDllThread.ahk
#include ObjRegisterActive.ahk

ObjToPublish := new MyServer()
Bind_Addr := A_IPAddress1
Bind_Port := 8337
Server := new RemoteObj(ObjToPublish, [Bind_Addr,Bind_Port])
; ObjRegisterActive(Server, "{93C04B39-0465-4460-8CA0-7BFFF481FF98}")
return

class MyServer {

        __New() {
            STATUS := "READY"
        }

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
            this.STATUS := "BUSY"            
            AhkThread := AhkDllThread(AhkDllPath)
            AhkThread.ahktextdll(this.runLong())
        }

        runLong() 
        {
            sleep 10000
            this.STATUS := "READY"
        }

        reloadScript() {
            this.STATUS := "RELOAD"
            Reload
        }

}

^!r::Reload
