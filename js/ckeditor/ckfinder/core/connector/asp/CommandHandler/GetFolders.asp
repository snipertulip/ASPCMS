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
	' Handle GetFolders command
	'
	' @package CKFinder
	' @subpackage CommandHandlers
	' @copyright CKSource - Frederico Knabben
	'
class CKFinder_Connector_CommandHandler_GetFolders
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
		command = "GetFolders"
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
		Dim oUFS, sServerDir, oFoldersNode, oFolderNode, oFolders, oFolder, oAcl, aclMask, oResourceTypeConfig
		Set oUFS = oCKFinder_Factory.UtilsFileSystem

		if (Not currentFolder.checkAcl(CKFINDER_CONNECTOR_ACL_FOLDER_VIEW)) then
			errorHandler.throwError CKFINDER_CONNECTOR_ERROR_UNAUTHORIZED, "", "Not authorized to access " & currentFolder.getClientPath
		End if

		' Map the virtual path to the local server path
		sServerDir = currentFolder.getServerPath()

		if (Not oUFS.FolderExists(sServerDir)) then
			errorHandler.throwError CKFINDER_CONNECTOR_ERROR_FOLDER_NOT_FOUND, "", "Folder not found " & sServerDir
		End if

		' Create the "Folders" node
		Set oFoldersNode = oXML.connectorNode.addChild("Folders")
		Set oFolders = oUFS.GetSubFolders( sServerDir )
		Set oAcl = oCKFinder_Factory.Config.getAccessControlConfig()
		Set oResourceTypeConfig = currentFolder.getResourceTypeConfig()

		For Each oFolder in oFolders
			aclMask = oAcl.getComputedMask(currentFolder.getResourceTypeName(), currentFolder.getClientPath() & oFolder.name & "/")

			if ((aclMask and CKFINDER_CONNECTOR_ACL_FOLDER_VIEW) = CKFINDER_CONNECTOR_ACL_FOLDER_VIEW) Then
				If Not(oResourceTypeConfig.checkIsHiddenFolder( oFolder.name)) then
					' Create the "Folder" node
					Set oFolderNode = oFoldersNode.addChild("Folder")

					oFolderNode.addAttribute "name", oFolder.name
					oFolderNode.addAttribute "hasChildren", oUFS.hasChildren( oUFS.combinePaths(sServerDir, oFolder.name) )
					oFolderNode.addAttribute "acl", aclMask
				End if
			End if
		Next
	End function

End Class

</script>
