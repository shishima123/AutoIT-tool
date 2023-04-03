#include <ImageSearch.au3>
#include <File.au3>
Opt("GUIOnEventMode",1)
Global $sleepTimeFast = 1000

Global $sleepTimeMiddle = 1500

Global $count = 0

Global $mouseClickSpeed = 3

#include <ButtonConstants.au3>
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
#Region ### START Koda GUI section ### Form=
$Form1_1 = GUICreate("Generate Sub", 604, 194, 155, 132)
$sourceFolderInput = GUICtrlCreateInput("E:\English\Listening_Practice_Through_Dictation\ListeningPracticeThroughDictation_1", 24, 40, 561, 22)
$subFolderInput = GUICtrlCreateInput("C:\Users\shish\Videos", 24, 96, 561, 22)
$Label1 = GUICtrlCreateLabel("Source Folder", 24, 16, 76, 18)
$Label2 = GUICtrlCreateLabel("Sub Folder", 24, 72, 68, 18)
$Label3 = GUICtrlCreateLabel("F1 = Start", 24, 144, 51, 18)
$Label4 = GUICtrlCreateLabel("Esc = Exit", 112, 144, 51, 18)
GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###

HotKeySet("{esc}", "stop")
HotKeySet("{F1}", "handle")

While 1
	$nMsg = GUIGetMsg()
	Switch $nMsg
		Case $GUI_EVENT_CLOSE
			Exit
	EndSwitch
WEnd

Func handle()
	GUICtrlSetState($sourceFolderInput, $GUI_DISABLE)
	GUICtrlSetState($subFolderInput, $GUI_DISABLE)

	Global $sourceFolder = GUICtrlRead($sourceFolderInput)
	Global $subFolder = GUICtrlRead($subFolderInput)

;~ 	clearSubFolder()

	Local $fileList = _FileListToArray($sourceFolder)

	If @error Then
		notifySubCount()
		Return
	EndIf

	For $i = 1 To $fileList[0]
		If checkVideoIsNotExist() Then
			ExitLoop
		EndIf

		$count = $i
		Local $file = $fileList[$i]
		removeVideoFromTimeline()
		dragAndDropFileToTimeline()
		makeSub()
		saveSub()
		moveSubToSourceDir($file)
		removeVideoFromTimeline()
		removeVideoAfterGenenated()
	Next

	notifySubCount()
EndFunc   ;==>handle

Func moveSubToSourceDir($file)
	$fileName = removeExt($file) & '.srt'

	FileMove($subFolder & "\" & 'sub.srt', $sourceFolder & "\" & $fileName, 1)

EndFunc   ;==>moveSubToSourceDir

Func removeExt($Input)
	Local $ExtArray = StringSplit($Input, ".")
	Return StringReplace($Input, "." & $ExtArray[$ExtArray[0]], "", -1)
EndFunc   ;==>removeExt

Func saveSub()
	Do
		Sleep(3000)
		Local $x = 0, $y = 0
		Local $search = _ImageSearchArea(@ScriptDir & "\Images\creating_sub.bmp", 1, 841, 389, 1069, 643, $x, $y, 0)
		ConsoleWrite("$search: " & $search & @CRLF)
	Until $search = 0

	Sleep($sleepTimeFast)
	MouseClick("left", 1771, 15, 1, $mouseClickSpeed) ; Button Export

	Sleep($sleepTimeFast)
	MouseClick("left", 1150, 252, 3, $mouseClickSpeed) ; Input Title

	Sleep($sleepTimeFast)
	Send("sub")

	Sleep($sleepTimeFast)
	MouseClick("left", 1150, 824, 3, $mouseClickSpeed) ; Button Export

	Sleep($sleepTimeFast)
	Send('{ENTER}')

	Sleep($sleepTimeFast)
	MouseClick("left", 1229, 643, 3, $mouseClickSpeed) ; Button OK

EndFunc   ;==>saveSub

Func makeSub()
	Sleep($sleepTimeFast)
	MouseClick("left", 157, 52, 1, $mouseClickSpeed) ; Button Text
	Local $x = 0, $y = 0
	Local $search = _ImageSearchArea(@ScriptDir & "\Images\auto_caption_active.bmp", 1, 14, 82, 123, 358, $x, $y, 0)

	If $search = 0 Then
		Sleep($sleepTimeFast)
		Local $x = 0, $y = 0
		Local $search = _ImageSearchArea(@ScriptDir & "\Images\auto_caption.bmp", 1, 14, 82, 123, 358, $x, $y, 0)
		MouseClick("left", $x, $y, 1, $mouseClickSpeed) ; Button Auto Caption
	EndIf

	Sleep($sleepTimeFast)
	MouseClick("left", 140, 250, 1, $mouseClickSpeed) ; checkbox overwrite
	Sleep($sleepTimeFast)
	MouseClick("left", 197, 276, 1, $mouseClickSpeed) ; Button create
EndFunc   ;==>makeSub

Func dragAndDropFileToTimeline()
	Sleep($sleepTimeFast)
	MouseClick("left", 42, 58, 1, $mouseClickSpeed) ; Button Media
	Sleep($sleepTimeFast)
	MouseClickDrag('left', 175, 204, 253, 823, 10) ;Drag file video to timeline
EndFunc   ;==>dragAndDropFileToTimeline

Func checkVideoIsNotExist()
	Sleep($sleepTimeMiddle)
	Local $x = 0, $y = 0
	Local $search = _ImageSearchArea(@ScriptDir & "\Images\import.bmp", 1, 347, 251, 609, 408, $x, $y, 0)
	Return $search
EndFunc   ;==>checkVideoIsNotExist

Func removeVideoFromTimeline()
	Sleep($sleepTimeFast)
	Local $x = 0, $y = 0
	Local $search = _ImageSearchArea(@ScriptDir & "\Images\edit_cover.bmp", 1, 109, 799, 182, 871, $x, $y, 0)
	ConsoleWrite("$search: " & $search & @CRLF)

	If $search = 1 Then
		MouseClickDrag('left', 1059, 965, 187, 675, 10) ;Drag file video to timeline
		Sleep($sleepTimeFast)
		Send("{DEL}")
	EndIf
EndFunc   ;==>removeVideoFromTimeline

Func removeVideoAfterGenenated()
	Sleep($sleepTimeFast)
	MouseClick("left", 42, 58, 1, $mouseClickSpeed) ; Button Media
	Sleep($sleepTimeFast)
	MouseClick("right", 176, 195, 1, $mouseClickSpeed) ; First Video
	Sleep($sleepTimeFast)
	MouseClick("left", 213, 214, 1, $mouseClickSpeed) ; Button Delete
	Sleep($sleepTimeFast)
	MouseClick("left", 902, 603, 1, $mouseClickSpeed) ; Button OK
EndFunc   ;==>removeVideoAfterGenenated

Func clearSubFolder()
	$fileList = _FileListToArray($subFolder, "*")
	If @error Then Return

	For $i = 1 To $fileList[0]
		If StringInStr($fileList[$i], ".srt") Then
			FileDelete($subFolder & "\" & $fileList[$i])
		EndIf
	Next
EndFunc   ;==>clearSubFolder

Func stop()
	Exit
EndFunc   ;==>stop

Func notifySubCount()
	MsgBox(0, "File move operation", "All Done. " & $count & " sub generated")
EndFunc   ;==>notifySubCount
