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

Class CKFinder_Connector_CommandHandler_CommandHandlerBase
	''
	' CKFinder_Connector_Core_Connector object
	'
	' @access protected
	'
	Dim oConnector

	''
	' CKFinder_Connector_Core_FolderHandler object
	'
	' @access protected
	'
	dim oCurrentFolder

	''
	' Error handler object
	'
	' @access protected
	' @var CKFinder_Connector_ErrorHandler_Base|CKFinder_Connector_ErrorHandler_FileUpload
	'
	dim oErrorHandler

	Private Sub Class_Initialize()
		Set oCurrentFolder = oCKFinder_Factory.FolderHandler
		Set oConnector = oCKFinder_Factory.Connector
		Set oErrorHandler = oConnector.ErrorHandler
	End Sub

	Public Property Get ErrorHandler()
		Set ErrorHandler = oErrorHandler
	End property

	Public Property Get currentFolder()
		Set currentFolder = oCurrentFolder
	End Property


	''
	' Check whether Connector is enabled
	'
	Public sub checkConnector()
		if not(oCKFinder_Factory.Config.getIsEnabled()) then
			errorHandler.throwError CKFINDER_CONNECTOR_ERROR_CONNECTOR_DISABLED, "", "Set 'CKFinder_Config.Add ""Enabled"", true' in your config.asp file"
		End if
	End sub

	''
	' Check request
	'
	Public Sub checkRequest()
		if (oCKFinder_Factory.RegExp.MatchesPattern( CKFINDER_REGEX_INVALID_PATH, currentFolder.getClientPath())) then
			errorHandler.throwError CKFINDER_CONNECTOR_ERROR_INVALID_NAME, "", currentFolder.getClientPath()
		End if

		Dim resourceTypeConfig
		Set resourceTypeConfig = currentFolder.getResourceTypeConfig()

		if (resourceTypeConfig Is Nothing) then
			errorHandler.throwError CKFINDER_CONNECTOR_ERROR_INVALID_TYPE, "", ""
		End if

		Dim clientPath, clientPathParts, i, part
		clientPath = currentFolder.getClientPath()
		clientPathParts = split (clientPath, "/")
		For i = lbound(clientPathParts) To UBound(clientPathParts)
			part = clientPathParts(i)
			If part<>"" then
				If (resourceTypeConfig.checkIsHiddenFolder( part )) Then
					errorHandler.throwError CKFINDER_CONNECTOR_ERROR_INVALID_REQUEST, "", part & " is a hidden folder name"
				End if
			End if
		Next

		if not(oCKFinder_Factory.UtilsFileSystem.FolderExists(currentFolder.getServerPath())) then
			if ( clientPath = "/") then

			   dim ok
			   on error resume next
			   ok = oCKFinder_Factory.UtilsFileSystem.createDirectoryRecursively( currentFolder.getServerPath() )
			   if (err.number<>0) then
					   errorHandler.throwError CKFINDER_CONNECTOR_ERROR_CUSTOM_ERROR, "Unable to create root folder", "Error creating the folder: " & err.description
			   end if
			   on error goto 0

			   if not(ok) then errorHandler.throwError CKFINDER_CONNECTOR_ERROR_CUSTOM_ERROR, "Unable to create root folder", "Failed to create " & currentFolder.getServerPath()

			else
				errorHandler.throwError CKFINDER_CONNECTOR_ERROR_FOLDER_NOT_FOUND, "", "Folder doesn't exists " & currentFolder.getServerPath()
			End if
		End if
	End Sub

End Class

</script>
