#include Lib\Jxon.ahk
#include Lib\Socket.ahk
#include Lib\AhkDllThread.ahk
#include Lib\RemoteObj.ahk
#include InstaFunctions.ahk
#Include Lib\Gdip_All.ahk
#include Lib\base64.ahk

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

Template =
    ( Join`r`n
    HTTP/1.0 200 OK
    Content-Type: text/html

    <!DOCTYPE html>
    <html>
        <head>
            <title>AHK Web Server</title>
            <style>
                table, td {
                    border-collapse: collapse;
                    border: 1px solid black;
                }
            </style>
            <script>
                // Send requests sequentially so as to not overload the server
                var update = function(){
                    var xhttp = new XMLHttpRequest();
                    xhttp.onreadystatechange = function() {
                        if (xhttp.readyState == 4 && xhttp.status == 200) {
                            document.getElementById("mouse").innerHTML = xhttp.responseText;
                            setTimeout(update, 1000);
                        }
                    };
                    xhttp.open("GET", "mouse", true);
                    xhttp.send();
                }

                var updateScreen = function(){
                    var xhttp = new XMLHttpRequest();
                    xhttp.onreadystatechange = function() {
                        if (xhttp.readyState == 4 && xhttp.status == 200) {
                            document.getElementById("screen").innerHTML = xhttp.responseText;
                            setTimeout(updateScreen, 1000);
                        }
                    };
                    xhttp.open("GET", "screen", true);
                    xhttp.send();
                }

                var updateTotals = function(){
                    var xhttp = new XMLHttpRequest();
                    xhttp.onreadystatechange = function() {
                        if (xhttp.readyState == 4 && xhttp.status == 200) {
                            document.getElementById("totals").innerHTML = xhttp.responseText;
                            setTimeout(updateTotals, 1000);                            
                        }
                    };
                    xhttp.open("GET","totals",true);
                    xhttp.send();
                }

                setTimeout(updateTotals, 1000);
                setTimeout(update, 1000);
                setTimeout(updateScreen, 1000);

            </script>

        </head>
        <body>
            <table>
                {}
                <tr><td>Visitor Count</td><td>{}</td></tr>
                <tr><td>Mouse Position</td><td id="mouse"></td></tr>
                <tr><td>Screen </td><td id="screen"></td></tr>
                <tr><td>Totals</td><td id="totals"></td></tr>
            </table>
        </body>
    </html>
    )


Bind_Addr := A_IPAddress1
Bind_Port2 := 80
hServer := new SocketTCP()
hServer.OnAccept := Func("OnAccept")
hServer.Bind([Bind_Addr,Bind_Port2])
hServer.Listen()
return

OnAccept(Server)
{
    global Template
    static Counter := 0
    Sock := Server.Accept()
    Request := StrSplit(Sock.RecvLine(), " ")

    while Line := Sock.RecvLine()
    {
        Table .= Format("<tr><td>{}</td><td>{}</td></tr>", StrSplit(Line, ": ")*)
    }
    if (Request[1] != "GET")
    {
        Sock.SendText("HTTP/1.0 501 Not Implemented`r`n`r`n")
        Sock.Disconnect()
        return
    }
    if (Request[2] == "/")
        Sock.SendText(Format(Template, Table, ++Counter))

    else if (Request[2] == "/mouse")
    {
        MouseGetPos, x, y
        Sock.SendText("HTTP/1.0 200 OK`r`n`r`n" x "," y)
    }
    else if (Request[2] == "/screen")
    {
        imgsrc := TakeScreenshot()
        html := "HTTP/1.0 200 OK`r`n`r`n <img src='data:image/png;base64," imgsrc "' width='700'/>"
        Sock.SendText(html)
    }
    else if (Request[2] == "/totals")
    {
        ; Sock.SendText("HTTP/1.0 200 OK`r`n`r`n <img src='image.jpg' />")
        ; <img src='image.jpg' />
    }
    else if (Request[2] == "/favicon.ico")
        Sock.SendText("HTTP/1.0 301 Moved Permanently`r`nLocation: https://autohotkey.com/favicon.ico`r`n")
    else
        Sock.SendText("HTTP/1.0 404 Not Found`r`n`r`nHTTP/1.0 404 Not Found")
    Sock.Disconnect()
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

TakeScreenshot()
{
    
  ; beaucoup thanks to tic (Tariq Porter) for his GDI+ Library
  ; https://autohotkey.com/boards/viewtopic.php?t=6517
  ; https://github.com/tariqporter/Gdip/raw/master/Gdip.ahk
  pToken:=Gdip_Startup()
  If (pToken=0)
  {
    MsgBox,4112,Fatal Error,Unable to start GDIP
    ExitApp
  }
  pBitmap:=Gdip_BitmapFromScreen()
  If (pBitmap<=0)
  {
    MsgBox,4112,Fatal Error,pBitmap=%pBitmap% trying to get bitmap from the screen
    ExitApp
  }
  encoded:=Gdip_EncodeBitmapTo64string(pBitmap, "png")

  If (ErrorLevel<>0)
  {
    MsgBox,4112,Fatal Error,ErrorLevel=%ErrorLevel% trying to save bitmap to`n%FileName%
    ExitApp
  }
  Gdip_DisposeImage(pBitmap)

  Return encoded
}


^+r::Reload
