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

Class CKFinder_FolderHandler
	''
	' CKFinder_Connector_Core_ResourceTypeConfig object
	'
	' @var CKFinder_Connector_Core_ResourceTypeConfig
	' @access private
	'
	Private resourceTypeConfig
	''
	' ResourceType name
	'
	' @var string
	' @access private
	'
	Private resourceTypeName
	''
	' Client path
	'
	' @var string
	' @access private
	'
	Private clientPath
	''
	' Url
	'
	' @var string
	' @access private
	'
	Private url
	''
	' Server path
	'
	' @var string
	' @access private
	'
	Private serverPath
	''
	' Thumbnails server path
	'
	' @var string
	' @access private
	'
	Private thumbsServerPath
	''
	' ACL mask
	'
	' @var int
	' @access private
	'
	Private aclMask
	''
	' Folder info
	'
	' @var mixed
	'
	Private folderInfo
	''
	' Thumbnails folder info
	'
	' @var mized
	'
	Private thumbsFolderInfo

	Private Sub Class_Initialize()
		resourceTypeName = request.queryString("type") & ""

		clientPath = request.queryString("currentFolder") & ""
		If (clientPath = "") Then
			clientPath = "/"
		Else
			If (Right(clientPath, 1) <> "/") Then
				clientPath = clientPath & "/"
			End If
			If (Left(clientPath, 1) <> "/" ) Then
				clientPath = "/" & clientPath
			End if
		End If

		aclMask = -1
	End Sub

	''
	' Get resource type config
	'
	' @return CKFinder_Connector_Core_ResourceTypeConfig
	' @access public
	'
	Public Property Get getResourceTypeConfig()
		If IsEmpty(resourceTypeConfig) Then
			Set resourceTypeConfig = oCKFinder_Factory.Config.getResourceTypeConfig( resourceTypeName )
		End if

		if (resourceTypeConfig Is Nothing) Then
			Dim oErrorHandler
			Set oErrorHandler = oCKFinder_Factory.Connector.ErrorHandler
			oErrorHandler.throwError CKFINDER_CONNECTOR_ERROR_INVALID_TYPE, "", "Invalid type *" & resourceTypeName & "*"
		End if

		Set getResourceTypeConfig = resourceTypeConfig
	End property

	''
	' Get resource type name
	'
	' @return string
	' @access public
	'
	public property get getResourceTypeName()
		getResourceTypeName = resourceTypeName
	end property

	''
	' Get Client path
	'
	' @return string
	' @access public
	'
	public property get getClientPath()
		getClientPath = clientPath
	end property

	''
	' Get Url
	'
	' @return string
	' @access public
	'
	Public Property get getUrl()
		if (isEmpty(url)) Then
			' Initialization
			Set resourceTypeConfig = getResourceTypeConfig()

			if (resourceTypeConfig Is Nothing) then
				Dim oErrorHandler
				Set oErrorHandler = oCKFinder_Factory.Connector.ErrorHandler
				oErrorHandler.throwError CKFINDER_CONNECTOR_ERROR_INVALID_TYPE, "", "getUrl *" & resourceTypeName & "*"
				url = ""
			else
				url = oCKFinder_Factory.UtilsFileSystem.combineURLs( resourceTypeConfig.getUrl(), getClientPath() )
			End if


		End if

		getUrl = url
	End property

	''
	' Get server path
	'
	' @return string
	' @access public
	'
	Public Property Get getServerPath()
		if (isEmpty(serverPath)) then
			Set resourceTypeConfig = getResourceTypeConfig()
			serverPath = oCKFinder_Factory.UtilsFileSystem.combinePaths(resourceTypeConfig.getDirectory(), clientPath)
		End if

		getServerPath = serverPath
	End property

	Public Property Get getThumbsServerPath()
		If (IsEmpty(thumbsServerPath)) then
			dim config, thumbnailsConfig
			Set resourceTypeConfig = getResourceTypeConfig()

			Set config = oCKFinder_Factory.Config
			Set thumbnailsConfig = config.getThumbnailsConfig()

			' Get the resource type directory.
			thumbsServerPath = oCKFinder_Factory.UtilsFileSystem.combinePaths(thumbnailsConfig.getDirectory(), resourceTypeConfig.getName())

			' Return the resource type directory combined with the required path.
			thumbsServerPath = oCKFinder_Factory.UtilsFileSystem.combinePaths(thumbsServerPath, clientPath)

			If not( oCKFinder_Factory.UtilsFileSystem.createDirectoryRecursively(thumbsServerPath) ) then
				''
				' @todo Ckfinder_Connector_Utils_Xml::raiseError() perhaps we should return error
				'
				'
			end if
		End If

		getThumbsServerPath = ThumbsServerPath
	End Property

	''
	' Get ACL Mask
	'
	' @return int
	' @access public
	'
	Public Property Get getAclMask()

		if (aclMask = -1) then
			aclMask = oCKFinder_Factory.Config.getAccessControlConfig.getComputedMask(resourceTypeName, clientPath)
		End if

		getAclMask = aclMask
	End property

	''
	' Check ACL
	'
	' @access public
	' @param int aclToCkeck
	' @return boolean
	'
	Public function checkAcl(aclToCkeck)
		aclToCkeck = cInt(aclToCkeck)

		checkAcl = ((getAclMask() and aclToCkeck) = aclToCkeck)
	End function
End class

</script>
