#include <ImageSearch.au3>
;#include <Array.au3>
#RequireAdmin

HotKeySet("{Space}","thoat")
HotKeySet("{F1}","di_ai")
HotKeySet("{F2}","click_quang_cao")
;Start_KoPlayer()
;For $i=0 to 30
;	ConsoleWrite($i&@CRLF)
;	Sleep(1000)
;Next
;click_quang_cao()


#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
#Region ### START Koda GUI section ### Form=
$Form1 = GUICreate("Auto Grow Castle", 383, 179, 192, 124)
GUISetFont(12, 400, 0, "Tahoma")
$Label1 = GUICtrlCreateLabel("Bấm F1 để đi ải", 16, 40, 114, 23)
$Label2 = GUICtrlCreateLabel("Bấm F2 để click quảng cáo", 176, 40, 192, 23)
$Label3 = GUICtrlCreateLabel("Bấm Space để thoát", 80, 112, 142, 23)
GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###

While 1
	$nMsg = GUIGetMsg()
	Switch $nMsg
		Case $GUI_EVENT_CLOSE
			Exit

	EndSwitch
WEnd


Func di_ai()
While 1
	check_toa_do_cua_so()
	Sleep(1000)
	$b=check_home()
	Sleep(1000)
	if $b=1 Then
		$checkads=click_ads();kiem tra xem co ads ko
		if $checkads=1 Then close_ads()
		Sleep(1000)
		Click_battle();vao tran
		Sleep(1000)
		Speed()
		Sleep(1000)
		skill()
		Sleep(1000)
	Else
		Start_game()
		Sleep(1000)
	EndIf
WEnd
EndFunc

Func click_quang_cao()
While 1
	check_toa_do_cua_so()
	$b=check_home()
	Sleep(1000)
	if $b=1 Then
		;click_ads()
		Click_battle();vao tran
		Sleep(2000)
		Speed()
		Sleep(2000)
		skill()
		Sleep(2000)
		$checkads=click_ads();kiem tra xem co ads ko
		Sleep(2000)
		if $checkads=1 Then
			close_ads()
			sleep(1000)
			ControlSend("KOPLAYER 1.4.1055",0,0,"{ESC}")
			Sleep(2000)
			ControlClick("KOPLAYER 1.4.1055",0,0,"left",1,386, 513+15)
		EndIf
	Else
		Start_game()
		Sleep(1000)
	EndIf
WEnd
EndFunc


Func Start_KoPlayer()
	;viet lenh kiem tra xem koplayer da chay chua
ShellExecute("D:\KOPLAYER\Lancher.exe",@SW_MAXIMIZE)
ConsoleWrite("Doi 10s"&@CRLF)
;sleep(10000)
EndFunc

Func Start_game()
do
Local $x=0,$y=0
Local $search=_ImageSearch("checkloadgame.bmp",1,$x,$y,0)
ConsoleWrite("dang check"&@CRLF)
if $search=1 Then
	ConsoleWrite("Game chua mo"&@CRLF)
	;ControlClick("KOPLAYER 1.4.1055",0,0,"left",1,252, 323)
	ControlClick("KOPLAYER 1.4.1055",0,0,"left",1,$x,$y)
	ConsoleWrite("Click vao icon game"&@CRLF)
	Sleep(15000)
Else
	local $a=check_home()
	if $a=1 Then
	ConsoleWrite("Da vao game"&@CRLF)
	ExitLoop
	EndIf
	Sleep(2000)
EndIf
Until $search=1
Sleep(10)
EndFunc

Func check_home()
	Local $x=0,$y=0
	Local $search6=_ImageSearchArea("home.bmp",1,76, 83,186, 143,$x,$y,0)
	if $search6=1 then
		ConsoleWrite("Da vao man hinh home"&@CRLF)
		Return 1
	Else
		ConsoleWrite("Chua vao man hinh home"&@CRLF)
		Return 0
	EndIf
	Sleep(10)
EndFunc

Func Click_battle()
	Local $x=0,$y=0
	Local $search2=_ImageSearchArea("battle.bmp",1,868, 577,1011, 628,$x,$y,0)
	if $search2=1 then
		ConsoleWrite("thay battle,click vao battle"&@CRLF)
		;ControlClick("KOPLAYER 1.4.1055",0,0,"left",1,937, 554)
		ControlClick("KOPLAYER 1.4.1055",0,0,"left",1,$x,$y)
		Sleep(1000)
		;ControlClick("KOPLAYER 1.4.1055",0,0,"left",1,713, 196+15)
		ControlClick("KOPLAYER 1.4.1055",0,0,"left",1,$x,$y)
	Else
		ConsoleWrite("ko thay battle"&@CRLF)
	EndIf
	Sleep(10)
EndFunc

Func skill()
	While 1
	Local $x=0,$y=0
	Local $a=0,$b=0
	Local $search3=_ImageSearchArea( "skill.bmp",1,205, 79, 395, 334,$x,$y,0)
	Sleep(100)
	if $search3=1 then
		ConsoleWrite("dung skill"&@CRLF)
		Sleep(100)
		ControlClick("KOPLAYER 1.4.1055",0,0,"left",1,$x,$y)
		Sleep(100)
		ConsoleWrite("chua xong tran"&@CRLF)
		Sleep(100)
		Local $search7=_ImageSearch("battle.bmp",1,$a,$b,0)
		Sleep(100)
		if $search7=1 then ExitLoop
	EndIf
	Sleep(100)
	WEnd
EndFunc

Func click_ads()
	local $x,$y
	$search4=_ImageSearchArea("clickads.bmp",1,427, 490,574, 592,$x,$y,0)
	if $search4=1 then
		ConsoleWrite("click ads"&@CRLF)
		;ControlClick("KOPLAYER 1.4.1055",0,0,"left",1,505, 514+30)
		ControlClick("KOPLAYER 1.4.1055",0,0,"left",1,$x+20,$y)
		Return 1
		Sleep(31000)
	Else
		;Return 0
		ConsoleWrite("ko thay ads"&@CRLF)
	EndIf
	Sleep(10)
EndFunc


Func close_ads();close ads
	;Sleep(30000)
	Local $x=0,$y=0
	Do
		$search5=_ImageSearchArea("closeads.bmp",1,892, 42,1029, 140,$x,$y,0)
		if $search5=1 then
			ConsoleWrite("close ads"&@CRLF)
			ControlClick("KOPLAYER 1.4.1055",0,0,"left",1,$x,$y)
		;Else
			;ConsoleWrite("ko tim thay ads"&@CRLF)
			;Sleep(5000)
			;ControlClick("KOPLAYER 1.4.1055",0,0,"left",1,991, 75)
		EndIf
		Sleep(10)
	Until $search5=1
EndFunc

Func Speed()
Local $x=0,$y=0
	$search6=_ImageSearchArea("speed.bmp",1,10, 596,77, 633,$x,$y,0)
	if $search6=1 then
		ConsoleWrite("speed x1,chuyen qua x2"&@CRLF)
		ControlClick("KOPLAYER 1.4.1055",0,0,"left",1,50, 553+20)
	EndIf
	Sleep(10)
EndFunc

Func check_toa_do_cua_so()
	Local $aPos = WinGetPos("KOPLAYER 1.4.1055")
	If $aPos[0]<>0 and $aPos[1]<>0 Then
	ConsoleWrite("vi tri cua so ko dung"&@CRLF)
		WinMove("KOPLAYER 1.4.1055","kaopu001_tiantianplayer_opengl_wndWindow",0,0,1088,640)
	ConsoleWrite("da chinh lai vi tri moi"&@CRLF)
Else
	ConsoleWrite("vi tri da chinh"&@CRLF)
EndIf
EndFunc


Func thoat()
	Exit
	Sleep(10)
EndFunc















