<%
'正整数
Function CPositiveLng(byVal value) 
	ON ERROR RESUME NEXT
	CPositiveLng = CLng(value)
	If Err.Number > 0 Then
		CPositiveLng = 1
		Err.Clear
	End If
	If CPositiveLng < 1 Then
		CPositiveLng = 1
	End If
End Function
%>