<%
'--------------------------------------------------------------------------------
'获取指定物理字串长度
Function DistillStr(ByVal str,ByVal charLen)
	ON ERROR RESUME NEXT
	charLen = CLng(charLen)
	If len("红,对不起呀") = 6 Then
		Dim l,t,c
		Dim i
		Dim countstr
		countstr=0
		l=len(str)
		t=l
		i=1
		For i=1 To l
			c=asc(mid(str,i,1))
			If c<0 Then
				c=c+65536
			End If
			If c>255 Then
				t=t+1
				countstr=countstr+2
			Else
				countstr=countstr+1
			End If
			If countstr<=charLen Then
				DistillStr=DistillStr+mid(str,i,1)
			End If
		Next
	Else 
		DistillStr=mid(str,0,charLen)
	End If		
	If Err.Number<>0 Then Err.Clear
End Function 
%>