<%
'Dim absolutepage
'absolutepage = CLng(Request("absolutepage"))
'Response.Write page("page.asp" , "", 100, 5, absolutepage , "absolutepage", "")

'================================================================================
'函数:
'		page( URL , query_string, total, fixed_len, current_page ,current_page_value_name, search_keywords recordCount, recordCountDefine)
'参数:
'		1).URL: 跳转地址;
'		2).query_string: 网页参数传送;
'		3).total: 总页数;
'		4).fixed_len:分页长数;
'		5).current_page:当前页码.
'		6).current_page_value_name:URL里的当前页面参数名
'		7).search_keywords:搜索参数显示传入
'		8).recordCount:总记录数
'		9).recordCountDefine:总记录的提示信息
'版本号: 1.1.2
'--------------------------------------------------------------------------------
'1.0.1		修正初始化时,当前页为0的错误
'1.1.1		添加没有搜索到相关信息的"关键字"
'1.1.2		无搜索时,提示信息不合理
'1.1.3		显示总记录数,以及提示信息
'--------------------------------------------------------------------------------

Public Function Page( URL , query_string, total, fixed_len, current_page , current_page_value_name, search_keywords, recordCount, recordCountDefine)
	'验证数据正确性
	If (current_page > total) Or (total < 0) Then
		If search_keywords = vbNullString Then
			page = "抱歉，暂无相关的记录。"
		Else
			page = "抱歉，没有找到与关键字“" & search_keywords & "” 相关的记录。"
		End If
		Exit Function
	End If
	'<
	If current_page < 1 Then
		current_page = 1
	End If
	
	page = page & "<font class=""a_info"">共" & recordCount  & recordCountDefine & "</font> "
	page = page & "<font class=""a_info"" title=""当前页码:"  & current_page & "/总页码:" & total & """>(" & current_page & "/" & total & ")页</font> "
	Dim i
	If (current_page - fixed_len <= 1) Then
		i = 1
	Else
		page = page & "<a href=""" & URL & "?" & current_page_value_name & "=" & 1 & query_string & """ class=""a_pagination"" target=""_self"">|<</a> "
		i = current_page - fixed_len
		If (i - fixed_len - 1 <= 0) Then
			page = page & "<a href=""" & URL & "?" & current_page_value_name & "=" & 1 & query_string & """ class=""a_pagination"" target=""_self""><</a> "
		Else
			page = page & "<a href=""" & URL & "?" & current_page_value_name & "=" & (i - 1) & query_string & """ class=""a_pagination"" target=""_self""><</a> "
		End If
	End If
	'12345...
	For i = i To current_page + fixed_len
		If i > total Then Exit For End If
		If i = current_page Then
			page = page & "<font class=""a_selectpage"">[" & i & "]</font> "
		Else
			page = page & "<a href=""" & URL & "?" & current_page_value_name & "=" & i & query_string & """ class=""a_pagination"" target=""_self"">[" & i & "]</a> "
		End If
	Next
	'>
	If current_page + fixed_len < total Then
			page = page & "<a href=""" & URL & "?" & current_page_value_name & "=" & (current_page + fixed_len + 1) & query_string & """ class=""a_pagination"" target=""_self"">></a> "
			page = page & "<a href=""" & URL & "?" & current_page_value_name & "=" & total & query_string & """ class=""a_pagination"" target=""_self"">>|</a> "
	End If
	page = page & "&nbsp;&nbsp;"
End Function
'================================================================================

%>