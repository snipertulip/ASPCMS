<!-- #include file="fun.CheckExp.asp" -->
<%
'================================================================================
'二级页面列表生成器
'类:
'	VTypes
'--------------------------------------------------------------------------------
'依赖函数:
'正则表达式 - CheckExp
'--------------------------------------------------------------------------------
'依赖类:
'暂无
'--------------------------------------------------------------------------------
'字段格式字典:
'--------------------------------------------------------------------------------
'版本号: 1.0.1
'1.0.1		增加BUG调试模块: Public Function debug()
'--------------------------------------------------------------------------------
Class VTypes
	
	Public username, v_username, password, v_password, vpassword, v_vpassword ,question, v_question, answer, v_answer, fullname, v_fullname, sex, v_sex, IDCard, v_IDCard, telephone, v_telephone, Email, v_Email, province, v_province, city, v_city, add, v_add, postalcode, v_postalcode, QQ, v_QQ, remark, v_remark, vCode, v_vCode, Error_INF
	Public currency_form, v_currency_form
	Public datetime, v_datetime
	
	Private Sub Class_Initialize()

		'成员变量以及验证特征码的声明
	
		username = "" :	v_username = "^[A-Za-z]{1}[A-Za-z0-9_]{3,11}$" '[4-12]位
	
		password = "" : v_password = "^[\S]{6,16}$" '[6-16]位非空白字符
	
		vpassword = "" : v_vpassword = "^[\S]{6,16}$" '[6-16]位非空白字符
	
		question = "" : v_question = "^[^ \f\n\r\t\v][^\f\n\r\t\v]{0,49}$"
	
		answer = "" : v_answer = "^[^ \f\n\r\t\v][^\f\n\r\t\v]{0,49}$"
	
		fullname = "张先生" : v_fullname = "^[\u4e00-\u9fa5]{2,5}$"
		
		sex = "" : v_sex = "^[\u7537|\u5973]{1}$" ' \u7537 - 男 \u5973 - 女
		
		IDCard = "" : v_IDCard = "^(\d{15}|(\d{17}[\d|x]))$" '|
		
		telephone = "" : v_telephone = "^([0-9]{3,4}(\-| )?[0-9]{3,8}$)|(^[0-9]{3,8}$)|(^\([0-9]{3,4}\)[0-9]{3,8}$)|(^0{0,1}13[0-9]{9})$"
	
		Email = "" : v_Email = "^[\w\.-]+@[\w\.-]+\.\w+$"
		
		province = "" : v_province = "^[^ \f\n\r\t\v][^\f\n\r\t\v]{0,49}$"
		
		city = "" : v_city = "^[^ \f\n\r\t\v][^\f\n\r\t\v]{0,49}$"
		
		add = "" : v_add = "^[^ \f\n\r\t\v][^\f\n\r\t\v]{0,49}$"
		
		postalcode = "" : v_postalcode = "^[0-9]{6}$"
	
		QQ = "" : v_QQ = "^[1-9]{1}[0-9]{1,9}$"
		
		remark = "" : v_remark = "^[^ \f\n\r\t\v][^\f\n\r\t\v]{0,511}$"
	
		vCode = "" : v_vCode = "^[0-9]{4}$"
		
		currency_form = "" : v_currency_form = ""
		
		datetime = "" : v_datetime = "" ' v_datetime - 日期格式
	
		Error_INF = vbNullString

	End Sub
	
	'成员验证公用函数
	Public Function vModule(string, reg_exp)
	
		vModule = CheckExp(reg_exp, string)
	
	End Function
	
	'成员验证
	Public Function validate(obj)
				
		'会员姓名
		If (InStr(obj, "username") > 0 And (Not vModule(username, v_username))) Then
		
			Error_INF = "用户名格式不规范！"

			validate = False

			Exit Function
		
		End If
		
		'会员密码
		If (InStr(obj, "password") > 0 And (Not vModule(password, v_password))) Then
		
			Error_INF = "密码格式不规范！"

			validate = False

			Exit Function
		
		End If
		
		'会员确认密码
		If (InStr(obj, "vpassword") > 0 And (Not vModule(vpassword, v_vpassword))) Then
		
			Error_INF = "确认密码格式不规范！"
			
			validate = False

			Exit Function
		
		End If
		
		'会员密保问题
		If (InStr(obj, "question") > 0 And (Not vModule(question, v_question))) Then
		
			Error_INF = "密保问题格式不规范！"
			
			validate = False

			Exit Function
		
		End If
		
		'会员密保回答
		If (InStr(obj, "answer") > 0 And (Not vModule(answer, v_answer))) Then
		
			Error_INF = "密保回答格式不规范！"
			
			validate = False

			Exit Function
		
		End If
		

		'会员姓名
		If (InStr(obj, "fullname") > 0 And (Not vModule(fullname, v_fullname))) Then
		
			Error_INF = "姓名格式不规范！"
			
			validate = False

			Exit Function
		
		End If
		
		'会员姓别
		
		If (InStr(obj, "sex") > 0 And (Not vModule(sex, v_sex))) Then
		
			Error_INF = "姓别格式不规范！"
			
			validate = False

			Exit Function
		
		End If
		
		'会员身份证号
		If (InStr(obj, "IDCard") > 0 And (Not vModule(IDCard, v_IDCard))) Then
		
			Error_INF = "身份证格式不规范！"
			
			validate = False

			Exit Function
		
		End If
		
		'会员联系电话
		If (InStr(obj, "telephone") > 0 And (Not vModule(telephone, v_telephone))) Then
		
			Error_INF = "联系电话格式不规范！"
			
			validate = False

			Exit Function
		
		End If
		
		'会员Email
		If (InStr(obj, "Email") > 0 And (Not vModule(Email, v_Email))) Then
		
			Error_INF = "电子邮件格式不规范！"

			validate = False

			Exit Function
		
		End If
		
		'会员所在省份
		If (InStr(obj, "province") > 0 And (Not vModule(province, v_province))) Then
		
			Error_INF = "请选择您所在省！"
			
			validate = False

			Exit Function
		
		End If
		
		'会员所在市
		If (InStr(obj, "city") > 0 And (Not vModule(city, v_city))) Then
		
			Error_INF = "请选择您所在市！"
			
			validate = False

			Exit Function
		
		End If
		
		'会员地址
		If (InStr(obj, "add") > 0 And (Not vModule(add, v_add))) Then
		
			Error_INF = "地址格式不规范！"
			
			validate = False

			Exit Function
		
		End If
		
		'会员邮政编码
		If (InStr(obj, "postalcode") > 0 And (Not vModule(postalcode, v_postalcode))) Then
		
			Error_INF = "邮政编码格式不规范！"
			
			validate = False

			Exit Function
		
		End If

		'会员QQ号码
		If (InStr(obj, "QQ") > 0 And (Not vModule(QQ, v_QQ))) Then
		
			Error_INF = "QQ号码格式不规范！"
			
			validate = False

			Exit Function
		
		End If

		'会员备注
		If (InStr(obj, "remark") > 0 And (Not vModule(remark, v_remark))) Then
		
			Error_INF = "备注格式不规范！"
			
			validate = False

			Exit Function
		
		End If
		
		'验证码
		If (InStr(obj, "vCode") > 0 And (Not vModule(vCode, v_vCode))) Then
		
			Error_INF = "验证码不规范！"
			
			validate = False

			Exit Function
		
		End If
		
		'通用
		If (InStr(obj, "currency_form") > 0 And (Not vModule(currency_form, v_currency_form))) Then
		
			Error_INF = ""
			
			validate = False

			Exit Function
		
		End If
		
		'日期
		If (InStr(obj, "datetime") > 0) Then
		
			If Not isDate(datetime) Then
			
				Error_INF = ""
				
				validate = False
	
				Exit Function
			
			End If
		
		End If
		
		validate = True
		
	End Function
	
	'Just for debug
	Public Function debug()
		Dim i
		
		Response.Write "Form's count:" & Request.Form.Count & "<br>"
		For Each i in Request.Form
			If i <> "Submit" Then
				Response.Write i & ":" & Request.form(i) & "<br>"
			End If
		Next
		
		Response.Write "QueryString's count:" & Request.QueryString.Count & "<br>"
		For Each i in Request.QueryString
			If i <> "Submit" Then
				Response.Write i & ":" & Request.QueryString(i) & "<br>"
			End If
		Next
		
		Response.End
	End Function
	
End Class
'================================================================================

'--------------------------------------------------------------------------------
'test
'Dim clsVTypes
'Set clsVTypes = New VTypes
'clsVTypes.currency_form = "000000000"
'clsVTypes.v_currency_form = "^[1-2]{1}[0-1]{1}[0-4]{1}[0-7]{1}[0-4]{1}[0-8]{1}[0-3]{1}[0-6]{1}[0-4]{1}[0-7]{1}$|^[0-9]{1,9}$"
'^[1-2]{1}[0-1]{1}[0-4]{1}[0-7]{1}[0-4]{1}[0-8]{1}[0-3]{1}[0-6]{1}[0-4]{1}[0-7]{1}$

'2,147,483,647

''
'Response.Write clsVTypes.validate("currency_form")
'Response.Write CLng("2147483647")
%>