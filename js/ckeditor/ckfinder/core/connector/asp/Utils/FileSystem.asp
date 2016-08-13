<script runat="server" language="VBScript">
' CKFinder
' ========
' http://ckfinder.com
' Copyright (C) 2007-2010, CKSource - Frederico Knabben. All rights reserved.
'
' The software, this file and its contents are subject to the CKFinder
' License. Please read the license.txt file before using, installing, copying,
' modifying or distribute this file or part of its contents. The contents of
' this file is part of the Source Code of CKFinder.

	''
	' @package CKFinder
	' @subpackage Utils
	' @copyright CKSource - Frederico Knabben
	'

	''
	' @package CKFinder
	' @subpackage Utils
	' @copyright CKSource - Frederico Knabben
	'
class CKFinder_Connector_Utils_FileSystem
	''
	' Reference to Scripting.FileSystemObject
	'
	Private oFSO

	' A file that might be used by Asp.net to verify that the call is from this script.
	Private tempFilePath

	Private Sub Class_Initialize()
		Set oFSO = server.CreateObject("Scripting.FileSystemObject")
		tempFilePath = ""
	End Sub

	Private Sub Class_Terminate()
		' If there was a temp file created, delete it.
		cleanUpTempFile

		Set oFSO = nothing
	End sub

	''
	'
	' @static
	' @access public
	' @param string path1 first path
	' @param string path2 scecond path
	' @return string
	'
	Public function combinePaths(path1, path2)
		Dim sPath1, sPath2
		sPath1 = path1 & ""
		sPath2 = Replace(path2 & "", "/", "\")
		combinePaths = oFSO.BuildPath(sPath1, sPath2)
	End Function

	Public function combineURLs(path1, path2)
		Dim sPath1, sPath2
		sPath1 = path1 & ""
		sPath2 = path2 & ""
		If sPath1<>"" Then If (Right(sPath1, 1) = "/") Then sPath1 = Left(sPath1, Len(sPath1)-1)
		If sPath2<>"" Then If Left(sPath2, 1) = "/" Then sPath2 = right(sPath2, Len(sPath2)-1)
		combineURLs = sPath1 & "/" & sPath2
		If (combineURLs = "/") Then combineURLs = ""
	End Function


	Public Function FileExists(filename)
		If (filename = "") Then
			FileExists = False
			Exit function
		End If

		FileExists = oFSO.FileExists(filename)
	End Function

	Public Function FolderExists( foldername )
		If (foldername = "" Or foldername = "/") Then
			FolderExists = False
			Exit function
		End If
		If (Right(foldername, 1) = "\") Then foldername = Left(foldername, Len(foldername)-1)

		FolderExists = oFSO.FolderExists(foldername)
	End Function


	Public Function DeleteFile( filename )
		If (filename = "") Then
			DeleteFile = False
			Exit function
		End If

		If (FileExists(filename)) Then
			Dim eNumber, eDescription
			On Error Resume next
			oFSO.DeleteFile filename

			eNumber = Err.number
			eDescription = Err.description
			On Error goto 0

			If (eNumber<>0) Then
				Err.raise vbObjectError + CKFINDER_CONNECTOR_ERROR_CUSTOM_ERROR, "Failed to Delete File", "(Error: " & eNumber & ", " & eDescription & ") File " & filename
				DeleteFile = False
				Exit function
			End if

			DeleteFile = true
		Else
			DeleteFile = false
		End if
	End Function

	Public Function DeleteFolder( foldername )
		If (foldername = "" Or foldername = "/") Then
			DeleteFolder = False
			Exit function
		End If
		If (Right(foldername, 1) = "\") Then foldername = Left(foldername, Len(foldername)-1)

		If (FolderExists(foldername)) then
			oFSO.DeleteFolder foldername
			DeleteFolder = true
		Else
			DeleteFolder = false
		End if
	End Function

	''
	' Get file extension (only last part - e.g. extension of file.foo.bar.jpg = jpg)
	'
	' @param string fileName
	' @return string
	'
	Public Function GetExtension(filename)
		GetExtension = oFSO.GetExtensionName(filename)
	End Function

	Public Function GetFileName(filename)
		GetFileName = oFSO.GetFileName(filename)
	End Function

	Public function GetFileSize( filePath )
		Dim oFile
		Set oFile = oFSO.GetFile( filePath )
		GetFileSize = oFile.size
		Set oFile = Nothing
	End Function

	Public function GetParentFolderName(dir)
		GetParentFolderName = oFSO.GetParentFolderName(dir)
	End Function

	Public Function RenameFolder( oldFolderName, newFolderName )
		If (oldFolderName = "" Or oldFolderName = "/") Or (newFolderName = "" Or newFolderName = "/") Then
			RenameFolder = False
			Exit function
		End If
		If (Right(oldFolderName, 1) = "\") Then oldFolderName = Left(oldFolderName, Len(oldFolderName)-1)
		If (Right(newFolderName, 1) = "\") Then newFolderName = Left(newFolderName, Len(newFolderName)-1)

		If (FolderExists(oldFolderName) And Not(FolderExists(newFolderName)) ) then
			oFSO.MoveFolder oldFolderName, newFolderName
			RenameFolder = true
		Else
			RenameFolder = false
		End if
	End Function

	Public Function RenameFile( oldFileName, newFileName )
		If (oldFileName = "") Or (newFileName = "") Then
			RenameFile = False
			Exit function
		End If

		If (FileExists(oldFileName) And Not(FileExists(newFileName)) ) then
			oFSO.MoveFile oldFileName, newFileName
			RenameFile = true
		Else
			RenameFile = false
		End if
	End Function

	Public Function CopyFile( source, target )
		If (source = "") Or (target = "") Then
			RenameFile = False
			Exit function
		End If

		If (FileExists(source) And Not(FileExists(target)) ) then
			oFSO.CopyFile source, target
			CopyFile = true
		Else
			CopyFile = false
		End if
	End Function

	''
	' Check whether fileName is a valid file name, return true on success
	'
	' @static
	' @access public
	' @param string fileName
	' @return boolean
	'
	function checkFileName(fileName)

		if (isempty(fileName) Or (fileName="")) then
			checkFileName = False
			Exit function
		End if

		if (right(fileName, Len(fileName)-1)="." or inStr(fileName, "..")) then
			checkFileName = False
			Exit function
		End if

		' check \ / | : ? * " < >
		checkFileName = Not oCKFinder_Factory.RegExp.MatchesPattern( "(\\|\/|\||:|\?|\*|""|\<|\>|[\u0000-\u001F]|\u007F)", fileName )

	End function

	Public Function GetFiles( sFolderPath )
		Dim oCurrentFolder
		Set oCurrentFolder = oFSO.GetFolder( sFolderPath )
		Set GetFiles = oCurrentFolder.Files
	End function

	Public Function GetSubFolders( sFolderPath )
		Dim oCurrentFolder
		Set oCurrentFolder = oFSO.GetFolder( sFolderPath )
		Set GetSubFolders = oCurrentFolder.SubFolders
	End Function

	''
	' Returns true if directory is not empty
	'
	' @param string serverPath
	' @return boolean
	'
	public function hasChildren( sServerDir )
		if (Not oFSO.FolderExists(sServerDir)) Then
			hasChildren = False
			Exit function
		End If

		Dim oFolder
		Set oFolder = oFSO.GetFolder( sServerDir )
		hasChildren = (oFolder.SubFolders.Count > 0)
		Set oFolder = Nothing
	End Function

	''
	' Return file name without extension (without dot & last part after dot)
	'
	' @param string fileName
	' @return string
	'
	function getFileNameWithoutExtension(fileName)
		getFileNameWithoutExtension = oFSO.getBaseName(fileName)
	End function


	''
	' Create directory recursively
	'
	' @static
	' @param string dir
	' @param int mode
	' @return boolean
	'
	function createDirectoryRecursively(dir)
		If oFSO.FolderExists(dir) Then
			createDirectoryRecursively = true
			Exit function
		End If

		If Not createDirectoryRecursively(oFSO.GetParentFolderName(dir)) Then
			createDirectoryRecursively = false
			Exit function
		End If

		Dim eNumber, eDescription
		On Error Resume next
		oFSO.CreateFolder(dir)

		eNumber = Err.number
		eDescription = Err.description
		On Error goto 0

		If (eNumber<>0) Then
			Err.raise vbObjectError + CKFINDER_CONNECTOR_ERROR_CUSTOM_ERROR, "Failed to create directory", "(Error: " & eNumber & ", " & eDescription & ") Folder: " & dir
		End if

		createDirectoryRecursively = true
	End Function

	' send the contents of a file back to the client.
	' If filename is specified then it's sent as an attachment
	Public sub sendFile(filePath, contentType, fileName)
		Dim oStream, oFile, FileSize, FileDate, FileSent
		Const BlockSize = 100000

		Response.Buffer = true
		Response.clear

		Set oFile = oFSO.GetFile( filePath )
		FileSize = oFile.size
		FileDate = oFile.DateLastModified
		Set oFile = Nothing

		Dim sLastModified, strIfModifiedSince
		Dim Etag, sentEtag

		' a simple etag based on file date + time and filesize
		Etag = """" & Hex(FileDate) & Hex( (FileDate-Fix(FileDate)) * 60*60*24) &  ":" & Hex(FileSize) & """"
		sLastModified = FormatDateRFC822(FileDate)

		sentEtag = Request.ServerVariables("HTTP_IF_NONE_MATCH")
		strIfModifiedSince=Request.ServerVariables("HTTP_IF_MODIFIED_SINCE")
		If (Len(sentEtag)) Then
			If (sentEtag=Etag) And (strIfModifiedSince=sLastModified) Then
				Response.Status = "304 Not Modified"
				Response.End
			End If
		Else
			' If it hasn't sent the etag, then check only the date.
			If (Len(strIfModifiedSince)) Then
				If CompareRFC822Dates(strIfModifiedSince, sLastModified) Then
					Response.Status = "304 Not Modified"
					Response.End
				End If
			End If
		End If

' Avoids cache:
'		Response.Expires = 0
' Allows public cache systems to cache the response
'		response.CacheControl="Public"
		Response.ContentType = contentType
		Response.AddHeader "Last-Modified", sLastModified
		Response.AddHeader "Etag", Etag
		If (fileName<>"") Then Response.AddHeader "content-disposition", "attachment; filename=""" & Replace(fileName, """", "\""") & """"
		Response.AddHeader "Content-Length", FileSize
		Response.Flush

		If (FileSize>0) then
			Set oStream = CreateObject("ADODB.Stream")

			With oStream
				.Open
				.Type = 1
				.LoadFromFile filePath
			End With

			' Send data
			FileSent = 0
			While FileSent + BlockSize < FileSize
				Response.BinaryWrite oStream.Read(BlockSize)
				FileSent = FileSent + BlockSize
				Response.Flush
			Wend
			Response.BinaryWrite oStream.Read(FileSize - FileSent)

			oStream.close
			Set oStream = Nothing
		End if
		Set oFSO = nothing
	end sub

	''
	' Creates a temporay file for validation from Asp.net
	' Returns the name of the file, excluding the path and the special extension:
	'	.ckfindertemp
	'
	Function createTempFile()

		Dim tfolder, tname
		' If the user has set a path in config.asp use it, else use the system temp path
		If (CKFinderTempPath<>"") Then
			If Not( createDirectoryRecursively( CKFinderTempPath ) ) Then
				Exit function
			End if

			Set tfolder = oFSO.GetFolder( CKFinderTempPath )
		else
			Set tfolder = oFSO.GetSpecialFolder(2)
		End If

		' If it has been called previously, delete that file
		cleanUpTempFile()

		tname = oFSO.GetTempName
		' Store the path of the file so we can always delete it, not relying on the asp.net code
		tempFilePath = combinePaths( tfolder.path, tname & ".ckfindertemp")

		CreateTextFile tempFilePath, empty
		Set tfolder = Nothing

		createTempFile = tname
	End Function

	''
	' Creates a text file, with some contents (or empty)
	'
	Function CreateTextFile( sFilePath, sContents )
		Dim fileStream
		Set fileStream = oFSO.CreateTextFile( sFilePath )
		If Not( IsEmpty(sContents) ) Then
			fileStream.Write sContents
		End If
		fileStream.close

		CreateTextFile = true
	End Function

	''
	' Deletes the temp File that was created
	'
	Private Sub cleanUpTempFile()
		' If there's no file exit
		If tempFilePath="" Then Exit Sub

		if (oFSO is nothing) then	Set oFSO = server.CreateObject("Scripting.FileSystemObject")

		On Error Resume next
		' Call the delete routine
		' In some scenarios it might be possible to create the file but not to delete it
		DeleteFile tempFilePath
		on error goto 0

		' Reset the variable
		tempFilePath = ""
	End Sub

	''
	' Creates a text file, with some contents in UTF8
	'
	Function CreateTextFileUTF8( sFilePath, sContents )
		Dim oStream
		Set oStream = Server.CreateObject("ADODB.Stream")
		oStream.Open
		oStream.CharSet = "UTF-8"
		oStream.WriteText sContents
		oStream.SaveToFile sFilePath, 2 ' UTF-8
		oStream.Close

		CreateTextFileUTF8 = true
	End Function

	''
	' Reads the contents of a text file (UTF-8)
	'
	Function ReadTextFile( sFilePath )
'		Dim fileStream
'		Set fileStream = oFSO.OpenTextFile( sFilePath, 1, false, 0) ' ReadOnly, don't create, Ascii
'		ReadTextFile = fileStream.ReadAll()
'		fileStream.close

		Dim oStream
		Set oStream = Server.CreateObject("ADODB.Stream")
		oStream.Open
		oStream.LoadFromFile sFilePath
		oStream.CharSet = "UTF-8"
		ReadTextFile = oStream.ReadText()
		oStream.Close
	End Function

End Class

</script>
