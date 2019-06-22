#include <file.au3>

$file = FileOpen("a.txt", 0); mở file text

While 1
    $line = FileReadLine($file);đọc từ dòng file text
    If @error = -1 Then ExitLoop ;kiểm tra lỗi
    ;MsgBox(0,'',$line)
	Run(@ComSpec & ' /c ping ' & $line);run lệnh com
	sleep(3000)
WEnd
FileClose($file)