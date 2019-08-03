;GOOGLE SHEETS
gsheet(SheetKey, accessToken, ranges)
{
	url := "https://sheets.googleapis.com/v4/spreadsheets/" sheetkey "/values/" ranges "?access_token=" accessToken
    sheetBatch := URLDownloadToVar(url)
	return sheetBatch
}

GsheetAppendRow(SheetKey, accessToken, cell, values)
{
	url := "https://sheets.googleapis.com/v4/spreadsheets/" SheetKey "/values/" cell  ":append?includeValuesInResponse=true&valueInputOption=USER_ENTERED&access_token=" accessToken
	data = {"majorDimension":"ROWS","range":"%cell%","values":[[%values%]]}
	Return PutURL(url, data, "post")
}

googleAccessToken(client_id, client_secret, refresh_token) 
{
	StringReplace, client_id, client_id, %A_SPACE%,, All
    StringReplace, client_secret, client_secret, %A_SPACE%,, All
    StringReplace, refresh_token, refresh_token, %A_SPACE%,, All
	aURL := "https://www.googleapis.com/oauth2/v3/token"
    aPostData := "client_id=" client_id 
	aPostData .= "&client_secret=" client_secret 
	aPostData .= "&refresh_token=" refresh_token 
	aPostData .= "&grant_type=refresh_token"
    oHTTP := ComObjCreate("WinHttp.WinHttpRequest.5.1")
    oHTTP.Open("POST", aURL , False)
    oHTTP.SetRequestHeader("Content-Type", "application/x-www-form-urlencoded")
    oHTTP.Send(aPostData)
    response := oHTTP.ResponseText
	parsedAToken := JSON.Load(response, true)
    parsedAccessToken := parsedAToken.access_token
    oHTTP :=
    return parsedAccessToken
}

GetWorksheetRange(SheetKey, accessToken, ranges)
{
	url := "https://sheets.googleapis.com/v4/spreadsheets/" sheetkey "/values/" ranges "?access_token=" accessToken
    sheetBatch := URLDownloadToVar(url)
	return sheetBatch
}