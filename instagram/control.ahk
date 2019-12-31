#NoEnv
SendMode Input
SetWorkingDir %A_ScriptDir%
#SingleInstance,Force
#include Lib\CLR.ahk

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

URLDownloadToVar(url) 
{
    if url <> ""
    {
        hObject:=ComObjCreate("WinHttp.WinHttpRequest.5.1")
        hObject.Open("GET", url)
        hObject.Send()
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

GetAccessCode(client_id, client_secret, refresh_token) 
{
	;msgbox client_id %client_id% client_secret %client_secret% refresh_token %refresh_token%
    StringReplace, client_id, client_id, %A_SPACE%,, All
    StringReplace, client_secret, client_secret, %A_SPACE%,, All
    StringReplace, refresh_token, refresh_token, %A_SPACE%,, All
    aURL := "https://www.googleapis.com/oauth2/v3/token"
    aPostData := "client_id=" client_id "&client_secret=" client_secret "&refresh_token=" refresh_token "&grant_type=refresh_token"
    oHTTP := ComObjCreate("WinHttp.WinHttpRequest.5.1")
    oHTTP.Open("POST", aURL , False)
    oHTTP.SetRequestHeader("Content-Type", "application/x-www-form-urlencoded")
    oHTTP.Send(aPostData)
    data1 := oHTTP.ResponseText
    parsedAToken := JSON.Load(data1, true)
    parsedAccessToken := parsedAToken.access_token
    oHTTP :=
    return parsedAccessToken
}
; TODO: CLEAN UP
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