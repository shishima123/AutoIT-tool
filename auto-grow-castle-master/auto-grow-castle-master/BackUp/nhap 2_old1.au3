#include <MsgBoxConstants.au3>
#include<ImageSearch.au3>
HotKeySet("{Space}","thoat")
;Example()
;WinMove("KOPLAYER 1.4.1055","kaopu001_tiantianplayer_opengl_wndWindow",0,0,1088,640)

Func checkads()
	local $x,$y
	$search4=_ImageSearchArea("clickads.bmp",1,427, 490,574, 592,$x,$y,0)
	if $search4=1 then
		ConsoleWrite("click ads"&@CRLF)
		;ControlClick("KOPLAYER 1.4.1055",0,0,"left",1,505, 514+30)
		ControlClick("KOPLAYER 1.4.1055",0,0,"left",1,$x+20,$y)
		Return 1
		;Sleep(31000)
		close_ads()
	Else
		Return 0
		ConsoleWrite("ko thay ads"&@CRLF)
	EndIf
EndFunc

Func close_ads();close ads
	;Sleep(30000)
	Local $x=0,$y=0
	Do
		$search5=_ImageSearchArea("closeads.bmp",1,892, 42,1029, 140,$x,$y,0)
		if $search5=1 then
			ConsoleWrite("close ads"&@CRLF)
			;ControlClick("KOPLAYER 1.4.1055",0,0,"left",1,$x,$y)
			;MsgBox(0,0,"tim thay nut tat")
		Else
			ConsoleWrite("dang tim nut tat ads"&@CRLF)
			;Sleep(5000)
			;ControlClick("KOPLAYER 1.4.1055",0,0,"left",1,991, 75)
		EndIf
		Sleep(100)
	Until $search5=1
EndFunc

			;Sleep(5000)
			;Send("{ESC}")
			for $i=1 to 5
				ConsoleWrite($i&@CRLF)
				Sleep(1000)
			Next

			;Sleep(2000)
			ControlSend("KOPLAYER 1.4.1055",0,0,"{ESC}")
			ControlClick("KOPLAYER 1.4.1055",0,0,"left",1,386, 513+15)
	;$a=checkads()
	;MsgBox(0,0,$a)
	;close_ads()
#cs
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
EndFunc

;1024, 600

Func Example()
    ; Retrieve the position as well as height and width of the active window.
    Local $aPos = WinGetPos("KOPLAYER 1.4.1055")

    ; Display the array values returned by WinGetPos.
    MsgBox($MB_SYSTEMMODAL, "", "X-Pos: " & $aPos[0] & @CRLF & _
            "Y-Pos: " & $aPos[1] & @CRLF & _
            "Width: " & $aPos[2] & @CRLF & _
            "Height: " & $aPos[3])
EndFunc   ;==>Example
