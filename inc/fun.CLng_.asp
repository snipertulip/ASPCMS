<%
Function Clng_(byVal value) 
	ON ERROR RESUME NEXT
	Clng_ = CLng(value)
	If Err.Number > 0 Then
		Clng_ = 0
		Err.Clear
	End If
End Function
%>