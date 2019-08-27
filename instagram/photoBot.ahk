#NoEnv
SetBatchLines, -1 
#SingleInstance, force
setTitleMatchMode, 2
DetectHiddenWindows, On 
setWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
SetWinDelay, -1
SetControlDelay, -1

; TODO: IS IT TARGETING WRONG USER AFTER UPLOAD?

#Include Lib\Socket.ahk
#Include Lib\Jxon.ahk
#Include Lib\RemoteObj.ahk
#include Lib\JSON.ahk
#include Lib\Gdip_All.ahk
#include control.ahk
#include GSheets.ahk
#include Lib\AhkDllThread.ahk
#include GetPhotoQueue.ahk

global stage1path := "tempImages\*"
global stage2path := "igImage"
global stage3path := "instagramQueue"
global stage4path := "c:\syncToPhone"
pythonpath := A_ScriptDir

global client_id :=
global client_secret :=
global refresh_token :=
global influencer_sheetkey :=
global status_sheetkey :=
setupConfigs()
global myAccessToken := GetAccessCode(client_id, client_secret, refresh_token)

queueSheetId := "1RJffz2YvkCojjFoNubwRLuL-ywjlNwDXpinfuwSeXoE"
global photoSheetId := "1o2ObINzmU_IB5bHzEeuXmby4ucgZPgM8_rcghRKkdL8"


extensions := "bmp,jpg,png"
; Remote.Message("HELLO, WORLD!")

/* 
    myTcp := new SocketTCP()
    addr := "192.168.0.31"
    myTcp.Connect([addr,1339])
    command := "HELLLOH!"

    ; command := "print_to_terminal;" . text . ";" 
    sleep 10
    myTcp.SendText(command)
    sleep 1000
    myTcp.disconnect() 
 */
SetTimer, FolderMon, 90000
return

FolderMon:
serverAddress := A_IPAddress1
serverPort := 1337
Remote := new RemoteObjClient([serverAddress, serverPort])
try
{
	CheckPhotoQueue(myAccessToken, Remote)
}
catch e
{
	LogError(e)
	sleep 2000
	Run, photoBot.ahk
}
; AhkDllPath := A_ScriptDir "\AutoHotkeyMini.dll"
; AhkThread := AhkDllThread(AhkDllPath)
; cmd := "#include GetPhotoQueue.ahk `n CheckPhotoQueue("
; cmd .= " """ myAccessToken """, " 
; cmd .= " """ Remote """ "
; cmd .= ")"
; AhkThread.ahktextdll(cmd) 
sleep 1000
; CheckPhotoQueueSheet(myAccessToken, Remote)

Loop, %stage1path%
{
	If A_LoopFileExt not in %extensions%
		Continue

	Clipboard :=
	fileArray := 0
	FileCopy % stage1path, %stage2path%
	ToolTip BEGIN
	Sleep 1000
	imgPath = %A_LoopFileFullPath%
	SplitPath, imgPath, imgName
	param_array := StrSplit(imgName, "@")
    {
        imgTitle := param_array[1]
        igAccount := param_array[2]
        imgFormat := param_array[3]
        imgType := param_array[4] ;img type  or modifier eg drawing or watercolour or oil paint
        scheduleDate := param_array[5]
        scheduleHour := param_array[6]
        SplitPath % A_LoopFileFullPath  , OutFileName, OutDir, OutExtension, OutNameNoExt, OutDrive
	    imgForPubFile = %outDir%\%OutFileName%
    }
	Sleep 100
    If imgFormat in 3p,3s,3w
    {   
        fileArray := SplitPhoto(imgPath,imgFormat)
    }
    ; Else If imgFormat = 1
    ; {
    ;     fileArray := BackgroundPhotos(imgPath)
    ; }
    Else
    {
        FileCopy % stage2path, %stage3path%
        FileCopy % stage2path, %stage4path%
    }
    
	Tooltip found photo
	hashtagString := GetHashtags(igAccount, imgFormat, imgType)
	captionArray := BuildCaptions(imgFormat, hashtagString, igAccount)
    ; msgbox % hashtagString " " captionArray[2] " imgFormat " imgFormat " imgType" imgType " igAccount " igAccount  " " 

	filepath := 
	caption := 
	If not fileArray
	{	
        filepath = %imgName%
        caption := captionArray[2]
    }
	Else
		Loop, % fileArray.MaxIndex()
		{
			If (A_Index = fileArray.MaxIndex())
			{
				filepath .= fileArray[A_Index]		
				caption .= captionArray[A_Index]
			}
			Else
			{
				filepath .= fileArray[A_Index] . "&"		
				caption .= captionArray[A_Index] . "&"
			}
		}
    
	gdriveJpg := SaveToJpg(imgPath,pythonpath)
	SplitPath, gdriveJpg, jpgName
	; while !fileId && (A_Index < 20)
	; {
		try
		{
		fileId := Remote.GDrivePutJpg(jpgName)
		}
		catch e
		{
			
		}
		sleep 1000
	; }
	; msgbox "test " %fileId%
	imageurl := "https://drive.google.com/uc?export=view&id=" . fileid
	filepath := StrReplace(filepath, "\", "%5C")	
	updateValues = "%igAccount%", "%account%", "%imgTitle%", "%imgFormat%", "%imgType%", "%scheduleDate%", "%scheduleHour%", "%filepath%", "%caption%", "%imageurl%"
	
	;msgbox "%igAccount%", "%account%", "%imgTitle%", "%imgFormat%", "%imgType%", "%scheduleDate%", "%scheduleHour%", "%filepath%", "%caption%", "%imageurl%"
	cell = Sheet1!A2
    response := GsheetAppendRow(photoSheetId, myAccessToken, cell, updateValues)
	objData := Jxon_Load(response)
	updaterange := objData["updates","updatedRange"]
	cellId := StrSplit(updaterange, ":")
	rowid := SubStr(cellId[2], 2)
	refCell := "J" . rowid	
	value := "=IMAGE({})"
	url := Format(value, refCell)
	cell := "Sheet1!K" . rowid
	
    UpdateGSheetCell(photoSheetId, myAccessToken, cell, url)
	sleep 10
	FileRecycle % imgPath
	imgForPub = %stage2path%\%imgName%
	Sleep 10
	ToolTip FINISHED
	Sleep 160000

}

Reload

setupConfigs() {
	if FileExist( "settings.dll" ) {
	FileCopy, settings.dll, c:\instasettings.dll
	Sleep 2000
	asm := CLR_LoadLibrary("c:\instasettings.dll ")
    obj := CLR_CreateObject(asm, "Settings")
    global client_id := obj.gcc()
	global client_secret := obj.gcs()
    global refresh_token := obj.grt()
	global influencer_sheetkey := obj.gis()
	global status_sheetkey:= obj.gss()
	; msgbox % "yep client_id " client_id " ig_name " ig_name " influencer_sheetkey " influencer_sheetkey
	}
	else
	{
		MsgBox setting.dll not found
		ErrorGui("setting.dll file not found. Exiting...")
		ExitApp
	}
	if FileExist( "settings.ini" ) {	
		IniRead, influencer_hotkey, settings.ini, General, influencer_hotkey
		IniRead, login_type, settings.ini, General, login_type
		IniRead, e_session_id, settings.ini, Session, session_id
		if (e_session_id) && (e_session_id <> "ERROR")
		{
			session_id := e_session_id
		}
	}
	else
	{
		msgbox settings.ini not found
		ErrorGui("setting.ini file not found. Exiting...")
		ExitApp
	}
}

BackgroundPhotos(imgFile)
{
	SplitPath, imgFile, , , , imgName
    file3 = %stage3path%\%imgName%1.jpg
	file2 = %stage3path%\%imgName%2.jpg
	file1 = %stage3path%\%imgName%3.jpg
	Random, n, 1, 9
	bgFile = backgrounds\bg%n%.jpg
    pToken := Gdip_Startup()
	pBitmap1 := Gdip_CreateBitmapFromFile(bgFile)
	pBitmap2 := Gdip_CreateBitmapFromFile(bgFile)
    Gdip_SaveBitmapToFile(pBitmap1,file1,100)
    Gdip_SaveBitmapToFile(pBitmap2,file3,100)
	
    Gdip_DisposeImage(pBitmap1)
    Gdip_DisposeImage(pBitmap2)
    Gdip_Shutdown(pToken)

    file1 = %imgName%1.jpg
	file2 = %imgName%2.jpg
	file3 = %imgName%3.jpg
    
    SaveToJpg(imgFile,stage3path,file2)
	aFile := Array(file1, file2, file3)
	return aFile
}

BlurPhoto(imgFile)
{
	SplitPath, imgFile, , , , imgName
    file3 = %stage3path%\%imgName%1.jpg
	file2 = %stage3path%\%imgName%2.jpg
	file1 = %stage3path%\%imgName%3.jpg
    pToken := Gdip_Startup()
	pBitmap := Gdip_CreateBitmapFromFile(imgFile)

    blurredBitmap := Gdip_BlurBitmap(pBitmap, 100)
	Loop, 20
		blurredBitmap := Gdip_BlurBitmap(blurredBitmap, 100)
	Loop, 20
    	blurredBitmap2 := Gdip_BlurBitmap(blurredBitmap, 100)

    Gdip_ImageRotateFlip(blurredBitmap,3)   
    Gdip_ImageRotateFlip(blurredBitmap2,1) 
    Gdip_SaveBitmapToFile(blurredBitmap,file1,100)
    Gdip_SaveBitmapToFile(blurredBitmap2,file3,100)
    Gdip_DisposeImage(pBitmap)
	Gdip_DisposeImage(blurredBitmap)
	Gdip_DisposeImage(blurredBitmap2)
    Gdip_Shutdown(pToken)

    file1 = %imgName%1.jpg
	file2 = %imgName%2.jpg
	file3 = %imgName%3.jpg
    
    SaveToJpg(imgFile,stage3path,file2)
	aFile := Array(file1, file2, file3)
	return aFile
}

SaveToJpg(imgFile, path, newName:=0)
{
	pToken := Gdip_Startup()
	SplitPath, imgFile, , , , imgName
    If newName 
        file = %path%\%newName%
	Else
        file = %path%\%imgName%.jpg
	Sleep 100
	pBitmap := Gdip_CreateBitmapFromFile(imgFile)

	Gdip_SaveBitmapToFile(pBitmap,file,100)
	Gdip_DisposeImage(pBitmap)
	Gdip_Shutdown(pToken)
	Return file
}


DimensionsArray(format)
{
    if format = 3s
	{
		a := Array(3240,1080,1080,1080)
	}
    else if format = 3p
    {
		a := Array(3240,1350,1080,1080)
    }
    else if format = 3w
    {
		a := Array(2212,566,566,1080)
    }
    Return a
}

SplitPhoto(imgFile,split:="3s")
{
	pToken := Gdip_Startup()
	;driveSyncPath := "G:\Google Drive\DriveSyncFiles"
	SplitPath, imgFile, , , , imgName
	file3 = %stage3path%\%imgName%1.jpg
	file2 = %stage3path%\%imgName%2.jpg
	file1 = %stage3path%\%imgName%3.jpg
	Sleep 100
	pBitmap := Gdip_CreateBitmapFromFile(imgFile)
	Sleep 100
	If !pBitmap
	{
		errormsg := "File loading error Could not load image Module SplitThreeSquare"
		GsheetAppendRow(photoSheetId, myAccessToken, "Sheet1!A1", errormsg)
		ToolTip %errormsg%
		return errormsg
		;Remote.Message("File loading error Could not load image")
	}
	aDimensions := DimensionsArray(split)
	Gdip_GetDimensions(pBitmap, w, h)
	If !(w >= aDimensions[1]) || !(h >= aDimensions[2])
	{
		Remote.Message("Size Error Image must be at least 3240x1080")
	}
	Else If (w > aDimensions[1]) || (h > aDimensions[2])
	{
		wCrop := w-aDimensions[1]
		hCrop := h-aDimensions[2]
		pBitmap := Gdip_CropImage(pBitmap, 0, 0, w-wCrop, h-hCrop)
	}
    (2212,566,1080)
	pBitmap1 := Gdip_CropImage(pBitmap, 0, 0, 1080, aDimensions[2])
	Gdip_SaveBitmapToFile(pBitmap1,file1,100)
	Gdip_DisposeImage(pBitmap1)

	pBitmap2 := Gdip_CropImage(pBitmap, aDimensions[3], 0, 1080, aDimensions[2])
	Gdip_SaveBitmapToFile(pBitmap2,file2,100)
	Gdip_DisposeImage(pBitmap2)

	pBitmap3 := Gdip_CropImage(pBitmap, (aDimensions[1] - aDimensions[4]), 0, 1080, aDimensions[2])
	Gdip_SaveBitmapToFile(pBitmap3,file3,100)
	Gdip_DisposeImage(pBitmap3)
	Gdip_DisposeImage(pBitmap)
	Gdip_Shutdown(pToken)
	file1 = %imgName%1.jpg
	file2 = %imgName%2.jpg
	file3 = %imgName%3.jpg

	aFile := Array(file1, file2, file3)
	return aFile
}

GetHashtags(igAccount, imgFormat:=1, imgType:="o") {
	hashtag_sheetkey = 16yguXSFWUhrBMNs9BgxQM3xkKH3pcjhG-SaZ90xiEgA
	Category1 := Object()
	Category2 := Object()
	Category3 := Object()
    ;	msgbox % "GetHashtags " imgFormat " " imgType " " igAccount
	If igAccount = philhughesart
	{
		nCategories = 3
		ranges := "PHA!A1:D"
		hashtagSheetData := GetWorksheetRange(hashtag_sheetkey, myAccessToken, ranges)
		oArray := json.Load(hashtagSheetData)
		If imgType = o
		{
			for i in oArray.values
			{
				If oArray.values[i][4] = "Art"
					Category1.Insert(oArray.values[i][1])
				Else If oArray.values[i][4] = "Scene"
					Category2.Insert(oArray.values[i][1])
				Else If oArray.values[i][4] = "Oil Painting"
					Category3.Insert(oArray.values[i][1])
			}
		}
		Else If imgType = d
		{
			for i in oArray.values
			{
				If oArray.values[i][4] = "Art"
					Category1.Insert(oArray.values[i][1])
				Else If oArray.values[i][4] = "Scene"
					Category2.Insert(oArray.values[i][1])
				Else If oArray.values[i][4] = "Drawing"
					Category3.Insert(oArray.values[i][1])
			}	
		}
		ELSE If imgType = w
		{
			for i in oArray.values
			{
				If oArray.values[i][4] = "Art"
					Category1.Insert(oArray.values[i][1])
				Else If oArray.values[i][4] = "Scene"
					Category2.Insert(oArray.values[i][1])
				Else If oArray.values[i][4] = "Watercolour"
					Category3.Insert(oArray.values[i][1])
			}
		}
	}
	Else If (igAccount = "noplacetosit") || (igAccount = noplacetosit)
	{
		;msgbox % " GetHashtags() NPS "
		ranges := "NPS!A1:D"
		nCategories = 1
		;msgbox % " sheetkey " hashtag_sheetkey " accesstoken " myAccessToken " ranges " ranges
		hashtagSheetData := GetWorksheetRange(hashtag_sheetkey, myAccessToken, ranges)
		oArray := json.Load(hashtagSheetData)
		;msgbox % hashtagSheetData
		For i in oArray.values
		{
			Category1.Insert(oArray.values[i][1])
		}	
	}
	Else If igAccount in TT,T,thomasthomas2211 
	{
		nCategories = 1
		ranges := "TT!A1:D"
		hashtagSheetData := GetWorksheetRange(hashtag_sheetkey, myAccessToken, ranges)
		oArray := json.Load(hashtagSheetData)
		
		For i in oArray.values
		{
			Category1.Insert(oArray.values[i][1])
		}
	}
	Else If (igAccount = "b") || (igAccount = "bliss") || (igAccount = "bm") || (igAccount = "blissMolecule") || (igAccount = b)
	{
		;msgbox % " GetHashtags() blissMolecule "
		nCategories = 1
		ranges := "BM!A1:D"
		;msgbox % " sheetkey " hashtag_sheetkey " accesstoken " myAccessToken " ranges " ranges
		hashtagSheetData := GetWorksheetRange(hashtag_sheetkey, myAccessToken, ranges)
		;msgbox % hashtagSheetData
		oArray := json.Load(hashtagSheetData)
		
		For i in oArray.values
		{
			Category1.Insert(oArray.values[i][1])
		}
		
	}

	Loop % Category1.MaxIndex()
	{
		cat1Deck%A_Index% := Category1[A_Index]
	}
	Loop % Category1.MaxIndex()
	{
		random, pos, 1, Category1.MaxIndex()
		temp := cat1Deck%A_Index%
		cat1Deck%A_Index% := cat1Deck%pos%
		cat1Deck%pos% := temp
	}
	Loop % Category2.MaxIndex()
	{
		cat2Deck%A_Index% := Category2[A_Index]
	}
	Loop % Category2.MaxIndex()
	{
		random, pos, 1, Category2.MaxIndex()
		temp := cat2Deck%A_Index%
		cat2Deck%A_Index% := cat2Deck%pos%
		cat2Deck%pos% := temp
	}
	Loop % Category3.MaxIndex()
	{
		cat3Deck%A_Index% := Category3[A_Index]
	}
	Loop % Category3.MaxIndex()
	{
		random, pos, 1, Category3.MaxIndex()
		temp := cat3Deck%A_Index%
		cat3Deck%A_Index% := cat3Deck%pos%
		cat3Deck%pos% := temp
	}
	
	If nCategories = 1
	{
		Loop 27
		{
			s.=cat1Deck%A_Index%
		}
	}
	Else If nCategories = 2
	{
		Loop 14
		{
			s.=cat1Deck%A_Index%
		}
		Loop 13
		{
			s.=cat2Deck%A_Index%
		}
	}
	Else If nCategories = 3
	{
		Loop 9
		{
			s.= cat1Deck%A_Index% . cat2Deck%A_Index% . cat3Deck%A_Index%
		}
	}
	
	return % s

}

BuildCaptions(imgFormat, hashtagString, igAccount) 
{
    global
    aCaptions := Object()
    If igAccount in TT,T,thomasthomas2211
	{
		If imgFormat = 1
		{
			imgCaption:= imgTitle "`n➖➖➖➖➖➖➖➖➖➖`nSee more @thomasThomas2211 `n〰〰〰〰〰〰〰〰〰〰〰〰`n"
			imgCaption .= hashtagString "`n"
			sleep 10
			aCaptions := Array("",imgCaption,"")
			sleep 10
			Return aCaptions
		}
		Else If (imgFormat = "3s") || (imgFormat = "3p")
		{	
			imgCaption31:= "#Split Pano 1/3 ◻◼◼`n➖➖➖➖➖➖➖➖➖➖`n🌏 "imgTitle "`n➖➖➖➖➖➖➖➖➖➖`nSee more 👀👉 @thomasThomas2211 `n〰〰〰〰〰〰〰〰〰〰〰〰`n"
			imgCaption31.= hashtagString "`n`n"
			
			imgCaption32:= "#Split Pano 2/3 ◼◻◼`n➖➖➖➖➖➖➖➖➖➖`n🌏 "imgTitle "`n➖➖➖➖➖➖➖➖➖➖`nSee more 👀👉 @thomasThomas2211`n〰〰〰〰〰〰〰〰〰〰〰〰`n"
			imgCaption32.= hashtagString "`n`n"
			
			imgCaption33:="Split Pano 3/3 ◼◼◻`n➖➖➖➖➖➖➖➖➖➖`n🌏 "imgTitle "`n➖➖➖➖➖➖➖➖➖➖`nSee more 👀👉 @thomasThomas2211`n〰〰〰〰〰〰〰〰〰〰〰〰`n"	
			imgCaption33.= hashtagString	"`n`n"
			
			aCaptions  := Array(imgCaption33, imgCaption32, imgCaption31)
								
			return aCaptions
		}
		Else If (imgFormat = "3w")
		{
			imgCaption31:= "#HyperWide Pano 1/3 ◻◼◼ `n➖➖➖➖➖➖➖➖➖➖ `n🌏 "imgTitle " `n➖➖➖➖➖➖➖➖➖➖ `nSee more 👀👉 #thomasThomas `n〰〰〰〰〰〰〰〰〰〰〰〰`n"
			imgCaption31.= hashtagString "`n`n"
			
			imgCaption32:= "#HyperWide Pano 2/3 ◼◻◼`n➖➖➖➖➖➖➖➖➖➖`n🌏 "imgTitle "`n➖➖➖➖➖➖➖➖➖➖`nSee more 👀👉 #thomasThomas`n〰〰〰〰〰〰〰〰〰〰〰〰`n"
			imgCaption32.= hashtagString "`n`n"
			
			imgCaption33:="#HyperWide Pano 3/3 ◼◼◻`n➖➖➖➖➖➖➖➖➖➖`n🌏 "imgTitle "`n➖➖➖➖➖➖➖➖➖➖`nSee more 👀👉 #thomasThomas`n〰〰〰〰〰〰〰〰〰〰〰〰`n"	
			imgCaption33.= hashtagString	 "`n`n"
			
			CaptionArray := Array(imgCaption33, imgCaption32, imgCaption31)
					
			aCaptions := Array(CaptionArray)
			
			return aCaptions
		}
		Else
		{
			imgCaption:= imgTitle "`n➖➖➖➖➖➖➖➖➖➖`nSee more 👀👉 #thomasThomas `n〰〰〰〰〰〰〰〰〰〰〰〰`n"
			imgCaption .= hashtagString "`n`n"
			sleep 10
			aCaptions := Array(imgCaption)
			sleep 10
			
			Return aCaptions
		}
    }
    Else If igAccount in p,"p",philhughesart
	{
		If imgFormat = 1
		{
			imgCaption := imgTitle "`n➖➖➖➖➖➖➖➖➖➖`nSee more #PhilHughesArt `n〰〰〰〰〰〰〰〰〰〰〰〰`n"
			imgCaption .= hashtagString
			sleep 10
			aCaptions := Array("",imgCaption,"")
			sleep 10
			Return aCaptions
		}
		Else If (imgFormat = "3s") || (imgFormat = "3p")
		{
			imgCaption31:= "Triptych 1/3 ◻◼◼`n➖➖➖➖➖➖➖➖➖➖`n"imgTitle "`n➖➖➖➖➖➖➖➖➖➖`nSee more @PhilHughesArt`n〰〰〰〰〰〰〰〰〰〰〰〰`n#FineArt @PhilHughesArt"
			imgCaption31.= hashtagString "`n`n"
			
			imgCaption32:= "Triptych 2/3 ◼◻◼ `n➖➖➖➖➖➖➖➖➖➖`n"imgTitle "`n➖➖➖➖➖➖➖➖➖➖`nSee more @PhilHughesArt`n〰〰〰〰〰〰〰〰〰〰〰〰`n#FineArt @PhilHughesArt"
			imgCaption32.= hashtagString "`n"
			
			imgCaption33:="Triptych 3/3 ◼◼◻`n➖➖➖➖➖➖➖➖➖➖`n"imgTitle "`n➖➖➖➖➖➖➖➖➖➖`nSee more @PhilHughesArt`n〰〰〰〰〰〰〰〰〰〰〰〰`n#FineArt @PhilHughesArt"	
			imgCaption33.= hashtagString "`n`n"
			
			aCaptions := Array(imgCaption33, imgCaption32, imgCaption31)
								
			return aCaptions
		}
		Else If (imgFormat = "3w")
		{
			imgCaption31:= "#HyperWide Triptych 1/3 ◻◼◼`n➖➖➖➖➖➖➖➖➖➖`n"imgTitle "`n➖➖➖➖➖➖➖➖➖➖`nSee more @PhilHughesArt`n〰〰〰〰〰〰〰〰〰〰〰〰`n#FineArt @PhilHughesArt"
			imgCaption31.= hashtagString "`n`n"
			
			imgCaption32:= "#HyperWide Triptych 2/3 ◼◻◼ `n➖➖➖➖➖➖➖➖➖➖`n"imgTitle "`n➖➖➖➖➖➖➖➖➖➖`nSee more @PhilHughesArt`n〰〰〰〰〰〰〰〰〰〰〰〰`n#FineArt @PhilHughesArt"
			imgCaption32.= hashtagString "`n`n"
			
			imgCaption33:="#HyperWide Triptych 3/3 ◼◼◻`n➖➖➖➖➖➖➖➖➖➖`n"imgTitle "`n➖➖➖➖➖➖➖➖➖➖`nSee more @PhilHughesArt`n〰〰〰〰〰〰〰〰〰〰〰〰`n#FineArt @PhilHughesArt"	
			imgCaption33.= hashtagString	"`n`n"
			
			aCaptions := Array(imgCaption33, imgCaption32, imgCaption31)
								
			return aCaptions
		}
		Else
		{
			imgCaption := imgTitle "`n➖➖➖➖➖➖➖➖➖➖`nSee more @PhilHughesArt `n〰〰〰〰〰〰〰〰〰〰〰〰`n"
			imgCaption .= hashtagString
			sleep 10
			aCaptions := Array("",imgCaption,"")
			sleep 10
			Return aCaptions
		}
		
    }
	Else If igAccount in  "nps","noplacetosit",noplacetosit
	{
		If imgFormat = 1
		{
			imgCaption := imgTitle "`n➖➖➖➖➖➖➖➖➖➖ `nSee more 👀👉 @NoPlaceToSit `n➖➖➖➖➖➖➖➖➖➖ `n"
			imgCaption .= hashtagString
			aCaptions := Array("",imgCaption,"")
			sleep 10
			Return aCaptions
		}
		
		Else If imgFormat = 3w
		{
			imgCaption31 := "#HyperWide Pano 1/3 ◻◼◼ `n➖➖➖➖➖➖➖➖➖➖ `n "imgTitle " `n➖➖➖➖➖➖➖➖➖➖ `nSee more   @NoPlaceToSit`n〰〰〰〰〰〰〰〰〰〰〰〰 `n`n"
			imgCaption31 .= hashtagString "`n`n"
			
			imgCaption32 := "#HyperWide Pano 2/3 ◼◻◼`n➖➖➖➖➖➖➖➖➖➖`n "imgTitle  "`n➖➖➖➖➖➖➖➖➖➖`nSee more  @NoPlaceToSit `n〰〰〰〰〰〰〰〰〰〰〰〰`n`n"
			imgCaption32 .= hashtagString "`n`n"		

			imgCaption33 := "#HyperWide Pano 3/3 ◼◼◻`n➖➖➖➖➖➖➖➖➖➖`n "imgTitle  "`n➖➖➖➖➖➖➖➖➖➖`nSee more @NoPlaceToSit `n〰〰〰〰〰〰〰〰〰〰〰〰`n`n"	
			imgCaption33 .= hashtagString "`n`n"		

			aCaptions := Array(imgCaption33, imgCaption32, imgCaption31)
								
			return aCaptions
		}
		Else If (imgFormat = "3s") || (imgFormat = "3p") || (imgFormat = 3s) || (imgFormat = 3p) 
		{	
			imgCaption31 := "Split Pano 1/3 ◻◼◼`n➖➖➖➖➖➖➖➖➖➖`n" imgTitle " @noplacetosit `n➖➖➖➖➖➖➖➖➖➖ `n#streetview"
			imgCaption31 .= hashtagString "`n`n"
			
			imgCaption32 := "Split Pano 2/3 ◼◻◼`n➖➖➖➖➖➖➖➖➖➖`n "imgTitle " @noplacetosit `n➖➖➖➖➖➖➖➖➖➖ `n#streetview"
			imgCaption32 .= hashtagString "`n`n"
			
			imgCaption33 := "Split Pano 3/3 ◼◼◻`n➖➖➖➖➖➖➖➖➖➖`n "imgTitle " @noplacetosit `n➖➖➖➖➖➖➖➖➖➖ `n#streetview"
			imgCaption33 .= hashtagString "`n`n"
			
			aCaptions := Array(imgCaption33, imgCaption32, imgCaption31)
			
			return aCaptions
		}
		
    }
    Else If igAccount in "b","bliss",blissmolecule
    {
        If imgFormat = 1
        {
            random, r, 1,4
            imgCaption := imgTitle  "`n➖➖➖➖➖➖➖➖➖➖`n #Cannatographer @blissMolecule `n➖➖➖➖➖➖➖➖➖➖`n"
            imgCaption .= hashtagString
            sleep 10
			aCaptions := Array("",imgCaption,"")	            
        }
        Else If imgFormat = (imgFormat = "3s") || (imgFormat = "3p") 
        {	
            random, r, 1,2
            imgCaption31 := "Split/Pic 1/3 ◻◼◼ 👀👉@blissMolecule`n➖➖➖➖➖➖➖➖➖➖`n"imgTitle  "`n➖➖➖➖➖➖➖➖➖➖`nSee more 👀👉 #blissMolecule `n〰〰〰〰〰〰〰〰〰〰〰〰`n"
            imgCaption31 .= hashtagString "`n"
            
            imgCaption32 := "Split/Pic 2/3 ◼◻◼ 👀👉@blissMolecule`n➖➖➖➖➖➖➖➖➖➖`n"imgTitle  "`n➖➖➖➖➖➖➖➖➖➖`nSee more 👀👉 #blissMolecule`n〰〰〰〰〰〰〰〰〰〰〰〰`n"
            imgCaption32 .= hashtagString "`n"
            
            imgCaption33 :="Split/Pic 3/3 ◼◼◻ 👀👉@blissMolecule`n➖➖➖➖➖➖➖➖➖➖`n"imgTitle  "`n➖➖➖➖➖➖➖➖➖➖`nSee more 👀👉 #blissMolecule`n〰〰〰〰〰〰〰〰〰〰〰〰`n"	
            imgCaption33 .= hashtagString "`n"

			aCaptions := Array(imgCaption33, imgCaption32, imgCaption31)            
        }
        Else If imgFormat = 3w
        {	
            random, r, 1,2
            imgCaption31 := "#HyperWide Split/Pic 1/3 ◻◼◼`n👀👉@blissMolecule`n➖➖➖➖➖➖➖➖➖➖`n"imgTitle  "`n➖➖➖➖➖➖➖➖➖➖`nSee more 👀👉 #blissMolecule `n〰〰〰〰〰〰〰〰〰〰〰〰`n"
            imgCaption31 .= hashtagString
            
            imgCaption32 := "#HyperWide Split/Pic 2/3 ◼◻◼`n👀👉@blissMolecule`n➖➖➖➖➖➖➖➖➖➖`n"imgTitle  "`n➖➖➖➖➖➖➖➖➖➖`nSee more 👀👉 #blissMolecule`n〰〰〰〰〰〰〰〰〰〰〰〰`n"
            imgCaption32 .= hashtagString
            
            imgCaption33 := "#HyperWide Split/Pic 3/3 ◼◼◻`n👀👉@blissMolecule`n➖➖➖➖➖➖➖➖➖➖`n"imgTitle  "`n➖➖➖➖➖➖➖➖➖➖`nSee more 👀👉 #blissMolecule`n〰〰〰〰〰〰〰〰〰〰〰〰`n"	
            imgCaption33 .= hashtagString
            
            aCaptions := Array(imgCaption33, imgCaption32, imgCaption31)            
        }
        Else
        {		
            imgCaption := imgTitle "`nKnow more 👀👉 @blissMolecule`n➖➖➖➖➖➖➖➖➖➖`n"
            imgCaption .= hashtagString	

            aCaptions := Array(commentCaption, imgCaption)
            sleep 10
        }
        Return aCaptions

    }
}

ShuffleHashtags(Set="All") {
	hashtag_sheetkey = 16yguXSFWUhrBMNs9BgxQM3xkKH3pcjhG-SaZ90xiEgA 
	If Set = "All"
	{
	    sheet = Sheet2!
	}
	Else If Set = "NPS"
	{
	    sheet = NPS!
	}
	Else If Set = "TT"
	{
	    sheet = TT!
	}
	rows = 120
	
	Loop % rows
	{ tooltip setting up %A_Index%
		Deck%A_Index% := A_Index
	}
	
	Loop 28
	{
		random, pos, 2, 120
		tooltip, swapping %A_Index% with %pos%
		temp := Deck%A_Index%
		Deck%A_Index% := Deck%pos%
		Deck%Pos% := temp
	}
	
	Loop 28
	{ tooltip creating the output string from %A_Index%
		if (A_Index = 1)
		{	str := "ranges=NPS!A" Deck%A_Index% "&"
		}
		Else
		{	x := "ranges=NPS!A" Deck%A_Index% "&"
			str = %str%%x%
		}
	}
	;msgbox, %str%
	url := "https://sheets.googleapis.com/v4/spreadsheets/" hashtag_sheetkey "/values:batchGet?" str "valueRenderOption=FORMATTED_VALUE&access_token=" myAccessToken
	hObject:=ComObjCreate("WinHttp.WinHttpRequest.5.1")
	
	hObject.Open("GET", url)
	hObject.SetRequestHeader("Content-Type", "application/json")
	hObject.Send()
	hashtagSheetData := hObject.ResponseText
	
	hObject :=
	oArray2 := json.Load(hashtagSheetData)
		 
	for i in oArray2.valueRanges
		s.= oArray2.valueRanges[i].values[1][1]
	 	 
	 return s
}

randomize(a) 
{
    i := a.maxindex()
    while (i>1) 
	{
        random, x, 1, i
        swap := a[x]
        a[x] := a[i]
        a[i] := swap
        i--
    }
}

Gdip_CropImage(pBitmap, x, y, w, h)
{
   pBitmap2 := Gdip_CreateBitmap(w, h)
   G2 := Gdip_GraphicsFromImage(pBitmap2)
   Gdip_DrawImage(G2, pBitmap, 0, 0, w, h, x, y, w, h)
   Gdip_DeleteGraphics(G2)
   
   return pBitmap2
}

^!r::Reload
