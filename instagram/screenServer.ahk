#SingleInstance, force

#NoEnv  ; Do not check empty variables
;#Warn   ; Enable warnings to assist with common errors
SetWorkingDir %A_ScriptDir%
SetTitleMatchMode, 2
SetBatchLines, -1 ; Run script at maximum speed
SetWinDelay, -1
SetControlDelay, -1

#include Lib\Jxon.ahk
#include Lib\Socket.ahk

screen := ComObjActive("{93C04B39-0465-4460-8CA0-7BFFF481FF98}")

global encoded := ""
Bind_Addr := A_IPAddress1
Bind_Port := 7007

Try {
    hServer := new SocketTCP()
    hServer.OnAccept := Func("OnAccept")
    hServer.Bind([Bind_Addr,Bind_Port])
    ; run, HttpServerClone.ahk
}
catch e 
{
    msgbox %e%
    ; sleep 2000
    ; run, HttpServer.ahk
    ; ExitApp
}

hServer.Listen()
SetTimer, screenshot, 3000
return

OnAccept(Server)
{
    ; filemod := A_LoopFileTimeModified
    global Template
    static Counter := 0
    global encoded
    
    Sock := Server.Accept()
    Request := StrSplit(Sock.RecvLine(), " ")
    msgbox % Request[1] " " Request[2]
    if (Request[2] == "/mouse")
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

screenshot:
global encoded := screen.encoded

; TakeScreenshot()
return

^+i::Reload
