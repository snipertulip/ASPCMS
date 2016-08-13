<%
'--------------------------------------------------------------------------------
'获取数组长度
Function ArrayLength(ByRef Arr)
	On Error Resume Next
	ArrayLength = UBound(Arr) - LBound(Arr) + 1
	If Err.Number > 0 Then
		Err.Clear
		ArrayLength = ArrayLength Xor ArrayLength
		Exit Function
	End If
End Function
%>