#NoTrayIcon
;~ http://www.autoitscript.com/autoit3/scite/docs/SciTE4AutoIt3/directives-available.html

#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Au3Check_Parameters=-d -w 1 -w 2 -w 3 -w 4 -w 5 -w 6
;~ #AutoIt3Wrapper_Version=Beta
#AutoIt3Wrapper_Icon=C:\TextDiff1.ico
#AutoIt3Wrapper_Outfile=TextDiff.exe
#AutoIt3Wrapper_Compression=4
#AutoIt3Wrapper_UseUpx=y
#AutoIt3Wrapper_Res_Comment=find differences between 2 "text" files.
#AutoIt3Wrapper_Res_Description=TextDiff
#AutoIt3Wrapper_Res_Field=Made By|wakillon
#AutoIt3Wrapper_Res_Fileversion=1.0.2.4
#AutoIt3Wrapper_Res_LegalCopyright=wakillon 2014
#AutoIt3Wrapper_Res_requestedExecutionLevel=asInvoker
#AutoIt3Wrapper_Res_Field=AutoIt Version|%AutoItVer%
#AutoIt3Wrapper_Res_Field=Compile date|%longdate% %time%
#AutoIt3Wrapper_Run_Au3Stripper=y
#au3stripper_Parameters=/so /pe ; (/rm parameter is not used for Assign works when compiled)
#AutoIt3Wrapper_Run_After=del "%scriptfile%_stripped.au3"
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****

#Region    ;************ Includes ************
#Include <GuiListView.au3>
#include <WindowsConstants.au3>
#include <GUIConstantsEx.au3>
#Include <File.au3>
#EndRegion ;************ Includes ************

Opt ( 'GUIOnEventMode', 1 )
Opt ( 'MustDeclareVars', 1 )
Opt ( 'GUICloseOnESC', 0 )

#Region ------ Global Variables ------------------------------
Global $hGui, $idButtonSearch, $idProgressbar, $idEditFake
Global $iGuiWidth = 1020, $iGuiHeight = 620, $sFontName = 'Arial', $iFontSize = 8, $iFontWidth = 500, $iListviewColumn1Width = @DesktopWidth, $itemHeight
Global $idCheckBoxIgnoreBlankLines, $idCheckBoxIgnoreSpaces, $idCheckBoxOnTop, $idCheckBoxCaseSensitive, $idCheckBoxListViewSynch
Global $idLabelDrop1, $idLabelDrop2, $idLabelGreyedTxt1, $idLabelGreyedTxt2, $idLabelLineCount1, $idLabelLineCount2, $idLabelFilePath1, $idLabelFilePath2, $idLabelDiffFound, $idLabelFlash, $idLabelNoMatchCount1, $idLabelNoMatchCount2
Global $idListView1, $idListView2, $idListView3, $idListView4, $hListView1, $hListView2, $hListView3, $hListView4, $hListViewToRedraw, $hListViewClicked
Global $aRead1 = '', $aRead2 = '', $sFilePath1, $sFilePath2, $aRet, $sStr1, $sStr2, $iCount1, $iCount2, $iCancel, $aGuiSize, $iSyncListView
Global $bState = False, $bSearch = False, $a1[1], $a2[1], $iDblClick, $hCtrlFromPoint, $hProc, $hHook, $sVersion = _ScriptGetVersion ()
Global $sRegTitleKey = 'TextDiff', $sRegKeySettings = 'HKCU' & StringReplace ( StringReplace ( @OSArch, 'x64', '64' ), 'x86', '' ) & '\Software\' & $sRegTitleKey & '\Settings'
Global $sSoftTitle = $sRegTitleKey & ' v' & $sVersion & ' by wakillon'
Global $sImageBk = 'http://s11.postimg.org/5n58s6tlf/20141023193409.jpg'
#EndRegion --- Global Variables ------------------------------

AutoItWinSetTitle ( 'T3xt_D1ff' )
If _ScriptIsAlreadyRunning () Then Exit MsgBox ( 262144+16, 'Exiting', 'TextDiff is Already Running !', 4 )
_Gui ()
OnAutoItExitRegister ( '_OnAutoItExit' )

#Region ------ Main Loop ------------------------------
While 1
	If $bSearch Then
		ControlSetText ( $hGui, '', $idLabelNoMatchCount1, 'Text 1, Lines not found in Text 2' )
		ControlSetText ( $hGui, '', $idLabelNoMatchCount2, 'Text 2, Lines not found in Text 1' )
		GUICtrlSetState ( $idLabelDiffFound, $GUI_SHOW )
		GUISetOnEvent ( $GUI_EVENT_DROPPED, '_GuiNoEvent' )
		_GUICtrlListView_DeleteAllItems ( $idListView3 )
		_GUICtrlListView_DeleteAllItems ( $idListView4 )
		_GUICtrlListView_SetBkImage ( $hListView3, '', 0, 50, 50 )
		_GUICtrlListView_SetBkImage ( $hListView4, '', 0, 50, 50 )
		_GuiCtrlReDraw ( $idListView1 )
		_GuiCtrlReDraw ( $idListView2 )
		$aRet = _TextDiff ( $aRead1, $aRead2, _GuiCtrlIsChecked ( $idCheckBoxIgnoreSpaces ), _GuiCtrlIsChecked ( $idCheckBoxIgnoreBlankLines ), _GuiCtrlIsChecked ( $idCheckBoxCaseSensitive ), 1 )
		$bSearch = False
		If Not $iCancel Then
			$sStr1 = ''
			$sStr2 = ''
			$iCount1 = 0
			$iCount2 = 0
			For $i = 0 To UBound ( $aRet ) -1
				$sStr1 &= $aRet[$i][0] & @CRLF
				If $aRet[$i][0] Then $iCount1 +=1
				$sStr2 &= $aRet[$i][1] & @CRLF
				If $aRet[$i][1] Then $iCount2 +=1
			Next
			$a1 = 0
			$a2 = 0
			Dim $a1[1], $a2[1]
			For $i = 0 To UBound ( $aRet ) -1
				If $aRet[$i][2] Then
					_GUICtrlListView_AddItem ( $idListView3, $aRet[$i][2], $i )
					_GUICtrlListView_AddSubItem ( $idListView3, $i, $aRet[$i][0], 1 )
					ReDim $a1[$i+1]
					$a1[$i] = $aRet[$i][2]
				EndIf
				If $aRet[$i][3] Then
					_GUICtrlListView_AddItem ( $idListView4, $aRet[$i][3], $i )
					_GUICtrlListView_AddSubItem ( $idListView4, $i, $aRet[$i][1], 1 )
					ReDim $a2[$i+1]
					$a2[$i] = $aRet[$i][3]
				EndIf
			Next
			If $iCount1 Then ControlSetText ( $hGui, '', $idLabelNoMatchCount1, 'Text 1 : ' & $iCount1 & ' Line' & Chr ( -28*( $iCount1 <> 1 )+143 ) & ' not found in Text 2' )
			If $iCount2 Then ControlSetText ( $hGui, '', $idLabelNoMatchCount2, 'Text 2 : ' & $iCount2 & ' Line' & Chr ( -28*( $iCount1 <> 1 )+143 ) & ' not found in Text 1' )
		EndIf
		$iCancel = 0
		GUICtrlSetState ( $idButtonSearch, $GUI_ENABLE )
		GUICtrlSetData ( $idButtonSearch, 'Search Differences' )
		GUISetOnEvent ( $GUI_EVENT_DROPPED, '_GuiEventDropped' )
		_GuiCtrlReDraw ( $idListView1 )
		_GuiCtrlReDraw ( $idListView2 )
	EndIf
	If $hListViewToRedraw Then
		_GuiCtrlReDraw ( $hListViewToRedraw )
		$hListViewToRedraw = 0
	EndIf
	$hCtrlFromPoint = _GuiCtrlGetHandleByMousePos()
	If Not @error Then
		Switch $hCtrlFromPoint
			Case GUICtrlGetHandle ( $idButtonSearch ), $hListView1, $hListView2, $hListView3, $hListView4
				If Not BitAnd ( WinGetState ( $hGui ), 8 ) Then WinActivate ( $hGui ) ; activate Gui if Mouse is over Button or Listviews.
				ControlFocus ( $hGui, '', _GuiCtrlGetIdByHandle ( $hCtrlFromPoint ) )
		EndSwitch
	EndIf
	If $iDblClick Then
		If $hListViewClicked Then _GuiCtrlListView_AddOutLineToRow ( $hListViewClicked, $iDblClick -1, 0x0000FF, 2 ) ; rgb red
		$hListViewClicked = 0
		$iDblClick = 0
	EndIf
	Sleep ( 250 )
WEnd
#EndRegion --- Main Loop ------------------------------

Func _Base64Decode ( $input_string ) ; by trancexx
	Local $struct = DllStructCreate ( 'int' )
	Local $a_Call = DllCall ( 'Crypt32.dll', 'int', 'CryptStringToBinary', 'str', $input_string, 'int', 0, 'int', 1, 'ptr', 0, 'ptr', DllStructGetPtr ( $struct, 1 ), 'ptr', 0, 'ptr', 0 )
	If @error Or Not $a_Call[0] Then Return SetError ( 1, 0, '' )
	Local $a = DllStructCreate ( 'byte[' & DllStructGetData ( $struct, 1 ) & ']' )
	$a_Call = DllCall ( 'Crypt32.dll', 'int', 'CryptStringToBinary', 'str', $input_string, 'int', 0, 'int', 1, 'ptr', DllStructGetPtr ( $a ), 'ptr', DllStructGetPtr ( $struct, 1 ), 'ptr', 0, 'ptr', 0 )
	If @error Or Not $a_Call[0] Then Return SetError ( 2, 0, '' )
	Return DllStructGetData ( $a, 1 )
EndFunc ;==> _Base64Decode()

Func _Exit()
	_GuiSavePos ()
	Exit
EndFunc ;==> _Exit()

Func _FileCompactPath ( $sName, $iChrMax )
	If StringLen ( $sName ) <= $iChrMax Then Return $sName
	Local $i, $stName
	Do
		$stName  = StringLeft ( $sName, Int ( $iChrMax/2 -1 -$i ) ) & '...' & StringRight ( $sName, Int ( $iChrMax/2 -1 ) )
		$sName = $stName
		$i = 1
	Until StringLen ( $stName ) <= $iChrMax
	Return $stName
EndFunc ;==> _FileCompactPath()

Func _Gui()
	Local $iDefaultValue
	Local $iMarginV = 10
	Local $iMarginH = 10
	Local $iListViewWidth = ( $iGuiWidth - $iMarginH*3 ) /2
	Local $iListViewHeight1 = ( $iGuiHeight - $iMarginV*3 ) /2
	Local $iListViewHeight2 = $iGuiHeight - $iListViewHeight1 - $iMarginH*3 - 120
	Local $iLabelHeight = 20
	Local $iLabelFileWidth = 45
	Local $iLabelLineCountWidth = 90
	If Not FileExists ( 'C:\TextDiff1.ico' ) Then Textdiff1Ico ( 'TextDiff1.ico', 'C:' )
	Local $iDefaultValueX = RegRead ( $sRegKeySettings, 'X' )
	If @error Then $iDefaultValueX = -1
	Local $iDefaultValueY = RegRead ( $sRegKeySettings, 'Y' )
	If @error Then $iDefaultValueY = -1
;~  Gui
	$hGui = GUICreate ( $sSoftTitle, $iGuiWidth, $iGuiHeight, $iDefaultValueX, $iDefaultValueY, BitOR ( $WS_SIZEBOX, $WS_SYSMENU, $WS_MAXIMIZEBOX, $WS_MINIMIZEBOX ), $WS_EX_ACCEPTFILES )
	GUISetIcon ( 'C:\TextDiff1.ico'  )
	GUISetOnEvent ( $GUI_EVENT_CLOSE, '_Exit' )
	GUISetOnEvent ( $GUI_EVENT_DROPPED, '_GuiEventDropped' )
;~  Controls
;~  Label File 1
	GUICtrlCreateLabel ( 'File 1 :', $iMarginH, $iMarginV, $iLabelFileWidth, $iLabelHeight, 0x01 )
	GUICtrlSetFont ( -1, 9, 600 )
;~  LabelFilePath1
	$idLabelFilePath1 = GUICtrlCreateLabel ( '', $iLabelFileWidth+$iMarginH*1.5, $iMarginV, $iListViewWidth -$iLabelFileWidth - $iLabelLineCountWidth -$iMarginH, $iLabelHeight -2, 0x01 )
;~  LabelLineCount1
	$idLabelLineCount1 = GUICtrlCreateLabel ( '', $iListViewWidth+$iMarginH-$iLabelLineCountWidth, $iMarginV, $iLabelLineCountWidth, $iLabelHeight -2, 0x01 )
	GUICtrlSetFont ( -1, 9, 600 )
;~  Label File 2
	GUICtrlCreateLabel ( 'File 2 :', $iMarginH*2+$iListViewWidth, $iMarginV, $iLabelFileWidth, $iLabelHeight, 0x01 )
	GUICtrlSetFont ( -1, 9, 600 )
;~  LabelFilePath2
	$idLabelFilePath2 = GUICtrlCreateLabel ( '', $iListViewWidth+$iLabelFileWidth+2.5*$iMarginH, $iMarginV, $iListViewWidth -$iLabelFileWidth - $iLabelLineCountWidth -$iMarginH, $iLabelHeight -2, 0x01 )
;~  LabelLineCount2
	$idLabelLineCount2 = GUICtrlCreateLabel ( '', $iListViewWidth*2+$iMarginH*2-$iLabelLineCountWidth, $iMarginV, $iLabelLineCountWidth, $iLabelHeight -2, 0x01 )
	GUICtrlSetFont ( -1, 9, 600 )
;~  LabelDrop1
	$idLabelDrop1 = GUICtrlCreateLabel ( '', $iMarginH, $iMarginV*3, $iListViewWidth, $iListViewHeight1 )
	GUICtrlSetState ( -1, BitOR ( $GUI_DISABLE, $GUI_DROPACCEPTED ) )
	GUICtrlSetBkColor ( -1, 0xFFFFFF )

;~  ListView1
	GUIRegisterMsg ( $WM_MEASUREITEM, '_WM_MEASUREITEM' )
	$idListView1 = GUICtrlCreateListView ( '', $iMarginH, $iMarginV*3, $iListViewWidth, $iListViewHeight1, BitOR ( $LVS_REPORT, $LVS_SHOWSELALWAYS, $LVS_OWNERDRAWFIXED ) )
	GUICtrlSetFont ( -1, $iFontSize, $iFontWidth, 1, $sFontName, 5 )
	GUICtrlSetState ( -1, $GUI_HIDE )
	$hListView1 = GUICtrlGetHandle ( -1 )
	_GUICtrlListView_SetExtendedListViewStyle ( $hListView1, BitOR ( $LVS_EX_DOUBLEBUFFER, $LVS_EX_FULLROWSELECT ) )
	_GUICtrlListView_InsertColumn ( $hListView1, 0, 'Line', 40 )
	_GUICtrlListView_InsertColumn ( $hListView1, 1, 'Text', $iListviewColumn1Width )

;~  LabelGreyedTxt1
	$idLabelGreyedTxt1 = GUICtrlCreateLabel ( 'Drag and Drop Text File 1 Here', $iMarginH*2, $iMarginV + $iListViewHeight1/2 -25, $iListViewWidth -4*$iMarginH, 25, 0x01 )
	GUICtrlSetState ( -1, $GUI_DISABLE )
	GUICtrlSetFont ( -1, 14, 600 )
	GUICtrlSetBkColor ( -1, 0xFFFFFF )
;~  LabelDrop2
	$idLabelDrop2 = GUICtrlCreateLabel ( '', $iMarginH*2+$iListViewWidth, $iMarginV*3, $iListViewWidth, $iListViewHeight1 )
	GUICtrlSetState ( -1, BitOR ( $GUI_DISABLE, $GUI_DROPACCEPTED ) )
	GUICtrlSetBkColor ( -1, 0xFFFFFF )

;~  ListView2
	$idListView2 = GUICtrlCreateListView ( '', $iMarginH*2+$iListViewWidth, $iMarginV*3, $iListViewWidth, $iListViewHeight1, BitOR ( $LVS_REPORT, $LVS_SHOWSELALWAYS, $LVS_OWNERDRAWFIXED ) )
	GUICtrlSetFont ( -1, $iFontSize, $iFontWidth, 1, $sFontName, 5 )
	GUICtrlSetState ( -1, $GUI_HIDE )
	$hListView2 = GUICtrlGetHandle ( -1 )
	_GUICtrlListView_SetExtendedListViewStyle ( $hListView2, BitOR ( $LVS_EX_DOUBLEBUFFER, $LVS_EX_FULLROWSELECT ) )
	_GUICtrlListView_InsertColumn ( $hListView2, 0, 'Line', 40 )
	_GUICtrlListView_InsertColumn ( $hListView2, 1, 'Text', $iListviewColumn1Width )

;~  LabelGreyedTxt2
	$idLabelGreyedTxt2 = GUICtrlCreateLabel ( 'Drag and Drop Text File 2 Here', $iMarginH*3+$iListViewWidth, $iMarginV + $iListViewHeight1/2 -25, $iListViewWidth -4*$iMarginH, 25, 0x01 )
	GUICtrlSetState ( -1, $GUI_DISABLE )
	GUICtrlSetFont ( -1, 14, 600 )
	GUICtrlSetBkColor ( -1, 0xFFFFFF )
;~  Label
	$idLabelNoMatchCount1 = GUICtrlCreateLabel ( 'Text 1, Lines not found in Text 2', $iMarginH, $iListViewHeight1+5*$iMarginV, 495, 18, 0x01 )
	GUICtrlSetFont ( -1, 9, 600 )
;~  ListView3
	$idListView3 = GUICtrlCreateListView ( '', $iMarginH, $iListViewHeight1+7*$iMarginV, $iListViewWidth, $iListViewHeight2 -20 )
	GUICtrlSetFont ( -1, $iFontSize, $iFontWidth, 1, $sFontName, 5 )
	$hListView3 = GUICtrlGetHandle ( -1 )
	_GUICtrlListView_SetExtendedListViewStyle ( $hListView3, BitOR ( $LVS_EX_DOUBLEBUFFER, $LVS_EX_FULLROWSELECT ) )
	_GUICtrlListView_SetBkImage ( $hListView3, $sImageBk, 0, 50, 50 )
	_GUICtrlListView_InsertColumn ( $hListView3, 0, 'Line', 40 )
	_GUICtrlListView_InsertColumn ( $hListView3, 1, 'Text', $iListviewColumn1Width )
;~  Label
	$idLabelNoMatchCount2 = GUICtrlCreateLabel ( 'Text 2, Lines not found in Text 1', $iMarginH*2+$iListViewWidth, $iListViewHeight1+5*$iMarginV, 495, 18, 0x01 )
	GUICtrlSetFont ( -1, 9, 600 )
;~  ListView4
	$idListView4 = GUICtrlCreateListView ( '', $iMarginH*2+$iListViewWidth, $iListViewHeight1+7*$iMarginV, $iListViewWidth, $iListViewHeight2 -20 )
	GUICtrlSetFont ( -1, $iFontSize, $iFontWidth, 1, $sFontName, 5 )
	$hListView4 = GUICtrlGetHandle ( -1 )
	_GUICtrlListView_SetExtendedListViewStyle ( $hListView4, BitOR ( $LVS_EX_DOUBLEBUFFER, $LVS_EX_FULLROWSELECT ) )
	_GUICtrlListView_SetBkImage ( $hListView4, $sImageBk, 0, 50, 50 )
	_GUICtrlListView_InsertColumn ( $hListView4, 0, 'Line', 40 )
	_GUICtrlListView_InsertColumn ( $hListView4, 1, 'Text', $iListviewColumn1Width )
;~  CheckBoxes
;~  CheckBoxIgnoreSpaces
	$idCheckBoxIgnoreSpaces = GUICtrlCreateCheckbox ( ' Ignore Spaces', $iMarginH, $iMarginV*2+$iListViewHeight1+$iLabelHeight*2+$iListViewHeight2, 110, $iLabelHeight )
	GUICtrlSetOnEvent ( -1, '_GuiCtrlEvents' )
	$iDefaultValue = RegRead ( $sRegKeySettings, 'IgnoreSpaces' )
	If @error Then $iDefaultValue = 1
	If $iDefaultValue = 1 Then
		GUICtrlSetState ( -1, $GUI_CHECKED )
		GUICtrlSetFont ( -1, 8.5, 600 )
	EndIf
	GUICtrlSetResizing ( -1, $GUI_DOCKBOTTOM+$GUI_DOCKHEIGHT )
;~  CheckBoxIgnoreBlankLines
	$idCheckBoxIgnoreBlankLines = GUICtrlCreateCheckbox ( ' Ignore Blank Lines', $iMarginH*2+ 110, $iMarginV*2+$iListViewHeight1+$iLabelHeight*2+$iListViewHeight2, 135, $iLabelHeight )
	GUICtrlSetOnEvent ( -1, '_GuiCtrlEvents' )
	$iDefaultValue = RegRead ( $sRegKeySettings, 'IgnoreBlankLines' )
	If @error Then $iDefaultValue = 1
	If $iDefaultValue = 1 Then
		GUICtrlSetState ( -1, $GUI_CHECKED )
		GUICtrlSetFont ( -1, 8.5, 600 )
	EndIf
	GUICtrlSetResizing ( -1, $GUI_DOCKBOTTOM+$GUI_DOCKHEIGHT )
;~  CheckBoxCaseSensitive
	$idCheckBoxCaseSensitive = GUICtrlCreateCheckbox ( ' Case Sensitive', $iMarginH*3+110+135, $iMarginV*2+$iListViewHeight1+$iLabelHeight*2+$iListViewHeight2, 115, $iLabelHeight )
	GUICtrlSetOnEvent ( -1, '_GuiCtrlEvents' )
	$iDefaultValue = RegRead ( $sRegKeySettings, 'CaseSensitive' )
	If @error Then $iDefaultValue = 0
	If $iDefaultValue = 1 Then
		GUICtrlSetState ( -1, $GUI_CHECKED )
		GUICtrlSetFont ( -1, 8.5, 600 )
	EndIf
	GUICtrlSetResizing ( -1, $GUI_DOCKBOTTOM+$GUI_DOCKHEIGHT )
;~  CheckBoxOnTop
	$idCheckBoxOnTop = GUICtrlCreateCheckbox ( ' OnTop', $iMarginH, $iMarginV*5+$iListViewHeight1+$iLabelHeight*2+$iListViewHeight2, 65, $iLabelHeight )
	GUICtrlSetOnEvent ( -1, '_GuiCtrlEvents' )
	$iDefaultValue = RegRead ( $sRegKeySettings, 'AlwaysOnTop' )
	If @error Then $iDefaultValue = 1
	If $iDefaultValue = 1 Then
		GUICtrlSetState ( -1, $GUI_CHECKED )
		GUICtrlSetFont ( -1, 8.5, 600 )
	EndIf
	GUICtrlSetResizing ( -1, $GUI_DOCKBOTTOM+$GUI_DOCKHEIGHT )
	WinSetOnTop ( $hGui, '', $iDefaultValue )
;~  CheckBoxListViewSynch
	$idCheckBoxListViewSynch = GUICtrlCreateCheckbox ( ' ListViews Synch', $iMarginH*2+ 110, $iMarginV*5+$iListViewHeight1+$iLabelHeight*2+$iListViewHeight2, 135, $iLabelHeight )
	GUICtrlSetOnEvent ( -1, '_GuiCtrlEvents' )
	$iDefaultValue = RegRead ( $sRegKeySettings, 'ListViewSynch' )
	If @error Then $iDefaultValue = 1
	If $iDefaultValue = 1 Then
		GUICtrlSetState ( -1, $GUI_CHECKED )
		GUICtrlSetFont ( -1, 8.5, 600 )
	EndIf
	$iSyncListView = $iDefaultValue
	GUICtrlSetResizing ( -1, $GUI_DOCKBOTTOM+$GUI_DOCKHEIGHT )
;~  ButtonSearch
	$idButtonSearch = GUICtrlCreateButton ( 'Search Differences', $iGuiWidth -$iMarginH -160, $iMarginV*5+$iListViewHeight1+$iLabelHeight*2+$iListViewHeight2 -5, 160, 26, 0x0001 ) ; $BS_DEFPUSHBUTTON
	GUICtrlSetFont ( -1, 9, 600 )
	GUICtrlSetOnEvent ( -1, '_GuiCtrlEvents' )
	GUICtrlSetResizing ( -1, $GUI_DOCKBOTTOM+$GUI_DOCKHEIGHT )
;~  ProgressBar
	$idProgressBar = GUICtrlCreateProgress ( $iListViewWidth+$iMarginH*5+100, $iMarginV*5+$iListViewHeight1+$iLabelHeight*2+$iListViewHeight2, 180, 15 )
	GUICtrlSetState ( -1, $GUI_HIDE )
	GUICtrlSetResizing ( -1, $GUI_DOCKBOTTOM+$GUI_DOCKHEIGHT )
;~  LabelDiffFound
	$idLabelDiffFound = GUICtrlCreateEdit ( '', $iListViewWidth+$iMarginH*2, $iMarginV*5+$iListViewHeight1+$iLabelHeight*2+$iListViewHeight2 -1, 100, $iLabelHeight, 2048 ) ; $ES_READONLY, $ES_RIGHT
	GUICtrlSetState ( -1, $GUI_HIDE )
	GUICtrlSetFont ( -1, 9, 600 )
	GUICtrlSetColor ( -1, 0xFF0000 )
	GUICtrlSetResizing ( -1, $GUI_DOCKBOTTOM+$GUI_DOCKHEIGHT )
;~  EditFake
	$idEditFake = GUICtrlCreateEdit ( '', $iGuiWidth, $iGuiHeight, 10, 10, BitOR ( 4, $WS_VSCROLL, $WS_HSCROLL ) ) ; $ES_MULTILINE
	GUICtrlSetState ( -1, $GUI_HIDE )
;~  Gui RegisterMsg.
	$aGuiSize = WinGetPos ( $hGui )
	GUIRegisterMsg ( $WM_GETMINMAXINFO, '_WM_GETMINMAXINFO' )
	GUIRegisterMsg ( $WM_SIZE, '_WM_SIZE' )
	GUIRegisterMsg ( $WM_NOTIFY, '_WM_NOTIFY' )
	GUIRegisterMsg ( $WM_MOVING, '_WM_MOVING' )
	GUISetState ()
	GUICtrlSetStyle ( $idListView1, $LVS_DEFAULT )
	GUICtrlSetStyle ( $idListView2, $LVS_DEFAULT )
	GUIRegisterMsg ( $WM_MEASUREITEM, '' )
	_WinEventHookRegister()
EndFunc ;==> _Gui()

Func _GuiCtrlEvents()
	Local $iValue
	Switch @GUI_CtrlId
		Case $idCheckBoxIgnoreSpaces
			$iValue = Int ( _GuiCtrlIsChecked  ( @GUI_CtrlId ) )
			RegWrite ( $sRegKeySettings, 'IgnoreSpaces', 'REG_SZ', $iValue )
			If $iValue Then
				GUICtrlSetFont ( @GUI_CtrlId, 8.5, 600 )
			Else
				GUICtrlSetFont ( @GUI_CtrlId, 8.5, 400 )
			EndIf
		Case $idCheckBoxIgnoreBlankLines
			$iValue = Int ( _GuiCtrlIsChecked  ( @GUI_CtrlId ) )
			RegWrite ( $sRegKeySettings, 'IgnoreBlankLines', 'REG_SZ', $iValue )
			If $iValue Then
				GUICtrlSetFont ( @GUI_CtrlId, 8.5, 600 )
			Else
				GUICtrlSetFont ( @GUI_CtrlId, 8.5, 400 )
			EndIf
		Case $idCheckBoxCaseSensitive
			$iValue = Int ( _GuiCtrlIsChecked  ( @GUI_CtrlId ) )
			RegWrite ( $sRegKeySettings, 'CaseSensitive', 'REG_SZ', $iValue )
			If $iValue Then
				GUICtrlSetFont ( @GUI_CtrlId, 8.5, 600 )
			Else
				GUICtrlSetFont ( @GUI_CtrlId, 8.5, 400 )
			EndIf
		Case $idCheckBoxOnTop
			$iValue = Int ( _GuiCtrlIsChecked  ( @GUI_CtrlId ) )
			RegWrite ( $sRegKeySettings, 'AlwaysOnTop', 'REG_SZ', $iValue )
			WinSetOnTop ( $hGui, '', $iValue )
			If $iValue Then
				GUICtrlSetFont ( @GUI_CtrlId, 8.5, 600 )
			Else
				GUICtrlSetFont ( @GUI_CtrlId, 8.5, 400 )
			EndIf
		Case $idCheckBoxListViewSynch
			$iValue = Int ( _GuiCtrlIsChecked  ( @GUI_CtrlId ) )
			RegWrite ( $sRegKeySettings, 'ListViewSynch', 'REG_SZ', $iValue )
			If $iValue Then
				GUICtrlSetFont ( @GUI_CtrlId, 8.5, 600 )
				$iSyncListView = 1
			Else
				GUICtrlSetFont ( @GUI_CtrlId, 8.5, 400 )
				$iSyncListView = 0
			EndIf
		Case $idButtonSearch
			If GUICtrlRead ( $idButtonSearch ) = 'Cancel Search' Then
				$iCancel = 1
				GUICtrlSetState ( $idButtonSearch, $GUI_DISABLE )
				Return
			EndIf
			If Not $sFilePath1 Or Not $sFilePath2 Then
				MsgBox ( 262144+16, 'Error', 'There is no files to compare !', 3 )
				Return
			EndIf
			GUICtrlSetState ( @GUI_CtrlId, $GUI_DISABLE )
			_FileReadToArray ( $sFilePath1, $aRead1, 0 )
			If @error Then
				MsgBox ( 262144+16, 'Error', 'File 1 can not be read !', 3 )
				GUICtrlSetState ( @GUI_CtrlId, $GUI_ENABLE )
				Return
			EndIf
			_FileReadToArray ( $sFilePath2, $aRead2, 0 )
			If @error Then
				MsgBox ( 262144+16, 'Error', 'File 2 can not be read !', 3 )
				GUICtrlSetState ( @GUI_CtrlId, $GUI_ENABLE )
				Return
			EndIf
			GUICtrlSetData ( @GUI_CtrlId, 'Cancel Search' )
			GUICtrlSetState ( @GUI_CtrlId, $GUI_ENABLE )
			$bSearch = True
	EndSwitch
EndFunc ;==> _GuiCtrlEvents()

Func _GuiCtrlGetHandleByMousePos()
	Local $g_tStruct = DllStructCreate ( $tagPOINT )
	DllStructSetData ( $g_tStruct, 'x', MouseGetPos ( 0 ) )
	DllStructSetData ( $g_tStruct, 'y', MouseGetPos ( 1 ) )
	Local $hWnd = _WinAPI_WindowFromPoint ( $g_tStruct )
	If @error Then Return SetError ( 1, 0, 0 )
	$g_tStruct = 0
	Return SetError ( 0, 0, $hWnd )
EndFunc ;==> _GuiCtrlGetHandleByMousePos()

Func _GuiCtrlGetIdByHandle ( $hWnd )
	If IsHWnd ( $hWnd ) Then Return _WinAPI_GetDlgCtrlID ( $hWnd )
EndFunc ;==> _GuiCtrlGetIdByHandle()

Func _GuiCtrlIsChecked ( $idCtrl )
	Return BitAND ( GUICtrlRead ( $idCtrl ), $GUI_CHECKED ) = $GUI_CHECKED
EndFunc ;==> _GuiCtrlIsChecked()

Func _GuiCtrlListView_AddOutLineToRow ( $hWnd, $iIndex, $sColor=0xFF0000, $iLineWidth=2 )
	If Not IsHWnd ( $hWnd ) Then $hWnd = GUICtrlGetHandle ( $hWnd )
	If $iLineWidth < 1 Then $iLineWidth = 1
	If $iLineWidth > 2 Then $iLineWidth = 2
	Local $aRect = _GUICtrlListView_GetItemRect ( $hWnd, $iIndex, 0 ) ; 2 = select nb, 1 = ?, 0 = all the line row, 3 = all the line row
	If UBound ( $aRect ) < 4 Then Return SetError ( 1, 0, 0 )
	Local $hDC = DllCall ( 'user32.dll', 'handle', 'GetDC', 'hwnd', $hWnd )
	Local $aPen = DllCall ( 'gdi32.dll', 'handle', 'CreatePen', 'int', 0, 'int', $iLineWidth, 'INT', $sColor )
	DllCall ( 'gdi32.dll', 'handle', 'SelectObject', 'handle', $hDC[0], 'handle', $aPen[0] )
	DllCall ( 'gdi32.dll', 'bool', 'MoveToEx', 'handle', $hDC[0], 'int', $aRect[0], 'int', $aRect[1], 'ptr', 0 )
	Local $i = 0
	Do
		$i+=1
		DllCall ( 'gdi32.dll', 'bool', 'LineTo', 'handle', $hDC[0], 'int', $aRect[2], 'int', $aRect[1] - $i +1 )
		DllCall ( 'gdi32.dll', 'bool', 'LineTo', 'handle', $hDC[0], 'int', $aRect[2], 'int', $aRect[3] - $i +1 )
		DllCall ( 'gdi32.dll', 'bool', 'LineTo', 'handle', $hDC[0], 'int', $aRect[0] + $i -1, 'int', $aRect[3] )
		DllCall ( 'gdi32.dll', 'bool', 'LineTo', 'handle', $hDC[0], 'int', $aRect[0] + $i -1, 'int', $aRect[1] )
	Until $i = $iLineWidth
	DllCall ( 'user32.dll', 'int', 'ReleaseDC', 'hwnd', $hWnd, 'handle', $hDC[0] )
	DllCall ( 'gdi32.dll', 'bool', 'DeleteObject', 'handle', $aPen[0] )
EndFunc ;==> _GuiCtrlListView_AddOutLineToRow()

Func _GuiCtrlReDraw ( $hWnd )
	If Not IsHWnd ( $hWnd ) Then $hWnd = GUICtrlGetHandle ( $hWnd )
	DllCall ( 'user32.dll', 'bool', 'RedrawWindow', 'hwnd', $hWnd, 'struct*', 0, 'handle', 0, 'uint', 5 )
EndFunc ;==> _GuiCtrlReDraw()

Func _GuiEventDropped ()
	If Not @GUI_DragFile Then Return
	Local $u11 = $a1[0]
	Local $u12 = $a1[ UBound ( $a1 ) -1]
	Local $u21 = $a2 [0]
	Local $u22 = $a2 [UBound ( $a2 ) -1]
	$a1 = 0
	$a2 = 0
	Dim $a1[1], $a2[1]
	Local $i
	Switch @GUI_DropId
		Case $idLabelDrop1
			$i = 1
			_GUICtrlListView_RedrawItems ( $hListView2, $u21, $u22 )
			$hListViewToRedraw = $hListView2
		Case $idLabelDrop2
			$i = 2
			_GUICtrlListView_RedrawItems ( $hListView1, $u11, $u12 )
			$hListViewToRedraw = $hListView1
		Case Else
			Return
	EndSwitch
	Local $idListView
	If IsDeclared ( 'idListView' & $i ) Then
		$idListView = Eval ( 'idListView' & $i )
	Else
		Return
	EndIf
	GUICtrlSetState ( $idListView, $GUI_HIDE )
	Local $idLabel, $idLabelLineCount, $idLabelFilePath
	If IsDeclared ( 'idLabelGreyedTxt' & $i ) Then
		$idLabel = Eval ( 'idLabelGreyedTxt' & $i )
	Else
		Return
	EndIf
	If IsDeclared ( 'idLabelLineCount' & $i ) Then
		$idLabelLineCount = Eval ( 'idLabelLineCount' & $i )
	Else
		Return
	EndIf
	If IsDeclared ( 'idLabelFilePath' & $i ) Then
		$idLabelFilePath = Eval ( 'idLabelFilePath' & $i )
	Else
		Return
	EndIf
	Local $sFilePath = @GUI_DragFile
	If IsDeclared ( 'sFilePath' & $i ) Then
		Assign ( 'sFilePath' & $i, $sFilePath, 2 )
	Else
		Return
	EndIf
	ControlSetText ( $hGui, '', $idLabel, 'Loading File...' )
	GUICtrlSetState ( $idLabel, $GUI_SHOW )
	_GUICtrlListView_DeleteAllItems ( $idListView )
	AdlibUnRegister ( '_LabelFlash' )
	$idLabelFlash = 0
	$bState = False
	GUICtrlSetColor ( $idLabelFilePath, 0xFF0000 )
	GUICtrlSetFont ( $idLabelFilePath, 9, 600 )
	GUICtrlSetState ( $idLabelFilePath1, $GUI_SHOW )
	GUICtrlSetState ( $idLabelFilePath2, $GUI_SHOW )
	ControlSetText ( $hGui, '', $idLabelNoMatchCount1, 'Text 1, Lines not found in Text 2' )
	ControlSetText ( $hGui, '', $idLabelNoMatchCount2, 'Text 2, Lines not found in Text 1' )
	ControlSetText ( $hGui, '', $idLabelDiffFound, '' )
	ControlSetText ( $hGui, '', $idLabelFilePath, '' )
	Local $sErrorMsg
	Local $sText = FileRead ( $sFilePath )
	If @error Then $sErrorMsg = 'File can not be read'
	If Not $sErrorMsg Then
		Local $iLineCount = _FileCountLines ( $sFilePath )
		If @error Or Not $iLineCount Then $sErrorMsg = 'File is empty'
		If Not $sErrorMsg Then
			ControlSetText ( $hGui, '', $idEditFake, '' ) ; LabelDropFake hidden control used for check text/file type.
			ControlSetText ( $hGui, '', $idEditFake, $sText )
			Local $sReadFakeEdit = GUICtrlRead ( $idEditFake )
			If ( $iLineCount > 1 And StringInStr ( $sReadFakeEdit, @CR ) + StringInStr ( $sReadFakeEdit, @LF ) = 0 ) Or _
				( StringLeft ( $sText, 4 ) = 'ÿÿÿÿ' ) Or _
				( IsBinary ( $sText ) ) Or _ ; since Beta v3.3.13.19.
				( StringInStr ( $sText, Chr ( 1 ) ) <> 0 ) Or _
				( StringLen ( $sReadFakeEdit ) = 0 ) Then $sErrorMsg = 'Invalid Text file'
		EndIf
	EndIf
	_GUICtrlListView_DeleteAllItems ( $hListView3 )
	_GUICtrlListView_DeleteAllItems ( $hListView4 )
	If $sErrorMsg Then
		AdlibRegister ( '_LabelFlash', 1200 )
		ControlSetText ( $hGui, '', $idLabelFilePath, $sErrorMsg )
		GUICtrlSetColor ( $idLabelFilePath, 0xFF0000 )
		GUICtrlSetFont ( $idLabelFilePath, 11, 800 )
		$idLabelFlash = $idLabelFilePath
		ControlSetText ( $hGui, '', $idLabel, 'Drag and Drop Text File ' & $i & ' Here' )
		GUICtrlSetState ( $idLabel, $GUI_SHOW )
		Assign ( 'sFilePath' & $i, '', 2 )
		ControlSetText ( $hGui, '', $idLabelLineCount, '' )
		_GUICtrlListView_SetBkImage ( $hListView3, $sImageBk, 0, 50, 50 )
		_GUICtrlListView_SetBkImage ( $hListView4, $sImageBk, 0, 50, 50 )
		Return
	EndIf
	Local $aTextSplit = StringSplit ( $sText, @CR, 1+2 )
	If UBound ( $aTextSplit ) -1 = 0 Then $aTextSplit = StringSplit ( $sText, @LF, 1+2 )
	If UBound ( $aTextSplit ) -1 = 0 Then $aTextSplit[0] = $sText
	_GUICtrlListView_BeginUpdate ( $idListView )
	For $i = 0 To $iLineCount -1
		_GUICtrlListView_AddItem ( $idListView, $i+1, $i )
		_GUICtrlListView_AddSubItem ( $idListView, $i, $aTextSplit[$i], 1 )
	Next
	_GUICtrlListView_EndUpdate ( $idListView )
	GUICtrlSetState ( $idListView, $GUI_SHOW )
	GUICtrlSetState ( $idLabel, $GUI_HIDE )
	ControlSetText ( $hGui, '', $idLabel, 'Drag and Drop Text File ' & $i & ' Here' )
	ControlSetText ( $hGui, '', $idLabelFilePath, _FileCompactPath ( $sFilePath, 50 ) )
	ControlSetText ( $hGui, '', $idLabelLineCount, $iLineCount & ' Line' & Chr ( -28*( $iLineCount <> 1 )+143 ) )
EndFunc ;==> _GuiEventDropped()

Func _GuiNoEvent()
	; do nothing on event.
EndFunc ;==> _GuiNoEvent()

Func _GuiSavePos()
	Local $aPos = WinGetPos ( $hGui )
	If Not @error And Not _WindowIsMinimized ( $hGui ) Then
		RegWrite ( $sRegKeySettings, 'X', 'REG_SZ', _Min ( _Max ( $aPos[0], 0 ), @DesktopWidth - $aPos[2] ) )
		RegWrite ( $sRegKeySettings, 'Y', 'REG_SZ', _Min ( _Max ( $aPos[1], 0 ), @DesktopHeight - $aPos[3] ) )
	EndIf
EndFunc ;==> _GuiSavePos()

Func _LabelFlash()
	$bState = Not $bState
	If $idLabelFlash Then
		If $bState Then
			GUICtrlSetState ( $idLabelFlash, $GUI_HIDE )
		Else
			GUICtrlSetState ( $idLabelFlash, $GUI_SHOW )
		EndIf
	EndIf
EndFunc ;==> _LabelFlash()

Func _LzntDecompress ( $bBinary ); by trancexx
	$bBinary = Binary ( $bBinary )
	Local $tInput = DllStructCreate ( 'byte[' & BinaryLen ( $bBinary ) & ']' )
	DllStructSetData ( $tInput, 1, $bBinary )
	Local $tBuffer = DllStructCreate ( 'byte[' & 16*DllStructGetSize ( $tInput ) & ']' )
	Local $a_Call = DllCall ( 'ntdll.dll', 'int', 'RtlDecompressBuffer', 'ushort', 2, 'ptr', DllStructGetPtr ( $tBuffer ), 'dword', DllStructGetSize ( $tBuffer ), 'ptr', DllStructGetPtr ( $tInput ), 'dword', DllStructGetSize ( $tInput ), 'dword*', 0 )
	If @error Or $a_Call[0] Then Return SetError ( 1, 0, '' )
	Local $tOutput = DllStructCreate ( 'byte[' & $a_Call[6] & ']', DllStructGetPtr ( $tBuffer ) )
	Return SetError ( 0, 0, DllStructGetData ( $tOutput, 1 ) )
EndFunc ;==> _LzntDecompress()

Func _Max ( $nNum1, $nNum2 )
	If Not IsNumber ( $nNum1 ) Then Return SetError ( 1, 0, 0 )
	If Not IsNumber ( $nNum2 ) Then Return SetError ( 2, 0, 0 )
	If $nNum1 > $nNum2 Then
		Return $nNum1
	Else
		Return $nNum2
	EndIf
EndFunc ;==> _Max()

Func _Min ( $nNum1, $nNum2 )
	If ( Not IsNumber ( $nNum1 ) ) Then Return SetError ( 1, 0, 0 )
	If ( Not IsNumber ( $nNum2 ) ) Then Return SetError ( 2, 0, 0 )
	If $nNum1 > $nNum2 Then
		Return $nNum2
	Else
		Return $nNum1
	EndIf
EndFunc ;==> _Min()

Func _OnAutoItExit()
	_WinEventHookUnRegister()
EndFunc ;==> _OnAutoItExit()

Func _ScriptGetVersion()
	Local $sFileVersion
	If @Compiled Then
		$sFileVersion = FileGetVersion ( @ScriptFullPath, 'FileVersion' )
	Else
		$sFileVersion = _StringBetween ( FileRead ( @ScriptFullPath ), '#AutoIt3Wrapper_Res_Fileversion=', @CR )
		If Not @error Then
			$sFileVersion = $sFileVersion[0]
		Else
			$sFileVersion = '0.0.0.0'
		EndIf
	EndIf
	Return $sFileVersion
EndFunc ;==> _ScriptGetVersion()

Func _ScriptIsAlreadyRunning()
	Local $a = WinList ( AutoItWinGetTitle () )
	If Not @error Then Return UBound ( $a ) -1 > 1
EndFunc ;==> _ScriptIsAlreadyRunning ()

Func _StringBetween ( $s_String, $s_Start, $s_End, $v_Case = -1 )
	Local $s_case = ''
	If $v_Case = Default Or $v_Case = -1 Then $s_case = '(?i)'
	Local $s_pattern_escape = '(\.|\||\*|\?|\+|\(|\)|\{|\}|\[|\]|\^|\$|\\)'
	$s_Start = StringRegExpReplace ( $s_Start, $s_pattern_escape, '\\$1' )
	$s_End = StringRegExpReplace ( $s_End, $s_pattern_escape, '\\$1' )
	If $s_Start = '' Then $s_Start = '\A'
	If $s_End = '' Then $s_End = '\z'
	Local $a_ret = StringRegExp ( $s_String, '(?s)' & $s_case & $s_Start & '(.*?)' & $s_End, 3 )
	If @error Then Return SetError ( 1, 0, 0 )
	Return $a_ret
EndFunc ;==> _StringBetween()

Func _TextDiff ( $aText1, $aText2, $iIgnoreSpaces=1, $iIgnoreBlankLines=1, $iCase=0, $iShowProgress=1 )
	ProcessSetPriority ( @AutoItPID, 0 )
	Local $u1 = UBound ( $aText1 ) -1, $u2 = UBound ( $aText2 ) -1
	Local $max = $u1
	If $u2 > $u1 Then $max = $u2
	Local $aTmp1 = $aText1, $aTmp2 = $aText2
	If $iIgnoreSpaces Then
		For $i = 0 To $max
			If $i <= $u1 Then $aTmp1[$i] = StringStripWS ( $aTmp1[$i], 8 ); remove all spaces.
			If $i <= $u2 Then $aTmp2[$i] = StringStripWS ( $aTmp2[$i], 8 ); remove all spaces.
		Next
	EndIf
	If $iShowProgress Then
		GUICtrlSetData ( $idProgressbar, 0 )
		GUICtrlSetState ( $idProgressBar, $GUI_SHOW )
	EndIf
	Local $aDiff[1][4]
	Local $iPercent, $iPercentOld = 0, $r1 = 0, $r2 = 0
	For $i = 0 To $max
		If $iCancel Then ExitLoop
		If $i <= $u1 Then
			If _ArraySearch ( $aTmp2, $aTmp1[$i], 0, 0, $iCase, 1 ) = -1 Then
				If StringIsSpace ( $aTmp1[$i] ) Then
					If Not $iIgnoreBlankLines Then
						If $r1 > UBound ( $aDiff ) -1 Then ReDim $aDiff[$r1+1][4]
						$aDiff[$r1][0] = $aText1[$i]
						$aDiff[$r1][2] = $i+1
;~                      ConsoleWrite ( '!!!!!! Text 1, Line ' & $i +1 & ' is not in Text 2 : ' & $aText1[$i] & @Crlf )
						$r1 +=1
					Else
					EndIf
				Else
					If $r1 > UBound ( $aDiff ) -1 Then ReDim $aDiff[$r1+1][4]
					$aDiff[$r1][0] = $aText1[$i]
					$aDiff[$r1][2] = $i+1
;~                  ConsoleWrite ( '!!!!!! Text 1, Line ' & $i +1 & ' is not in Text 2 : ' & $aText1[$i] & @Crlf )
					$r1 +=1
				EndIf
			EndIf
		EndIf
		If $i <= $u2 Then
			If _ArraySearch ( $aTmp1, $aTmp2[$i], 0, 0, $iCase, 1 ) = -1 Then
				If StringIsSpace ( $aTmp2[$i] ) Then
					If Not $iIgnoreBlankLines Then
						If $r2 > UBound ( $aDiff ) -1 Then ReDim $aDiff[$r2+1][4]
						$aDiff[$r2][1] = $aText2[$i]
						$aDiff[$r2][3] = $i+1
;~                      ConsoleWrite ( '>>>>> Text 2, Line ' & $i +1 & ' is not in Text 1 : ' & $aText2[$i] & @Crlf )
						$r2 +=1
					EndIf
				Else
					If $r2 > UBound ( $aDiff ) -1 Then ReDim $aDiff[$r2+1][4]
					$aDiff[$r2][1] = $aText2[$i]
					$aDiff[$r2][3] = $i+1
;~                  ConsoleWrite ( '>>>>> Text 2, Line ' & $i +1 & ' is not in Text 1 : ' & $aText2[$i] & @Crlf )
					$r2 +=1
				EndIf
			EndIf
		EndIf
		If $iShowProgress Then
			$iPercent = Round ( $i*100/$max, 1 )
			If $iPercent > $iPercentOld Then
				GUICtrlSetData ( $idProgressbar, $iPercent )
				ControlSetText ( $hGui, '', $idLabelDiffFound, 'Diff : ' & $r1+$r2 )
				$iPercentOld = $iPercent+1
			EndIf
		EndIf
		Sleep ( 10 ) ; limit cpu.
	Next
	If $iShowProgress Or $iCancel Then
		ControlSetText ( $hGui, '', $idLabelDiffFound, 'Diff : ' & $r1+$r2 )
		If Not $iCancel Then
			GUICtrlSetData ( $idProgressbar, 100 )
			Sleep ( 1000 )
		Else
			ControlSetText ( $hGui, '', $idLabelDiffFound, '' )
		EndIf
		GUICtrlSetState ( $idProgressbar, $GUI_HIDE )
		GUICtrlSetData ( $idProgressbar, 0 )
	EndIf
	ProcessSetPriority ( @AutoItPID, 2 )
;~  return a 4DArray.
;~  column 1 : text line of file 1 not found in file 2
;~  column 2 : text line of file 2 not found in file 1
;~  column 3 : line number of corresponding row in file 1
;~  column 4 : line number of corresponding row in file 2
	Return $aDiff
EndFunc ;==> _TextDiff()

Func _WindowIsMinimized ( $hWnd )
	If BitAnd ( WinGetState ( $hWnd ), 16 ) Then Return 1
EndFunc ;==> _WindowIsMinimized()

Func _WinEventHook ( $hHook, $iEvent, $hWnd, $iObjectID )
	#forceref $hHook, $iEvent, $hWnd, $iObjectID
	Switch $hWnd
		Case $hListView1, $hListView2
			If Not $iSyncListView Then Return
;~ 			If $hWnd <> _GuiCtrlGetHandleByMousePos() Then Return
			Local $aRet1, $aRet2, $x, $y, $iScroll = 1, $hList = $hListView1
			If $hWnd = $hListView1 Then $hList = $hListView2
			If Not _GUICtrlListView_GetItemCount ( $hList ) Then Return
			Switch $iEvent
				Case 0x00000012 ; $EVENT_SYSTEM_SCROLLINGSTART
;~ 					_GuiCtrlReDraw ( $hList )
				Case 0x00000013 ; $EVENT_SYSTEM_SCROLLINGEND
					_GUICtrlListView_EnsureVisible ( $hList, _GUICtrlListView_GetTopIndex ( $hWnd ), False )
				Case 0x0000800E ; $EVENT_OBJECT_VALUECHANGE
					Switch $iObjectID
						Case 0xFFFFFFFB, 0xFFFFFFFA	; $OBJID_VSCROLL, $OBJID_HSCROLL
							If $iObjectID = 0xFFFFFFFA Then $iScroll = 0
							While 1
								$aRet1 = DllCall ( 'user32.dll', 'int', 'GetScrollPos', 'hwnd', $hWnd, 'int', $iScroll )  ; $SB_VERT or $SB_HORZ
								$aRet2 = DllCall ( 'user32.dll', 'int', 'GetScrollPos', 'hwnd', $hList, 'int', $iScroll ) ; $SB_VERT or $SB_HORZ
								If $aRet1[0] = $aRet2[0] Then ExitLoop
								If $iScroll Then ; vertical
									If _GUICtrlListView_GetTopIndex ( $hWnd ) + _GUICtrlListView_GetCounterPage ( $hWnd ) > _GUICtrlListView_GetItemCount ( $hList ) Then ExitLoop
									$x = 0
									$y = ( $aRet1[0] - $aRet2[0] )* $itemHeight
								Else ; horizontal
									_GUICtrlListView_SetColumnWidth ( $hList, 1, _GUICtrlListView_GetColumnWidth ( $hWnd, 1 ) )
									$x = $aRet1[0] - $aRet2[0]
									$y = 0
								EndIf
								_SendMessage ( $hList, $LVM_SCROLL, $x, $y )
								If Not $iScroll Then ExitLoop
							WEnd
					EndSwitch
			EndSwitch
	EndSwitch
EndFunc ;==> _WinEventHook()

Func _WinEventHookRegister()
	$hProc = DllCallbackRegister ( '_WinEventHook', 'none', 'ptr;dword;hwnd;long' )
	Local $aRet = DllCall ( 'user32.dll', 'handle', 'SetWinEventHook', 'uint', 0x00000012, 'uint', 0x0000800E, 'ptr', 0, 'ptr', DllCallbackGetPtr ( $hProc ), 'dword', @AutoItPID, 'dword', 0, 'uint', 0 ) ; $EVENT_SYSTEM_SCROLLINGSTART,  $EVENT_OBJECT_VALUECHANGE
	If Not @error And IsArray ( $aRet ) Then $hHook = $aRet[0]
EndFunc ;==> _WinEventHookRegister()

Func _WinEventHookUnRegister()
	If $hHook Then DllCall ( 'user32.dll', 'bool', 'UnhookWinEvent', 'handle', $hHook )
	DllCallbackFree ( $hProc )
EndFunc ;==> _WinEventHookUnRegister()

Func _WM_GETMINMAXINFO ( $hWnd, $iMsg, $wParam, $lParam )
	#forceref $hWnd, $iMsg, $wParam, $lParam
	Local $sMinMaxInfo
	Switch $hWnd
		Case $hGui
			$sMinMaxInfo = DllStructCreate ( 'int;int;int;int;int;int;int;int;int;int', $lParam )
			If Not @error Then
				DllStructSetData ( $sMinMaxInfo, 7, $aGuiSize[2] )     ; min width
				DllStructSetData ( $sMinMaxInfo, 8, $aGuiSize[3] )     ; min height
				DllStructSetData ( $sMinMaxInfo, 9, @DesktopWidth )    ; max width
				DllStructSetData ( $sMinMaxInfo, 10, @DesktopHeight )  ; max height
			EndIf
	EndSwitch
	Return $GUI_RUNDEFMSG
EndFunc ;==> _WM_GETMINMAXINFO()

Func _WM_MEASUREITEM ( $hWnd, $iMsg, $wParam, $lParam )
	#forceref $hWnd, $iMsg, $wParam, $lParam
	Local $tMEASUREITEMS = DllStructCreate ( 'uint cType;uint cID;uint itmID;uint itmW;uint itmH;ulong_ptr itmData', $lParam )
	$itemHeight = DllStructGetData ( $tMEASUREITEMS, 'itmH', 1 )
	Return $GUI_RUNDEFMSG
EndFunc ;==> _WM_MEASUREITEM()

Func _WM_MOVING()
	_GuiSavePos()
EndFunc ;==> _WM_MOVING()

Func _WM_NOTIFY ( $hWnd, $iMsg, $wParam, $lParam )
	#forceref $hWnd, $iMsg, $wParam, $lParam
	Local $tNMHDR, $iCode, $hWndFrom, $tDraw, $iDrawStage, $iItemSpec
	$tNMHDR = DllStructCreate ( $tagNMHDR, $lParam )
	$iCode = DllStructGetData ( $tNMHDR, 'Code' )
	$hWndFrom = DllStructGetData ( $tNMHDR, 'hWndFrom' )
	$tDraw = DllStructCreate ( $tagNMLVCUSTOMDRAW, $lParam )
	Switch $hWndFrom
		Case $hListView1, $hListView2
			Switch $iCode
				Case $NM_CUSTOMDRAW
					$iDrawStage = DllStructGetData ( $tDraw, 'dwDrawStage' )
					$iItemSpec = DllStructGetData ( $tDraw, 'dwItemSpec' )
					DllStructSetData ( $tDraw, 'clrText', 0x0000FF*( DllStructGetData ( $tDraw, 'iSubItem' ) = 0 ) )
					Switch $iDrawStage
						Case $CDDS_PREPAINT
							Return $CDRF_NOTIFYITEMDRAW
						Case $CDDS_ITEMPREPAINT
							If ( UBound ( $a1 ) > 0 Or UBound ( $a2 ) > 0 ) Then
								If $a1[0] And $a2[0] Then
									Local $a
									If $hWndFrom = $hListView1 Then
										$a = $a1
									ElseIf $hWndFrom = $hListView2 Then
										$a = $a2
									EndIf
									Local $iIndex = _ArraySearch ( $a, $iItemSpec +1, 0, 0, 0, 0 )
									If $iIndex <> -1 Then
										If $bSearch Then
											DllStructSetData ( $tDraw, 'clrTextBk', 0xFFFFFF ) ; $CLR_WHITE
										Else
											DllStructSetData ( $tDraw, 'clrTextBk', 0x98E3FC ) ; 0xFF8000 ) ; 0x17CCFB ) ; 0x17FBCC ) ;$CLR_RED ) ;$CLR_AQUA )
										EndIf
									Else
										DllStructSetData ( $tDraw, 'clrTextBk', 0xFFFFFF ) ; $CLR_WHITE
									EndIf
								Else
									DllStructSetData ( $tDraw, 'clrTextBk', 0xFFFFFF ) ; $CLR_WHITE
								EndIf
							Else
								DllStructSetData ( $tDraw, 'clrTextBk', 0xFFFFFF ) ; $CLR_WHITE
							EndIf
							Return $CDRF_NOTIFYSUBITEMDRAW
					EndSwitch
				Case $NM_CLICK
					_GuiCtrlReDraw ( $hWndFrom )
			EndSwitch
		Case $hListView3, $hListView4
			Local $tInfo = DllStructCreate ( $tagNMLISTVIEW, $lParam )
			Local $iItem = DllStructGetData ( $tInfo, 'Item' )
			Local $iSelectedItem, $iPageCount, $hListView = $hListView1
			Switch $iCode
				Case $NM_CUSTOMDRAW
					DllStructSetData ( $tDraw, 'clrText', 0x0000FF*( DllStructGetData ( $tDraw, 'iSubItem' ) = 0 ) )
					Return $CDRF_NOTIFYSUBITEMDRAW
				Case $NM_DBLCLK
					If $iItem >= 0 Then
						If $hWndFrom = $hListView4 Then $hListView = $hListView2
						$iSelectedItem = _GUICtrlListView_GetItemText ( $hWndFrom, _GUICtrlListView_GetSelectedIndices ( $hWndFrom ), 0 )
						; display the selection to the middle of the listview.
						$iPageCount = _GUICtrlListView_GetCounterPage ( $hListView )
						_GUICtrlListView_EnsureVisible ( $hListView, $iSelectedItem -1 - $iPageCount/2, True )
						_GUICtrlListView_EnsureVisible ( $hListView, $iSelectedItem -1 + $iPageCount/2, True )
						_GUICtrlListView_EnsureVisible ( $hListView, $iSelectedItem -1, True )
						_GuiCtrlReDraw ( $hListView )
						Local $hList = $hListView1
						If $hListView = $hListView1 Then $hList = $hListView2
						If $iSyncListView = 1 Then
							_GUICtrlListView_EnsureVisible ( $hList, $iSelectedItem -1 - $iPageCount/2, True )
							_GUICtrlListView_EnsureVisible ( $hList, $iSelectedItem -1 + $iPageCount/2, True )
							_GUICtrlListView_EnsureVisible ( $hList, $iSelectedItem -1, True )
						EndIf
						_GuiCtrlReDraw ( $hList )
						$hListViewClicked = $hListView
						$iDblClick = $iSelectedItem
					EndIf
			EndSwitch
	EndSwitch
	Return $GUI_RUNDEFMSG
EndFunc ;==> _WM_NOTIFY()

Func _WM_SIZE ( $hWnd, $iMsg, $wParam, $lParam )
	#forceref $hWnd, $iMsg, $wParam, $lParam
	GUIRegisterMsg ( $WM_NOTIFY, '' )
	Local $aPos, $idListView
	For $i = 1 To 4
		$aPos = ControlGetPos ( $hGui, '', Eval ( 'idLabelDrop' & $i ) )
		If Not @error Then
			$idListView = Eval ( 'idListView' & $i )
			ControlMove ( $hGui, '', $idListView, $aPos[0], $aPos[1], $aPos[2], $aPos[3] )
			_GUICtrlListView_SetColumnWidth ( $idListView, 0, 40 )
			_GUICtrlListView_SetColumnWidth ( $idListView, 1, $iListviewColumn1Width )
		EndIf
	Next
	_GuiSavePos ()
	GUIRegisterMsg ( $WM_NOTIFY, '_WM_NOTIFY' )
	Return $GUI_RUNDEFMSG
EndFunc ;==> _WM_SIZE()

Func Textdiff1Ico ( $sFileName, $sOutputDirPath, $iOverWrite=0 ) ; Code Generated by BinaryToAu3Kompressor.
	Local $sFileBin = '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'
	$sFileBin = Binary ( _Base64Decode ( $sFileBin ) )
	$sFileBin = Binary ( _LzntDecompress ( $sFileBin ) )
	If Not FileExists ( $sOutputDirPath ) Then DirCreate ( $sOutputDirPath )
	If StringRight ( $sOutputDirPath, 1 ) <> '\' Then $sOutputDirPath &= '\'
	Local $sFilePath = $sOutputDirPath & $sFileName
	If FileExists ( $sFilePath ) Then
		If $iOverWrite = 1 Then
			If Not Filedelete ( $sFilePath ) Then Return SetError ( 2, 0, $sFileBin )
		Else
			Return SetError ( 0, 0, $sFileBin )
		EndIf
	EndIf
	Local $hFile = FileOpen ( $sFilePath, 16+2 )
	If $hFile = -1 Then Return SetError ( 3, 0, $sFileBin )
	FileWrite ( $hFile, $sFileBin )
	FileClose ( $hFile )
	Return SetError ( 0, 0, $sFileBin )
EndFunc ;==> Textdiff1Ico()