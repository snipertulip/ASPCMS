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
	' Handle MoveFiles command
	'
	' @package CKFinder
	' @subpackage CommandHandlers
	' @copyright CKSource - Frederico Knabben
	'
class CKFinder_Connector_CommandHandler_MoveFiles

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
		command = "MoveFiles"
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
		Dim fileName, filePath, thumbPath, oDeleteFileNode, currentResourceTypeConfig

		if ( request.Form("CKFinderCommand") <> "true") then
			errorHandler.throwError CKFINDER_CONNECTOR_ERROR_INVALID_REQUEST, "", "Not sent by CKFinder"
		End if

		Dim clientPath, sServerDir, config, aclConfig
		clientPath = currentFolder.getClientPath()
		sServerDir = currentFolder.getServerPath()
		Set currentResourceTypeConfig = currentFolder.getResourceTypeConfig()
        Set config = oCKFinder_Factory.Config
        Set aclConfig = config.getAccessControlConfig()

		Dim dictAclMasks, dictCheckedPaths
        Set dictAclMasks = Server.CreateObject("Scripting.Dictionary")
		Set dictCheckedPaths = Server.CreateObject("Scripting.Dictionary")

		if (Not currentFolder.checkAcl(CKFINDER_CONNECTOR_ACL_FILE_RENAME or CKFINDER_CONNECTOR_ACL_FILE_UPLOAD or CKFINDER_CONNECTOR_ACL_FILE_DELETE)) then
			errorHandler.throwError CKFINDER_CONNECTOR_ERROR_UNAUTHORIZED, "", "Not authorized to access " & currentFolder.getClientPath()
		End If

        ' Create the "Errors" node.
		Dim oErrorsNode, errorCode, moved, movedAll, oMoveFilesNode
		Set oErrorsNode = oXML.createChild("Errors")

		errorCode = CKFINDER_CONNECTOR_ERROR_NONE
        moved = 0
        movedAll = request.Form("copied")
		If IsNumeric(movedAll) Then
			movedAll = CLng(movedAll)
		Else
			movedAll = 0
		End if

		Set oMoveFilesNode = oXML.createChild("MoveFiles")

		Dim index, name, resourceTypeName, path, options, destinationFilePath, sourceFilePath
		Dim oUFS, tmpResourceTypeConfig
		Set oUFS = oCKFinder_Factory.UtilsFileSystem

		index = 0
		While (request.form("files[" & index & "][name]") <> "")

			name = request.Form("files[" & index & "][name]")
			resourceTypeName = request.Form("files[" & index & "][type]")
			path = request.Form("files[" & index & "][folder]")

			if (name = "" Or resourceTypeName = "" Or path = "") then
				errorHandler.throwError CKFINDER_CONNECTOR_ERROR_INVALID_REQUEST, "", "Invalid data for file " & index & ": name=" & name & ", type=" & resourceTypeName & ", folder=" & path
			End if

			' options
			options = request.Form("files[" & index & "][options]")

            destinationFilePath = sServerDir & name

            ' check #1 (path)
			if (Not oUFS.checkFileName(name)) Or oCKFinder_Factory.RegExp.MatchesPattern( CKFINDER_REGEX_INVALID_PATH, path) then
				errorHandler.throwError CKFINDER_CONNECTOR_ERROR_INVALID_REQUEST, "", "Failed path check " & name
				Exit function
			End If

            ' get resource type config for current file
			' already cached in the config object
			Set tmpResourceTypeConfig = config.getResourceTypeConfig(resourceTypeName)

            ' check #2 (resource type)
			if (tmpResourceTypeConfig Is nothing) then
				errorHandler.throwError CKFINDER_CONNECTOR_ERROR_INVALID_REQUEST, "", "Invalid resource type " & resourceTypeName
				Exit function
			End if

			Dim i
			For i=1 To 1 ' VbScript lacks "continue" statement, let's fake it to avoid very complex nesting of IFs

				' check #3 (extension)
				if not(tmpResourceTypeConfig.checkExtension(name)) then
					errorCode = CKFINDER_CONNECTOR_ERROR_INVALID_EXTENSION
					appendErrorNode oErrorsNode, errorCode, name, resourceTypeName, path
					Exit For 'faked continue
				End if

				' check #4 (extension) - when moving to another resource type, double check extension
				if (currentResourceTypeConfig.getName() <> resourceTypeName) then
					if not(currentResourceTypeConfig.checkExtension(name)) then
						errorCode = CKFINDER_CONNECTOR_ERROR_INVALID_EXTENSION
						appendErrorNode oErrorsNode, errorCode, name, resourceTypeName, path
						Exit For 'faked continue
					End if
				End If

				' check #5 (hidden folders)
				' cache results
				if Not( dictCheckedPaths.Exists(path)) then
					dictCheckedPaths.Add path, true

					if (tmpResourceTypeConfig.checkIsHiddenPath(path)) then
						errorHandler.throwError CKFINDER_CONNECTOR_ERROR_INVALID_REQUEST, "", "Hidden path " & path
					End if
				End if

				sourceFilePath = tmpResourceTypeConfig.getDirectory() & path & name

				' check #6 (hidden file name)
				if (currentResourceTypeConfig.checkIsHiddenFile(name)) then
					errorHandler.throwError CKFINDER_CONNECTOR_ERROR_INVALID_REQUEST, "", "Hidden file " & name
				End if

				' check #7 (Access Control, need file view permission to source files)
				if not(dictAclMasks.Exists( resourceTypeName & "@" & path )) then
					dictAclMasks.Add resourceTypeName & "@" & path, aclConfig.getComputedMask(resourceTypeName, path)
				End if

				Dim isAuthorized
				isAuthorized = ((dictAclMasks.item( resourceTypeName & "@" & path ) and CKFINDER_CONNECTOR_ACL_FILE_VIEW) = CKFINDER_CONNECTOR_ACL_FILE_VIEW)
				if not(isAuthorized) then
					errorHandler.throwError CKFINDER_CONNECTOR_ERROR_UNAUTHORIZED, "", "ACL check failed for " & resourceTypeName & "@" & path
				End if

				' check #8 (invalid file name)
				if Not(oUFS.FileExists(sourceFilePath)) then
					errorCode = CKFINDER_CONNECTOR_ERROR_FILE_NOT_FOUND
					appendErrorNode oErrorsNode, errorCode, name, resourceTypeName, path
					Exit For 'faked continue
				End if

				' check #9 (max size)
				if (currentResourceTypeConfig.getName() <> resourceTypeName) then
					Dim maxSize, fileSize
					maxSize = currentResourceTypeConfig.getMaxSize()
					if (maxSize>0) Then
						fileSize = oUFS.GetFileSize(sourceFilePath)
						If (fileSize>maxSize) then
							errorCode = CKFINDER_CONNECTOR_ERROR_UPLOADED_TOO_BIG
							appendErrorNode oErrorsNode, errorCode, name, resourceTypeName, path
							Exit For 'faked continue
						End if
					End if
				End if

                '$overwrite
                ' finally, no errors so far, we may attempt to copy a file
                ' protection against copying files to itself
                if (sourceFilePath = destinationFilePath) then
                    errorCode = CKFINDER_CONNECTOR_ERROR_SOURCE_AND_TARGET_PATH_EQUAL
					appendErrorNode oErrorsNode, errorCode, name, resourceTypeName, path
					Exit For 'faked continue
                End if

                ' check if file exists if we don't force overwriting
				if (oUFS.FileExists(destinationFilePath)) Then
					if (instr(options, "overwrite")>0) Then
						If Not(oUFS.DeleteFile(destinationFilePath)) then
							errorCode = CKFINDER_CONNECTOR_ERROR_ACCESS_DENIED
							appendErrorNode oErrorsNode, errorCode, name, resourceTypeName, path
							Exit For 'faked continue
						End if

						if (Not oUFS.RenameFile(sourceFilePath, destinationFilePath)) then
							errorCode = CKFINDER_CONNECTOR_ERROR_ACCESS_DENIED
							appendErrorNode oErrorsNode, errorCode, name, resourceTypeName, path
							Exit For 'faked continue
						End if
						moved = moved + 1

					elseif (instr(options, "autorename")>0) Then
						Dim iCounter
						iCounter = 1
						do
							fileName = oUFS.getFileNameWithoutExtension(name) & "(" & iCounter & ")." & oUFS.getExtension(name)

							destinationFilePath = sServerDir & fileName
							if (Not oUFS.FileExists(destinationFilePath)) then
								Exit do
							End if
							iCounter = iCounter +1
						Loop While true
						if (Not oUFS.RenameFile(sourceFilePath, destinationFilePath)) then
							errorCode = CKFINDER_CONNECTOR_ERROR_ACCESS_DENIED
							appendErrorNode oErrorsNode, errorCode, name, resourceTypeName, path
							Exit For 'faked continue
						End if
						moved = moved + 1
					else
						errorCode = CKFINDER_CONNECTOR_ERROR_ALREADY_EXIST
						appendErrorNode oErrorsNode, errorCode, name, resourceTypeName, path
						Exit For 'faked continue
					End if

				' copy() overwrites without warning
				else
					if (oUFS.FileExists(destinationFilePath)) then
						If Not(oUFS.DeleteFile(destinationFilePath)) then
							errorCode = CKFINDER_CONNECTOR_ERROR_ACCESS_DENIED
							appendErrorNode oErrorsNode, errorCode, name, resourceTypeName, path
							Exit For 'faked continue
						End if
					End if
					if (Not oUFS.RenameFile(sourceFilePath, destinationFilePath)) then
						errorCode = CKFINDER_CONNECTOR_ERROR_ACCESS_DENIED
						appendErrorNode oErrorsNode, errorCode, name, resourceTypeName, path
						Exit For 'faked continue
					End if
					moved = moved + 1
				End if

			Next ' end of fake continue

			index = index + 1
		Wend

        oXML.connectorNode.node.appendChild oMoveFilesNode.node
        if (errorCode <> CKFINDER_CONNECTOR_ERROR_NONE) then
            oXML.connectorNode.node.appendChild oErrorsNode.node
        End if
        oMoveFilesNode.addAttribute "moved", moved
        oMoveFilesNode.addAttribute "movedTotal", movedAll + moved

        ''
         ' Note: actually we could have more than one error.
         ' This is just a flag for CKFinder interface telling it to check all errors.
         '
        if (errorCode <> CKFINDER_CONNECTOR_ERROR_NONE) then
 			errorHandler.throwError CKFINDER_CONNECTOR_ERROR_MOVE_FAILED, "", "Check errors node"
       End if

	End function

	Private Sub appendErrorNode(oErrorsNode, errorCode, name, resourceTypeName, path)
		Dim oErrorNode
		Set oErrorNode = oErrorsNode.addChild("Error")

        oErrorNode.addAttribute "code", errorCode
        oErrorNode.addAttribute "name", name
        oErrorNode.addAttribute "type", resourceTypeName
        oErrorNode.addAttribute "folder", path
	End Sub

End Class

</script>
