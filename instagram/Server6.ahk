#NoEnv
SetBatchLines, -1
#Include Lib\Socket.ahk
#Include Lib\Jxon.ahk
#Include Lib\RemoteObj.ahk
#include control.ahk
#include GSheets.ahk

ObjToPublish := new objServer() ; This is the object that will be published
Bind_Addr := A_IPAddress1 ; Local IP (it looks like 192.168.1.xxx)
Bind_Port := 1337 ; Listen for connctions on port 1337 
Server := new RemoteObj(ObjToPublish, [Bind_Addr, Bind_Port])

; msgbox "iP " %Bind_Addr%
;msgbox % A_IPAddress1 

class objServer
{	
	print_to_python(text)
	{
		myTcp := new SocketTCP()
		addr := "192.168.0.2"
		myTcp.Connect([addr,2338])
		command := "print_to_terminal;" . text . ";" 
		sleep 10
		myTcp.SendText(command)
		myTcp.disconnect() 
	}		

	rcloneDelete()
	{
		myTcp.connect([addr, 1337])
		myTcp.sendText("rclone delete")
		response := myTcp.recvText(1024)
		return response
	}

	GDrivePutJpg(file:=0, folder:=0)
	{
		myTcp := new SocketTCP()
		addr := "192.168.0.2"
		command := "gDriveJpgUpload"
		command .= ";" . file
		myTcp.Connect([addr, 2338])
		myTcp.SendText(command)
		while !response && (A_Index < 20) ;loops 20 seconds then gives up
		{
			response := myTcp.recvText(1024)
			sleep 1000
		}
		myTcp.disconnect() 
		return response
	}

	PhotoToInstagram(fileArray)
	{
		this.print_to_python(fileArray)
		instaAccount := fileArray[1]
		files := StrSplit(fileArray[2], "&")
		captions := StrSplit(fileArray[3], "&")
		
		myTcp := new SocketTCP()
		addr := "192.168.0.2"
		myTcp.Connect([addr,2338])
		Loop % files.MaxIndex()
		{
			command := "instaPhotoUpload;" . instaAccount . ";" 
			command .= files[A_Index] . ";"
			command .= captions[A_Index]
			sleep 10
			myTcp.SendText(command)
			SleepRand(15000,35000)
		}		
		myTcp.disconnect() 
		return
	}

	InputBox(Prompt) 
	{
		InputBox, Out, % this.Title, %Prompt%
		return Out
	}
	
	Message(m)
	{
		msgbox % m
		replyMessage := "Received: " . m
		return replyMessage
	}
	
	Continue()
	{
		msgbox Continue?
		return True
	}
	
	SendToClipboard(c)
	{
		clipboard :=
		sleep 10
		clipboard := c
	}

}

/* 
Template =
    ( Join`r`n
    HTTP/1.0 200 OK
    Content-Type: text/html

    <!DOCTYPE html>
    <html>
        <head>
            <title>Go AutoHotkey!</title>
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
                            setTimeout(update, 50);
                        }
                    };
                    xhttp.open("GET", "mouse", true);
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
                setTimeout(update, 100);
            </script>

        </head>
        <body>
            <table>
                {}
                <tr><td>Visitor Count</td><td>{}</td></tr>
                <tr><td>Mouse Position</td><td id="mouse"></td></tr>
                <tr><td>Totals</td><td id="totals"></td></tr>
            </table>
        </body>
    </html>
    )

Bind_Addr := A_IPAddress1
Bind_Port2 := 1338 
hServer := new SocketTCP()
hServer.OnAccept := Func("OnAccept")
hServer.Bind([Bind_Addr,Bind_Port2])
hServer.Listen()

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
    else if (Request[2] == "/totals")
    {
        sleep,1000
        myTcp := new SocketTCP()
        addr := "192.168.0.2"
        command := "get_totals"
        myTcp.Connect([addr, 1337])
        myTcp.SendText(command)
        response := StrSplit(myTcp.recvText(1024),",")
        Sock.SendText("HTTP/1.0 200 OK`r`n`r`n" response[1] "," response[2])
    }
    else if (Request[2] == "/favicon.ico")
        Sock.SendText("HTTP/1.0 301 Moved Permanently`r`nLocation: https://autohotkey.com/favicon.ico`r`n")
    else
        Sock.SendText("HTTP/1.0 404 Not Found`r`n`r`nHTTP/1.0 404 Not Found")
    Sock.Disconnect()
}	
 */

CountFiles(Directory)
{
	fso := ComObjCreate("Scripting.FileSystemObject")
	try
		objFiles := fso.GetFolder(Directory).Files
	catch
		return -1
	cnt := objFiles.count
	IfExist, %directory%\*.db
		cnt--
	return cnt
}

^r::Reload