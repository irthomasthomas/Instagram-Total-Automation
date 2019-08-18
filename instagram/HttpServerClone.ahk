#NoEnv  ; Do not check empty variables
#SingleInstance, force
;#Warn   ; Enable warnings to assist with common errors
SetWorkingDir %A_ScriptDir%
SetTitleMatchMode, 2
SetBatchLines, -1 ; Run script at maximum speed
SetWinDelay, -1
SetControlDelay, -1

#include Lib\Jxon.ahk
#include Lib\Socket.ahk
; #include Lib\AhkDllThread.ahk
; #include Lib\RemoteObj.ahk
; #Include Lib\Gdip_All.ahk
; #include Lib\base64.ahk
screen := ComObjActive("{93C04B39-0465-4460-8CA0-7BFFF481FF98}")

class worker {
    STATUS
        {
            get 
            {
                if FileExist( "status.ini" ) 
                {	
                    IniRead, STATUS, status.ini, General, STATUS
                }
                return STATUS
            }
            set 
            {
                IniWrite, %value%, status.ini, General, STATUS
                return STATUS := value
            }
        }
        
        ACTIVITY
        {
            get 
            {
                if FileExist( "activity" )
                {	
                    FileRead, ACTIVITY, activity
                    ; IniRead, ACTIVITY, activity, General, ACTIVITY
                }
                ; TODO: make activity.ini
                return ACTIVITY
            }
            set 
            {   
                ; FileSetAttrib, -R, activity
                sleep 50
                FileDelete, activity
                sleep 100
                FileAppend, %value%, activity
                ; IniWrite, %value%, activity, General, ACTIVITY
                return ACTIVITY := value
            }
        }

}

global encoded := screen.encoded

Template =
    ( Join`r`n
    HTTP/1.0 200 OK
    Content-Type: text/html

    <!DOCTYPE html>
    <html>
        <head>
            <title>Tommy Bot</title>
            <style>
                table, td {
                    border-collapse: collapse;
                    border: 2px solid black;
                }
            </style>
            <script>
                random = {}
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
                var updateStatus = function(){
                    var xhttp = new XMLHttpRequest();
                    xhttp.onreadystatechange = function() {
                        if (xhttp.readyState == 4 && xhttp.status == 200) {
                            document.getElementById("status").innerHTML = xhttp.responseText;
                            setTimeout(updateStatus, 1000);
                        }
                    };
                    xhttp.open("GET", "status", true);
                    xhttp.send();
                }
                var updateActivity = function(){
                    var xhttp = new XMLHttpRequest();
                    xhttp.onreadystatechange = function() {
                        if (xhttp.readyState == 4 && xhttp.status == 200) {
                            document.getElementById("activity").innerHTML = xhttp.responseText;
                            setTimeout(updateActivity, 1000);
                        }
                    };
                    xhttp.open("GET", "activity", true);
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

                setTimeout(updateTotals, 500);
                setTimeout(update, 500);
                setTimeout(updateScreen, 500);
                setTimeout(updateStatus, 500);
                setTimeout(updateActivity, 500);
            </script>

        </head>
        <body>
            <table>
                {}
                <tr><td><a href="/reload">reload</a></td></tr>
                <tr><td>Visitor Count</td><td>{}</td></tr>
                <tr><td>Mouse Position</td><td id="mouse"></td></tr>
                <tr><td>Screen </td><td id="screen"></td></tr>
                <tr><td>Status</td><td id="status"></td><td id="activity"></td></tr>
            </table>
        </body>
    </html>
    )
Bind_Addr := A_IPAddress1
Bind_Port2 := 80
hServer := new SocketTCP()
hServer.OnAccept := Func("OnAccept")
Try {
    hServer.Bind([Bind_Addr,Bind_Port2])
}
catch e 
{
    sleep 1000
    run, HttpServer.ahk
}
hServer.Listen()
SetTimer, screenshot, 3000
return

OnAccept(Server)
{
    ; Loop, Files, HttpServer.ahk
    ; filemod := A_LoopFileTimeModified
    global Template
    static Counter := 0
    global encoded
    
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
    {
        ; <script src="test.js?rndstr=<%= getRandomStr() %>"></script>
        ; mod = <script src="test.js?random="%filemod%></script>
        ; <script src="test.js?v=1"></script>
        filemod = ""
        Sock.SendText(Format(Template, filemod, "", ++Counter))
    }
        
    else if (Request[2] == "/mouse")
    {
        MouseGetPos, x, y
        Sock.SendText("HTTP/1.0 200 OK`r`n`r`n" x "," y)
    }
    else if (Request[2] == "/screen")
    {
        imgsrc := encoded
        html := "HTTP/1.0 200 OK`r`n`r`n <img src='data:image/png;base64," imgsrc "' width='700'/>"
        Sock.SendText(html)
    }
    else if (Request[2] == "/status")
    {
        Sock.SendText("HTTP/1.0 200 OK`r`n`r`n" worker.STATUS)
    }
    else if (Request[2] == "/activity")
    {
        Sock.SendText("HTTP/1.0 200 OK`r`n`r`n" worker.ACTIVITY)
    }
    else if (Request[2] == "/reload") {
        Sock.SendText("HTTP/1.0 301 Moved Permanently`r`nLocation: http://192.168.0.35")
        Sock.Disconnect()
        reloadAll()
    }
    else
        Sock.SendText("HTTP/1.0 404 Not Found`r`n`r`nHTTP/1.0 404 Not Found")
    
    Sock.Disconnect()
}

reloadAll(){
    ; TODO: Thread, Priority, 1 ; Make priority of current thread slightly above average.
    ; Thread, Interrupt, 0  ; Make each newly launched thread immediately interruptible.
    ; Thread, Interrupt, 50, 2000  ; Make each thread interruptible after 50ms or 2000 lines, whichever comes first

    ; WinClose instaServer.ahk
    FileAppend,,INTERRUPT
    Sleep 1200
    
    ; WinKill instaServer.ahk
    sleep 1000
        /*  ahk_class #32770
            ahk_exe AutoHotkey.exe
            ahk_pid 3576
        
            Z:\projects\rope\instagram\website\HttpServer.ahk - AutoHotkey v1.1.30.03
            ahk_class AutoHotkey
            ahk_exe AutoHotkey.exe
            ahk_pid 2316
        
            winclose, Z:\projects\rope\instagram\instaServer.ahk - AutoHotkey v1.1
        */
        ; sleep 200
    ; run, instaServer.ahk
    sleep 300
    Reload
}

; TakeScreenshot()
; {
;     ObjRegisterActive(worker, "{93C04B39-0465-4460-8CA0-7BFFF481FF98}")
;   global encoded  
;   ; beaucoup thanks to tic (Tariq Porter) for his GDI+ Library
;   ; https://autohotkey.com/boards/viewtopic.php?t=6517
;   ; https://github.com/tariqporter/Gdip/raw/master/Gdip.ahk
;   pToken:=Gdip_Startup()
;   If (pToken=0)
;   {
;     MsgBox,4112,Fatal Error,Unable to start GDIP
;     ExitApp
;   }
;   pBitmap:=Gdip_BitmapFromScreen()
;   If (pBitmap<=0)
;   {
;     MsgBox,4112,Fatal Error,pBitmap=%pBitmap% trying to get bitmap from the screen
;     ExitApp
;   }
;   encoded:=Gdip_EncodeBitmapTo64string(pBitmap, "png")

;   If (ErrorLevel<>0)
;   {
;     MsgBox,4112,Fatal Error,ErrorLevel=%ErrorLevel% trying to save bitmap to`n%FileName%
;     ExitApp
;   }
;   Gdip_DisposeImage(pBitmap)

;     ;   encoded
; }

screenshot:
global encoded := screen.encoded

; TakeScreenshot()
return

^+i::Reload
