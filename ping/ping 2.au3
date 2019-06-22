#include <file.au3>

$file = FileOpen("a.txt", 0); mở file text

While 1
    $line = FileReadLine($file);đọc từ dòng file text
    If @error = -1 Then ExitLoop ;kiểm tra lỗi
	send("#r")
	WinWaitActive("Run")
	ControlSend("Run","","","cmd{enter}")
	WinWaitActive("C:\Windows\system32\cmd.exe")
	ControlSend("C:\Windows\system32\cmd.exe","","","ping "&$line&" -t{enter}")
	Sleep(1000)
WEnd
FileClose($file)
