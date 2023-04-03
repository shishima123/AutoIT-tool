#include <MsgBoxConstants.au3>
#include <ImageSearch.au3>
#include<GuiStatusBar.au3>
HotKeySet("{Space}", "thoat")
;Example()
;WinMove("KOPLAYER 1.4.1055","kaopu001_tiantianplayer_opengl_wndWindow",0,0,1088,640)

;GUISetOnEvent

#include <ColorConstants.au3>
#include <GUIConstantsEx.au3>
#include <GuiStatusBar.au3>
#include <WinAPITheme.au3>

Example()

Func Example()
    Local $hGUI, $hStatus
    Local $aParts[3] = [75, 150, -1]
    ; Create GUI
    $hGUI = GUICreate("StatusBar Set BkColor", 400, 300)
    $hStatus = _GUICtrlStatusBar_Create($hGUI)
    GUISetState(@SW_SHOW)

    ; to allow the setting of Bk Color at least under Windows 10
    _WinAPI_SetWindowTheme($hStatus, "", "")

    ; Set parts
    _GUICtrlStatusBar_SetParts($hStatus, $aParts)
    _GUICtrlStatusBar_SetText($hStatus, "Part 1")
    _GUICtrlStatusBar_SetText($hStatus, "Part 2", 1)
    _GUICtrlStatusBar_SetText($hStatus, "Part 3", 2)

    ; Set background color
    _GUICtrlStatusBar_SetBkColor($hStatus, $CLR_MONEYGREEN)

    ; Loop until the user exits.
    Do
    Until GUIGetMsg() = $GUI_EVENT_CLOSE
    GUIDelete()
EndFunc   ;==>Example








#cs
Func checkads()
	Local $x, $y
	$search4 = _ImageSearchArea("clickads.bmp", 1, 427, 490, 574, 592, $x, $y, 0)
	If $search4 = 1 Then
		ConsoleWrite("click ads" & @CRLF)
		;ControlClick("KOPLAYER 1.4.1055",0,0,"left",1,505, 514+30)
		ControlClick("KOPLAYER 1.4.1055", 0, 0, "left", 1, $x + 20, $y)
		Return 1
		;Sleep(31000)
		close_ads()
	Else
		Return 0
		ConsoleWrite("ko thay ads" & @CRLF)
	EndIf
EndFunc   ;==>checkads

Func close_ads() ;close ads
	;Sleep(30000)
	Local $x = 0, $y = 0
	Do
		$search5 = _ImageSearchArea("closeads.bmp", 1, 892, 42, 1029, 140, $x, $y, 0)
		If $search5 = 1 Then
			ConsoleWrite("close ads" & @CRLF)
			;ControlClick("KOPLAYER 1.4.1055",0,0,"left",1,$x,$y)
			;MsgBox(0,0,"tim thay nut tat")
		Else
			ConsoleWrite("dang tim nut tat ads" & @CRLF)
			;Sleep(5000)
			;ControlClick("KOPLAYER 1.4.1055",0,0,"left",1,991, 75)
		EndIf
		Sleep(100)
	Until $search5 = 1
EndFunc   ;==>close_ads

;Sleep(5000)
;Send("{ESC}")
For $i = 1 To 5
	ConsoleWrite($i & @CRLF)
	Sleep(1000)
Next

;Sleep(2000)
ControlSend("KOPLAYER 1.4.1055", 0, 0, "{ESC}")
ControlClick("KOPLAYER 1.4.1055", 0, 0, "left", 1, 386, 513 + 15)
;$a=checkads()
;MsgBox(0,0,$a)
;close_ads()
	while 1
	Local $x=0,$y=0
	Local $search3=_ImageSearchArea( "skill.bmp",1,205, 79, 395, 334,$x,$y,0)
	if $search3=1 then
	ConsoleWrite("thay battle"&@CRLF)
	MouseMove($x,$y+33)
	ControlClick("KOPLAYER 1.4.1055",0,0,"left",1,$x,$y)
	Else
	ConsoleWrite("ko tim thay battle"&@CRLF)
	EndIf
	WEnd
#ce

Func thoat()
	Exit
EndFunc   ;==>thoat


Func Example1()
	; Retrieve the position as well as height and width of the active window.
	Local $aPos = WinGetPos("KOPLAYER 1.4.1055")

	; Display the array values returned by WinGetPos.
	MsgBox($MB_SYSTEMMODAL, "", "X-Pos: " & $aPos[0] & @CRLF & _
			"Y-Pos: " & $aPos[1] & @CRLF & _
			"Width: " & $aPos[2] & @CRLF & _
			"Height: " & $aPos[3])
EndFunc   ;==>Example
