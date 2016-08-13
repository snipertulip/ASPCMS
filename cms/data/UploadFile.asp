<!-- #include file="../../common.asp" -->
<!-- #include file="../../adovbs.inc" -->
<!-- #include file="../../inc/Function/FormatDate.asp" -->
<!-- #include file="../../inc/Function/FileExtCheck.asp" -->
<!-- #include file="../../inc/Class/upload_5xsoft.asp" -->
<!-- #include file="../../inc/Function/file.asp" -->
<%
Response.ContentType = "text/html"

'IIS AspMaxRequestEntityAllowed 默认2048000 , 200K
'本机设置 204800000 , 20000K, 18M左右
Dim MaxSize : MaxSize = 2048 * 100000


Dim Upload,FormPath
Set Upload=new upload_5xsoft '建立上传对象
FormPath="../../attachments/"

process

'--------------------------------------------------------------------------------
Public Function process()
	Dim tempFile : Set tempFile = Upload.File("filename")
	Dim tempFileName : tempFileName = vbNullString
	Dim tempfileExtName : tempfileExtName = Right(tempFile.filename, 3)
	tempfileExtName = "." & tempfileExtName
	If UpLoad.File("filename").FileSize <= 0 Or UpLoad.File("filename").FileSize > MaxSize Then
		Response.Clear()
		Response.Write "{success:false, msg:""文件大小不在(1-" & MaxSize  & "K)之间！""}"
		Response.End()
	End If
	If Not FileExtCheck(tempfileExtName, Conf_ExtName_ArticleList & "|" & Conf_ExtName_image) Then
		Response.Clear()
		Response.Write "{success:false, msg:""系统不支持您上传的文件类型(" & tempfileExtName & ")[只支持" & Conf_ExtName_ArticleList & "|" & Conf_ExtName_image & "]""}"
		Response.End()
	End If
	
	tempFileName = tempFileName & FmtNumber(CLng(Request.QueryString("category")), 5)
	tempFileName = tempFileName & "-"
	tempFileName = tempFileName & FormatDate("yyyy-mm-dd hh:mm:ss", "", Now())
	tempFileName = Replace(tempFileName, "-", "")
	tempFileName = Replace(tempFileName, " ", "")
	tempFileName = Replace(tempFileName, ":", "")
'	tempFileName = "ArticlList-" & tempFileName
	Randomize timer
	tempFileName = tempFileName & FmtNumber((CInt(8999*Rnd+1000)), 4) & tempfileExtName
	tempFile.SaveAs Server.Mappath(FormPath & tempfileName)
	Response.Clear()
	Response.Write "{success:true, file:""" & tempfileName & """}"
	Response.Flush()
	Response.End()
End Function

'数值补0
function FmtNumber(n,length)
	if len(n)>=length then
		fmtNumber = n
		exit function
	end if
	FmtNumber = string(length - len(n), "0") & n
end function


'	Call renameFile(FormPath & tempfileName,  FormPath & "../../" & tempfileName)

%>