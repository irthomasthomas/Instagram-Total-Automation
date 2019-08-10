
UpdateGSheetCell(SheetKey, accessToken, cell, value)
{
	
	url := "https://sheets.googleapis.com/v4/spreadsheets/" SheetKey "/values/" cell  "?includeValuesInResponse=true&valueInputOption=USER_ENTERED&access_token=" accessToken
	data = {"majorDimension":"ROWS","range":"%cell%","values":[["%value%"]]}
	;Clipboard = %url%
	Return PutURL(url, data)
}

GsheetDeleteRow(SheetKey, sheetId, accessToken, row)
{
    url := "https://sheets.googleapis.com/v4/spreadsheets/" SheetKey ":batchUpdate"
    endRow := row + 1
    data = {"requests": [{"deleteDimension": {"range": {"sheetId": "%sheetId%","dimension": "ROWS","startIndex": "%row%","endIndex": "%endRow%"}  }  }]}
    response := PutURL(url,data,"post",accessToken)
    Return response
}

GsheetAppendRow(SheetKey, accessToken, cell, values)
{ 
    url =
    url .= "https://sheets.googleapis.com/v4/spreadsheets/" SheetKey
    url .= "/values/" cell  ":append?includeValuesInResponse=true&"
    url .= "valueInputOption=USER_ENTERED&insertDataOption=INSERT_ROWS&access_token=" accessToken
    data = {"majorDimension":"ROWS","range":"%cell%","values":[[%values%]]}
    return PutURL(url, data, "post")
}

UpdateStatusSheet(result, accessToken) 
{
	cell = Sheet1!A1:F1	
	;msgbox accessToken %accessToken%
	status := GsheetAppendRow(status_sheetkey, accessToken, cell, result)
	;msgbox % status
}

GetWorksheetRange(SheetKey, accessToken, ranges)
{
	url := "https://sheets.googleapis.com/v4/spreadsheets/" sheetkey "/values/" ranges "?access_token=" accessToken
    sheetBatch := URLDownloadToVar(url)
	return sheetBatch
}
