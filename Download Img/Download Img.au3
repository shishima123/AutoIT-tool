#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Icon=download.ico
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#include <IE.au3>
#include <ButtonConstants.au3>
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
#include <GuiStatusBar.au3>
#include <Array.au3>
#include <StringConstants.au3>
#NoTrayIcon
#Region ### START Koda GUI section ### Form=
$Form1_1 = GUICreate("Tool Download Image", 329, 127, 192, 124)
GUISetFont(9, 400, 0, "Tahoma")
$Button1 = GUICtrlCreateButton("Download", 112, 48, 97, 33)
$Input1 = GUICtrlCreateInput("", 48, 8, 257, 23)
$Label1 = GUICtrlCreateLabel("Url", 16, 8, 23, 20)
GUICtrlSetFont(-1, 11, 400, 0, "Tahoma")
$StatusBar = _GUICtrlStatusBar_Create($Form1_1)
_GUICtrlStatusBar_SetText($StatusBar, "Enter Url Then Press Button Download")
GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###
Global $oIE

While 1
	$nMsg = GUIGetMsg()
	Switch $nMsg
		Case $GUI_EVENT_CLOSE
			IEquit()
			Exit
		Case $Button1
			_GetImg()
	EndSwitch
WEnd

Func _GetImg()
	_GUICtrlStatusBar_SetText($StatusBar, "Loading...")
	Const $sFilePath = "D:\ImgDownloaded\"

	If Not FileExists($sFilePath) Then
		; Create the directory.
		DirCreate($sFilePath)
	EndIf

	$sWebPage = GUICtrlRead($Input1) ; webpage with images

	$oIE = _IECreate($sWebPage, '', 0)
	$oIMGs = _IEImgGetCollection($oIE)
	Local $arrType[4] = ["JPEG", "JPG", "PNG", "GIF"]
	Local $count = 0
	Local $arrImg[0]
	Local $totalImg = _GetTotalImg($oIMGs, $arrType)

	_GUICtrlStatusBar_SetText($StatusBar, "Downloaded 0/" & $totalImg)

	; Loop through all IMG tags and save file to local directory using INetGet
	For $oIMG In $oIMGs
		$sImgUrl = $oIMG.src
		$sImgFileName = $oIMG.nameProp
		;If _ArraySearch($arrImg, $oIMG.nameProp) == -1 Then
			;$fileExts = StringRegExp($oIMG.nameProp, "\.\w{3,4}($|\?)$")
			;If _ArraySearch($arrType, $fileExts) Then
				;$count = $count + 1
				ConsoleWrite($sImgUrl & @CRLF)
				InetGet($sImgUrl, $sFilePath & $sImgFileName&".jpeg")
				;_ArrayAdd($arrImg, $oIMG.nameProp)
			;EndIf
			;_GUICtrlStatusBar_SetText($StatusBar, "Downloaded " & $count & "/" & $totalImg)
		;EndIf
	Next
	MsgBox(64, "Tool Download Image", "Download Success")
	_IEQuit($oIE)
	Run("Explorer.exe " & $sFilePath)
EndFunc   ;==>_GetImg

Func IEquit()
	_IEQuit($oIE)
EndFunc   ;==>IEquit

Func _GetTotalImg($oIMGs, $arrType)
	Local $arrImg[0]
	Local $totalImg
	For $oIMG In $oIMGs
		;ConsoleWrite($oIMG.nameProp & @CRLF)
		If _ArraySearch($arrImg, $oIMG.nameProp) == -1 Then
			Local $fileExts = StringRegExp($oIMG.nameProp, "\.\w{3,4}($|\?)$")
			If _ArraySearch($arrType, $fileExts) Then
				_ArrayAdd($arrImg, $oIMG.nameProp)
				$totalImg = $totalImg + 1
			EndIf
		EndIf
	Next
	;_ArrayDisplay($arrImg)
	Return $totalImg
EndFunc   ;==>_GetTotalImg

