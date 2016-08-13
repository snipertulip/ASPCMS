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
	' Handle RenameFolder command
	'
	' @package CKFinder
	' @subpackage CommandHandlers
	' @copyright CKSource - Frederico Knabben
	'
class CKFinder_Connector_CommandHandler_RenameFolder

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
		command = "RenameFolder"
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
		Dim oUFS, newFolderName, oldFolderPath, newFolderPath
		Dim oResourceTypeConfig, newFolderUrl, oRenameNode
		Set oUFS = oCKFinder_Factory.UtilsFileSystem

		if ( request.Form("CKFinderCommand") <> "true") then
			errorHandler.throwError CKFINDER_CONNECTOR_ERROR_INVALID_REQUEST, "", "Not sent by CKFinder"
		End if

		if (Not currentFolder.checkAcl(CKFINDER_CONNECTOR_ACL_FOLDER_RENAME)) then
			errorHandler.throwError CKFINDER_CONNECTOR_ERROR_UNAUTHORIZED, "", "Not authorized to access " & currentFolder.getClientPath
		End if

		if (currentFolder.getClientPath = "/") then
			errorHandler.throwError CKFINDER_CONNECTOR_ERROR_INVALID_REQUEST, "", "Can't rename root folder"
		End if

		newFolderName = request.queryString("NewFolderName")
		Set oResourceTypeConfig = currentFolder.getResourceTypeConfig()

		if (Not oUFS.checkFileName(newFolderName)) Or oResourceTypeConfig.checkIsHiddenFolder( newFolderName)  then
			errorHandler.throwError CKFINDER_CONNECTOR_ERROR_INVALID_NAME, "", "Invalid folder name " & newFolderName
		End if

		oldFolderPath = currentFolder.getServerPath()

		if (Not oUFS.FolderExists(oldFolderPath)) then
			errorHandler.throwError CKFINDER_CONNECTOR_ERROR_INVALID_REQUEST, "", "Source folder doesn't exists " & oldFolderPath
		End if

		'let's calculate new folder name
		newFolderPath = oUFS.combinePaths(oUFS.GetParentFolderName(oldFolderPath), newFolderName)

		if (oUFS.FolderExists(newFolderPath)) then
			errorHandler.throwError CKFINDER_CONNECTOR_ERROR_ALREADY_EXIST, "", "Destination file/folder already exists " & newFolderPath
		End if

		if (oUFS.FileExists(newFolderPath)) then
			errorHandler.throwError CKFINDER_CONNECTOR_ERROR_ALREADY_EXIST, "", "Destination file/folder already exists " & newFolderPath
		End if

		On Error Resume next
		if (Not oUFS.RenameFolder(oldFolderPath, newFolderPath)) then
			If Err.number<>0 then
				errorHandler.throwError CKFINDER_CONNECTOR_ERROR_ACCESS_DENIED, "", "(error:" & Err.number & ", " & Err.description & ") "
			End If
			errorHandler.throwError CKFINDER_CONNECTOR_ERROR_ACCESS_DENIED, "", "Not able to rename folders"
		End If

		Dim newThumbsServerPath
		newThumbsServerPath =  oUFS.combinePaths( oUFS.GetParentFolderName( currentFolder.getThumbsServerPath() ), newFolderName)
		If Not(oUFS.RenameFolder( currentFolder.getThumbsServerPath() , newThumbsServerPath) ) then
			oUFS.DeleteFolder currentFolder.getThumbsServerPath()
		End If

		On Error goto 0

		newFolderPath =  oCKFinder_Factory.RegExp.ReplacePattern( "[^/]+/?$", currentFolder.getClientPath(), newFolderName) & "/"

		newFolderUrl = oUFS.combineUrls(oResourceTypeConfig.getUrl(), newFolderPath)

		Set oRenameNode = oXML.connectorNode.addChild("RenamedFolder")
		oRenameNode.addAttribute "newName", newFolderName
		oRenameNode.addAttribute "newPath", newFolderPath
		oRenameNode.addAttribute "newUrl", newFolderUrl
	End Function

End Class

</script>
