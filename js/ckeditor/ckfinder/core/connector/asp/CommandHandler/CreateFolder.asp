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
	' Handle CreateFolder command
	'
	' @package CKFinder
	' @subpackage CommandHandlers
	' @copyright CKSource - Frederico Knabben
	'
class CKFinder_Connector_CommandHandler_CreateFolder

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
		command = "CreateFolder"
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
		Dim oUFS, sServerDir, oNewFolderNode, sNewFolderName, resourceTypeConfig
		Set oUFS = oCKFinder_Factory.UtilsFileSystem
		Set resourceTypeConfig = currentFolder.getResourceTypeConfig()

		if ( request.Form("CKFinderCommand") <> "true") then
			errorHandler.throwError CKFINDER_CONNECTOR_ERROR_INVALID_REQUEST, "", "Not sent by CKFinder"
		End if

		if (Not currentFolder.checkAcl(CKFINDER_CONNECTOR_ACL_FOLDER_CREATE)) then
			errorHandler.throwError CKFINDER_CONNECTOR_ERROR_UNAUTHORIZED, "", "Not authorized to access " & currentFolder.getClientPath
		End if

		sNewFolderName = request.queryString("NewFolderName") & ""
		if (Not oUFS.checkFileName(sNewFolderName)) Or resourceTypeConfig.checkIsHiddenFolder(sNewFolderName) then
			errorHandler.throwError CKFINDER_CONNECTOR_ERROR_INVALID_NAME, "", "Invalid folder name " & sNewFolderName
		End if

		if (Not oUFS.FolderExists(currentFolder.getServerPath )) then
			errorHandler.throwError CKFINDER_CONNECTOR_ERROR_FOLDER_NOT_FOUND, "", "Current folder doesn't exists: " & currentFolder.getServerPath
		End if

		' Map the virtual path to the local server path
		sServerDir = oUFS.CombinePaths(currentFolder.getServerPath(), sNewFolderName)

		if (oUFS.FolderExists(sServerDir)) then
			errorHandler.throwError CKFINDER_CONNECTOR_ERROR_ALREADY_EXIST, "", "Destination folder already exists " & sServerDir
		End if

		On Error Resume next
		if (Not oUFS.createDirectoryRecursively(sServerDir)) then
			If Err.number<>0 then
				errorHandler.throwError CKFINDER_CONNECTOR_ERROR_ACCESS_DENIED, "", "Not able to create folder " & sServerDir & " (error:" & Err.number & ", " & Err.description & ") "
			End If
			errorHandler.throwError CKFINDER_CONNECTOR_ERROR_ACCESS_DENIED, "", "Not able to create folder " & sServerDir
		End If

		On Error goto 0

		' Create the "NewFolder" node
		Set oNewFolderNode = oXML.connectorNode.addChild("NewFolder")

		oNewFolderNode.addAttribute "name", sNewFolderName
	End Function

End Class

</script>
