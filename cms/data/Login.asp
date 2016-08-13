<!-- #include file="../../common.asp" -->
<!-- #include file="../../adovbs.inc" -->
<!-- #include file="../../inc/Function/MD5.asp" -->
<!-- #include file="../../inc/Class/JSON_1.5.1.asp" -->
<!-- #include file="../../inc/Class/JSON_2.0.4.asp" -->
<!-- #include file="../../inc/Class/JSON_UTIL_0.1.1.asp" -->

<!-- #include file="../../inc/Function/Convert.asp" -->
<!-- #include file="../../inc/Function/urlDecode.asp" -->
<%
Response.ContentType = "application/json"
   
Dim Message : Set Message = jsObject()

Dim TableName : TableName = "Admin"

Dim User : Set User = jsObject()
User("username") = CString(Request("username"))
User("password") = CString(Request("password"))

Dim vcode : vcode = CString(Request("vcode"))
Dim keeponline : keeponline = C2Lng(Request("keeponline"))
Dim isKeeponline : isKeeponline = C2Lng(Request("isKeeponline"))

If Not C2Lng(Session("GetCode")) = C2Lng(vcode) Then
	Message("success") = false
	Message("msg") = "对不起，验证未通过(验证码与图片不匹配)！"
	Message.Flush
	Response.End()
End IF

comm.ActiveConnection = conn 
comm.commandtype = 1 
comm.commandtext = "SELECT TOP 1 * FROM [" & TableName & "] WHERE [USERNAME] = :USERNAME AND [PASSWORD] = :PASSWORD"

'comm.commandtext = "select * from adv where home_A like :home_A" 'return userid" 
comm.Parameters.Append comm.CreateParameter(":USERNAME", 200, 1, 32, User("username"))
If isKeeponline = 1 Then
    comm.Parameters.Append comm.CreateParameter(":PASSWORD", 200, 1, 32, User("password"))
Else
    comm.Parameters.Append comm.CreateParameter(":PASSWORD", 200, 1, 32, MD5(User("password")))
End If
set rst = Server.CreateObject("ADODB.recordset")
rst.pagesize = 10
rst.CursorLocation = 3 
rst.open comm

Set User = Nothing

If Not rst.Eof Then
	ra = 1
	Set Session("User") = Server.CreateObject("Scripting.Dictionary")
	Session("User").Add "userID", rst("userID").value
	Session("User").Add "username", rst("username").value

	Select Case keeponline
		Case 1
			Response.Cookies("User").Expires=Date + 1
		Case 17
		Response.Cookies("User").Expires=Date + 7
		Case 30
			Response.Cookies("User").Expires=Date + 30
	End Select
	
	If Not keeponline = 0 Then
		Response.Cookies("User")("userID") = Server.URLEncode(rst("userID").value)
		Response.Cookies("User")("username") = Server.URLEncode(rst("username").value)
		Response.Cookies("User")("password") = Server.URLEncode(rst("password").value)
		Response.Cookies("User")("keeponline") = Server.URLEncode(keeponline)
	End If
	
	Conn.Execute("update [Admin] set LastLoginDatetime = Now() where UserID=" & rst("userID").value)

End If
rst.Close
Set rst = Nothing

If Conn.Errors.Count > 0 Then
	Message("success") = false
	Message("msg") = err.description
	err.clear
Else
	If ra > 0 Then
		Message("success") = true
		Message("msg") = "恭喜您，验证已通过！"
	Else
		Message("success") = false
		Message("msg") = "对不起，验证未通过(用户名或密码错误)！"
	End If
End If

Message.Flush
Set Message = Nothing
%>