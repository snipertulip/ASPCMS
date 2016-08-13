<%
'================================================================================
'函数:
'		CheckExp(ByVal patrn,ByVal strng)
'参数:
'		1).URL: 跳转地址;
'版本号: 1.0.0
'--------------------------------------------------------------------------------
'1.0.1		+
'--------------------------------------------------------------------------------
Function CheckExp(ByVal patrn,ByVal strng)
	Dim regEx,Match
	Set regEx = New regExp
	regEx.Pattern = patrn
	regEx.IgnoreCase = True
	regEx.Global = True
	CheckExp = regEx.Test(strng)
	Set regEx = Nothing
End Function
'================================================================================
%>