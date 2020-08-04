; AOL File Downloader. *VERY MUCH BETA*
; by slipstream and Kodi Arfer in 2014
; Needs AOL 9.7. (AOL 9.6 seems to work better at least in Windows 7.)
; Run AOL, sign in, close all windows, run this script, it'll start downloading to C:\AOLDLs.
; Sorry for the mess of this script.. a mix of used stuff and no longer used stuff from debugging and previous iterations..
; The script *will* screw up if it encounters something it can't handle..
;
; Script version 0.32
; Changelog:
; 0.32 - fixes issues with info.txt files not being written because of file-name mangling
; 0.31 - fixes an issue with clicking the List More Files button. Also adds a sleep() to fix 100% cpu usage.
; 0.3 - now clicks the "List More Files" button until it greys out, so we can get everything.
; 0.2 - fixed some more things, now it handles file-exists and download-failure, it's all completely automated now! the only way this script will screw up, is on connection failure, or AOL client crash..

Func seq($start, $end)
    Local $ary[$end - $start + 1]
	for $i = 0 to $end - $start
		$ary[$i] = $i + $start
	Next
	return $ary
EndFunc

; Area numbers to scrape
$areas = seq(5045, 5100)
; Local $areas[] = [1, 2, 3]

Const $info_files_only = True

Const $sleep_ms = 250

#include <GuiListView.au3>
#include <GuiListBox.au3>
#include <ListBoxConstants.au3>
#include <Array.au3>
#include <Constants.au3>
;#include <StringConstants.au3>
#include <WinAPI.au3>
#include <SendMessage.au3>
Const $PROCESS_READ = 0x10
Const $RIGHTS_REQUIRED = 0xF0000

Func AOLList_GetCount($hwnd)
	return _SendMessage($hwnd,$LB_GETCOUNT,0,0)
EndFunc

Func AOLList_Select($hwnd,$index)
	return _SendMessage($hwnd,$index,0)
EndFunc

Func AOLList_GetText($hwnd,$index)
	Global $hProcess
	$memptr = _SendMessage($hwnd,$LB_GETITEMDATA,$index,0)
	$memptr += 28
	$struct1 = DllStructCreate("long pointer;")
	$rBytes = 0
	_WinAPI_ReadProcessMemory($hProcess,$memptr,DllStructGetPtr($struct1,"pointer"),4,$rBytes)
	$struct2 = DllStructCreate("char string[2048];") ; we shouldn't need this much ram but just in case!
	_WinAPI_ReadProcessMemory($hProcess,DllStructGetData($struct1,"pointer")+6,DllStructGetPtr($struct2,"string"),2048,$rbytes)
	return DllStructGetData($struct2,"string")
EndFunc

Func MakeValidFilename($fn)
	$fn = StringReplace($fn,"\","_")
	$fn = StringReplace($fn,"/","_")
	$fn = StringReplace($fn,":","_")
	$fn = StringReplace($fn,"*","_")
	$fn = StringReplace($fn,"?","_")
	$fn = StringReplace($fn,'"',"_")
	$fn = StringReplace($fn,"<","_")
	$fn = StringReplace($fn,">","_")
	$fn = StringReplace($fn,"|","_")
    $fn = StringRegExpReplace($fn, "[. ]+\z", "")
	Return $fn
EndFunc

Func WinGetFirstChild($hwnd,$class)
	; loops the list of child windows, returns the hwnd of the first with specified class name or class names, if not found return 0
	if not IsArray($class) then
		Local $class2[1] = [$class]
		$class = $class2
	EndIf

	$hChild = _WinAPI_GetWindow($hwnd,$GW_CHILD)
	While $hChild
		$childClass = _WinAPI_GetClassName($hChild)
		for $wanted in $class
			if $wanted = $childClass then return $hChild
		Next
		$result = WinGetFirstChild($hChild,$class)
		if not $result = 0 then return $result
		$hChild = _WinAPI_GetWindow($hChild,$GW_HWNDNEXT)
	WEnd

	return 0
EndFunc

Func WinListChildren($hWnd, ByRef $avArr)
    If UBound($avArr, 0) <> 2 Then
        Local $avTmp[10][3] = [[0]]
        $avArr = $avTmp
    EndIf

    Local $hChild = _WinAPI_GetWindow($hWnd, $GW_CHILD)

    While $hChild
        If $avArr[0][0]+1 > UBound($avArr, 1)-1 Then ReDim $avArr[$avArr[0][0]+10][3]
        $avArr[$afvArr[0][0]+1][0] = $hChild
        $avArr[$avArr[0][0]+1][1] = _WinAPI_GetWindowText($hChild)
		$avArr[$avArr[0][0]+1][2] = _WinAPI_GetClassName($hChild)
        $avArr[0][0] += 1
        WinListChildren($hChild, $avArr)
        $hChild = _WinAPI_GetWindow($hChild, $GW_HWNDNEXT)
    WEnd

    ReDim $avArr[$avArr[0][0]+1][3]
EndFunc

$hwnd = WinGetHandle("America  Online")
if $hwnd = 0 then $hwnd = WinGetHandle("AOL")
$pid = 0
$tid = _WinAPI_GetWindowThreadProcessId($hwnd,$pid)
$hProcess = _WinAPI_OpenProcess(BitOr($PROCESS_READ,$RIGHTS_REQUIRED),0,$pid)
if not $hProcess then Exit
for $area in $areas
    ConsoleWrite("Opening area " & $area & @CRLF)

    ; Kill everything that will be a nuisance to us
    while True
    	$hwnd2 = ControlGetHandle($hwnd,"","[REGEXPCLASS:(?i)(_AOL_Modal|AOL Child)]")
    	if $hwnd2 = 0 then ExitLoop
    	$title = WinGetTitle($hwnd2)
    	WinKill($hwnd2)
    	if WinExists($hwnd2) then WinClose($hwnd2)
    	if WinExists($hwnd2) then WinSetState($hwnd2,"",@SW_SHOW)
    	if WInExists($hwnd2) then ExitLoop
    WEnd

    ControlFocus($hwnd,"","[CLASS:_AOL_Edit; INSTANCE:1]")
    ; aol://4400:

    #cs
    If we get a list of downloads:
    Advanced (Class):	[CLASS:AOL Child; INSTANCE:1]
    ID:	31746
    Text:	Guild of Heroes WAV Files

    List of errors:

    >>>> Window <<<<
    Title:
    Class:	_AOL_Modal

    Advanced (Class):	[CLASS:_AOL_Static; INSTANCE:1]
    ID:
    Text:	Sorry, but you do not have access to this library/file.

    Class:	_AOL_Icon
    Instance:	1
    ClassnameNN:	_AOL_Icon1
    Name:
    Advanced (Class):	[CLASS:_AOL_Icon; INSTANCE:1]
    ID:

    No released files [with upload]:
    ClassnameNN:	AOL Child1
    Name:
    Advanced (Class):	[CLASS:AOL Child; INSTANCE:1]

    ; 2nd button;
    Class:	_AOL_Icon
    Instance:	2
    ClassnameNN:	_AOL_Icon2
    Name:
    Advanced (Class):	[CLASS:_AOL_Icon; INSTANCE:2]

    ; Only one button [no upload]
    Name:
    Advanced (Class):	[CLASS:AOL Child; INSTANCE:1]

    ClassnameNN:	_AOL_Icon2
    Name:
    Advanced (Class):	[CLASS:_AOL_Icon; INSTANCE:2]
    #ce

    ; so.. based on this info.. let's try this:

    ; Plug the area URL into the address bar
    while ControlGetText($hwnd,"","[CLASS:_AOL_Edit; INSTANCE:1]") <> "aol://4400:" & $area
    	ControlSetText($hwnd,"","[CLASS:_AOL_Edit; INSTANCE:1]","")
    	ControlSend($hwnd,"","[CLASS:_AOL_Edit; INSTANCE:1]","aol://4400:"&$area&"{DELETE}")
    WEnd
    ControlSend($hwnd,"","[CLASS:_AOL_Edit; INSTANCE:1]","{ENTER}")

    ;Sleep(1000)
    ;Global $test
    ;WinListChildren($hwnd,$test)
    ;_ArrayDisplay($test)
    ;Exit
    ;Sleep(1000)

    while True
    	$hwnd2 = WinGetHandle("[CLASS:_AOL_Modal]")
    	if $hwnd2 = 0 then $hwnd2 = WinGetFirstChild($hwnd,"AOL Child")
    	if ($hwnd2 = 0) or (StringInStr(WinGetTitle($hwnd2),"Welcome, ")) or (StringInStr(WinGetTitle($hwnd2),"AOL Channels")) Then
    		Sleep($sleep_ms)
    	else
    		ExitLoop
    	EndIf
	 WEnd

    $title = WinGetTitle($hwnd2)
    if $title == "" Then
    	; this is an _AOL_Modal?
		; At any rate, it doesn't seem to be a download window.
		; Move on to the next area.
    	WinKill($hwnd2)
		ContinueLoop
    EndIf

    $ctrl = ControlGetText($hwnd2,"","[CLASS:_AOL_Static; INSTANCE:1]")
	if StringInStr($ctrl,"There are no released files.") then
		WinKill($hwnd2)
		ContinueLoop
	EndIf

	; Get the list of downloads.
	$hListBox = ControlGetHandle($hwnd2,"","[CLASS:_AOL_Listbox; INSTANCE:1]")
	if $hListBox = 0 then
		WinKill($hwnd2)
		ContinueLoop
	EndIf

	; Wait for the list to be populated.
	while AOLList_GetCount($hListBox) = 0
		sleep($sleep_ms)
	WEnd

	$title = StringStripWS(WinGetTitle($hwnd2),3)

	; Mash the "List More Files" button until we can no more.
	$hListMore = ControlGetHandle($hwnd2,"","[CLASS:_AOL_Icon; INSTANCE:5]")
	while BitAnd(WinGetState($hListMore),4)
		ControlSend($hListMore,"","","{ENTER}")
		sleep($sleep_ms)
	WEnd

	for $dlnumber = 1 to AOLList_GetCount($hListBox)
        ControlSend($hListBox,"","","{ENTER}")

    	; Wait for the second child.
    	$fail = False
    	while True
    		$hwnd3 = WinGetFirstChild($hwnd,"AOL Child")
    		if $hwnd3 = $hwnd2 then
    			Sleep($sleep_ms)
    			$hwnd3 = WinGetHandle("[CLASS:_AOL_Modal]")
    			if not $hwnd3 = 0 Then
    				$fail = True
    				ExitLoop
    			EndIf
    		Else
    			ExitLoop
    		EndIf
    	WEnd
    	if $fail Then
    		WinKill($hwnd3)
    		ControlSend($hListBox,"","","{DOWN}")
    		WinActivate($hwnd2)
    		ContinueLoop
    	EndIf

    	While True
    		$ctrl = ControlGetText($hwnd3,"","[CLASS:_AOL_View; INSTANCE:1]")
    		if $ctrl = "" then
    			Sleep($sleep_ms)
    		Else
    			ExitLoop
    		EndIf
    	WEnd

        ; Create necessary directories and the info.txt.
	    ; If an info.txt already exists, WriteFile will
	    ; append to it.
        if not FileExists("C:\AOLDLs\"&MakeValidFilename($title)) then
    		DirCreate("C:\AOLDLs\"&MakeValidFilename($title))
    		FileWrite("C:\AOLDLs\"&MakeValidFilename($title)&"\url.txt","aol://4400:"&$area)
    	EndIf
    	$subj = StringSplit($ctrl,@CRLF,3)
    	$subj = StringStripWS(StringTrimLeft($subj[0],8),3)
    	if not FileExists("C:\AOLDLs\"&MakeValidFilename($title)&"\"&MakeValidFilename($subj)) then DirCreate("C:\AOLDLs\"&MakeValidFilename($title)&"\"&MakeValidFilename($subj))
    	$infopath = "C:\AOLDLs\"&MakeValidFilename($title)&"\"&MakeValidFilename($subj)&"\info.txt"
        if not FileWrite($infopath, $ctrl) then
            ConsoleWrite("Writing " & $infopath & " failed" & @CRLF)
        EndIf

        if $info_files_only then
	        WinKill($hwnd3)
            ControlSend($hListBox,"","","{DOWN}")
            WinActivate($hwnd2)
		    ContinueLoop
        EndIf

        ; Now try downloading the file.
    	ControlEnable($hwnd3,"Download Now","[CLASS:_AOL_Icon]")
    	$fail = False
    	for $count = 1 to 10
    		WinActivate($hwnd3)
    		ControlSend($hwnd3,"","","{ENTER}")
    		$hwnd4 = WinWait("Download Manager","",1)
    		if not $hwnd4 = 0 then ExitLoop
    		if $count = 10 then $fail = True
    	Next
    	if $fail Then
    		WinKill($hwnd3)
    		ControlSend($hListBox,"","","{DOWN}")
    		while True
    			$hwndkill = ControlGetHandle($hwnd,"","[REGEXPCLASS:(?i)(_AOL_Modal|AOL Child)]")
    			if $hwndkill = 0 then ExitLoop
    			$titlekill = WinGetTitle($hwndkill)
    			if $titlekill = WinGetTitle($hwnd2) then ExitLoop
    			WinKill($hwndkill)
    			if WinExists($hwndkill) then WinClose($hwndkill)
    			if WinExists($hwndkill) then WinSetState($hwndkill,"",@SW_SHOW)
    			if WInExists($hwndkill) then ExitLoop
    		WEnd
    		WinActivate($hwnd2)
    		ContinueLoop
    	EndIf

    	if StringInStr(ControlGetText($hwnd4,"","[CLASS:_AOL_Static]"),"You have already downloaded this file") Then
    		WinKill($hwnd4)
    		WinKill($hwnd3)
    		ControlSend($hListBox,"","","{DOWN}")
    		while True
    			$hwndkill = ControlGetHandle($hwnd,"","[REGEXPCLASS:(?i)(_AOL_Modal|AOL Child)]")
    			if $hwndkill = 0 then ExitLoop
    			$titlekill = WinGetTitle($hwndkill)
    			if $titlekill = WinGetTitle($hwnd2) then ExitLoop
    			WinKill($hwndkill)
    			if WinExists($hwndkill) then WinClose($hwndkill)
    			if WinExists($hwndkill) then WinSetState($hwndkill,"",@SW_SHOW)
    			if WInExists($hwndkill) then ExitLoop
    		WEnd
    		WinActivate($hwnd2)
    		ContinueLoop
    	EndIf

        ; We should have a Save As box now. Set the right filename
        ; and hit Enter.
    	$hEdit = ControlGetHandle($hwnd4,"","[CLASS:Edit; INSTANCE:1]")
    	$filename = ControlGetText($hEdit,"","")
    	ControlSetText($hEdit,"","","C:\AOLDLs\"&MakeValidFilename($title)&"\"&MakeValidFilename($subj))
    	ControlSend($hEdit,"","","{ENTER}")
    	$it = 2
    	$oldfilename = $filename
    	while FileExists("C:\AOLDLs\"&MakeValidFilename($title)&"\"&MakeValidFilename($subj)&"\"&$filename)
    		$filename = $it&"_"&$oldfilename ; too lazy to do anything else
    		$it += 1
    	WEnd
    	ControlSetText($hEdit,"","",$filename)
    	ControlSend($hEdit,"","","{ENTER}")

    	while True
    		$hwnd5 = WinGetFirstChild($hwnd,"AOL Child")
    		if StringInStr(WinGetTitle($hwnd5),"File Transfer -") Then
    			while not WinWaitClose($hwnd5,"",1)
    				if winexists("Download Manager") Then
    					winkill("Download Manager")
    				EndIf
    			WEnd
    			ExitLoop
    		EndIf
    		if stringinstr(wingettitle($hwnd5),"Download Confirmation - ") Then
    			ExitLoop
    		EndIf
    	WEnd
    	;$hwnd5 = WinWait("Download Confirmation")
    	;ControlSend($hwnd5,"","","{ENTER}")
    	WinKill($hwnd3)
    	ControlSend($hListBox,"","","{DOWN}")
    	while True
    		$hwndkill = ControlGetHandle($hwnd,"","[REGEXPCLASS:(?i)(_AOL_Modal|AOL Child)]")
    		if $hwndkill = 0 then ExitLoop
    		$titlekill = WinGetTitle($hwndkill)
    		if $titlekill = WinGetTitle($hwnd2) then ExitLoop
    		WinKill($hwndkill)
    		if WinExists($hwndkill) then WinClose($hwndkill)
    		if WinExists($hwndkill) then WinSetState($hwndkill,"",@SW_SHOW)
    		if WInExists($hwndkill) then ExitLoop
    	WEnd
    	WinActivate($hwnd2)
    Next
Next