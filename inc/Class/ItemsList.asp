<%
'================================================================================
'二级页面列表生成器
'类:
'		Items_List
'--------------------------------------------------------------------------------
'依赖函数:
'获取数组长度 - ArrayLength
'获取指定物理字串长度 - DistillStr
'格式化日期 - FormatDate
'修正日期中小于10时出现缺位的人为BUG - Format :D
'--------------------------------------------------------------------------------
'依赖类:
'暂无
'--------------------------------------------------------------------------------
'字段格式字典:
'LONG:
'STRING:
'STRING, length
'DATETIME:
'DATETIME, formate - FormatDate() 函数提供的格式
'EW_PIC:
'EW_PIC, {#1#}title{#2#}src{#1#}title{#2#}src
'--------------------------------------------------------------------------------
'版本号: 1.0.0
'1.0.1		修正+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
'--------------------------------------------------------------------------------
Class ItemsList
'--------------------------------------------------------------------------------
	'显示字段缓存表
	'Such as: title - $TITLE$ (UCase("title"))
	Private Fields_Cache()
	Private Fields_Exp()
	'显示字段数据源
	Private Fields_DataSource
	Private Template
	'设置日期显示格式
	'具体请查看 FormatDate() 函数
	Private Date_Style, Date_SplitSign
	'无相关图片时的默认图片
	Private Default_PIC
'--------------------------------------------------------------------------------
	Private Sub Class_Initialize()
		ReDim Fields_Cache(0) : Fields_Cache(0) = vbNullString
		ReDim Fields_Exp(0) : Fields_Exp(0) = vbNullString
		Date_Style = "yyyy-mm-dd" : Date_SplitSign = "-"
		Default_PIC = "wanting-PIC.jpg"
	End Sub
'--------------------------------------------------------------------------------
	'获取字段缓存表
	Public Function Get_Fields()
		Get_Fields = Fields_Cache
	End Function
	'增加字段到字段缓存表
	Public Sub Add_Fields(A_Field, A_Exp)
		If Fields_Cache(0) = vbNullString Then
			Fields_Cache(0) = A_Field
			Fields_Exp(0) = A_Exp
		Else
			ReDim Preserve Fields_Cache(UBound(Fields_Cache) + 1)
			ReDim Preserve Fields_Exp(UBound(Fields_Exp) + 1)
			Fields_Cache(UBound(Fields_Cache)) = A_Field
			Fields_Exp(UBound(Fields_Exp)) = A_Exp
		End If
	End Sub
'--------------------------------------------------------------------------------
	'设置字段数据源
	Public Sub Set_Fields_DataSource(ByRef List_RST)
		Set Fields_DataSource = List_RST
	End Sub
'--------------------------------------------------------------------------------
	'设置Item代码片段
	Public Sub Set_Template(ByRef Item_Code)
		Template = Item_Code
	End Sub
'--------------------------------------------------------------------------------
	Public Function Creator(ByRef iCount)
		Do While Not Fields_DataSource.Bof And Not Fields_DataSource.Eof And iCount > 0
			Dim cache_template : cache_template = vbNullString
			cache_template = Template
			Dim ii : ii = ArrayLength(Fields_Cache) - 1
			Do While ii >= 0
			'格式化字段
				Dim temp_Fields_Value : temp_Fields_Value = Fields_DataSource(Fields_Cache(ii))
				temp_Fields_Value = deal_Fields(ii, temp_Fields_Value)
				If temp_Fields_Value <> vbNullString Then
					cache_template = Replace(cache_template, "$" & UCase(Fields_Cache(ii)) & "$", temp_Fields_Value)
				Else
					cache_template = Replace(cache_template, "$" & UCase(Fields_Cache(ii)) & "$", "")
				End If
				ii = ii - 1
			Loop
			Creator = Creator & cache_template
			Fields_DataSource.MoveNext
			iCount = iCount - 1
		Loop
	End Function
'--------------------------------------------------------------------------------
	Private Function deal_Fields(ByVal subscript_id, ByVal Field_Value)
		On Error Resume Next
		Dim Fields_Exp_ 
		'防漏
		'para : "para1, para2"
		'para : "para1,para2"
		Fields_Exp_ = Replace(Fields_Exp(subscript_id), ", ", ",")
		Fields_Exp_ = Replace(Fields_Exp_, ",", ",")
		'防漏
		Select Case (Split(Fields_Exp_, ","))(0)
			Case "LONG"
				deal_Fields = Field_Value
			Case "STRING" 'STRING, length
				deal_Fields = DistillStr(Field_Value, Split(Fields_Exp_, ",")(1))
			Case "DATETIME" 'DATETIME, formate
				Dim paraCache
				paraCache = Split(Fields_Exp_, ",")
				Dim Date_SplitSign_ : Date_SplitSign_ = Date_SplitSign
				If paraCache(2) <> "" Then
					Date_SplitSign_ = paraCache(2)
				Else
					Date_SplitSign_ = Date_SplitSign
				End If
				If paraCache(1) = "" Then
					deal_Fields = FormatDate(Date_Style, Date_SplitSign_, Field_Value)
				Else
					deal_Fields = FormatDate(paraCache(1), Date_SplitSign_, Field_Value)
				End If
				paraCache = vbNullString
			Case "EW_PIC" 'EW_PIC, {#1#}title{#2#}src
				Dim pic_Title, pic_Src
				deal_Fields = Split(Split(Rst("accessories"), "{#1#}")(1), "{#2#}")(1)
				If Err.Number > 0 Then
					deal_Fields = Default_PIC
					Err.Clear
				End If
			Case Else
				deal_Fields = Field_Value
		End Select
	End Function
	
	Public Sub Set_FormatDate(ByVal Style,ByVal SplitSign)
		Date_Style = Style
		Date_SplitSign = SplitSign
	End Sub
	
	Public Sub Set_Default_PIC(ByVal default_PIC_)
		Default_PIC = default_PIC_
	End Sub
'--------------------------------------------------------------------------------
	Private Sub Class_Terminate()
		Fields_DataSource.Close
		Set Fields_DataSource = Nothing
	End Sub
'--------------------------------------------------------------------------------
End Class
'================================================================================
%>