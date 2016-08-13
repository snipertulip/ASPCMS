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
	' @subpackage Core
	' @copyright CKSource - Frederico Knabben
	'

	''
	' Executes all commands
	'
	' @package CKFinder
	' @subpackage Core
	' @copyright CKSource - Frederico Knabben
	'

Class CKFinder_Connector_Core_Connector
	private oErrorHandler

	Private Sub Class_Initialize()
	End Sub

	Private Sub Class_Terminate()
		Set oErrorHandler = nothing
	End Sub

    ''
     ' Generic handler for invalid commands
     ' @access private
     '
     '
    Private function handleInvalidCommand( sCommand )
        ErrorHandler.throwError CKFINDER_CONNECTOR_ERROR_INVALID_COMMAND, "", "Invalid command " & sCommand
    End function

	Public Sub executeCommand( sCommand )
		Dim args(0)
		args(0) = sCommand
		If Not(oCKFinder_Factory.Hooks.run("BeforeExecuteCommand", args)) Then
			Exit sub
		End if

		Dim commandHandler
		If IsEmpty(sCommand) Then
			handleInvalidCommand "{empty}"
		Else
			Select case sCommand

				case "CopyFiles"
					Set commandHandler = new CKFinder_Connector_CommandHandler_CopyFiles

				case "CreateFolder"
					Set commandHandler = new CKFinder_Connector_CommandHandler_CreateFolder

				case "DeleteFile"
					Set commandHandler = new CKFinder_Connector_CommandHandler_DeleteFile

				case "DeleteFolder"
					Set commandHandler = new CKFinder_Connector_CommandHandler_DeleteFolder

				case "DownloadFile"
					Set oErrorHandler = new CKFinder_Connector_ErrorHandler_Http
					Set commandHandler = new CKFinder_Connector_CommandHandler_DownloadFile

				case "FileUpload"
					Set oErrorHandler = new CKFinder_Connector_ErrorHandler_FileUpload
					Set commandHandler = new CKFinder_Connector_CommandHandler_FileUpload

				case "GetFiles"
					Set commandHandler = new CKFinder_Connector_CommandHandler_GetFiles

				case "GetFolders"
					Set commandHandler = new CKFinder_Connector_CommandHandler_GetFolders

				Case "Init"
					Set commandHandler = New CKFinder_Connector_CommandHandler_CommandHandlerInit

				case "MoveFiles"
					Set commandHandler = new CKFinder_Connector_CommandHandler_MoveFiles

				case "QuickUpload"
					Set oErrorHandler = new CKFinder_Connector_ErrorHandler_QuickUpload
					Set commandHandler = new CKFinder_Connector_CommandHandler_QuickUpload

				case "RenameFile"
					Set commandHandler = new CKFinder_Connector_CommandHandler_RenameFile

				case "RenameFolder"
					Set commandHandler = new CKFinder_Connector_CommandHandler_RenameFolder

				case "Thumbnail"
					Set oErrorHandler = new CKFinder_Connector_ErrorHandler_Http
					Set commandHandler = new CKFinder_Connector_CommandHandler_Thumbnail

				Case Else
					handleInvalidCommand sCommand
			End select
		End If

		commandHandler.sendResponse response
		Set commandHandler = nothing
	End Sub

	Public Property Get ErrorHandler
		If IsEmpty(oErrorHandler) Then
			Set oErrorHandler = new CKFinder_Connector_ErrorHandler_Base
		End If
		Set ErrorHandler = oErrorHandler
	End Property

End Class

</script>
