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
	' Handle DeleteFolder command
	'
	' @package CKFinder
	' @subpackage CommandHandlers
	' @copyright CKSource - Frederico Knabben
	'
class CKFinder_Connector_CommandHandler_DeleteFolder
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
		command = "DeleteFolder"
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
		Dim sServerDir, oNewFolderNode, folderServerPath, oUFS, resourceTypeConfig
		Set resourceTypeConfig = currentFolder.getResourceTypeConfig()

		if ( request.Form("CKFinderCommand") <> "true") then
			errorHandler.throwError CKFINDER_CONNECTOR_ERROR_INVALID_REQUEST, "", "Not sent by CKFinder"
		End if

		if (Not currentFolder.checkAcl(CKFINDER_CONNECTOR_ACL_FOLDER_DELETE)) then
			errorHandler.throwError CKFINDER_CONNECTOR_ERROR_UNAUTHORIZED, "", "Not authorized to access " & currentFolder.getClientPath
		End if

		if (currentFolder.getClientPath = "/") then
			errorHandler.throwError CKFINDER_CONNECTOR_ERROR_INVALID_REQUEST, "", "Can't delete root folder"
		End If

		folderServerPath = currentFolder.getServerPath()
		Set oUFS = oCKFinder_Factory.UtilsFileSystem
		if not(oUFS.FolderExists(folderServerPath)) then
			errorHandler.throwError CKFINDER_CONNECTOR_ERROR_FOLDER_NOT_FOUND, "", "Folder doesn't exists " & folderServerPath
		End If

		On Error Resume next
		if (Not oUFS.DeleteFolder(folderServerPath)) then
			If Err.number<>0 then
				errorHandler.throwError CKFINDER_CONNECTOR_ERROR_ACCESS_DENIED, "", "Not able to delete folder " & folderServerPath & " (error:" & Err.number & ", " & Err.description & ") "
			End If
			errorHandler.throwError CKFINDER_CONNECTOR_ERROR_ACCESS_DENIED, "", "Not able to delete folder " & folderServerPath
		End If

		' We don't care about errors at this point
		oUFS.DeleteFolder currentFolder.getThumbsServerPath
		On Error goto 0
	End function
End Class

</script>
