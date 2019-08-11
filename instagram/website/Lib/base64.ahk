SetWorkingDir, %A_ScriptDir%
SetBatchLines, -1

If !pToken := Gdip_Startup()
{
   MsgBox, 48, gdiplus error!, Gdiplus failed to start. Please ensure you have gdiplus on your system
   ExitApp
}
       
; ; ---------------- create red square bitmap for test ----------

; pBitmap:=Gdip_CreateBitmap(10,10)
; pGraphics:=Gdip_GraphicsFromImage(pBitmap)
; Gdip_GraphicsClear(pGraphics, 0xffff0000)


; ; ---------------- ---------------- ---------------- ----------


; encoded:=Gdip_EncodeBitmapTo64string(pBitmap, "png")
; clipboard := encoded
; msgbox %encoded%


; ---------------- test create the image ---------------- 

; pBm:=get_bitmapfrom64(encoded)
; Gdip_SaveBitmapToFile(pbm,"red_square.png")

; Gdip_Shutdown(pToken)
; exitapp


; based on gdip_all.ahk save bitmap to file

Gdip_EncodeBitmapTo64string(pBitmap, ext, Quality=75)
{
	
	if Ext not in BMP,DIB,RLE,JPG,JPEG,JPE,JFIF,GIF,TIF,TIFF,PNG
		return -1
	Extension := "." Ext

	DllCall("gdiplus\GdipGetImageEncodersSize", "uint*", nCount, "uint*", nSize)
	VarSetCapacity(ci, nSize)
	DllCall("gdiplus\GdipGetImageEncoders", "uint", nCount, "uint", nSize, Ptr, &ci)
	if !(nCount && nSize)
		return -2
	


		Loop, %nCount%
		{
			sString := StrGet(NumGet(ci, (idx := (48+7*A_PtrSize)*(A_Index-1))+32+3*A_PtrSize), "UTF-16")
			if !InStr(sString, "*" Extension)
				continue
			
			pCodec := &ci+idx
			break
		}
	
	
	if !pCodec
		return -3

	if (Quality != 75)
	{
		Quality := (Quality < 0) ? 0 : (Quality > 100) ? 100 : Quality
		if Extension in .JPG,.JPEG,.JPE,.JFIF
		{
			DllCall("gdiplus\GdipGetEncoderParameterListSize", Ptr, pBitmap, Ptr, pCodec, "uint*", nSize)
			VarSetCapacity(EncoderParameters, nSize, 0)
			DllCall("gdiplus\GdipGetEncoderParameterList", Ptr, pBitmap, Ptr, pCodec, "uint", nSize, Ptr, &EncoderParameters)
			Loop, % NumGet(EncoderParameters, "UInt")      
			{
				elem := (24+(A_PtrSize ? A_PtrSize : 4))*(A_Index-1) + 4 + (pad := A_PtrSize = 8 ? 4 : 0)
				if (NumGet(EncoderParameters, elem+16, "UInt") = 1) && (NumGet(EncoderParameters, elem+20, "UInt") = 6)
				{
					p := elem+&EncoderParameters-pad-4
					NumPut(Quality, NumGet(NumPut(4, NumPut(1, p+0)+20, "UInt")), "UInt")
					break
				}
			}      
		}
	}
	

    DllCall("Ole32.dll\CreateStreamOnHGlobal", Ptr, 0, Int, True, PtrP, pStream)

    E:=DllCall( "gdiplus\GdipSaveImageToStream", Ptr,pBitmap, Ptr,pStream, Ptr, pCodec, uint, p ? p : 0)
    
    DllCall( "ole32\GetHGlobalFromStream", Ptr ,pStream , UIntP,hData )
    pData :=DllCall("Kernel32.dll\GlobalLock", Ptr, hData, UPtr)
    nSize := DllCall( "GlobalSize", UInt,pData )

    VarSetCapacity( Bin, nSize, 0 )
    DllCall( "RtlMoveMemory", Ptr, &Bin , Ptr, pData , UInt, nSize )
    DllCall( "GlobalUnlock", Ptr,hData )
    DllCall(NumGet(NumGet(pStream + 0, 0, "UPtr") + (A_PtrSize * 2), 0, "UPtr"), Ptr, pStream)
    DllCall( "GlobalFree", Ptr,hData )
    
    
    DllCall("Crypt32.dll\CryptBinaryToString", "Ptr", &Bin, "UInt", nSize, "UInt", 0x01, "Ptr", 0, "UIntP", enc64Len)
    VarSetCapacity(enc64, enc64Len*2, 0)
    DllCall("Crypt32.dll\CryptBinaryToString", "Ptr", &Bin, "UInt", nSize, "UInt", 0x01, "Ptr", &enc64, "UIntP", enc64Len)
    Bin := ""
    VarSetCapacity(Bin, 0)
    VarSetCapacity(enc64, -1)

    Return enc64
}


; based upon just me code: https://autohotkey.com/board/topic/93292-image2include-include-images-in-your-scripts/

get_bitmapfrom64(enc64){
If !DllCall("Crypt32.dll\CryptStringToBinary", "Ptr", &enc64, "UInt", 0, "UInt", 0x01, "Ptr", 0, "UIntP", BinLen, "Ptr", 0, "Ptr", 0)
   Return False
VarSetCapacity(Bin, BinLen, 0)
If !DllCall("Crypt32.dll\CryptStringToBinary", "Ptr", &enc64, "UInt", 0, "UInt", 0x01, "Ptr", &Bin, "UIntP", BinLen, "Ptr", 0, "Ptr", 0)
   Return False

hData := DllCall("Kernel32.dll\GlobalAlloc", "UInt", 2, "UPtr", BinLen, "UPtr")
pData := DllCall("Kernel32.dll\GlobalLock", "Ptr", hData, "UPtr")
DllCall("Kernel32.dll\RtlMoveMemory", "Ptr", pData, "Ptr", &Bin, "UPtr", BinLen)
DllCall("Kernel32.dll\GlobalUnlock", "Ptr", hData)
DllCall("Ole32.dll\CreateStreamOnHGlobal", "Ptr", hData, "Int", True, "PtrP", pStream)
hGdip := DllCall("Kernel32.dll\LoadLibrary", "Str", "Gdiplus.dll", "UPtr")
VarSetCapacity(SI, 16, 0), NumPut(1, SI, 0, "UChar")
DllCall("Gdiplus.dll\GdiplusStartup", "PtrP", pToken, "Ptr", &SI, "Ptr", 0)
DllCall("Gdiplus.dll\GdipCreateBitmapFromStream",  "Ptr", pStream, "PtrP", pBitmap)

DllCall("Gdiplus.dll\GdiplusShutdown", "Ptr", pToken)
DllCall("Kernel32.dll\FreeLibrary", "Ptr", hGdip)
DllCall(NumGet(NumGet(pStream + 0, 0, "UPtr") + (A_PtrSize * 2), 0, "UPtr"), "Ptr", pStream)
Return pBitmap
}






