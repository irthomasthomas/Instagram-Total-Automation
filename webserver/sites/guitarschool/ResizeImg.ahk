#include Lib\Gdip_All.ahk

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
	SplitPath, imgFile, , , , imgName
	pBitmap := Gdip_CreateBitmapFromFile(imgFile)
	
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

