<%
'--------------------------------------------------------------------------------
'ver:1.0.1
'增加时、分、秒

'日期格式化
'依赖函数:Format() 修正月或天小于"10"时,补"0"
Function FormatDate(ByVal Style,ByVal SplitSign,ByVal DateTime)	'格式化时间	'SplitSign-分隔符
	Dim TempYear,TempMonth,TempDay,TempHour,TempMinute,TempSecond
	FormatDate=FormatDateTime(DateTime,2)
	TempYear=Year(DateTime)
	TempMonth=Format(Month(DateTime))
	TempDay=Format(Day(DateTime))
	
	TempHour = Format(Hour(DateTime))
	TempMinute = Format(Minute(DateTime))
	TempSecond = Format(Second(DateTime))
	Select Case Style
		Case "yyyy-mm-dd"	'Format 1: 2007-08-08
			FormatDate=TempYear & SplitSign & TempMonth & SplitSign & TempDay
		Case "yy-mm-dd"	'Format 2: 07-08-08
			TempYear=Right(TempYear,2)
			FormatDate=TempYear & SplitSign & TempMonth & SplitSign & TempDay
		Case "mm-dd"	'Format 3: 08-08
			FormatDate=TempMonth & SplitSign & TempDay
		Case "mm/dd/yyyy"	'Format 4: 08/08/2007
			FormatDate=TempMonth & SplitSign & TempDay & SplitSign & TempYear
		Case "yyyy-mm-dd hh:mm:ss"
			FormatDate=TempYear & SplitSign & TempMonth & SplitSign & TempDay & " " & TempHour & ":" & TempMinute & ":" & TempSecond
		Case "mm-dd hh:mm:ss"
			FormatDate=TempMonth & SplitSign & TempDay & " " & TempHour & ":" & TempMinute & ":" & TempSecond
		Case "mm/dd/yyyy hh:mm:ss"
			FormatDate=TempMonth & SplitSign & TempDay & SplitSign & TempYear & " " & TempHour & ":" & TempMinute & ":" & TempSecond
	End Select
End Function
'修正月或天小于"10"时,补"0"
Function Format(ByVal TempNumber)	'修正 月,天在[1,9]之前加"0"
	TempNumber=CInt(TempNumber)
	If TempNumber>0 AND TempNumber<10 Then
		TempNumber="0" & CStr(TempNumber)
	End If
	Format=TempNumber
End Function
'--------------------------------------------------------------------------------
%>