; #Include Lib\Socket2.ahk
#Include Lib\Jxon.ahk
#Include Lib\RemoteObj.ahk
#include Lib\JSON.ahk
#include control.ahk
#include GSheets.ahk

; msgbox getPHotoQueue.ahk
sleep 1000

CheckPhotoQueue(accessToken, remoteObj)
{
		; msgbox % "remoteObj " remoteObj.__Addr[1]
		; TODO: Multithreading
		If FileExist("photoBotBUSY")
		{
	        ; remoteObj.print_to_python("photoBotBUSY")
			Tooltip, photoBotBUSY
			sleep 10000
			return
		}

		try
		{
	        remoteObj.print_to_python("Checking Queue")
		}
		catch e
		{

		}
		fileArray = 0
        photoSheetId := "1o2ObINzmU_IB5bHzEeuXmby4ucgZPgM8_rcghRKkdL8"
        range := "A2:M"
        url := "https://sheets.googleapis.com/v4/spreadsheets/" 
        url .= photoSheetId "/values/" range  "?access_token=" accessToken
        oArray := json.Load(UrlDownloadToVar(url))
		sleep 1000
		Loop, % oArray.values.MaxIndex()
		{
			If !(DateParse(oArray.values[A_Index][6]) = DateParse(A_Now))
				Continue
			If !(oArray.values[A_Index][7] = A_Hour)
				Continue
			row := A_Index
			Loop 11
			{
				photoData .= """" . oArray.values[row][A_Index] . """" "," 			
			}
			sleep 10
			fileArray := Array(oArray.values[A_Index][1],oArray.values[A_Index][8],oArray.values[a_index][9])
		}
		If not fileArray
			return

		remoteObj.print_to_python("engaging insta worker")
		FileAppend,,INTERRUPT
		Sleep 1000
		While NOT FileExist("instaServerREADY")
		{
			Tooltip, GetPhotoQueue: Bot busy. Waiting.
			Sleep 10000
			If A_Index > 150
			{
				cell = Sheet3!A2
				response := GsheetAppendRow(photoSheetId, accessToken, cell, photoData)
				throw { msg: "PhotoQueue: failed waiting for instaWorker "} 
			}
		}
		sleep 1400
		FileDelete,instaServerREADY
		FileAppend,,photoBotBUSY
	    Tooltip, photobotBUSY flag set
		remoteObj.print_to_python("setting interrupt flag")
		; FileAppend, ,INTERRUPT
		try
		{
			remoteObj.PhotoToInstagram(fileArray)
		}
		catch e
		{
			msgbox %e%
				throw { msg: "PhotoQueue: failed call to: remoteObj.PhotoToInstagram() "} 
		}

		FileAppend,,instaServerREADY
		tooltip, fileappend instaserverREADY
		sleep 1000
		cell = Sheet2!A2
		response := GsheetAppendRow(photoSheetId, accessToken, cell, photoData)
		tooltip, gsheetappendrow
		sleep 4000
		GsheetDeleteRow(photoSheetId,0,accessToken,row)
		tooltip, gsheetdeleterow
		sleep 3000
		FileDelete, photoBotBUSY
		; get the row id 
		objData := Jxon_Load(response)
		updaterange := objData["updates","updatedRange"]
		cellId := StrSplit(updaterange, ":")
		rowid := SubStr(cellId[2], 2)
		refCell := "J" . rowid	
		value := "=IMAGE({})"
		url := Format(value, refCell)
		cell := "Sheet2!K" . rowid
		UpdateGSheetCell(photoSheetId, accessToken, cell, url)
		sleep 3000
}

