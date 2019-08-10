#Include Lib\Socket.ahk
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
        ; ToolTip Checking Queue
        remoteObj.print_to_python("Checking Queue")
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
			If !(oArray.values[A_Index][7] => A_Hour)
				Continue
			row := A_Index
			Loop 11
			{
				photoData .= """" . oArray.values[row][A_Index] . """" "," 			
			}
			sleep 10
			fileArray := Array(oArray.values[A_Index][1],oArray.values[A_Index][8],oArray.values[a_index][9])
			tooltip % "three " fileArray[1]
		}
		If not fileArray
			return
	
		; tooltip % "four " photoSheetId " and " accessToken " row " row

		GsheetDeleteRow(photoSheetId,0,accessToken,row)
		result := remoteObj.PhotoToInstagram(fileArray)
		msgbox % result
		cell = Sheet2!A2
		response := GsheetAppendRow(photoSheetId, accessToken, cell, photoData)
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