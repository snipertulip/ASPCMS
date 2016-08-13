<%
'类型安全转换

'字符串 - sring

Public Function CString(byVal str)
	ON ERROR RESUME NEXT
	str = CStr(str)
	If Err.Number > 0 Then
		Err.Clear
		CString = vbNullString
		Exit Function
	Else
		CString = str
		Exit Function
	End If
End Function

'正整数 - positive integer

Public Function C2PInt(byVal id) 
	ON ERROR RESUME NEXT
	id = CInt(id)
	If Err.Number > 0 Or id < 1 Then
		Err.Clear
		C2PInt = 1
		Exit Function
	Else
		C2PInt = id
		Exit Function
	End If
End Function

'正长整数 - positive long integer

Public Function C2LPLng(byVal id) 
	ON ERROR RESUME NEXT
	id = CLng(id)
	If Err.Number > 0 Or id < 1 Then
		Err.Clear
		C2LPLng = 1
		Exit Function
	Else
		C2LPLng = id
		Exit Function
	End If
End Function

'整数 - positive integer

Public Function C2Int(byVal id) 
	ON ERROR RESUME NEXT
	id = CInt(id)
	If Err.Number > 0 Then
		Err.Clear
		C2Int = 0
		Exit Function
	Else
		C2Int = id
		Exit Function
	End If
End Function

'长整数 - positive long integer

Public Function C2Lng(byVal id) 
	ON ERROR RESUME NEXT
	id = CLng(id)
	If Err.Number > 0 Then
		Err.Clear
		C2Lng = 0
		Exit Function
	Else
		C2Lng = id
		Exit Function
	End If
End Function

%>