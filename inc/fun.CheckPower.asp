<%
'================================================================================
Function checkPower(ByRef userPurview, ByRef optPurview)
	Dim purviewValue : purviewValue = 2 ^ optPurview
	checkPower = ( ( userPurview And purviewValue ) = purviewValue)
End Function
'================================================================================
%>