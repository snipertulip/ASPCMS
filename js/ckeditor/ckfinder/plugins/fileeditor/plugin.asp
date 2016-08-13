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
'
' CKFinder extension: provides command that saves edited file.

class CKFinder_Connector_CommandHandler_FileEditor
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
		command = "SaveFile"
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

	''
     ' handle request and build XML
     ' @access protected
     '
     '
	 function buildXml( oXML )

		if ( request.Form("CKFinderCommand") <> "true") then
			errorHandler.throwError CKFINDER_CONNECTOR_ERROR_INVALID_REQUEST, "", "Not sent by CKFinder"
		End if

        ' Saving empty file is equal to deleting a file, that's why FILE_DELETE permissions are required
        if (Not currentFolder.checkAcl(CKFINDER_CONNECTOR_ACL_FILE_DELETE)) then
			errorHandler.throwError CKFINDER_CONNECTOR_ERROR_UNAUTHORIZED, "", "Failed ACL check"
        End if

		Dim resourceTypeInfo, fileName, content, oUFS, filePath
        Set resourceTypeInfo = currentFolder.getResourceTypeConfig()

		fileName = request.form("fileName")
        if ("" = fileName) then
			errorHandler.throwError CKFINDER_CONNECTOR_ERROR_INVALID_NAME, "", "Empty fileName"
        End If

		content = request.form("Content")
        if (IsEmpty(content)) then
			errorHandler.throwError CKFINDER_CONNECTOR_ERROR_INVALID_REQUEST, "", "No content"
        End If

		Set oUFS = oCKFinder_Factory.UtilsFileSystem

		if (Not oUFS.checkFileName(fileName) Or resourceTypeInfo.checkIsHiddenFile(fileName)) then
			errorHandler.throwError CKFINDER_CONNECTOR_ERROR_INVALID_REQUEST, "", "Invalid filename"
		End if

		if (Not resourceTypeInfo.checkExtension(fileName)) then
			errorHandler.throwError CKFINDER_CONNECTOR_ERROR_INVALID_REQUEST, "", "Invalid extension"
		End if

		filePath = oUFS.combinePaths( currentFolder.getServerPath(), fileName)

		if (Not oUFS.FileExists(filePath)) then
			errorHandler.throwError CKFINDER_CONNECTOR_ERROR_FILE_NOT_FOUND, "", "File doesn't exists: " & filePath
		End if

		If Not(oUFS.DeleteFile(filePath)) then
			errorHandler.throwError CKFINDER_CONNECTOR_ERROR_ACCESS_DENIED, "", "Can't delete file: " & filePath
		End If

		If Not(oUFS.CreateTextFileUTF8(filePath, content)) then
			errorHandler.throwError CKFINDER_CONNECTOR_ERROR_ACCESS_DENIED, "", "Can't write file: " & filePath
		End If

    End function

	' Event listeners:
    public function onBeforeExecuteCommand( command )
        if ( command = "SaveFile" ) then
            sendResponse( response )
            onBeforeExecuteCommand = False
            Exit function
        End if

        onBeforeExecuteCommand = true
    End Function

End Class

	Dim CommandHandler_FileEditor

If (TypeName(oCKFinder_Factory) <> "Empty") then
	Set CommandHandler_FileEditor = new CKFinder_Connector_CommandHandler_FileEditor

	CKFinder_AddHook "BeforeExecuteCommand", CommandHandler_FileEditor

	CKFinder_AddPlugin "fileeditor"
End If

</script>
