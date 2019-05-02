#include <ButtonConstants.au3>
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
#Region ### START Koda GUI section ### Form=
$Form1 = GUICreate("Form1", 253, 121, 382, 160)
GUISetFont(12, 400, 0, "Tahoma")
$Form1 = GUICreate("Form1", 235, 118, 375, 173)
$Label1 = GUICtrlCreateLabel("Nhấn F10 để tắt", 72, 24, 88, 17)
$Button1 = GUICtrlCreateButton("Bắt đầu", 72, 56, 75, 25)
GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###
Global $key=False
HotKeySet("{F10}","Exit_gui")
HotKeySet("{F9}","ban")
Global $b=0
AutoItSetOption("WinTitleMatchMode",2);chuyen ve mode 2 cua tittle
While 1
	$nMsg = GUIGetMsg()
	Switch $nMsg
		Case $GUI_EVENT_CLOSE
			Exit
		Case $Button1
			ban()
	EndSwitch
WEnd

Func Exit_gui()
	Exit
EndFunc
Func ban()
	do
	$mang1=PixelSearch(236, 433,397, 447,0x173D53)
	if IsArray($mang1) Then
		;Mouseclick("left",$mang1[0],$mang1[1])
		;Mousemove($mang1[0],$mang1[1])
		ControlClick("Game ben tau khung bo",'','',"left",1,$mang1[0],$mang1[1]+1)
	EndIf

	$mang2=PixelSearch(277, 362,323, 367,0x173D53)
	if IsArray($mang2) Then
		;MouseClick("left",$mang2[0]+7,$mang2[1])
		;MouseMove($mang2[0]+5,$mang2[1]+2)
		ControlClick("Game ben tau khung bo",'','',"left",1,$mang2[0]+7,$mang2[1])
	EndIf

	$mang3=PixelSearch(707, 414,716, 425,0x173D53)
	if IsArray($mang3) Then
		;MouseClick("left",$mang3[0],$mang3[1])
		;Mousemove($mang3[0],$mang3[1])
		ControlClick("Game ben tau khung bo",'','',"left",1,714,431)
	EndIf

	$mang4=PixelSearch(392, 272,692, 433,0x173D53)
	if IsArray($mang4) Then
		MouseClick("left",$mang4[0],$mang4[1]+1)
		;Mousemove($mang3[0],$mang3[1])
		;ControlClick("Game ben tau khung bo",'','',"left",1,$mang3[0],$mang3[1])
	EndIf
Until $b<>0
EndFunc

