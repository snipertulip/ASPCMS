<%
	Private Conf_ExtName_01	'允许的文件类型库
	Private Conf_ExtName_image : Conf_ExtName_image=".jpg|.gif|.png"
	Private Conf_ExtName_music : Conf_ExtName_music=".mp3|.wav"
	Private Conf_ExtName_movie : Conf_ExtName_movie=".wmv"

	Private Conf_ExtName_ArticleList : Conf_ExtName_ArticleList=".jpg|.gif|.png|.bmp"

'01/允许文件类型过滤__________________________________________________________________
'	调用格式：
'	Call FileExtCheck(".jpg",Conf_ExtName_01)
	'                                   +被验证的文件          +允许的文件类型库	
	Private Function FileExtCheck(ByRef BeCheckedExtName,ByVal AllowableExtNameArray)
		Dim i,ii
		BeCheckedExtName=LCase(BeCheckedExtName)
		AllowableExtNameArray=LCase(AllowableExtNameArray)
		AllowableExtNameArray=Split(AllowableExtNameArray,"|")
		For i=0 To UBound(AllowableExtNameArray)
			If AllowableExtNameArray(i)=BeCheckedExtName Then
				FileExtCheck=True
				Exit Function
			End If
		Next
		FileExtCheck=False
	End Function
'01/允许文件类型过滤__________________________________________________________________

'	<!-- Copyright By Sniper,All Rights Resolved. -->
'	<!--<meta http-equiv="Content-Type" content="text/html; charset=gb2312">-->
%>