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
' CKFinder extension: resize image according to a given size

class CKFinder_Connector_CommandHandler_ImageResize
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
		command = "ImageResize"
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

    private function getConfig()
		Dim config
		If CKFinder_Config.Exists("plugin_imageresize") then
			Set config = CKFinder_Config("plugin_imageresize")
		Else
			Set config = server.CreateObject("Scripting.Dictionary")
		End if

		If Not(config.Exists("smallThumb")) Then config.Add "smallThumb", "90x90"
		If Not(config.Exists("mediumThumb")) Then config.Add "mediumThumb", "120x120"
		If Not(config.Exists("largeThumb")) Then config.Add "largeThumb", "180x180"

		Set getConfig = config
    End function

    ''
     ' handle request and build XML
     ' @access protected
     '
     '
	 function buildXml( oXML )

		if ( request.Form("CKFinderCommand") <> "true") then
			errorHandler.throwError CKFINDER_CONNECTOR_ERROR_INVALID_REQUEST, "", "Not sent by CKFinder"
		End if

        ' resizing to 1x1 is almost equal to deleting a file, that's why FILE_DELETE permissions are required
        if (Not currentFolder.checkAcl(CKFINDER_CONNECTOR_ACL_FILE_DELETE)) then
			errorHandler.throwError CKFINDER_CONNECTOR_ERROR_UNAUTHORIZED, "", "Failed ACL check"
        End if
        ' it is possible to create a new file with this plugin, so check FILE_UPLOAD as well
        if (Not currentFolder.checkAcl(CKFINDER_CONNECTOR_ACL_FILE_UPLOAD)) then
			errorHandler.throwError CKFINDER_CONNECTOR_ERROR_UNAUTHORIZED, "", "Failed ACL check"
        End if

		Dim resourceTypeInfo, fileName, oUFS, filePath
        Set resourceTypeInfo = currentFolder.getResourceTypeConfig()

		fileName = request.form("fileName")
        if ("" = fileName) then
			errorHandler.throwError CKFINDER_CONNECTOR_ERROR_INVALID_NAME, "", "Empty fileName"
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

		Dim imagesConfig, maxWidth, maxHeight, newWidth, newHeight, quality, newFileName, newFilePath
		newWidth = request.form("width")
		newHeight = request.form("height")
        quality = 80

		set imagesConfig = oCKFinder_Factory.Config.getImagesConfig
		maxWidth = imagesConfig.getMaxWidth()
		maxHeight = imagesConfig.getMaxHeight()

        if (IsNumeric(newWidth) And IsNumeric(newHeight)) Then
			newWidth = CInt(newWidth)
			newHeight = CInt(newHeight)
			if (newWidth<1 Or newHeight<1) then
				errorHandler.throwError CKFINDER_CONNECTOR_ERROR_INVALID_REQUEST, "", "wrong dimensions"
			End if

			if (maxWidth>0 And newWidth>maxWidth) then
				errorHandler.throwError CKFINDER_CONNECTOR_ERROR_INVALID_REQUEST, "", "wrong dimensions"
			End if
			if (maxHeight>0 And newHeight>maxHeight) then
				errorHandler.throwError CKFINDER_CONNECTOR_ERROR_INVALID_REQUEST, "", "wrong dimensions"
			End if

			newFileName = request.form("newFileName")
			if (""=newFileName) then
				errorHandler.throwError CKFINDER_CONNECTOR_ERROR_INVALID_NAME, "", "Empty newFileName"
			End If

			if (Not resourceTypeInfo.checkExtension(newFileName)) then
				errorHandler.throwError CKFINDER_CONNECTOR_ERROR_INVALID_EXTENSION, "", "Invalid extension " & newFileName
			End If

			if (Not oUFS.checkFileName(newFileName) or resourceTypeInfo.checkIsHiddenFile(newFileName)) then
				errorHandler.throwError CKFINDER_CONNECTOR_ERROR_INVALID_NAME, "", "Invalid name " & newFileName
			End If

			newFilePath = oUFS.combinePaths(currentFolder.getServerPath(), newFileName)

'            if (!is_writable(dirname($newFilePath))) {
 '               $this->_errorHandler->throwError(CKFINDER_CONNECTOR_ERROR_ACCESS_DENIED);
  '          }

			if (request.form("overwrite") <> "1" And oUFS.FileExists(newFilePath)) then
				errorHandler.throwError CKFINDER_CONNECTOR_ERROR_ALREADY_EXIST, "", "File exists: " & newFilePath
			End if

            if (Not oCKFinder_Factory.UtilsImage.createThumb(filePath, newFilePath, newWidth, newHeight, quality, false) ) then
				errorHandler.throwError CKFINDER_CONNECTOR_ERROR_ACCESS_DENIED, "", "Error in createThumb"
			End if

		End if

		Dim config, nameWithoutExt, extension, sizes, size, i, thumbName, oRegex, matches, match
        Set config = getConfig()

        nameWithoutExt = oUFS.getFileNameWithoutExtension(fileName)
        extension = oUFS.getExtension(fileName)
		sizes = Array("small", "medium", "large")
		For i=0 To 2
			size = sizes(i)
			If request.form(size)="1" Then
				thumbName = nameWithoutExt & "_" & size & "." & extension
				newFilePath = oUFS.CombinePaths(currentFolder.getServerPath, thumbName)

				if (oUFS.FileExists(newFilePath)) then
					errorHandler.throwError CKFINDER_CONNECTOR_ERROR_ALREADY_EXIST, "", "File exists: " & newFilePath
				End if

				If config.Exists(size & "Thumb") then

					Set oRegex	= New RegExp
					oRegex.IgnoreCase	= True
					oRegex.Global		= True
					oRegex.Pattern	= "^(\d+)x(\d+)$"

					Set matches	= oRegex.Execute( config(size & "Thumb") )
					Set match = matches(0).subMatches

					oCKFinder_Factory.UtilsImage.createThumb filePath, newFilePath, match(0), match(1), quality, true

				End if
			End if
		next

    End function

	' Event listeners:
    public function onInitCommand( connectorNode )
		Dim pluginsInfo, imageResize, config, i, entry

		Set pluginsInfo = connectorNode.getChild("PluginsInfo")
		Set imageresize = pluginsInfo.addChild("imageresize")

		Set config = getConfig()
		For Each entry In config
			imageresize.addAttribute entry, config(entry)
		next
		onInitCommand = true
    End function

    public function onBeforeExecuteCommand( command )
        if ( command = "ImageResize" ) then
            sendResponse( response )
            onBeforeExecuteCommand = False
            Exit function
        End if

        onBeforeExecuteCommand = true
    End Function

End Class




class CKFinder_Connector_CommandHandler_ImageResizeInfo
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
		command = "ImageResizeInfo"
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

        if not(currentFolder.checkAcl(CKFINDER_CONNECTOR_ACL_FILE_VIEW)) then
			errorHandler.throwError CKFINDER_CONNECTOR_ERROR_UNAUTHORIZED, "", "ACL check failed"
		End if

		Dim resourceTypeInfo
		Set resourceTypeInfo = currentFolder.getResourceTypeConfig()

		Dim fileName
		fileName = request("fileName")
		If (fileName="") then
			errorHandler.throwError CKFINDER_CONNECTOR_ERROR_INVALID_NAME, "", "Missing filename"
		End if

		Dim oUFS
		Set oUFS = oCKFinder_Factory.UtilsFileSystem

        if (Not oUFS.checkFileName(fileName) or resourceTypeInfo.checkIsHiddenFile(fileName)) then
			errorHandler.throwError CKFINDER_CONNECTOR_ERROR_INVALID_REQUEST, "", "Invalid filename"
		End if

        if (Not resourceTypeInfo.checkExtension(fileName)) then
 			errorHandler.throwError CKFINDER_CONNECTOR_ERROR_INVALID_REQUEST, "", "Invalid extension"
		End if

		Dim filePath
		filePath = oUFS.combinePaths(currentFolder.getServerPath(), fileName)

		If Not(oUFS.fileExists(filePath)) then
 			errorHandler.throwError CKFINDER_CONNECTOR_ERROR_FILE_NOT_FOUND, "", "File doesn't exists: " & filePath
		End if

		' returns CKFinder_Size object
		Dim size, oNode
        Set size = oCKFinder_Factory.UtilsImage.getImageSize(filePath)
        Set oNode = oXML.connectorNode.addChild("ImageInfo")
        oNode.addAttribute "width", size.width
        oNode.addAttribute "height", size.height

    End function

	' Event listeners:

    public function onBeforeExecuteCommand( command )
        if ( command = "ImageResizeInfo" ) then
            sendResponse( response )
            onBeforeExecuteCommand = False
            Exit function
        End if

        onBeforeExecuteCommand = true
    End Function

End Class

	Dim CommandHandler_ImageResize, CommandHandler_ImageResizeInfo
If (TypeName(oCKFinder_Factory) <> "Empty") then
	Set CommandHandler_ImageResize = new CKFinder_Connector_CommandHandler_ImageResize
	Set CommandHandler_ImageResizeInfo = new CKFinder_Connector_CommandHandler_ImageResizeInfo

	CKFinder_AddHook "BeforeExecuteCommand", CommandHandler_ImageResize
	CKFinder_AddHook "BeforeExecuteCommand", CommandHandler_ImageResizeInfo
	CKFinder_AddHook "InitCommand", CommandHandler_ImageResize

	CKFinder_AddPlugin "imageresize"
End if

</script>
