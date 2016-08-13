<form name="mofeiform" method="post" action="Validation/save.asp">
请输入验证码:<input name="mofei" type="text">
  <%=getcode1()%> (回车即可提交) 
  <input type="submit" name="Submit" value="提交">
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