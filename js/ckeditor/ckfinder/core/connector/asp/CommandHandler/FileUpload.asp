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
	' Handle FileUpload command
	'
	' @package CKFinder
	' @subpackage CommandHandlers
	' @copyright CKSource - Frederico Knabben
	'
class CKFinder_Connector_CommandHandler_FileUpload

	''
	' Command name
	'
	' @access private
	' @var string
	'
	private command
	private base

	Private Sub Class_Initialize()
		Set base = new CKFinder_Connector_CommandHandler_CommandHandlerBase
		command = "FileUpload"
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

	Private oUploader
	Private resourceTypeConfig
	Private oRegistry
	Private checkSizeAfterScaling

	function sendResponse( response )
		set oRegistry = oCKFinder_Factory.Registry
		oRegistry.Item("FileUpload_fileName") = "unknown file"
		oRegistry.Item("FileUpload_url") = currentFolder.getUrl()

		base.checkConnector
		base.checkRequest

		if (Not currentFolder.checkAcl(CKFINDER_CONNECTOR_ACL_FILE_UPLOAD)) then
			errorHandler.throwError CKFINDER_CONNECTOR_ERROR_UNAUTHORIZED, false, "Not authorized to access " & currentFolder.getClientPath
			Exit function
		End If

		Set resourceTypeConfig = currentFolder.getResourceTypeConfig()

		Set oUploader = New NetRube_Upload
		checkSizeAfterScaling = oCKFinder_Factory.Config.getCheckSizeAfterScaling()
		oUploader.MaxSize = 0
		If not(checkSizeAfterScaling) then
			oUploader.MaxSize = resourceTypeConfig.getMaxSize
		End if

		oUploader.Allowed	= resourceTypeConfig.getAllowedExtensions
		oUploader.Denied	= resourceTypeConfig.getDeniedExtensions
		oUploader.HtmlExtensions = oCKFinder_Factory.Config.getHtmlExtensions
		oUploader.GetData

		If oUploader.ErrNum > 0 Then
			If (oUploader.ErrNum = 1) Then errorHandler.throwError CKFINDER_CONNECTOR_ERROR_UPLOADED_INVALID, false, "Component error in GetData: " & oUploader.ErrNum
			If (oUploader.ErrNum = 2) Then errorHandler.throwError CKFINDER_CONNECTOR_ERROR_UPLOADED_CORRUPT, false, "Component error in GetData: " & oUploader.ErrNum
			If (oUploader.ErrNum = 3) Then errorHandler.throwError CKFINDER_CONNECTOR_ERROR_UPLOADED_TOO_BIG, false, "Component error in GetData: " & oUploader.ErrNum

			If (oUploader.ErrNum = 7) Then errorHandler.throwError CKFINDER_CONNECTOR_ERROR_CUSTOM_ERROR, "Corrupted data", "Component error in GetData: " & oUploader.ErrNum

			errorHandler.throwError CKFINDER_CONNECTOR_ERROR_CUSTOM_ERROR, oUploader.ErrDescription, "Component error in GetData: " & oUploader.ErrNum
			Exit function
		End If

		' Get the uploaded file name.
		If (oUploader.File.Count <> 1) Then errorHandler.throwError CKFINDER_CONNECTOR_ERROR_CUSTOM_ERROR, false, "The command requires ONE file uploaded. Count: " & oUploader.File.Count

		Dim FieldName
		' I can't get the "Keys" property to work. Using the For Each seems the only way to get the uploaded file names
		For Each FieldName In oUploader.File
			sendResponse = SaveFile( FieldName )
		Next
	End Function

	Private Function SaveFile(FieldName)
		Dim sFileName, sUnsafeFileName, sExtension, oUFS, sOriginalFileName, iCounter, sServerDir, iErrorNumber
		iErrorNumber = 0

		sUnsafeFileName	= oUploader.File( FieldName ).Name
		sFileName = oCKFinder_Factory.RegExp.ReplacePattern("[\:\*\?\|\/]", sUnsafeFileName, "_")
		If (sFileName <> sUnsafeFileName) Then iErrorNumber = CKFINDER_CONNECTOR_ERROR_UPLOADED_INVALID_NAME_RENAMED

		sExtension	= oCKFinder_Factory.UtilsFileSystem.GetExtension( sFileName )

'Feva filename
		Randomize
		Dim SystemDateTime : SystemDateTime = Now()
		Dim CacheString : CacheString = Year(SystemDateTime) & Month(SystemDateTime) & Day(SystemDateTime) & Minute(SystemDateTime) & Second(SystemDateTime) & CStr(CLng(89999*Rnd+10000))
		sFileName = CacheString & "." & sExtension
'Feva

		' Properly check that it's safe
		Set oUFS = oCKFinder_Factory.UtilsFileSystem
		if (Not resourceTypeConfig.checkExtension(sFileName)) then
			errorHandler.throwError CKFINDER_CONNECTOR_ERROR_INVALID_EXTENSION, false, "Invalid extension " & sFileName
			Exit function
		End if
		if (Not oUFS.checkFileName(sFileName)) Or resourceTypeConfig.checkIsHiddenFile(sFileName) then
			errorHandler.throwError CKFINDER_CONNECTOR_ERROR_INVALID_NAME, false, "Invalid file name " & sFileName
			Exit function
		End If

		sOriginalFileName = sFileName
		oRegistry.Item("FileUpload_fileName") = sFileName

		iCounter = 0
		sServerDir = currentFolder.getServerPath()

		Do While ( True )
			Dim sFilePath
			sFilePath = oUFS.CombinePaths(sServerDir, sFileName)

			If ( oUFS.FileExists( sFilePath ) ) Then
				iCounter = iCounter + 1
				sFileName = oUFS.getFileNameWithoutExtension( sOriginalFileName ) & "(" & iCounter & ")." & sExtension
				oRegistry.Item("FileUpload_fileName") = sFileName
				iErrorNumber = CKFINDER_CONNECTOR_ERROR_UPLOADED_FILE_RENAMED
			Else
				On Error Resume next
				oUploader.SaveAs FieldName, sFilePath
				If Err.number<>0 Then
					errorHandler.throwError CKFINDER_CONNECTOR_ERROR_ACCESS_DENIED, false, "(error: " & Err.number & ", " & Err.description & ")"
					Exit function
				End if
				On Error GoTo 0

				If (oUploader.ErrNum = 2) Then
					errorHandler.throwError CKFINDER_CONNECTOR_ERROR_UPLOADED_CORRUPT, false, "Component error in SaveAs: " & oUploader.ErrNum
					Exit function
				End if
				' FileName Invalid
				If (oUploader.ErrNum = 4) Then
					errorHandler.throwError CKFINDER_CONNECTOR_ERROR_UPLOADED_INVALID, false, "Component error in SaveAs: " & oUploader.ErrNum
					Exit function
				End if
				' HTML
				If (oUploader.ErrNum = 5) Then
					errorHandler.throwError CKFinder_Connector_Error_UploadedWrongHtmlFile, false, "Component error in SaveAs: " & oUploader.ErrNum
					Exit function
				End if

				If oUploader.ErrNum > 0 Then iErrorNumber = CKFINDER_CONNECTOR_ERROR_ACCESS_DENIED
				Exit Do
			End If
		Loop

		if ( oCKFinder_Factory.Config.getSecureImageUploads ) Then
			If oCKFinder_Factory.UtilsImage.isImage(sFilePath) And Not(oCKFinder_Factory.UtilsImage.isImageValid(sFilePath) ) Then
				oUFS.DeleteFile sFilePath
				errorHandler.throwError CKFINDER_CONNECTOR_ERROR_UPLOADED_CORRUPT, false, "Not a valid image"
				Exit function
			End if
		End if

		' Resize if required
		Dim imagesConfig, tmpPath
		If oCKFinder_Factory.UtilsImage.isImage(sFilePath) then
			Set imagesConfig = oCKFinder_Factory.Config.getImagesConfig

			if (imagesConfig.getMaxWidth()>0 and imagesConfig.getMaxHeight()>0 and imagesConfig.getQuality()>0) Then
				' We need to preserve the extension in the tmp file
				tmpPath = sFilePath & "_tmp." & sExtension
				If oCKFinder_Factory.UtilsImage.createThumb(sFilePath, tmpPath, imagesConfig.getMaxWidth(), imagesConfig.getMaxHeight(), imagesConfig.getQuality(), True) then
					oUFS.DeleteFile sFilePath
					oUFS.RenameFile tmpPath, sFilePath
				else
					oUFS.DeleteFile sFilePath
					errorHandler.throwError CKFINDER_CONNECTOR_ERROR_UPLOADED_INVALID, false, "Not a valid image"
					Exit function
				End if
			End If
		End if

		If ( checkSizeAfterScaling And resourceTypeConfig.getMaxSize>0 ) Then
			Dim size
			size = oUFS.GetFileSize(sFilePath)
			If (resourceTypeConfig.getMaxSize < size ) Then
				oUFS.DeleteFile sFilePath
				errorHandler.throwError CKFINDER_CONNECTOR_ERROR_UPLOADED_TOO_BIG, false, "Size too big " & size
				Exit function
			End if
		End If

		Dim args(2)
		Set args(0) = currentFolder
		Set args(1) = oUploader.File( FieldName )
		args(2) = sFilePath
		oCKFinder_Factory.Hooks.run "AfterFileUpload", args

		errorHandler.throwError iErrorNumber, true, oUploader.ErrNum
	End Function

End Class

</script>
