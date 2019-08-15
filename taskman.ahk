If (!A_IsAdmin)
{
	If (A_IsUnicode)
		DllCall("shell32\ShellExecuteW", UInt, 0, WStr, "RunAs", WStr, A_AhkPath, WStr, """" . A_ScriptFullPath . """", WStr, A_WorkingDir, Int, 1)
	Else
		DllCall("shell32\ShellExecuteA", UInt, 0, AStr, "RunAs", AStr, A_AhkPath, AStr, """" . A_ScriptFullPath . """", AStr, A_WorkingDir, Int, 1)
	ExitApp
}

#NoEnv
#Warn
SetWorkingDir, %A_ScriptDir%
#MaxThreads, 20

TaskKill = "%A_ScriptDir%\taskkill.exe" ; Path to taskkill.exe
PsExec = "%A_ScriptDir%\PsExec.exe" ; Path to PsExec.exe

OnExit, Exiting

hLibPsapi := DllCall("LoadLibrary", Str, "psapi.dll", Ptr)

SetFormat, Float, 0
pMemBuf := DllCall("msvcrt\realloc", UInt,0,UInt,512*(16+A_PtrSize), "Cdecl Ptr" )
if (!pMemBuf)
	ExitApp
nMemAllocated := 512*(16+A_PtrSize)

Menu, lvMenu, Add, Open File Location, LVMenuOpen
Menu, lvMenu, Add
Menu, lvMenu, Add, End Process, LVMenuEnd
Menu, lvMenu, Add, End Process Tree, LVMenuEndTree
Menu, lvMenu, Add

Menu, Submenu1, Add, Low, MenuHandler
Menu, Submenu1, Add, Below Normal, MenuHandler
Menu, Submenu1, Add, Normal, MenuHandler
Menu, Submenu1, Add, Above Normal, MenuHandler
Menu, Submenu1, Add, High, MenuHandler
Menu, Submenu1, Add, Realtime, MenuHandler

Menu, lvMenu, Add, Set Priority, :Submenu1

Gui, +AlwaysOnTop
Gui, Add, ListView, r20 w700 -Multi vProcesses AltSubmit gShowMenu, Name|PID|User Name|CPU|Mem Usage|Handles|Threads|Priority

LV_ModifyCol(1,100) ; Name
LV_ModifyCol(2,"50 Right") ; PID
LV_ModifyCol(3,100) ; User Name
LV_ModifyCol(4,"40 Right") ; CPU
LV_ModifyCol(5,"75 Right") ; Mem Usage
LV_ModifyCol(6,"60 Right") ; Handles
LV_ModifyCol(7,"60 Right") ; Threads
LV_ModifyCol(8,"100 Right") ; Priority
Gui, Show, Autosize

; Set debug privs for the script
sdbRet := SetPrivilege()
if (sdbRet)
{
	MsgBox % sdbRet
	ExitApp
}

GoSub, DoProcs
SetTimer, DoProcs, 2000
Return

DoProcs:
	GetProcesses()
Return

GetProcesses() {
	Static busy := 0
	SystemProcessInformation := 0x5
	SystemInformationLength := 8000
	
	if (busy != 0)
		return
	busy := 1
	
	VarSetCapacity(pSPIBuf,0,0)
	VarSetCapacity(ReturnLength,A_PtrSize,0)
	
	; Get the required size of the buffer
	ret := DllCall("ntdll.dll\NtQuerySystemInformation", UInt, SystemProcessInformation
												, Ptr, &pSPIBuf
												, UInt, 0 ;SystemInformationLength
												, Ptr, &ReturnLength)
	
	bufSize := NumGet(ReturnLength)
	VarSetCapacity(pSPIBuf,bufSize,0)
	ret := DllCall("ntdll.dll\NtQuerySystemInformation", UInt, SystemProcessInformation
												, Ptr, &pSPIBuf
												, UInt, bufSize ;SystemInformationLength
												, Ptr, &ReturnLength)
	
	ParseProcessBuffer(pSPIBuf)
	busy := 0
}

ParseProcessBuffer(byref pSPIBuf) {
	nRowCount := LV_GetCount()
	nPIDCount := 0
	
	; Get 1st struct in the list
	pNext := NumGet(&pSPIBuf,0,"UInt")
	
	while (true)
	{
		pCur := pNext
		
		; Get process name. It is stored in a UNICODE_STRING struct
		VarSetCapacity(szImageName, NumGet(&pSPIBuf+pCur, 56, "UShort")+2, 0)
		DllCall("lstrcpyW", Str, szImageName, Ptr, NumGet(&pSPIBuf+pCur, (A_PtrSize=8 ? "64" : "60"), "Ptr"))
		
		; Get ProcessID
		PID := NumGet(&pSPIBuf+pCur, (A_PtrSize=8 ? "80" : "68"), "Ptr")
		PID%A_Index% := PID ; Keep a list of PIDs so we can determine any that were closed since last update
		nPIDCount++
		
		; Get handle count
		nHandles := GetProcessHandleCount(PID)
		
		; Get number of threads
		nThreads := NumGet(&pSPIBuf+pCur, 4, "UInt")
		
		
		; Get base priority
		nBasePriority := FormatPriority(NumGet(&pSPIBuf+pCur, (A_PtrSize=8 ? "72" : "64"), "UInt"))
		
		; Get name of user account the process is running under
		szUser := GetProcessUserName(PID)
		
		; Get process memory usage
		nMemUsage := GetProcessMemoryInfo(PID)
		
		; Get CPU usage
		nCPU := GetProcessTimes(PID)
		
		; Update the ListView
		if (nRowCount > 0)
		{
			found := 0
			Loop, % nRowCount
			{
				LV_GetText(nPID, A_Index, 2)
				if (nPID == PID)
				{
					;Name|PID|User Name|CPU|Mem Usage|Handles|Threads|Priority
					LV_Modify(A_Index, " "
							, szImageName 		; Name
							, PID				; PID
							, szUser			; User Name
							, nCPU				; CPU
							, nMemUsage			; Mem Usage
							, nHandles			; Handles
							, nThreads			; Threads
							, nBasePriority)	; Priority
					++found
				}
			}
			
			if (!found)
			{
				;Name|PID|User Name|CPU|Mem Usage|Handles|Threads|Priority
				LV_Add("", szImageName 		; Name
						, PID				; PID
						, szUser			; User Name
						, nCPU				; CPU
						, nMemUsage			; Mem Usage
						, nHandles			; Handles
						, nThreads			; Threads
						, nBasePriority)	; Priority
			}
		}
		else
		{
			;Name|PID|User Name|CPU|Mem Usage|Handles|Threads|Priority
			LV_Add("", szImageName 		; Name
					, PID				; PID
					, szUser			; User Name
					, nCPU				; CPU
					, nMemUsage			; Mem Usage
					, nHandles			; Handles
					, nThreads			; Threads
					, nBasePriority)	; Priority
		}
		
		
		; Break if there are no more structures.
		if ( !NumGet(&pSPIBuf+pCur,0,"UInt") )
			break
		pNext += NumGet(&pSPIBuf+pCur,0,"UInt")
	}
	
	; Remove processes that have quit running from the listview. Has to be a better way to do this...
	Loop, % LV_GetCount()
	{
		match := 0
		i := A_Index
		Loop, % nPIDCount
		{
			id := PID%A_Index%
			LV_GetText(ov, i, 2)
			if (ov == id)
			{
				match++
				break
			}
		}
		if (!match)
			LV_Delete(i)
	}
}

GetModuleFileNameEx(PID) {
	ret := ""

	hProc := DllCall("OpenProcess", "Uint", 0x400|0x0010, "int", 0, "Ptr", pid, Ptr)
	if (hProc != 0)
	{
		VarSetCapacity(lpFilename, 512, 0)
		if (DllCall("psapi.dll\GetModuleFileNameEx", Ptr, hProc, Ptr, 0, Str, lpFilename, UInt, 512) != 0)
			ret := lpFilename
		DllCall("CloseHandle", "Ptr", hProc)
	}
	return % ret
}

; Function by SKAN: http://www.autohotkey.com/forum/post-120871.html&sid=8b53c406ecb240cbdc1b457950698f57#120871
GetProcessTimes(PID) {
	; pMemBuf = buffer for PID/times pairs, nMemAllocated = current memory allocated
	Global pMemBuf, nMemAllocated
	Static nMemUsed:=0
	CreationTime:=0,ExitTime:=0,newKrnlTime:=0,newUserTime:=0
	
	hProc := DllCall("OpenProcess", "Uint", 0x400, "int", 0, "Ptr", pid, Ptr)
	if (hProc != 0)
	{
		DllCall("GetProcessTimes", "Ptr", hProc, "Int64P", CreationTime, "Int64P", ExitTime, "Int64P", newKrnlTime, "Int64P", newUserTime)
		DllCall("CloseHandle", "Ptr", hProc)
	}
	
	nStep := A_PtrSize+16

	; Determine if PID is already in the buffer
	Loop, % nMemUsed/nStep
	{
		nPos := (A_Index-1)*nStep
		if (NumGet(pMemBuf+0, nPos,"Ptr") == PID)
		{
			oldKrnlTime := NumGet(pMemBuf+0, nPos+A_PtrSize,"Int64")
			oldUserTime := NumGet(pMemBuf+0, (nPos+A_PtrSize)+8,"Int64")
			
			NumPut(newKrnlTime,pMemBuf+0,nPos+A_PtrSize,"Int64")
			NumPut(newUserTime,pMemBuf+0,(nPos+A_PtrSize)+8,"Int64")
			
			ff := A_FormatFloat
			SetFormat, Float, 02.0
			ret := ((newKrnlTime-oldKrnlTime + newUserTime-oldUserTime)/10000000 * 100)
			SetFormat, Float, %ff%
			Return % ret
		}
	}

	if ((nMemUsed+(16+A_PtrSize)) >= nMemAllocated)
	{
		pMemBuf := DllCall("msvcrt\realloc", Ptr,pMemBuf,UInt,512*(16+A_PtrSize), "Cdecl Ptr" )
		if (!pMemBuf) ; Are we out of memory?
			ExitApp
		nMemAllocated+=512*(16+A_PtrSize)
	}
	
	NumPut(PID,pMemBuf+0,nMemUsed,"Ptr")
	NumPut(newKrnlTime,pMemBuf+0, nMemUsed+A_PtrSize,"Int64")
	NumPut(newUserTime,pMemBuf+0,(nMemUsed+A_PtrSize)+8,"Int64")
	
	nMemUsed+=(16+A_PtrSize)
	
	ff := A_FormatFloat
	SetFormat, Float, 02.0
	ret := 1.0-1
	SetFormat, Float, %ff%
	return % ret
}

; Get numbers of handles in use in a process.
GetProcessHandleCount(PID) {
	PROCESS_QUERY_INFORMATION:=0x400
	PROCESS_VM_READ := 0x0010
	
	; Get number of handles
	hProcess := DllCall( "OpenProcess", UInt,PROCESS_QUERY_INFORMATION|PROCESS_VM_READ,Int,0,Ptr,PID, Ptr )
	if (hProcess)
	{
		VarSetCapacity(pdwHandleCount,4,0)
		DllCall("GetProcessHandleCount", Ptr, hProcess, PtrP, pdwHandleCount)
		DllCall("CloseHandle", Ptr, hProcess)
		return % pdwHandleCount
	}
	return 0
}

; Get mem usage for a process (WorkingSet).
GetProcessMemoryInfo(PID) {
	size := 440
	VarSetCapacity(pmcex,size,0)
	ret := ""
	
	hProcess := DllCall( "OpenProcess", UInt,0x400|0x0010,Int,0,Ptr,PID, Ptr )
	if (hProcess)
	{
		if (DllCall("psapi.dll\GetProcessMemoryInfo", Ptr, hProcess, Ptr, &pmcex, UInt,size))
			ret := NumGet(pmcex, (A_PtrSize=8 ? "16" : "12"), "UInt")/1024 . " K"
		DllCall("CloseHandle", Ptr, hProcess)
	}
	return % ret
}

; Function by SKAN: http://www.autohotkey.com/forum/post-232445.html&sid=91c8f22903fcd01e6eef112a152efbf4#232445
GetProcessUserName(PID) {
	PROCESS_QUERY_INFORMATION := 0x400
	TOKEN_READ := 0x20008
	TokenUser := 0x1
	ret := ""
	test := 1
	
	hProcess := DllCall( "OpenProcess", UInt,PROCESS_QUERY_INFORMATION,Int,0,Ptr,PID, Ptr )
	if (hProcess)
	{
		VarSetCapacity(hToken, A_PtrSize, 0)
		if (DllCall("Advapi32.dll\OpenProcessToken", Ptr, hProcess, UInt, TOKEN_READ, PtrP, hToken) != 0)
		{
			VarSetCapacity(dwReturnLength,4,0)
			DllCall("Advapi32.dll\GetTokenInformation", Ptr, hToken, UInt, TokenUser, Ptr, 0, UInt, 0, Ptr, &dwReturnLength )
			VarSetCapacity(ti, NumGet(dwReturnLength, 0, "UInt"), 0)
			if (DllCall("Advapi32.dll\GetTokenInformation", Ptr, hToken, UInt, TokenUser, Ptr, &ti, UInt, NumGet(dwReturnLength, 0, "UInt"), Ptr, &dwReturnLength ) != 0)
			{
				pSid := NumGet(ti,0,"Ptr")
				VarSetCapacity(nSizeNM, 4, 0), VarSetCapacity(nSizeRD, 4, 0), VarSetCapacity(eUser, A_PtrSize, 0)
				DllCall("Advapi32\LookupAccountSidW", Str, "", Ptr, pSid, Ptr, 0, PtrP, nSizeNM, Ptr, 0, PtrP, nSizeRD, PtrP, eUser)
				VarSetCapacity(sName,NumGet(nSizeNM, 0, "UInt"),0), VarSetCapacity(sRDmn,NumGet(nSizeRD, 0, "UInt"),0)
				if (DllCall("Advapi32\LookupAccountSidW", Str, "", Ptr, pSid, Str, sName, PtrP, nSizeNM, Str, sRDmn, PtrP, nSizeRD, PtrP, eUser) != 0)
				{
					ret := sName
				}
			}
			DllCall("CloseHandle", Ptr, hToken)
		}
		DllCall("CloseHandle", Ptr, hProcess)
	}
	return ret
}

; Change numerical priority values to a string.
FormatPriority(p) {
	if (p>=24)
		return "Realtime"
	if (p>=13)
		return "High"
	if (p>=10)
		return "Above Normal"
	if (p>=8)
		return "Normal"
	if (p>=6)
		return "Below Normal"
	return "Low"
}

; Adjusts token privs for a process. 
SetPrivilege(PID=0,priv="SeDebugPrivilege"){
	PROCESS_QUERY_INFORMATION := 0x0400
	TOKEN_ADJUST_PRIVILEGES := 0x20
	SE_PRIVILEGE_ENABLED := 0x02
	ERROR_NOT_ALL_ASSIGNED := 1300
	hToken := 0

	if (PID == 0)
	{
		Process, Exist
		PID := ErrorLevel
	}
	
	hCurProcess := DllCall("OpenProcess", UInt, PROCESS_QUERY_INFORMATION, Int, 0, UInt, PID, Ptr)
	if (hCurProcess != 0)
	{
		if (DllCall("Advapi32.dll\OpenProcessToken", Ptr, hCurProcess, UInt, TOKEN_ADJUST_PRIVILEGES, PtrP, hToken) != 0)
		{
			VarSetCapacity(luid, 8, 0)
			if (DllCall("Advapi32.dll\LookupPrivilegeValueW", Ptr, 0, Str, priv, Int64P, luid) != 0)
			{
				VarSetCapacity(tp, 16, 0)
				NumPut(1, tp, 0, "UInt")
				NumPut(luid, tp, 4, "Int64")
				NumPut(SE_PRIVILEGE_ENABLED, tp, 12, "UInt")
				if (DllCall("Advapi32.dll\AdjustTokenPrivileges", Ptr, hToken, Int, 0, Ptr, &tp, UInt, 0, Ptr, 0, Ptr, 0) != 0)
				{
					if (A_LastError != ERROR_NOT_ALL_ASSIGNED)
					{
						ret := 0
					}
					else
						ret := "Requested privilege was not set."
				}
				else
					ret := "AdjustTokenPrivileges failed.`n`nErrorLevel: " . ErrorLevel . "`nA_LastError: " . A_LastError
			}
			else
				ret := "LookupPrivilegeValueW failed.`n`nErrorLevel: " . ErrorLevel . "`nA_LastError: " . A_LastError
			DllCall("CloseHandle", Ptr, hToken)
		}
		else
			ret := "OpenProcessToken failed.`n`nErrorLevel: " . ErrorLevel . "`nA_LastError: " . A_LastError
		DllCall("CloseHandle", Ptr, hCurProcess)
	}
	else
		ret := "OpenProcess failed.`n`nErrorLevel: " . ErrorLevel . "`nA_LastError: " . A_LastError 
	return % ret
}

GuiEscape:
GuiClose:
ExitApp

; Closing...
Exiting:
	
	if (hLibPsapi)
		DllCall("FreeLibrary", Ptr, hLibPsapi)
	if (pMemBuf)
		DllCall("msvcrt\free", Ptr, pMemBuf, Cdecl)
ExitApp

; Open the context menu only on right click
ShowMenu:
	Thread, NoTimers
	if (A_GuiEvent == "RightClick")
	{
		; Clear old checkmarks.
		Menu, SubMenu1, UnCheck, Low
		Menu, SubMenu1, UnCheck, Below Normal
		Menu, SubMenu1, UnCheck, Normal
		Menu, SubMenu1, UnCheck, Above Normal
		Menu, SubMenu1, UnCheck, High
		Menu, SubMenu1, UnCheck, Realtime
	
		LV_GetText(sr, LV_GetNext(0), 2)
		if (StrLen(GetModuleFileNameEx(sr)) <= 0) ; Can we get the path for this process?
			Menu, lvMenu, Disable, Open File Location
		else
			Menu, lvMenu, Enable, Open File Location
			
		LV_GetText(priority, LV_GetNext(0), 8)
		Menu, SubMenu1, Check, %priority%
		Menu, lvMenu, Show, %A_GuiX%, %A_GuiY%
	}
	Thread, NoTimers, false

Return

; Executes when Open File Location is selected from context menu.
LVMenuOpen:
	LV_GetText(sr, LV_GetNext(0), 2) ; Get the PID of the process
	szModFn := GetModuleFileNameEx(sr) ; Get filename + path of process
	if (SubStr(szModFn, 1, 11)=="\SystemRoot") ; Weed out the SystemRoot macro
		StringReplace, szModFn, szModFn, \SystemRoot, %A_WinDir%
	if (SubStr(szModFn,1,4)=="\??\") ; Weed out UNCs
		StringReplace, szModFn, szModFn, \??\
	cl = /n, /select, "%szModFn%" ; /n = new window... fixes bug on Windows XP if 2 files are in same dir
	DllCall("Shell32.dll\ShellExecuteW", Ptr, 0, Str, "open", Str, "explorer.exe", Str, cl, Str, "", Int, 1)
Return

; Executes when End Process is selected from context menu.
LVMenuEnd:
	LV_GetText(processId, LV_GetNext(0), 2)
	Run %PsExec% -s %taskkill% /F /PID %processId%,, hide
Return

; Executes when End Process Tree is selected from context menu.
LVMenuEndTree:
	LV_GetText(processId, LV_GetNext(0), 2)
	Run, %PsExec% -s %taskkill% /F /PID %processId% /T,, hide
Return

; Submenu: Set Priority handlers
MenuHandler:
	LV_GetText(processId, LV_GetNext(0), 2)
	Process, Priority, %processId%, % SubStr(A_ThisMenuItem,1,1)
return