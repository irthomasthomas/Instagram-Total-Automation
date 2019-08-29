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
        try {
    		myTcp.Connect([addr,2338])
        }
        catch e
        {

        }
		command := "print_to_terminal;" . text . ";" 
		sleep 10
        try
        {
    		myTcp.SendText(command)
        }
        catch e
        {

        }
		myTcp.disconnect()
	}		

	GDrivePutJpg(file:=0, folder:=0)
	{
		myTcp := new SocketTCP()
		addr := "192.168.0.2"
		command := "gDriveJpgUpload"
		command .= ";" . file
        try
        {
            myTcp.Connect([addr, 2338])
		    myTcp.SendText(command)
        }
        catch e
        {
            return e
        }
		
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