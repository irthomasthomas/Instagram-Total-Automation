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