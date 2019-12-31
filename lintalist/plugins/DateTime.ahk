﻿/* 
Plugin        : DateTime [Standard Lintalist]
Purpose       : Insert date and or time, including options for date & time calculations e.g. tomorrows date
Version       : 1.2

History:
- 1.2 Added date Locale Identifiers (LCID) v1.8 ht dbielz https://github.com/lintalist/lintalist/issues/58 
- 1.1 Modified for improvement of nested snippets in Lintalist v1.6
- 1.0 first version
*/


GetSnippetDateTime:
 	 Loop ; get Date & Time [[DateTime=yy mm dd|2|days|LCID]]
		{
		 If (InStr(Clip, "[[DateTime=") = 0) or (A_Index > 100)
			Break
		 
		 If (InStr(PluginOptions,"|"))
			{
			 FormatTime, DT,, yyyyMMddHHmmss
			 EnvAdd, DT, % StrSplit(PluginOptions,"|").2, % StrSplit(PluginOptions,"|").3
			 DTLocale:=StrSplit(PluginOptions,"|").4
			 FormatTime, DT, %DT% %DTLocale%, % StrSplit(PluginOptions,"|").1
			}
		 Else
			FormatTime, DT,, %PluginOptions%
		 StringReplace, clip, clip, %PluginText%, %DT%, All
		 DT:=""
		 DTLocale:=""
		 PluginOptions:=""
		 PluginText:=""
		 ProcessTextString:=""

	  } 
Return