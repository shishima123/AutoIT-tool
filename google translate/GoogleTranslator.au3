#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Icon=google_translate.ico
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#include <_HttpRequest.au3>
#include <Array.au3>
#include <MsgBoxConstants.au3>
#include <StringConstants.au3>
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <GuiEdit.au3>
#include <WindowsConstants.au3>
#include <String.au3>
#include <StaticConstants.au3>

#Region ### START Koda GUI section ### Form=
$Form1_1 = GUICreate("Tool Support Translate.", 656, 658, 86, 6)
$Edit1 = GUICtrlCreateEdit("", 16, 8, 505, 625)
GUICtrlSetData(-1, "")
$CopyText = GUICtrlCreateButton("Copy Text", 544, 256, 83, 25)
$Group1 = GUICtrlCreateGroup("Setting", 536, 24, 105, 209)
$TransFrom = GUICtrlCreateList("Auto Detect", 544, 72, 81, 58)
GUICtrlSetData(-1, "English|Japan|Viet Nam")
$TransTo = GUICtrlCreateList("English", 544, 160, 81, 58)
GUICtrlSetData(-1, "Japan|Viet Nam")
$Label1 = GUICtrlCreateLabel("Translate From", 544, 48, 83, 17, BitOR($SS_CENTER, $SS_CENTERIMAGE))
$Label2 = GUICtrlCreateLabel("Translate To", 544, 136, 81, 17, BitOR($SS_CENTER, $SS_CENTERIMAGE))
GUICtrlCreateGroup("", -99, -99, 1, 1)
$Label3 = GUICtrlCreateLabel("Select text then press F1", 528, 353, 124, 17, $SS_CENTER)
$ClearText = GUICtrlCreateButton("Clear Text", 544, 296, 83, 25)
GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###

HotKeySet("{F1}", "translateInput")

While 1
	$nMsg = GUIGetMsg()
	Switch $nMsg
		Case $GUI_EVENT_CLOSE
			Exit
		Case $CopyText
			copyText()
		Case $ClearText
			clearText()
	EndSwitch
WEnd

Func translateInput()
	Local $range = _GUICtrlEdit_GetSel(GUICtrlGetHandle($Edit1))
	If $range[0] <> $range[1] Then
		$SelectedText = StringMid(GUICtrlRead($Edit1), $range[0] + 1, $range[1] - $range[0])
		Local $iFrom = convertLanguage(GUICtrlRead($TransFrom))
		Local $iTo = convertLanguage(GUICtrlRead($TransTo))
		Local $textTranslated = StringRegExp(GoogleTrans_Translate($SelectedText, $iFrom, $iTo), '\"(.*?)\"', $STR_REGEXPARRAYMATCH)[0]
		_GUICtrlEdit_ReplaceSel(GUICtrlGetHandle($Edit1), _StringProper($textTranslated))
	Else
		MsgBox(16,"Error", "Please select text.")
	EndIf

EndFunc   ;==>translateInput

Func convertLanguage($value)
	Local $typeLang
	Switch $value
		Case 'English'
			$typeLang = "en"
		Case 'Japan'
			$typeLang = "ja"
		Case 'Viet Nam'
			$typeLang = "vi"
		Case Else
			$typeLang = "auto"
	EndSwitch
	Return $typeLang
EndFunc   ;==>convertLanguage

Func copyText()
	Local $textFromAnEditBox = GUICtrlRead($Edit1)
	ClipPut($textFromAnEditBox)
EndFunc   ;==>copyText

Func clearText()
	GUICtrlSetData($Edit1, '')
EndFunc   ;==>clearText

Func GoogleTrans_TranslateDoc($DocPath, $iFrom = 'auto', $iTo = 'en') ; $DocPath Đường dẫn file Text muốn translate
	If Not $iFrom Or IsKeyword($iFrom) Then $iFrom = 'auto'
	If Not $iTo Or IsKeyword($iTo) Then $iTo = 'en'
	Local $aForm = ['sl=' & $iFrom, 'tl=' & $iTo, 'hl=' & $iTo, 'ie=UTF-8', 'text=', 'prev=_t', 'js=y', 'edit-text=', '$file=' & $DocPath]
	Local $rq = _HttpRequest(2, 'https://translate.googleusercontent.com/translate_f', $aForm)
	If @extended > 400 Then Return SetError(1, '', '')
	Return $rq
EndFunc   ;==>GoogleTrans_TranslateDoc

Func GoogleTrans_Translate($iText, $iFrom = 'auto', $iTo = 'en')
	If StringLen($iText) > 5000 Then Return SetError(1, '', '')
	If Not $iFrom Or IsKeyword($iFrom) Then $iFrom = 'auto'
	If Not $iTo Or IsKeyword($iTo) Then $iTo = 'en'
	Local $rq = _HttpRequest(2, 'https://translate.google.com/translate_a/single?client=t&sl=' & $iFrom & '&tl=' & $iTo & '&ie=UTF-8&oe=UTF-8&dt=at&dt=bd&dt=ex&dt=ld&dt=md&dt=qca&dt=rw&dt=rm&dt=ss&dt=t&tk=' & _GoogleGetTK($iText) & '&q=' & _URIEncode($iText))
	If @extended > 400 Then Return SetError(2, '', '')
	Return $rq
EndFunc   ;==>GoogleTrans_Translate

Func GoogleTrans_TTS($iText, $iLang = '', $SavePath = '', $iSpeechSpeed = 1) ; Lưu ý: $iLang= phải đúng mã ngôn ngữ mới request thành công
	If Not $iLang Or IsKeyword($iLang) Or $iLang = 'auto' Then
		$iLang = GoogleTrans_LangDetect($iText)
		If @error Then Return SetError(1, '', '')
	EndIf
	Local $rq = _HttpRequest(3, 'https://translate.google.com/translate_tts?ie=UTF-8' & '&tl=' & $iLang & '&client=webapp&ttsspeed=' & $iSpeechSpeed & '&tk=' & _GoogleGetTK($iText) & '&q=' & _URIEncode($iText))
	If @extended > 400 Then Return SetError(2, '', '')
	If $SavePath Then Return _HttpRequest_Test($rq, $SavePath, Default, False)
	Return $rq
EndFunc   ;==>GoogleTrans_TTS

Func GoogleTrans_LangDetect($iText)
	Local $rq = _HttpRequest(2, 'https://translate.google.com/translate_a/single?client=t&sl=auto&ie=UTF-8&oe=UTF-8&tk=' & _GoogleGetTK($iText) & '&q=' & _URIEncode($iText))
	If @extended > 400 Then Return SetError(1, '', '')
	Local $vLang = StringRegExp($rq, '\["([^"]+)"\]', 1)
	If @error Or $vLang[0] = '' Then Return SetError(2, '', '')
	Return $vLang[0]
EndFunc   ;==>GoogleTrans_LangDetect





;$sQueryString: Text cần dịch
;$iTimeCheck: Sau khoảng thời gian được set thì lấy TKK mới
;$iForceRequestGetTKK: nếu True thì sẽ lấy TKK mới mỗi lần lấy TK
Func _GoogleGetTK($sQueryString, $iForceRequestGetTKK = False, $iTimeCheck = 15) ;$iTimeCheck tính theo phút
	Local $GoogleTKReg = 'HKCU\Software\AutoIt v3\HttpRequest\GoogleTK'
	Local $tkkIndex, $tkkKey
	Local $vTimer = RegRead($GoogleTKReg, 'Timer')
	Local $sTKK = RegRead($GoogleTKReg, 'TKK')
	If Not $vTimer Or Not $sTKK Or TimerDiff($vTimer) > $iTimeCheck * 60 * 1000 Or $iForceRequestGetTKK Then ;sau 15ph thì lấy TKK mới
		Local $sourceGGTS = _HttpRequest(2, 'https://translate.google.com/')
		Local $aTKK = StringRegExp($sourceGGTS, "(?i)\QTKK=eval('((function(){var a\x3d\E(-?\d+)\Q;var b\x3d\E(-?\d+);return (-?\d+)\Q+\x27.\x27+(a+b)}\E", 3)
		If @error Then
			$aTKK = StringRegExp($sourceGGTS, "(?i)TKK\h*?[:=]\h*?'(\d+)\.(\d+)", 3)
			If @error Then Return SetError(RegWrite($GoogleTKReg, 'Timer', 'REG_SZ', 0) * RegWrite($GoogleTKReg, 'TKK', 'REG_SZ', ''), 0, '')
			$tkkIndex = Number($aTKK[0], 1)
			$tkkKey = Number($aTKK[1], 1)
			RegWrite($GoogleTKReg, 'TKK', 'REG_SZ', $aTKK[0] & '.' & $aTKK[1])
		Else
			$tkkIndex = Number($aTKK[2], 1)
			$tkkKey = Number($aTKK[0] + $aTKK[1], 1)
			RegWrite($GoogleTKReg, 'TKK', 'REG_SZ', $aTKK[2] & '.' & ($aTKK[0] + $aTKK[1]))
		EndIf
		RegWrite($GoogleTKReg, 'Timer', 'REG_SZ', TimerInit())
	Else
		Local $aTKK = StringSplit($sTKK, '.', 2)
		$tkkIndex = Number($aTKK[0], 1)
		$tkkKey = Number($aTKK[1], 1)
	EndIf
	;Ép kiểu cho $tkkIndex và $tkkKey là số 32bit
	Local $sTK = $tkkIndex
	Local $aQuery = StringToASCIIArray($sQueryString, 0, -1, 2)
	;-----------------------------------------------------------
	Local $aOP1[2] = ['+-a', '^+6']
	For $i = 0 To UBound($aQuery) - 1
		$sTK += $aQuery[$i]
		__BitshiftByOp($sTK, $aOP1)
	Next
	;-----------------------------------------------------------
	Local $aOP2[3] = ['+-3', '^+b', '+-f']
	__BitshiftByOp($sTK, $aOP2)
	$sTK = BitXOR($sTK, $tkkKey)
	;-----------------------------------------------------------
	If $sTK < 0 Then $sTK = BitAND($sTK, 0x7FFFFFFF) + 0x7FFFFFFF + 1
	$sTK = Mod($sTK, 0x000F4240)
	$sTK = $sTK & '.' & BitXOR($sTK, $tkkIndex)
	Return $sTK
EndFunc   ;==>_GoogleGetTK

Func __BitshiftByOp(ByRef $vCc, $aOp)
	Local $opString, $BitShiftAmount = Number(0, 1), $BitMask = Number(0, 1) ;ép kiểu cho $BitShiftAmount và $BitMask là số 32bit
	For $i = 0 To UBound($aOp) - 1
		$opString = StringSplit($aOp[$i], '', 2)
		$BitShiftAmount = ($opString[2] >= 'a' ? Asc($opString[2]) - 0x00000057 : Number($opString[2]))
		$BitMask = __Bitshift($vCc, ($opString[1] == '+' ? 1 : -1) * $BitShiftAmount)
		$vCc = ($opString[0] == '+' ? $vCc + BitAND($BitMask, 0x7FFFFFFF - -0x80000000) : BitXOR($vCc, $BitMask))
	Next
	Return $vCc
EndFunc   ;==>__BitshiftByOp

Func __Bitshift($Val, $Shift)
	If $Shift > 0 And BitAND($Val, 0x80000000) = 0x80000000 Then
		$Val = BitShift($Val, 1)
		$Val = BitXOR($Val, 0x80000000)
		$Shift -= 1
	EndIf
	Return BitShift($Val, $Shift)
EndFunc   ;==>__Bitshift



