#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#SingleInstance,Force
#include JSON.ahk
#include functions.ahk
#include CLR.ahk

Global InfluencerSheetID = "1k6FgcpZQIokxPWmsUosNVSykSgK1zVaKfeYo-Ezk7wo"
Global clientid = "861097509237-m67osc1agpccvp5v7qqamaughhmun14e.apps.googleusercontent.com"
Global ClientSecret = "2nVg6scMtTIu4bmZty5jom22"
Global StatusSheetID = "1441O3sW-4tyKxGRXcYpFhC0kkpJIpmT1Q-i-ET1Tga0"

if FileExist( "settings.ini" ) 
{
    goto, WorksheetSettings
}

StartSettings:
{

Gui, 1:Add, GroupBox, xs y+20 w1005 h103 Section, SETUP INSTRUCTIONS
Gui, 1:Add, Link, xp+20 yp+30 w280 h80, Obtain Google Oauth credentials from <a href="https://console.developers.google.com">developer console</a>
;Gui, 1:Add, GroupBox, xs w1005 h103 Section, Your Instagram Accounts
;Gui, 1:Add, Edit, xs+20 yp+15 w280 h20 vigAccount
;Gui, 1:Add, Text, xp+110 yp w100 h20 , Influencer Task Hotkeys:
;Gui, 1:Add, DropDownList, xs+20 yp+15 w480 h20 vigAccount, @thomasthomas2211|@philhughesart|@noplacetosit|@blissmolecule
;Gui, 1:Add, DropDownList, xp+490 yp w100 h20 vInfluencerHotkey, F2|F3|F4|F5|F6|F7|F8|F9|F10|F11||F12

Gui, 1:Add, GroupBox, xs w498 h155 Section, SPREADSHEET KEYS
Gui, 1:Add, Text, xp+15 yp+30 w220 h20 , INFLUENCER SHEET KEY:
Gui, 1:Add, Edit, xp yp+20 w465 h20 vInfluencerSheetKey, 

Gui, 1:Add, Text, yp+30 w220 h20, STATUS SHEET KEY:
Gui, 1:Add, Edit, yp+20 w465 h20 vStatusSheetKey

;Gui, 1:Add, GroupBox, xs w498 h105 Section, 

Gui, 1:Add, GroupBox, ys w498 h325, GOOGLE OAUTH 2.0 ACCESS SETTINGS

Gui, 1:Add, Text, xp+20 yp+30 w210 h20, Client ID:
Gui, 1:Add, Edit, yp+20 w460 h20 vClientId, 

Gui, 1:Add, Text, yp+30 w230 h20 , Client Secret:
Gui, 1:Add, Edit, yp+20 w230 h20 vClientSecret, 


Gui, 1:Add, Button, yp+40 w460 h30 vGetAuthCodeBtn gGetAuthCode, Get Authorization Code
Gui, 1:Add, Text, yp+40 w400 h20 , (after copying Authorization code from popup window it should appear in this box)
Gui, 1:Add, Edit, yp+15 w460 h20 vAuthCode, 
Gui, 1:Add, Button, yp+40 w460 h30 vGetRefreshTokenBtn gGetRefreshToken, Request Refresh Token
Gui, 1:Add, Text, yp+40 w420 h20 , (after requesting Refresh token it should appear in this box)
Gui, 1:Add, Edit, yp+15 w460 h20 vRefreshToken +ReadOnly, 

Gui, 1:Add, text, xm w10 h10,
Gui, 1:Add, Button, xm w1030 h50 Center vSubmitBtn gCreateSettings, CREATE SETTINGS FILE AND GO TO WORKSHEETS SETTINGS
Gui, 1:Add, text, xm w10 h10,

GuiControl, 1:, InfluencerSheetKey, %InfluencerSheetId%
GuiControl, 1:, StatusSheetKey, %StatusSheetId%
GuiControl, 1:, ClientId, %clientId%
GuiControl, 1:, ClientSecret, %ClientSecret%

SetTimer, EnableButtonsSetup, 1
Gui, 1:Show, w1050 h580, Settings
GuiControl, 1:Disable, GetAuthCodeBtn
GuiControl, 1:Disable, GetRefreshTokenBtn
GuiControl, 1:Disable, SubmitBtn
return
}

GetAuthCode:
{
    gui_title := "Get Authorization Code"
    GuiControlGet, urlClientId,, ClientId
    authURL := "https://accounts.google.com/o/oauth2/auth?scope=https://spreadsheets.google.com/feeds&redirect_uri=urn:ietf:wg:oauth:2.0:oob&response_type=code&client_id=" urlClientId
    WEB := ComObjCreate("Shell.Explorer")
    WEB.Visible := true
    Gui +LastFound
    Gui, 2:Color, FFFFFF
    Gui, 2:Add, ActiveX, w800 h500 x5 y55 vWEB, Shell.Explorer
    WEB.Navigate(authURL)
    Gui,2:show, w810 h560 x5 y5, %gui_title%
    Gui2_ID := WinExist()
    GroupAdd, Auth_Gui, ahk_id %Gui2_ID%
    ;clipboard =  
    ;ClipWait
    ;GuiControl, 1:, AuthCode, %clipboard%
    If pwb !=
      ObjRelease(WEB)
    ;Gui, 2:destroy
    GuiControl, 1:+ReadOnly, ClientId
    GuiControl, 1:+ReadOnly, ClientSecret
    return
    #if WinActive(gui_title)
        ^c::
        send {AppsKey}c
        GuiControl, 1:, AuthCode, %clpbrd%
        If pwb !=
          ObjRelease(WEB)
        Gui, 2:destroy
        GuiControl, 1:+ReadOnly, ClientId
        GuiControl, 1:+ReadOnly, ClientSecret
    return
}

GetRefreshToken:
{
    GuiControlGet, urlClientId,, ClientId
    GuiControlGet, urlClientSecret,, ClientSecret
    GuiControlGet, urlAuthCode,, AuthCode
    rURL := "https://www.googleapis.com/oauth2/v3/token"
    rPostData := "code=" urlAuthCode "&client_id=" urlClientId "&client_secret=" urlClientSecret "&redirect_uri=urn:ietf:wg:oauth:2.0:oob&access_type=offline&grant_type=authorization_code"
    o2HTTP := ComObjCreate("WinHttp.WinHttpRequest.5.1")
    o2HTTP.Open("POST", rURL , False)
    o2HTTP.SetRequestHeader("User-Agent", "Mozilla/5.0 (compatible; MSIE 9.0; Windows NT 6.1; WOW64; Trident/5.0)")
    o2HTTP.SetRequestHeader("Content-Type", "application/x-www-form-urlencoded")
    o2HTTP.Send(rPostData)
    data2 := o2HTTP.ResponseText
	;msgbox % data2
    parsedRToken := JSON.Load(data2, true)
    parsedRefreshToken := parsedRToken.refresh_token
	;msgbox % parsedRefreshToken
    GuiControl, 1:, RefreshToken, %parsedRefreshToken%
    return
 }
 
CreateSettings: 
{
    Gui, Submit

    if FileExist( "settings.ini" ) 
    {
        FileDelete, settings.ini
    }
    if FileExist( "settings.dll" ) 
    {
        FileDelete, settings.dll
    }
    IniWrite, %InfluencerHotkey%, settings.ini, General, influencer_hotkey
    c# =
    (
        using System;
        class Settings {
            public string gcc(string argum="%ClientId%") {
                return argum;
            }
			public string gcs(string argum="%ClientSecret%") {
                return argum;
            }
            public string grt(string argum="%RefreshToken%") {
                return argum;
            }
			public string gis(string argum="%InfluencerSheetKey%") {
                return argum;
            }
			public string gss(string argum="%StatusSheetKey%") {
				return argum;
			}
        }
    )
    CLR_CompileC#(c#, "System.dll", 0, "settings.dll")
    /* 
    if FileExist("settings.ini") && FileExist("settings.dll")
    {
        goto, WorksheetSettings
    }
	 */
    ExitApp
    return
}

WorksheetSettings:
GoTo, StartSettings

EnableButtonsSetup:
{
    GuiControlGet, cid,, ClientId
    GuiControlGet, csec,, ClientSecret
    GuiControlGet, autc,, AuthCode
    GuiControlGet, reft,, RefreshToken
    ;GuiControlGet, oname,, igAccount
    ;GuiControlGet, ikey,, InfluencerSheetKey
	
    If (cid && csec)
        GuiControl, 1:Enable, GetAuthCodeBtn
    else
        GuiControl, 1:Disable, GetAuthCodeBtn
    
    If (cid && csec && autc)
    {
        GuiControl, 1:Enable, GetRefreshTokenBtn
        GuiControl, 1:Disable, GetAuthCodeBtn
    }
    else
    {
        GuiControl, 1:Disable, GetRefreshTokenBtn
    }
    
    If (cid && csec && autc && reft)
    {
        GuiControl, 1:Disable, GetRefreshTokenBtn
        GuiControl, 1:Disable, GetAuthCodeBtn
        GuiControl, 1:+ReadOnly, AuthCode
    }
    
    If cid && csec && reft
    {   
        GuiControl, 1:Enable, SubmitBtn
        SetTimer, EnableButtonsSetup, Off
    }
    else 
    {
        GuiControl, 1:Disable, SubmitBtn
    }
    
    return
}
