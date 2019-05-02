#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Icon=..\..\Downloads\ping_256x256_Mdt_icon.ico
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#include <file.au3>
#include <ButtonConstants.au3>
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
#Region ### START Koda GUI section ### Form=
$GUI = GUICreate("Ping Test", 282, 234, 350, 140)
GUISetFont(12, 400, 0, "Tahoma")
GUICtrlCreateLabel("Địa chỉ IP", 104, 8, 72, 23)
$list_ip = GUICtrlCreateEdit("", 24, 40, 233, 129, BitOR($ES_AUTOVSCROLL,$ES_WANTRETURN,$WS_VSCROLL))
$ping_bt_button = GUICtrlCreateButton("Ping Kiểm Tra", 24, 184, 115, 33)
$ping_t_button = GUICtrlCreateButton("Ping -t", 144, 184, 115, 33)
GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###

Dim $line

$file = FileOpen("List_IP.txt",0); mở file text
kiem_tra_file_txt()
AutoItSetOption("WinTitleMatchMode",2);chuyen ve mode 2 cua tittle

While 1
	$nMsg = GUIGetMsg()
	Switch $nMsg
		Case $GUI_EVENT_CLOSE
			FileClose($file)
			FileDelete(@ScriptDir&"\List_IP.txt")
			FileWriteLine(@ScriptDir&"\List_IP.txt",GUICtrlRead($list_ip))
			FileClose($file)
			Exit
		Case $ping_bt_button
			If FileRead($file) <> GUICtrlRead($list_ip) Then
				lay_gia_tri_input_moi()
				ping_bt()
			Else
				ping_bt()
			EndIf
		Case $ping_t_button
			If FileRead($file) <> GUICtrlRead($list_ip) Then
				lay_gia_tri_input_moi()
				ping_t()
			Else
				ping_t()
			EndIf
	EndSwitch
WEnd

Func lay_gia_tri_input_moi();lấy giá trị vừa nhập vào inputbox rồi lưu vào file txt
	FileClose($file)
	FileDelete(@ScriptDir&"\List_IP.txt")
	FileWriteLine(@ScriptDir&"\List_IP.txt",GUICtrlRead($list_ip))
	$file = FileOpen("List_IP.txt",0)
EndFunc
Func ping_bt();ping kiểu mặc định
	FileSetPos($file,0,0);đưa con trỏ về đầu file text
	While 1
	$line = FileReadLine($file);đọc từ dòng file text
    If @error = -1 Then ExitLoop(1) ;đọc hết file thì thoát
	Run(@ComSpec & ' /c ping ' & $line);run lệnh com
	sleep(2000)
	WEnd
EndFunc

Func ping_t();ping kiểu -t
	FileSetPos($file,0,0);đưa con trỏ về đầu file text
	While 1
	$line = FileReadLine($file);đọc từ dòng file text
    If @error = -1 Then ExitLoop(1) ;đọc hết file thì thoát
	$a=Run(@ComSpec & ' /c ping ' & $line &" -t");run lệnh com
	MsgBox(0,0,$a)
	Sleep(1000)
	WEnd
EndFunc

Func kiem_tra_file_txt();kiểm tra xem đã có tồn tại file lisIP.txt chưa
	If $file = -1 Then
		;MsgBox(0,0,"chua co file txt")
		GUICtrlSetData($list_ip,"Vui lòng nhập địa chỉ IP")
	Else
		GUICtrlSetData($list_ip,FileRead($file));guild đọc giá trị ở file text,lúc đọc xong nó đưa con trỏ về cuối
		FileSetPos($file,0,0);đưa con trỏ về đầu file text
	EndIf
EndFunc

