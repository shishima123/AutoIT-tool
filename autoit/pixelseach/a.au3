	$mang1=PixelSearch(160, 110,426, 294,0xFFE68C)
	if IsArray($mang1) Then
		MouseMove($mang1[0],$mang1[1])
		Sleep(500)
		MouseMove($mang1[0]-1,$mang1[1]+3)
	EndIf