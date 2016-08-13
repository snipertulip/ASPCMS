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
	' Handle DeleteFile command
	'
	' @package CKFinder
	' @subpackage CommandHandlers
	' @copyright CKSource - Frederico Knabben
	'
class CKFinder_Connector_CommandHandler_DeleteFile

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
		command = "DeleteFile"
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
		Dim fileName, filePath, thumbPath, oDeleteFileNode, resourceTypeConfig
		Set resourceTypeConfig = currentFolder.getResourceTypeConfig()

		if ( request.Form("CKFinderCommand") <> "true") then
			errorHandler.throwError CKFINDER_CONNECTOR_ERROR_INVALID_REQUEST, "", "Not sent by CKFinder"
		End if

		if (Not currentFolder.checkAcl(CKFINDER_CONNECTOR_ACL_FILE_DELETE)) then
			errorHandler.throwError CKFINDER_CONNECTOR_ERROR_UNAUTHORIZED, "", "Not authorized to access " & currentFolder.getClientPath
		End If

		fileName = request.queryString("FileName")

		if (Not oCKFinder_Factory.UtilsFileSystem.checkFileName(fileName)) Or resourceTypeConfig.checkIsHiddenFile(fileName) then
			errorHandler.throwError CKFINDER_CONNECTOR_ERROR_INVALID_REQUEST, "", "Invalid FileName " & fileName
		End if

        if (Not resourceTypeConfig.checkExtension(fileName)) then
            errorHandler.throwError CKFINDER_CONNECTOR_ERROR_INVALID_REQUEST, "", "Invalid Extension " & fileName
        End if

		filePath = oCKFinder_Factory.UtilsFileSystem.combinePaths(currentFolder.getServerPath(), fileName)

		if (Not oCKFinder_Factory.UtilsFileSystem.FileExists(filePath)) then
			errorHandler.throwError CKFINDER_CONNECTOR_ERROR_FILE_NOT_FOUND, "", "File doesn't exists " & fileName
		End if

		On Error Resume next
		If Not(oCKFinder_Factory.UtilsFileSystem.DeleteFile(filePath)) then
			errorHandler.throwError CKFINDER_CONNECTOR_ERROR_ACCESS_DENIED, "", "Unable to delete file " & fileName
			Exit Function
		End If

		If Err.number<>0 then
			errorHandler.throwError CKFINDER_CONNECTOR_ERROR_UNKNOWN, "Unable to delete file " & fileName, "(error:" & Err.number & ", " & Err.description & ") "
			Exit Function
		End if
		On Error goto 0

		thumbPath = oCKFinder_Factory.UtilsFileSystem.combinePaths(currentFolder.getThumbsServerPath(), fileName)

		oCKFinder_Factory.UtilsFileSystem.DeleteFile thumbPath

		Set oDeleteFileNode = oXML.connectorNode.addChild("DeletedFile")
		oDeleteFileNode.addAttribute "name", fileName

	End function

End Class

</script>
