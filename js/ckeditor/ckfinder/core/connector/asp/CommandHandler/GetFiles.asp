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
	' Handle GetFiles command
	'
	' @package CKFinder
	' @subpackage CommandHandlers
	' @copyright CKSource - Frederico Knabben
	'
class CKFinder_Connector_CommandHandler_GetFiles

	''
	' Command name
	'
	' @access private
	' @var string
	'
	private command
	Private oFSO
	Private oRegexImage

	'pseudo inheritance
	private base

	Private Sub Class_Initialize()
		Set base = new CKFinder_Connector_CommandHandler_XmlCommandHandlerBase
		Set base.child = me
		command = "GetFiles"

		Set oRegexImage	= New RegExp
		oRegexImage.IgnoreCase	= True
		oRegexImage.Pattern	= "\.(jpg|gif|png|bmp|jpeg)$"
	End Sub

	Private Sub Class_Terminate()
		Set base.child = Nothing
		Set base = Nothing
		Set oRegexImage	= Nothing
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
		Dim oUFS, sServerDir, oFilesNode, oFolderNode, oFiles, oFile, oResourceTypeInfo
		Set oUFS = oCKFinder_Factory.UtilsFileSystem

		if (Not currentFolder.checkAcl(CKFINDER_CONNECTOR_ACL_FILE_VIEW)) then
			errorHandler.throwError CKFINDER_CONNECTOR_ERROR_UNAUTHORIZED, "", "Not authorized to access " & currentFolder.getClientPath
		End if

		' Map the virtual path to the local server path
		sServerDir = currentFolder.getServerPath()

		if (Not oUFS.FolderExists(sServerDir)) then
			errorHandler.throwError CKFINDER_CONNECTOR_ERROR_FOLDER_NOT_FOUND, "", "Folder doesn't exists " & sServerDir
		End if

		' Create the "Files" node
		Set oFilesNode = oXML.connectorNode.addChild("Files")

		Set oFiles = oUFS.GetFiles( sServerDir )
		Set oResourceTypeInfo = currentFolder.getResourceTypeConfig()
		Dim thumbnailsConfig, thumbServerPath, showThumbs
		Set thumbnailsConfig = oCKFinder_Factory.Config.getThumbnailsConfig()
		thumbServerPath = ""
		showThumbs = (Request.QueryString("showThumbs")="1")
		If (thumbnailsConfig.getIsEnabled() And (thumbnailsConfig.getDirectAccess() Or showThumbs)) Then
			'directThumbAccess = True
			thumbServerPath = currentFolder.getThumbsServerPath()
		End If

		For Each oFile in oFiles
			If (oResourceTypeInfo.checkExtension( oFile.name ) And Not(oResourceTypeInfo.checkIsHiddenFile( oFile.name)) ) then
				' Create the "Folder" node
				Set oFolderNode = oFilesNode.addChild("File")

				oFolderNode.addAttribute "name", oFile.name
				oFolderNode.addAttribute "date", oFile.DateLastModified

				If (thumbServerPath <> "") Then
					If IsImage( oFile.name ) Then
						If oUFS.fileExists( oUFS.combinePaths(thumbServerPath, oFile.name) ) Then
							oFolderNode.addAttribute "thumb", oFile.name
						ElseIf showThumbs then
							oFolderNode.addAttribute "thumb", "?" & oFile.name
						End if
					End if
				End if

				Dim iFileSize
				iFileSize = Round( oFile.size / 1024 )
				If ( iFileSize < 1 AND oFile.size <> 0 ) Then iFileSize = 1

				oFolderNode.addAttribute "size",iFileSize
			End if
		Next
	End Function

	' Checks if a file name looks like an image
	Private Function IsImage( file )
		IsImage = oRegexImage.Test( file )
	End Function

End Class

</script>
