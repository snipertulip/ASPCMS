<%
'================================================================================
'
'PARAMS: category-2/id-1.html
'category=2
'id=1
'
'Dim F : Set F = QueryString()
'Response.Write Request.ServerVariables("Query_String") & "<br />"
'Response.Write "category" & "=" & F("category") & "<br />"
'Response.Write "id" & "=" & F("id") & "<br />"
'Response.Write "page" & "=" & F("page") & "<br />"
'--------------------------------------------------------------------------------
'依赖函数:
'正则 - CheckExp
'--------------------------------------------------------------------------------
'依赖类:
'暂无
'--------------------------------------------------------------------------------
'版本号: 1.0.0
'1.0.1		修正+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
'--------------------------------------------------------------------------------
Function QueryStringSplit()

	Dim QS : Set QS = Server.CreateObject("Scripting.Dictionary")

	Dim URLQueryString
	URLQueryString = Request.ServerVariables("Query_String")
	URLQueryString = Replace(URLQueryString ,".html", "")
	
	Dim Params
	Params = Split(URLQueryString, "/")

	If IsArray(Params) Then
		Dim x
		For Each x in Params
			QS.Add Split(x, "_")(0), Split(x, "_")(1)
		Next
	Else
		If Len(Params) Then
			QS.Add Split(Params, "_")(0), Split(Params, "_")(1)
		End If
	End If

	Set QueryStringSplit = QS

End Function


%>