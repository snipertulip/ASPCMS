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
	' Handle Thumbnail command (create thumbnail if doesn't exist)
	'
	' @package CKFinder
	' @subpackage CommandHandlers
	' @copyright CKSource - Frederico Knabben
	'
class CKFinder_Connector_CommandHandler_Thumbnail

	''
	' Command name
	'
	' @access private
	' @var string
	'

	private base
	public command

	Private Sub Class_Initialize()
		Set base = new CKFinder_Connector_CommandHandler_CommandHandlerBase
		command = "Thumbnail"
	End Sub

	Private Sub Class_Terminate()
		Set base = nothing
	End Sub

	Public Property Get ErrorHandler()
		Set ErrorHandler = base.ErrorHandler
	End Property

	Public Property Get currentFolder()
		Set currentFolder = base.currentFolder
	End Property

	''
	' Send response
	' @access public
	'
	'
	function sendResponse( response )
		Dim thumbnails, fileName, thumbFilePath, sourceFilePath, contentType, oUFS, resourceTypeConfig

		Call base.checkConnector()

		Call base.checkRequest()

		Set thumbnails = oCKFinder_Factory.Config.getThumbnailsConfig()
		if not(thumbnails.getIsEnabled()) then
			errorHandler.throwError CKFINDER_CONNECTOR_ERROR_THUMBNAILS_DISABLED, "", "Thumbnails are disabled"
			Exit function
		End if

		if (Not currentFolder.checkAcl(CKFINDER_CONNECTOR_ACL_FILE_VIEW)) then
			errorHandler.throwError CKFINDER_CONNECTOR_ERROR_UNAUTHORIZED, "", "Lacks file view permission"
		End if

		fileName = request.queryString("FileName")

		Set oUFS = oCKFinder_Factory.UtilsFileSystem
		Set resourceTypeConfig = currentFolder.getResourceTypeConfig()
		if (Not oUFS.checkFileName(fileName)) then
			errorHandler.throwError CKFINDER_CONNECTOR_ERROR_INVALID_REQUEST, "", "Invalid file name"
		End if

		if resourceTypeConfig.checkIsHiddenFile(fileName) then
			errorHandler.throwError CKFINDER_CONNECTOR_ERROR_FILE_NOT_FOUND, "", "File is hidden"
		End if

		thumbFilePath = oCKFinder_Factory.UtilsFileSystem.combinePaths(currentFolder.getThumbsServerPath(), fileName)

		' If the thumbnail file doesn't exists, create it now.
		if not(oCKFinder_Factory.UtilsFileSystem.FileExists(thumbFilePath)) then

			sourceFilePath = oCKFinder_Factory.UtilsFileSystem.combinePaths(currentFolder.getServerPath(), fileName)

			if not(oCKFinder_Factory.UtilsFileSystem.FileExists(sourceFilePath)) Then
				errorHandler.throwError CKFINDER_CONNECTOR_ERROR_FILE_NOT_FOUND, "", "Source file doesn't exists"
			End if

			If not(oCKFinder_Factory.UtilsImage.createThumb(sourceFilePath, thumbFilePath, thumbnails.getMaxWidth(), thumbnails.getMaxHeight(), thumbnails.getQuality(), true)) then
				sendResponse = False
				Exit function
			End if
		End if

		contentType = "image/" & LCase(oCKFinder_Factory.UtilsFileSystem.GetExtension( thumbFilePath ) ) & _
					"; name=""" & Replace( oCKFinder_Factory.UtilsFileSystem.GetFileName( thumbFilePath ), """", "\""") & """"
		oCKFinder_Factory.UtilsFileSystem.sendFile thumbFilePath, contentType, ""

		response.end
	End function

End Class

</script>
