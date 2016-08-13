<!-- #include file="../../common.asp" -->
<!-- #include file="../../adovbs.inc" -->
<!-- #include file="../../inc/Function/MD5.asp" -->
<!-- #include file="../../inc/Function/Convert.asp" -->

<!-- #include file="../../inc/Function/BinaryToString.asp" -->
<!-- #include file="../../inc/Class/JSON_1.5.1.asp" -->
<!-- #include file="../../inc/Class/JSON_2.0.4.asp" -->
<script language="jscript" runat="server" src="../../inc/fun.json2.min.asp" charset="utf-8"></script>
<%
Response.ContentType = "text/json"
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
Dim tempSql : tempSql = ""

'-------------------------------------------------------------------------------------
'Modeling:
Dim modeling : Set modeling = jsObject()
modeling("success") = false
modeling("total") = 0

Dim recorder : Set recorder = jsArray()
Set recorder(Null) = jsObject()
recorder(Null)("id") = ""
recorder(Null)("username") = ""

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
'不返回密码
				If col.Name = "Password" Then
					jsa(Null)(col.Name) = ""'col.Value
				Else
					jsa(Null)(col.Name) = col.Value
				End If
			Next
	rs.MoveNext
	Wend
	Set QueryToJSON = jsa
End Function

Select Case action
	Case "read"
		Dim rs, sql, businessID, begin_n, end_n, dateBound
		start = C2LPLng(request("start"))
		limit = C2LPLng(request("limit"))
		begin_n=start+1
		end_n=start+limit

		Set rs = conn.Execute("select count(*) from Friendlink")
		response.write("{""success"": true")
		response.write(",""total"":"& rs(0) &",""data"":")

		If limit = 0 Then
			limit = rs(0)
		End If
		
		Dim pagesize : pagesize = limit

		If page > 0 Then
			If page = (rs(0)\limit + 1) Then
				pagesize = rs(0) - limit * (page - 1)
			End If
		
			sql = "SELECT * FROM [select top " & pagesize & " a.* from (select top "& limit * page & " * from Friendlink where category = " & category & " ORDER BY SortIndex DESC) a left join (select top " & limit * page & " ID, SortIndex from Friendlink where category = " & category & " ORDER BY SortIndex DESC) b on b.ID=a.ID order by a.sortindex asc]. AS c ORDER BY sortindex DESC;"

		Else
			sql = "select TOP "& limit &" * from Friendlink order by sortindex DESC"
		End If

		QueryToJSON(conn, sql).Flush

		response.write("}")
		conn.close
		Set conn = nothing
		Response.End()

	Case "create"
		comm.ActiveConnection = conn
		comm.commandtype = 1

		comm.commandtext = "INSERT INTO Friendlink(Title, Href, Category) VALUES(:Title, :Href, :Category)"

		comm.Parameters.Append comm.CreateParameter(":Title", adVarChar, adParamInput, 255, autoaModel.Title)
		comm.Parameters.Append comm.CreateParameter(":Href", adVarChar, adParamInput, 255, autoaModel.Href)
		comm.Parameters.Append comm.CreateParameter(":Category", adBigInt, adParamInput, 32, category)

		set rst = Server.CreateObject("ADODB.recordset")
'		rst.pagesize = 10
'		rst.CursorLocation = 3
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

		sqlStr = "UPDATE Friendlink SET SortIndex = '" & LastOrderId & "' WHERE ID = " & LastOrderId
		conn.execute(sqlStr)
		modeling("success") = true
		modeling("msg") = "操作成功！"
		modeling.Flush
		Response.End()

	Case "update"
		
		comm.ActiveConnection = conn 
		comm.commandtype = 1 
		comm.commandtext = "UPDATE Friendlink Set Title = :Title, Href = :Href, MODDatetime = Now(), SortIndex = :SortIndex WHERE ID = :ID"

		comm.Parameters.Append comm.CreateParameter(":Title", adVarChar, adParamInput, 255, autoaModel.Title)
		comm.Parameters.Append comm.CreateParameter(":Href", adVarChar, adParamInput, 255, autoaModel.Href)
		comm.Parameters.Append comm.CreateParameter(":SortIndex", adBigInt, adParamInput, 32, autoaModel.SortIndex)
'		comm.Parameters.Append comm.CreateParameter(":Category", adBigInt, adParamInput, 32, category)
		comm.Parameters.Append comm.CreateParameter(":ID", adBigInt, adParamInput, 32, autoaModel.ID)
'ID - 自动编号
'Title - 标题
'Summary - 摘要
'Content - 内容
'Attachment - 附件
'Source - 来源
'Author - 作者
'Label - 标签
'ExternalLinks - 外部链接
'ADDDatetime - 添加时间
'MODDatetime - 修改时间
'SortIndex - 排序
'Category - 分类
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
			Set modeling("data") = recorder
		end if
		modeling.Flush
'Set modeling("datalist") = recorder
	Case "destroy"
		
		comm.ActiveConnection = conn 
		comm.commandtype = 1 
		
		Err.Clear
		Dim iArrayLength
		Dim iArrayTempString : iArrayTempString = VBNullString 
		iArrayLength = autoaModel.length
		iArrayLength = iArrayLength XOR iArrayLength

		If Err.Number <> 0 Then
			'单条记录
			comm.commandtext = "delete from Friendlink where ID = :ID"
			comm.Parameters.Append comm.CreateParameter(":ID", adVarChar, adParamInput, 50, autoaModel.ID)
		Else
			'多条记录
			iArrayTempString = "delete from Friendlink where ID IN("
			Do While iArrayLength < autoaModel.length - 1
				iArrayTempString = iArrayTempString & ":ID" & iArrayLength & ", "
				iArrayLength = iArrayLength + 1
			Loop
			iArrayTempString = iArrayTempString & ":ID" & autoaModel.length - 1
			iArrayTempString = iArrayTempString & ")"
			comm.commandtext = iArrayTempString
			
			iArrayLength = iArrayLength XOR iArrayLength
			
			Dim x
			For Each x In autoaModel
				
				comm.Parameters.Append comm.CreateParameter(":ID" & iArrayLength, adVarChar, adParamInput, 50, x.ID)
				iArrayLength = iArrayLength + 1
				
			Next
						
		End If
		Err.Clear

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
		Else
			modeling("success") = true
			modeling("msg") = "操作成功！"
		End If		
		modeling.Flush
'	Case "search"
End Select

'-------------------------------------------------------------------------------------
'Deserialize:
Function deserialize
End Function

'-------------------------------------------------------------------------------------
'Serialize:
Function serialize
End Function

%>