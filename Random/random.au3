#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Icon=random.ico
#AutoIt3Wrapper_Res_Fileversion=0.0.0.5
#AutoIt3Wrapper_Res_Fileversion_AutoIncrement=y
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#include <ButtonConstants.au3>
#include <ComboConstants.au3>
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
#include <GUIonchangeRegister.au3>
#Region ### START Koda GUI section ### Form=
$Form1_1 = GUICreate("Tool Random", 545, 458, 280, 119)
$Group1 = GUICtrlCreateGroup("Random Code", 16, 8, 505, 201)
GUICtrlCreateLabel("Prefix:", 24, 40, 47, 24)
GUICtrlSetFont(-1, 12, 400, 0, "MS Sans Serif")
$strPrefixCd = GUICtrlCreateEdit("", 88, 40, 201, 21, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER))
GUICtrlonchangeRegister(-1, "Cal_Len", "42|53")
GUICtrlSetTip(-1, "Prefix Characters")
$strCdFr = GUICtrlCreateInput("000", 88, 80, 81, 21, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER))
GUICtrlSetTip(-1, "From")
$strCdTo = GUICtrlCreateInput("100", 200, 80, 89, 21, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER))
GUICtrlSetTip(-1, "To")
GUICtrlCreateLabel("~", 176, 80, 14, 40, BitOR($SS_CENTER, $SS_CENTERIMAGE))
GUICtrlSetFont(-1, 23, 400, 0, "MS Sans Serif")
$btnGenCd = GUICtrlCreateButton("GENERATE", 136, 160, 75, 25)
$listCd = GUICtrlCreateEdit("", 368, 32, 137, 161, BitOR($GUI_SS_DEFAULT_EDIT, $ES_CENTER, $ES_UPPERCASE))
GUICtrlSetData(-1, "")
$strQtyCd = GUICtrlCreateInput("10", 256, 120, 33, 21, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER))
$lblQtyCd = GUICtrlCreateLabel("QTY:", 200, 120, 47, 24)
GUICtrlSetFont(-1, 12, 400, 0, "MS Sans Serif")
$type = GUICtrlCreateCombo("Random", 88, 120, 81, 25, BitOR($CBS_DROPDOWN, $CBS_AUTOHSCROLL))
GUICtrlSetData(-1, "Order")
GUICtrlCreateLabel("Type", 24, 120, 47, 24)
GUICtrlSetFont(-1, 12, 400, 0, "MS Sans Serif")
$strLen = GUICtrlCreateLabel("LEN: 3", 296, 40, 71, 24)
GUICtrlSetFont(-1, 12, 400, 0, "MS Sans Serif")
GUICtrlCreateLabel("From-To", 24, 80, 63, 24)
GUICtrlSetFont(-1, 12, 400, 0, "MS Sans Serif")
GUICtrlCreateGroup("", -99, -99, 1, 1)
$Group2 = GUICtrlCreateGroup("Random YMD", 16, 216, 505, 217)
$lblYear = GUICtrlCreateLabel("Year", 32, 256, 38, 24)
GUICtrlSetFont(-1, 12, 400, 0, "MS Sans Serif")
$strYearFr = GUICtrlCreateInput("2019", 96, 256, 57, 21, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER))
GUICtrlSetTip(-1, "From")
$strYearTo = GUICtrlCreateInput("2019", 184, 256, 57, 21, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER))
GUICtrlSetTip(-1, "To")
GUICtrlCreateLabel("~", 160, 296, 14, 40, BitOR($SS_CENTER, $SS_CENTERIMAGE))
GUICtrlSetFont(-1, 23, 400, 0, "MS Sans Serif")
$btnGenYMD = GUICtrlCreateButton("GENERATE", 120, 376, 91, 25)
$listYMD = GUICtrlCreateEdit("", 368, 248, 137, 161, BitOR($GUI_SS_DEFAULT_EDIT, $ES_CENTER, $ES_UPPERCASE))
GUICtrlSetData(-1, "")
$strMonthFr = GUICtrlCreateInput("1", 96, 296, 57, 21, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER))
GUICtrlSetTip(-1, "From")
$strMonthTo = GUICtrlCreateInput("12", 184, 296, 57, 21, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER))
GUICtrlSetTip(-1, "To")
GUICtrlCreateLabel("~", 160, 256, 14, 40, BitOR($SS_CENTER, $SS_CENTERIMAGE))
GUICtrlSetFont(-1, 23, 400, 0, "MS Sans Serif")
$strDayFr = GUICtrlCreateInput("1", 96, 336, 57, 21, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER))
GUICtrlSetTip(-1, "From")
$strDayTo = GUICtrlCreateInput("30", 184, 336, 57, 21, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER))
GUICtrlSetTip(-1, "To")
GUICtrlCreateLabel("~", 160, 336, 14, 40, BitOR($SS_CENTER, $SS_CENTERIMAGE))
GUICtrlSetFont(-1, 23, 400, 0, "MS Sans Serif")
$lblMonth = GUICtrlCreateLabel("Month", 32, 296, 49, 24)
GUICtrlSetFont(-1, 12, 400, 0, "MS Sans Serif")
$lblDay = GUICtrlCreateLabel("Day", 32, 336, 32, 24)
GUICtrlSetFont(-1, 12, 400, 0, "MS Sans Serif")
$strQtyYmd = GUICtrlCreateInput("10", 280, 296, 33, 21, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER))
GUICtrlSetTip(-1, "From")
$lbl1 = GUICtrlCreateLabel("QTY:", 280, 256, 32, 24)
GUICtrlSetFont(-1, 12, 400, 0, "MS Sans Serif")
GUICtrlCreateGroup("", -99, -99, 1, 1)
GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###
While 1
	$nMsg = GUIGetMsg()
	Switch $nMsg
		Case $GUI_EVENT_CLOSE
			Exit
		Case $btnGenCd
			Random_Cd()
		Case $btnGenYMD
			Random_YMD()
		Case $type
			onChangeType()
	EndSwitch
WEnd

Func Random_Cd()
	Local $txtPre = GUICtrlRead($strPrefixCd)
	Local $txtCdFr = GUICtrlRead($strCdFr)
	Local $txtCdTo = GUICtrlRead($strCdTo)
	Local $txtQtyCd = GUICtrlRead($strQtyCd)
	Local $Combotype = GUICtrlRead($type)
	Local $txtCdRandom, $listCdRandom
	If $Combotype = 'Random' Then
		For $i = 1 To $txtQtyCd
			$txtCdRandom = Random($txtCdFr, $txtCdTo, 1)
			If StringLen($txtCdRandom) < StringLen($txtCdTo) Then
				For $j = StringLen($txtCdRandom) To StringLen($txtCdTo) - 1
					$txtCdRandom = 0 & $txtCdRandom
				Next
			EndIf
			$listCdRandom = $listCdRandom & $txtPre & $txtCdRandom & @CRLF
		Next
	Else
		For $i = $txtCdFr To $txtCdTo
			$listCdRandom = $listCdRandom & $txtPre & $i & @CRLF
		Next
	EndIf
	GUICtrlSetData($listCd, $listCdRandom)
EndFunc   ;==>Random_Cd

Func Random_YMD()
	Local $txtYearF = GUICtrlRead($strYearFr)
	Local $txtYearT = GUICtrlRead($strYearTo)
	Local $txtMoF = GUICtrlRead($strMonthFr)
	Local $txtMoT = GUICtrlRead($strMonthTo)
	Local $txtDayF = GUICtrlRead($strDayFr)
	Local $txtDayT = GUICtrlRead($strDayTo)
	Local $txtQtyYmd = GUICtrlRead($strQtyYmd)
	Local $listYmdRandom, $txtYearRandom, $txtMoRandom, $txtDayRandom

	For $i = 1 To $txtQtyYmd
		$txtYearRandom = Random($txtYearF, $txtYearT, 1)
		$txtMoRandom = Random($txtMoF, $txtMoT, 1)
		If $txtMoRandom = 2 Then
			$txtDayRandom = Random($txtDayF, $txtDayT, 1)
			If $txtDayRandom > 28 Then
				$txtDayRandom = $txtDayRandom - 2
			EndIf
		Else
			$txtDayRandom = Random($txtDayF, $txtDayT, 1)
		EndIf

		If $txtMoRandom < 10 Then
			$txtMoRandom = 0 & $txtMoRandom
		EndIf

		If $txtDayRandom < 10 Then
			$txtDayRandom = 0 & $txtDayRandom
		EndIf

		$listYmdRandom = $listYmdRandom & $txtYearRandom & $txtMoRandom & $txtDayRandom & @CRLF
	Next
	GUICtrlSetData($listYMD, $listYmdRandom)
EndFunc   ;==>Random_YMD

Func onChangeType()
	Local $Combotype = GUICtrlRead($type)
	If $Combotype = 'Random' Then
		GUICtrlSetState($strQtyCd, $GUI_SHOW)
		GUICtrlSetState($lblQtyCd, $GUI_SHOW)
		GUICtrlSetState($strLen, $GUI_SHOW)
	Else
		GUICtrlSetState($strQtyCd, $GUI_HIDE)
		GUICtrlSetState($lblQtyCd, $GUI_HIDE)
		GUICtrlSetState($strLen, $GUI_HIDE)
	EndIf
EndFunc   ;==>onChangeType

Func Cal_Len($i, $n)
	Local $txtPrefixLen = GUICtrlRead($strPrefixCd)
	Local $txtCdToLen = GUICtrlRead($strCdTo)
	Local $Len = StringLen($txtPrefixLen) + StringLen($txtCdToLen)
	GUICtrlSetData($strLen, 'LEN: ' & $Len)
EndFunc   ;==>Cal_Len
