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
	' Handle DownloadFile command
	'
	' @package CKFinder
	' @subpackage CommandHandlers
	' @copyright CKSource - Frederico Knabben
	'
class CKFinder_Connector_CommandHandler_DownloadFile

	''
	' Command name
	'
	' @access private
	' @var string
	'
	public command
	private base

	Private Sub Class_Initialize()
		Set base = new CKFinder_Connector_CommandHandler_CommandHandlerBase
		command = "DownloadFile"
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

	function sendResponse( response )
		Dim fileName, filePath, contentType, resourceTypeConfig, oUFS
		Set resourceTypeConfig = currentFolder.getResourceTypeConfig()

		Call base.checkConnector()

		Call base.checkRequest()

		if (Not currentFolder.checkAcl(CKFINDER_CONNECTOR_ACL_FILE_VIEW)) Then
			errorHandler.throwError CKFINDER_CONNECTOR_ERROR_UNAUTHORIZED, "", "Lacks file view permissions "
			Exit function
		End if

		Set oUFS = oCKFinder_Factory.UtilsFileSystem
		fileName = oUFS.GetFileName( request.queryString("FileName") )
		if (Not oUFS.checkFileName(fileName)) Or resourceTypeConfig.checkIsHiddenFile(fileName) then
			errorHandler.throwError CKFINDER_CONNECTOR_ERROR_FILE_NOT_FOUND, "", "Not a valid file "
			Exit function
		End if

        if (Not resourceTypeConfig.checkExtension(fileName)) then
            errorHandler.throwError CKFINDER_CONNECTOR_ERROR_INVALID_REQUEST, "", "Invalid Extension " & fileName
			Exit function
        End if

		filePath = oCKFinder_Factory.UtilsFileSystem.combinePaths(currentFolder.getServerPath(), fileName)
		if (Not oCKFinder_Factory.UtilsFileSystem.FileExists(filePath) ) then
			errorHandler.throwError CKFINDER_CONNECTOR_ERROR_FILE_NOT_FOUND, "", "File doesn't exists "
			Exit function
		End if

		contentType = "application/octet-stream;" ' name=""" & Replace( oCKFinder_Factory.UtilsFileSystem.GetFileName( filePath ), """", "\""") & """"
		If request.queryString("format")="text" Then contentType = "text/plain; charset=utf-8"
		oCKFinder_Factory.UtilsFileSystem.sendFile filePath, contentType, oCKFinder_Factory.UtilsFileSystem.GetFileName( filePath )

		response.end
	End function
End Class

</script>
