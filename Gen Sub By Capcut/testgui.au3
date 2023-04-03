#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>

Global $Form1 = GUICreate("Form1", 623, 444, 192, 114)
Global $StartButton = GUICtrlCreateButton("Start", 88, 192, 171, 25)
Global $EndButton = GUICtrlCreateButton("Stop", 320, 192, 203, 25)
GUICtrlSetState($EndButton, $GUI_DISABLE)

GUISetState(@SW_SHOW)

GUIRegisterMsg($WM_COMMAND, "_WM_COMMAND")

Global $bInterrupt = False

While 1
    Switch GUIGetMsg()
        Case $GUI_EVENT_CLOSE
            Exit
        Case $StartButton
            Start()
    EndSwitch
WEnd

Func Start()
    $bInterrupt = False
    GUICtrlSetState($StartButton, $GUI_DISABLE)
    GUICtrlSetState($EndButton, $GUI_ENABLE)

    For $x = 1 to 1000
        If $bInterrupt = False Then
            Sleep(500)
            ConsoleWrite("again " & $x & @CRLF)
        EndIf

    Next

    GUICtrlSetState($StartButton, $GUI_ENABLE)
    GUICtrlSetState($EndButton, $GUI_DISABLE)
    $bInterrupt = False
EndFunc   ;==>Start

Func _WM_COMMAND($hWnd, $Msg, $wParam, $lParam)
    ; The Stop button was pressed so set the flag
    If BitAND($wParam, 0x0000FFFF) = $EndButton Then
        $bInterrupt = True
    EndIf
    Return $GUI_RUNDEFMSG
EndFunc   ;==>_WM_COMMAND