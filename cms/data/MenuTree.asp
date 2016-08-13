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

		Set rs = conn.Execute("select count(*) from SMenu where ParentID = " & node)
		response.write("{""success"": true")
		response.write(",""total"":" & rs(0) & ",""data"":")
		
		sql = "select * from SMenu where parentId = " & node & " order by SortIndex DESC"
		QueryToJSON(conn, sql).Flush

'		Response.Write ", sql: """ & sql & """"
		response.write("}")
		conn.close
		Set conn = nothing
		Response.End()
	Case "create"
		comm.ActiveConnection = conn
		comm.commandtype = 1

		comm.commandtext = "INSERT INTO Menu(MenuName, ModelID, Expanded, Leaf, ParentID) VALUES(:MenuName, :ModelID, :Expanded, :Leaf, :ParentID)"

		comm.Parameters.Append comm.CreateParameter(":MenuName", adVarChar, adParamInput, 50, autoaModel.MenuName)
		comm.Parameters.Append comm.CreateParameter(":ModelID", adBigInt, adParamInput, 32, autoaModel.ModelID)
		comm.Parameters.Append comm.CreateParameter(":Expanded", adVarChar, adParamInput, 255, autoaModel.Expanded)
		comm.Parameters.Append comm.CreateParameter(":Leaf", adVarChar, adParamInput, 255, autoaModel.Leaf)
		comm.Parameters.Append comm.CreateParameter(":ParentID", adBigInt, adParamInput, 32, autoaModel.ParentID)

		set rst = Server.CreateObject("ADODB.recordset")
		rst.pagesize = 10
		rst.CursorLocation = 3
		rst.open comm

		If Conn.Errors.Count > 0 Then
			modeling("success") = false
			Select Case err.Number
				Case -2147217900
					modeling("msg") = "操作失败！原因：" & "填写的数据有非法字符！<br />如：' 　&<>?%,;:()`~!@#$^*{}[]|+-="
				Case -2147467259
					modeling("msg") = "操作失败！原因：" & "数据库中有重复记录！"
				Case Else
				modeling("msg") = "操作失败！原因：" & err.description
			End Select
			err.clear
			modeling.Flush
			Response.End()
		End If
		
		Dim LastOrderId
		Set rst= Server.CreateObject("ADODB.Recordset")
		rst.Open "SELECT @@IDENTITY AS LastOrderId", conn, 1, 3
		LastOrderId = rst("LastOrderId")
		rst.Close
		Set rst = Nothing

		sqlStr = "UPDATE Menu SET SortIndex = '" & LastOrderId & "' WHERE MenuID = " & LastOrderId
		conn.execute(sqlStr)
		modeling("success") = true
		modeling("msg") = "操作成功！" & autoaModel
		modeling.Flush
		Response.End()

	Case "update"
		
		comm.ActiveConnection = conn 
		comm.commandtype = 1 
		
		comm.commandtext = "UPDATE Menu Set MenuName = :MenuName, ModelID = :ModelID, Expanded = :Expanded, Leaf = :Leaf,  ParentID = :ParentID, SortIndex = :SortIndex WHERE MenuID = :MenuID"

		comm.Parameters.Append comm.CreateParameter(":MenuName", adVarChar, adParamInput, 50, autoaModel.MenuName)
		comm.Parameters.Append comm.CreateParameter(":ModelID", adBigInt, adParamInput, 32, autoaModel.ModelID)
		comm.Parameters.Append comm.CreateParameter(":Expanded", adBoolean, adParamInput, 32, autoaModel.Expanded)
		comm.Parameters.Append comm.CreateParameter(":Leaf", adBoolean, adParamInput, 32, autoaModel.Leaf)
		comm.Parameters.Append comm.CreateParameter(":ParentID", adBigInt, adParamInput, 32, autoaModel.ParentID)
		comm.Parameters.Append comm.CreateParameter(":SortIndex", adBigInt, adParamInput, 32, autoaModel.SortIndex)
		comm.Parameters.Append comm.CreateParameter(":MenuID", adBigInt, adParamInput, 32, autoaModel.MenuID)

		set rst = Server.CreateObject("ADODB.recordset")
'		rst.pagesize = 10
'		rst.CursorLocation = 3 
		rst.open comm

		If Conn.Errors.Count Then
			modeling("success") = false
			Select Case err.Number
				Case -2147217900
					modeling("msg") = "操作失败！原因：" & "填写的数据有非法字符"
				Case -2147467259
					modeling("msg") = "操作失败！原因：" & "数据库中有重复记录！"
				Case Else
				modeling("msg") = "操作失败！原因：" & err.description
			End Select
			err.clear
		Else
			modeling("success") = true
			modeling("msg") = "操作成功！"

			recorder(Null)("modelID") = autoaModel.MenuID
			recorder(Null)("MenuName") = autoaModel.MenuName
			
			Set modeling("data") = recorder
		end if
		modeling.Flush

	Case "destroy"
		
		comm.ActiveConnection = conn 
		comm.commandtype = 1 

		'单条记录
		comm.commandtext = "delete from Menu where menuID = :menuID or parentID = :parentID"
		comm.Parameters.Append comm.CreateParameter(":menuID", adVarChar, adParamInput, 50, autoaModel.MenuID)
		comm.Parameters.Append comm.CreateParameter(":parentID", adVarChar, adParamInput, 50, autoaModel.MenuID)

		set rst = Server.CreateObject("ADODB.recordset")
		rst.pagesize = 10
		rst.CursorLocation = 3 
		rst.open comm

		If Conn.Errors.Count > 0 Then
			modeling("success") = false
			Select Case err.Number
				Case -2147217900
					modeling("msg") = "操作失败！原因：" & "填写的数据有非法字符！<br />如：' 　&<>?%,;:()`~!@#$^*{}[]|+-="
				Case -2147467259
					modeling("msg") = "操作失败！原因：" & "数据库中有重复记录！"
				Case Else
				modeling("msg") = "操作失败！原因：" & autoaModel.MenuID
			End Select
			err.clear
		Else
			modeling("success") = true
			modeling("msg") = "操作成功！"
		End If		
		modeling.Flush
End Select
%>
