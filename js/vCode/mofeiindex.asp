<form name="mofeiform" method="post" action="Validation/save.asp">
��������֤��:<input name="mofei" type="text">
  <%=getcode1()%> (�س������ύ) 
  <input type="submit" name="Submit" value="�ύ">
</form>

<%
Function getcode1()
	Dim test
	On Error Resume Next
	Set test=Server.CreateObject("Adodb.Stream")
	Set test=Nothing
	If Err Then
		Dim zNum
		Randomize timer
		zNum = cint(8999*Rnd+1000)
		Session("GetCode") = zNum
		getcode1= Session("GetCode")		
	Else
		getcode1= "<img src=""getcode.asp"">"		
	End If
End Function
%>