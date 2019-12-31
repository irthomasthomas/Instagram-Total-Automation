﻿/* 
Plugin        : Input [Standard Lintalist]
Purpose       : Ask for user Input using a simple InputBox
Version       : 1.3

History:
- 1.3 Incorporate CancelPlugin (avoids SoundPlay and return nicely)
- 1.2 Allow for cancel via ESC and via close button (x) in Gui
- 1.1 Modified for improvement of nested snippets in Lintalist v1.6
- 1.0 first version
*/

GetSnippetInput:
Loop ; get user input with optional default response
	{
	 If (InStr(Clip, "[[Input=") = 0) or (A_Index > 100) or (PluginOptions = "")
		Break
	 InputBox, PluginSnippetInput, % StrSplit(PluginOptions,"|").1, % StrSplit(PluginOptions,"|").1, , 400, 150, , , , , % StrSplit(PluginOptions,"|").2
	 If !ErrorLevel
		{
		 StringReplace, clip, clip, %PluginText%, %PluginSnippetInput%, All
		}
	 else
		{
		 clip:=""
		 CancelPlugin:=1
		}

	 PluginSnippetInput:=""
	 PluginOptions:=""
	 PluginText:=""
	 ProcessTextString:=""

	 }
Return
