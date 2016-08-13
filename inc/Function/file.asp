<%
'--------------------------------------------------------------------------------
'delete file
Public Function deleteFile(ByRef path)
	path = Server.Mappath(path)
	Dim delFSO : Set delFSO = Server.CreateObject("Scripting.FileSystemObject")
	Dim delFile
	If delFSO.FileExists(path) Then
		Set delFile = delFSO.GetFile(path)
		delFile.Delete
	End If
	Set delFSO = Nothing
	Set delFile = Nothing
End Function
'--------------------------------------------------------------------------------
'rename file
Public Function renameFile(ByRef fromPath, ByRef toPath)
	Dim fs, SFile, NFile
	Set fs = Server.CreateObject("Scripting.FileSystemObject")
	SFile = Server.MapPath(fromPath)
	NFile = Server.MapPath(toPath)
	'屏蔽文件不存在的情况
	ON Error Resume Next
	fs.CopyFile SFile, NFile, True
	If fromPath <> toPath Then
		Call deleteFile(fromPath)
	End If
	Error.Clear
End Function
'--------------------------------------------------------------------------------
'rename file
Public Function copyFile(ByRef fromPath, ByRef toPath)
	Dim fs, SFile, NFile
	Set fs = Server.CreateObject("Scripting.FileSystemObject")
	SFile = Server.MapPath(fromPath)
	NFile = Server.MapPath(toPath)
	'屏蔽文件不存在的情况
	ON Error Resume Next
	fs.CopyFile SFile, NFile, True
'	If fromPath <> toPath Then
'		Call deleteFile(fromPath)
'	End If
	Error.Clear
End Function
%>