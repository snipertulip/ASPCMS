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
	' @subpackage CommandHandlers
	' @copyright CKSource - Frederico Knabben
	'

	''
	' Handle RenameFile command
	'
	' @package CKFinder
	' @subpackage CommandHandlers
	' @copyright CKSource - Frederico Knabben
	'
class CKFinder_Connector_CommandHandler_RenameFile
	''
	' Command name
	'
	' @access private
	' @var string
	'
	private command

	'pseudo inheritance
	private base

	Private Sub Class_Initialize()
		Set base = new CKFinder_Connector_CommandHandler_XmlCommandHandlerBase
		Set base.child = me
		command = "RenameFile"
	End Sub

	Private Sub Class_Terminate()
		Set base.child = Nothing
		Set base = Nothing
	End Sub

	' Pseudo inheritance
	Public Property Get currentFolder()
		Set currentFolder = base.currentFolder
	End Property

	Public Sub sendResponse(response)
		base.sendResponse(response)
	End sub

	Public Property Get ErrorHandler()
		Set ErrorHandler = base.ErrorHandler
	End Property

	function buildXml( oXML )
		Dim fileName, newFileName, oRenamedFileNode, filePath, newFilePath, thumbPath, oResourceTypeConfig
		Dim oUFS

		if ( request.Form("CKFinderCommand") <> "true") then
			errorHandler.throwError CKFINDER_CONNECTOR_ERROR_INVALID_REQUEST, "", "Not sent by CKFinder"
		End if

		if (Not currentFolder.checkAcl(CKFINDER_CONNECTOR_ACL_FILE_RENAME)) then
			errorHandler.throwError CKFINDER_CONNECTOR_ERROR_UNAUTHORIZED, "", "Not authorized to access " & currentFolder.getClientPath
		End if

		fileName = request.queryString("fileName")
		newFileName = request.queryString("newFileName")

		Set oRenamedFileNode = oXML.connectorNode.addChild("RenamedFile")
		oRenamedFileNode.addAttribute "name", fileName

		Set oResourceTypeConfig = currentFolder.getResourceTypeConfig()
		if (Not oResourceTypeConfig.checkExtension(newFileName)) then
			errorHandler.throwError CKFINDER_CONNECTOR_ERROR_INVALID_EXTENSION, "", "Invalid extension " & newFileName
		End if

		Set oUFS = oCKFinder_Factory.UtilsFileSystem
		if (Not oUFS.checkFileName(fileName)) Or oResourceTypeConfig.checkIsHiddenFile( fileName ) then
			errorHandler.throwError CKFINDER_CONNECTOR_ERROR_INVALID_REQUEST, "", "Invalid filename " & fileName
		End If

		if (Not oUFS.checkFileName(newFileName)) Or oResourceTypeConfig.checkIsHiddenFile( newFileName ) then
			errorHandler.throwError CKFINDER_CONNECTOR_ERROR_INVALID_NAME, "", "Invalid filename " & newFileName
		End If

        if (Not oResourceTypeConfig.checkExtension(fileName)) then
            errorHandler.throwError CKFINDER_CONNECTOR_ERROR_INVALID_REQUEST, "", "Invalid extension " & fileName
        End if

		filePath = oUFS.combinePaths(currentFolder.getServerPath(), fileName)
		newFilePath = oUFS.combinePaths(currentFolder.getServerPath(), newFileName)

		if (Not oUFS.FileExists(filePath)) then
			errorHandler.throwError CKFINDER_CONNECTOR_ERROR_FILE_NOT_FOUND, "", "File doesn't exists " & filePath
		End if

		if (oUFS.FolderExists(newFilePath)) then
			errorHandler.throwError CKFINDER_CONNECTOR_ERROR_ALREADY_EXIST, "", "Destination file/folder already exists " & newFilePath
		End if

		if (oUFS.FileExists(newFilePath)) then
			errorHandler.throwError CKFINDER_CONNECTOR_ERROR_ALREADY_EXIST, "", "Destination file/folder already exists " & newFilePath
		End if

'		if (Not is_writable(dirname(newFilePath)))
'			errorHandler.throwError(CKFINDER_CONNECTOR_ERROR_ACCESS_DENIED)
'		}
'
'		if (Not is_writable(filePath))
'			errorHandler.throwError(CKFINDER_CONNECTOR_ERROR_ACCESS_DENIED)
'		}

		oRenamedFileNode.addAttribute "newName", newFileName

		On Error Resume next
		oUFS.RenameFile filePath, newFilePath

		If Err.number<>0 then
			errorHandler.throwError CKFINDER_CONNECTOR_ERROR_UNKNOWN, "File " & fileName & " has not been renamed", "(error:" & Err.number & ", " & Err.description & ") "
		else
			thumbPath = oUFS.combinePaths(currentFolder.getThumbsServerPath(), fileName)
			If (oUFS.FileExists(thumbPath)) Then oUFS.deleteFile thumbPath
		End If
		On Error goto 0
	End function
End Class

</script>
