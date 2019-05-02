 #pragma compile(inputboxres, true);bỏ kái này vào là ko bị loop file exe
ping1()

Func ping1()
$x=InputBox("ping","Dia chi ping","google.com.vn")
if @error = 0 Then
Run("cmd.exe")
Sleep(1000)
;WinWait("C:\Windows\system32\cmd.exe","",10)
send("ping "&$x&" -t{enter}")
;winclose("Administrator: C:\Windows\SYSTEM32\cmd.exe - ping  tech24.vn -t ")
EndIf
EndFunc
