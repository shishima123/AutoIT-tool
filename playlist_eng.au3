#include <File.au3>
#include <MsgBoxConstants.au3>

; Path to the folder containing the files to read and copy
Local $sourceFolder = "E:\English\Listening_Practice_Through_Dictation(PDF+Audio)-KKa@VNZ\ListeningPracticeThroughDictation_1"
Local $destinationFolder = $sourceFolder & "\copied"
Local $numberOfFileCopy = 10

; Check if the destination folder exists, delete it if it does
If FileExists($destinationFolder) Then
    DirRemove($destinationFolder, 1)
EndIf

; Create the destination folder
DirCreate($destinationFolder)

; Loop through all the files in the source folder
Local $fileList = _FileListToArray($sourceFolder)
For $i = 1 To $fileList[0]
    ; Check if the file is an mp3 file
    If StringInStr($fileList[$i], ".mp3") Then
        ; Copy the file 10 times with incremental filenames starting from name_1.mp3
        For $j = 1 To $numberOfFileCopy
            FileCopy($sourceFolder & "\" & $fileList[$i], $destinationFolder & "\" & StringLeft($fileList[$i], StringLen($fileList[$i]) - 4) & "_" & $j & ".mp3", 1)
        Next
    EndIf
Next

; Display a message box when the copy operation is complete
If MsgBox($MB_OKCANCEL, "Copy complete", "Done copying files to " & $destinationFolder & ". Click OK to open the folder.") = $IDOK Then
    ShellExecute($destinationFolder)
EndIf