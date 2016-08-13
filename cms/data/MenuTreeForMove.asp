<!-- #include file="../../common.asp" -->
<!-- #include file="../../adovbs.inc" -->
<!-- #include file="../../inc/Function/Convert.asp" -->

<!-- #include file="../../inc/Function/BinaryToString.asp" -->
<!-- #include file="../../inc/Class/JSON_1.5.1.asp" -->
<!-- #include file="../../inc/Class/JSON_2.0.4.asp" -->
<!-- #include file="../../inc/Class/JSON_UTIL_0.1.1.asp" -->
<script language="jscript" runat="server" src="../../inc/fun.json2.min.asp" charset="utf-8"></script>
<%
Response.ContentType = "application/json"
'-------------------------------------------------------------------------------------
'Get the parameters:
'	action: read, add, update, delete, search
'	limit, page, start
Dim action : action = CString(Request("action"))
Dim category : category = C2Lng(Request("category"))
Dim limit : limit = C2LPLng(Request("limit"))
Dim page : page = C2LPLng(Request("page"))
Dim start : start = C2Lng(Request("start"))
Dim keywords : keywords = CString(Request("keywords"))

Dim node : node = C2LPLng(Request("node"))
'-------------------------------------------------------------------------------------
'Modeling:
Dim modeling : Set modeling = jsObject()
modeling("success") = false
modeling("total") = 0

Dim recorder : Set recorder = jsArray()
Set recorder(Null) = jsObject()
recorder(Null)("MenuID") = ""
recorder(Null)("MenuName") = ""

'-------------------------------------------------------------------------------------
'Auto modeling:
Dim autoaModel

If Request.TotalBytes > 0 Then Set autoaModel = JSON2.parse(Stream_BinaryToString(Request.BinaryRead(Request.TotalBytes), "utf-8"))

'-------------------------------------------------------------------------------------
Function QueryToJSON(dbc, sql)
	Dim rs, jsa, col
	Set rs = dbc.Execute(sql)
	Set jsa = jsArray()
	While Not (rs.EOF Or rs.BOF)
			Set jsa(Null) = jsObject()
			For Each col In rs.Fields

				jsa(Null)(col.Name) = col.Value

			Next
	rs.MoveNext
	Wend
	Set QueryToJSON = jsa
End Function

Select Case action
	Case "read"
		Dim rs, sql, businessID, begin_n,end_n, dateBound

		Set rs = conn.Execute("select count(*) from SMenu where ModelID = 10 and not MenuID=" & category)
		response.write("{""success"": true")
		response.write(",""total"":" & rs(0) & ",""data"":")
		
		sql = "select * from SMenu where ModelID = 10 and not MenuID=" & category & " order by SortIndex DESC"
		QueryToJSON(conn, sql).Flush

'		Response.Write ", sql: """ & sql & """"
		response.write("}")
		conn.close
		Set conn = nothing
		Response.End()

End Select
%>
