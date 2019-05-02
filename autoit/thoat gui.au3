#include <WindowsConstants.au3>
#include <GUIConstants.au3>

$hGUI = GUICreate("Test", 100, 100)
$hButton1 = GUICtrlCreateButton("Chạy vòng lặp", 10, 10, 80, 30)
$hButton2 = GUICtrlCreateButton("Ngắt vòng lặp", 10, 50, 80, 30)
GUISetState()

#Region Định nghĩa và gán các Button muốn dùng để ngắt vòng lặp
    $Interrupt = 0
    GUIRegisterMsg($WM_COMMAND, "_WM_COMMAND_BUTTON")
    Func _WM_COMMAND_BUTTON($hWnd, $Msg, $wParam, $lParam)
        Switch BitAND($wParam, 0x0000FFFF)
            Case $hButton2
                $Interrupt = 1
                ;Case $hButtonX
                ;    .....
        EndSwitch
        Return 'GUI_RUNDEFMSG'
    EndFunc
#EndRegion

#Region Tắt GUI khi vẫn còn đang chạy vòng lặp
    GUIRegisterMsg($WM_SYSCOMMAND, "_WM_COMMAND_CLOSEBUTTON")
    Func _WM_COMMAND_CLOSEBUTTON($hWnd, $Msg, $wParam, $lParam)
        If BitAND($wParam, 0x0000FFFF) = 0xF060 Then Exit
        Return 'GUI_RUNDEFMSG'
    EndFunc
#EndRegion


While Sleep(10)
    Switch GUIGetMsg()
        Case -3
            Exit
        Case $hButton1
            $Interrupt = 0
            Do
                ConsoleWrite("Dang Loop: " & Random() & @CRLF)
                Sleep(100)
            Until $Interrupt <> 0
            ConsoleWrite("!Loop bi ngat boi Button2" & @CRLF)
    EndSwitch
WEnd