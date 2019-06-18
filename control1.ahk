#NoEnv
SendMode Input
SetWorkingDir %A_ScriptDir%
#SingleInstance,Force
#include CLR.ahk

ComObjError(false)


DateParse(str, americanOrder=0) {
	static monthNames := "(?:Jan|Feb|Mar|Apr|May|Jun|Jul|Aug|Sep|Oct|Nov|Dec)[a-zA-Z]*"
		, dayAndMonth := "(\d{1,2})[^a-zA-Z0-9:.]+(\d{1,2})"
		, dayAndMonthName := "(?:(?<Month>" . monthNames . ")[^a-zA-Z0-9:.]*(?<Day>\d{1,2})[^a-zA-Z0-9]+|(?<Day>\d{1,2})[^a-zA-Z0-9:.]*(?<Month>" . monthNames . "))"
		, monthNameAndYear := "(?<Month>" . monthNames . ")[^a-zA-Z0-9:.]*(?<Year>(?:\d{4}|\d{2}))"
	If RegExMatch(str, "i)^\s*(?:(\d{4})([\s\-:\/])(\d{1,2})\2(\d{1,2}))?(?:\s*[T\s](\d{1,2})([\s\-:\/])(\d{1,2})(?:\6(\d{1,2})\s*(?:(Z)|(\+|\-)?(\d{1,2})\6(\d{1,2})(?:\6(\d{1,2}))?)?)?)?\s*$", i) ;ISO 8601 timestamps
		year := i1, month := i3, day := i4, t1 := i5, t2 := i7, t3 := i8
	Else If !RegExMatch(str, "^\W*(\d{1,2}+)(\d{2})\W*$", t){
		RegExMatch(str, "i)(\d{1,2})"					;hours
				. "\s*:\s*(\d{1,2})"				;minutes
				. "(?:\s*:\s*(\d{1,2}))?"			;seconds
				. "(?:\s*([ap]m))?", t)				;am/pm
		StringReplace, str, str, %t%
		if RegExMatch(str, "Ji)" . dayAndMonthName . "[^a-zA-Z0-9]*(?<Year>(?:\d{4}|\d{2}))?", d) ; named month eg 22May14; May 14, 2014; 22May, 2014
			year := dYear, month := dMonth, day := dDay
		else if Regexmatch(str, "i)" . monthNameAndYear, d) ; named month and year without day eg May14; May 2014
				year := dYear, month := dMonth
		else {
			If Regexmatch(str, "i)(\d{4})[^a-zA-Z0-9:.]+" . dayAndMonth, d) ;2004/22/03
				year := d1, month := d3, day := d2
			Else If Regexmatch(str, "i)" . dayAndMonth . "(?:[^a-zA-Z0-9:.]+((?:\d{4}|\d{2})))?", d) ;22/03/2004 or 22/03/04
				year := d3, month := d2, day := d1
			If (RegExMatch(day, monthNames) or americanOrder and !RegExMatch(month, monthNames) or (month > 12 and day <= 12)) ;try to infer day/month order
				tmp := month, month := day, day := tmp
		}
	}
	f = %A_FormatFloat%
	SetFormat, Float, 02.0
	if (day or month or year) and not (day and month and year) ; partial date
		if not month or not (day or month) or (t1 and not day) ; partial date must have month and day with time or day or year without time
			return
		else if not day ; without time use 1st for day if not present
			day := 1
	d := (StrLen(year) == 2 ? "20" . year : (year ? year : A_YYYY))
		. ((month := month + 0 ? month : InStr(monthNames, SubStr(month, 1, 3)) // 4 ) > 0 ? month + 0.0 : A_MM)
		. ((day += 0.0) ? day : A_DD) 
		. t1 + (t1 == 12 ? t4 = "am" ? -12.0 : 0.0 : t4 = "pm" ? 12.0 : 0.0)
		. t2 + 0.0 . t3 + 0.0
	SetFormat, Float, %f%
	return, d
}


GDriveSimpleUpload(file)
{
    /* 
    To send two files in one post you can do it in two ways:
 
    1. Send multiple files in a single "field" with a single field name:
 
        curl -F "pictures=@dog.gif,cat.gif"
 
     2. Send two fields with two field names:
 
        curl -F "docpicture=@dog.gif" -F "catpicture=@cat.gif"
 
    curl -X POST -L \
    -H "Authorization: Bearer `cat /tmp/token.txt`" \ ; HEADER
    -F "metadata={name : 'backup.zip'};type=application/json;charset=UTF-8" \ ; FORM DATA
    -F "file=@backup.zip;type=application/zip" \
    "https://www.googleapis.com/upload/drive/v3/files?uploadType=multipart"
    
    GDRIVE WEB EXAMPLE
    Request header 
        authorization: SAPISIDHASH 1550934525_a62c47b3030c55a67db71c1e534bf4a33422398c_e
        content-type: application/json
        Origin: https://drive.google.com
        Referer: https://drive.google.com/drive/folders/1TGaLmoesZJBdGX5w7tfiX6XQHf3k6OxT
        User-Agent: Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/72.0.3626.109 Safari/537.36
        x-goog-authuser: 0
        x-upload-content-length: 59182690
        x-upload-content-type: image/png
    {"title":"panorama-9_8giFiiSwvapZ9q7o-uZQ-5.png","mimeType":"image/png","parents":[{"id":"1TGaLmoesZJBdGX5w7tfiX6XQHf3k6OxT"}]}


    folderId := "1TGaLmoesZJBdGX5w7tfiX6XQHf3k6OxT"

    url := "https://www.googleapis.com/upload/drive/v3/files?uploadType=media&access_token=" myAccessToken

    fileSize := file.Length

    fileMetaData "metadata={name : '$backupFile', title : '$fileName', \
                            description : 'Backup file from $today', \
                            parents : [{id : '0B-b5yS-0xCQjVEcyMm9hYmtqd0k'}] }"

    http :=ComObjCreate("WinHttp.WinHttpRequest.5.1")
    http.Open("post", url, false)
    http.SetRequestHeader("Content-Type", "image/png")
    http.SetRequestHeader("Content-size", "%fileSize%")
    http.Send(file)
    response := http.ResponseText
    hObject :=
    ;file.id
        
    return response
     */
}

UpdateGSheetCell(SheetKey, accessToken, cell, value)
{
	
	url := "https://sheets.googleapis.com/v4/spreadsheets/" SheetKey "/values/" cell  "?includeValuesInResponse=true&valueInputOption=USER_ENTERED&access_token=" accessToken
	data = {"majorDimension":"ROWS","range":"%cell%","values":[["%value%"]]}
	;Clipboard = %url%
	Return PutURL(url, data)
}

GsheetDeleteRow(SheetKey, sheetId, accessToken, row)
{
    msgbox % "GSheetDeleteRow " SheetKey " " sheetId " " accessToken " " row
    url := "https://sheets.googleapis.com/v4/spreadsheets/" SheetKey ":batchUpdate"
    endRow := row + 1
    data = {"requests": [{"deleteDimension": {"range": {"sheetId": "%sheetId%","dimension": "ROWS","startIndex": "%row%","endIndex": "%endRow%"}  }  }]}
    response := PutURL(url,data,"post",accessToken)
    Return response
}


UpdateStatusSheet(result, accessToken) 
{
	cell = Sheet1!A1:F1	
	;msgbox accessToken %accessToken%
	status := GsheetAppendRow(status_sheetkey, accessToken, cell, result)
	;msgbox % status
}


PutURL(url, data, method:="put", token:=0) 
{
    if url <> ""
    {
        hObject:=ComObjCreate("WinHttp.WinHttpRequest.5.1")
        hObject.Open(method, url, false)
        If token
            hObject.SetRequestHeader("Authorization","Bearer "+token)
		hObject.SetRequestHeader("Content-Type", "application/json")
        hObject.Send(data)
        response := hObject.ResponseText
        hObject :=
        return response
    }
    else
    {
        ErrorGui("ERROR! Exiting...")
        ExitApp
    }
}


FindImg(img, action:=1, lp:=5, sx:=180, sy:=70, ex:=1190, ey:=710, rand:=1, xr:=0, yr:=0,Debug:=False)
{
    Loop % lp
    {
        CoordMode, Pixel, Window
        ImageSearch, FoundX, FoundY, %sx%, %sy%, %ex%, %ey%, %img%
        CenterImgSrchCoords(img, FoundX, FoundY)	
        SleepRand(100,300)
        If rand
        {
            If xr = 0
                xr := 11
            If yr = 0
                yr := 11
            Random, FoundX, (FoundX-xr), (FoundX+xr)
            Sleep 10	
            Random, FoundY, (FoundY-yr), (FoundY+yr)
            Sleep 10
        }
    }
    Until ErrorLevel = 0
    If ErrorLevel = 0
    {
	If Debug = True
		msgbox % FoundX, FoundY
	If action = 1
	{
		MouseMove, %FoundX%, %FoundY%
		SleepRand()
		Click
	}
	Else If action = 2
	{
		MouseMove, %FoundX%, %FoundY%
		SleepRand()
		Click 2
	}
	Else If action = 3
	{
		MouseMove, %FoundX%, %FoundY%
	}
	SleepRand()
	Return True
}
Else
{
	Return False
}
SleepRand()
}

CenterImgSrchCoords(File, ByRef CoordX, ByRef CoordY){
	; Tooltip, CenterImgSrchCoords, 0,1000
	; SleepRand(600,1100)
	static LoadedPic
	LastEL := ErrorLevel
	Gui, Pict:Add, Pic, vLoadedPic, %File%
	GuiControlGet, LoadedPic, Pict:Pos
	Gui, Pict:Destroy
	CoordX += LoadedPicW // 2
	CoordY += LoadedPicH // 2
	ErrorLevel := LastEL
}

SleepRand(x:=0,y:=0, debug:=False) {
	If x = 0
	{
		Random, x, 1, 11
	}
	If y  = 0
	{		
		Random, y, %x%, (x+200)
	}
	Random, rand, %x%, %y%
	If debug
	{
		MsgBox % rand
	}
	Sleep, %rand%
}

ErrorGui(string="Error while processing. Try again.")
{
    Gui, Destroy
            
    Gui, +lastFound +Owner +AlwaysOnTop -border -caption -ToolWindow
    Gui, Color, 000000
    Gui, margin, 40,20
    Gui, font, s18 cwhite
    Gui, Add, Text, center cWhite, %string%
    WinSet, TransColor, EE0000 175
    Gui, show, autosize

    ;showAndBreak(status_hotkey, operations_hotkey, wing_enter_hotkey, all_wings_hotkey)
    
    Gui, Destroy
    Suspend, Off
    Return
}

/* 

GuiClose:
GuiCancel:
GuiEscape:
    Gui, Destroy
    Suspend, Off 
 */