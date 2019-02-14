
GsheetAppendRow(SheetKey, accessToken, cell, values)
{
 
	url := "https://sheets.googleapis.com/v4/spreadsheets/" SheetKey "/values/" cell  ":append?includeValuesInResponse=true&valueInputOption=USER_ENTERED&access_token=" accessToken
	data = {"majorDimension":"ROWS","range":"%cell%","values":[[%values%]]}
	Return PutURL(url, data, "post")
/* 	

    {
    "range": "Sheet1!A1:E1",
    "majorDimension": "ROWS",
    "values": [
        ["Data", 123.45, true, "=MAX(D2:D4)", "10"]
    ],
    }

    {
    "range": "Sheet1!A1:E1",
    "majorDimension": "ROWS",
    "values": [
        ["Door", "$15", "2", "3/15/2016"],
        ["Engine", "$100", "1", "3/20/2016"],
    ],
    }
 */
}

GetWorksheetRange(SheetKey, accessToken, ranges)
{
	url := "https://sheets.googleapis.com/v4/spreadsheets/" sheetkey "/values/" ranges "?access_token=" accessToken
    sheetBatch := URLDownloadToVar(url)
	return sheetBatch
}

URLDownloadToVar(url) {
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

PutURL(url, data, method:="put") {
        if url <> ""
        {
            hObject:=ComObjCreate("WinHttp.WinHttpRequest.5.1")
            hObject.Open(method, url, false)
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
