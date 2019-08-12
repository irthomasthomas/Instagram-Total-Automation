#include Lib\Jxon.ahk
#include Lib\Socket.ahk
#include Lib\AhkDllThread.ahk
#include Lib\RemoteObj.ahk
#Include Lib\Gdip_All.ahk
#include Lib\base64.ahk

; msgbox %A_IPAddress1% 34
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
        Sock.SendText(Format(Template, "Table", ++Counter))

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
    else if (Request[2] == "/status")
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


^+i::Reload
