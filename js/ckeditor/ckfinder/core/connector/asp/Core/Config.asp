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
	' @subpackage Config
	' @copyright CKSource - Frederico Knabben
	'

Const CKFINDER_CONNECTOR_DEFAULT_USER_FILES_PATH = "/userfiles/"
Const CKFINDER_CHARS = "123456789ABCDEFGHJKLMNPQRSTUVWXYZ"
Const CKFINDER_REGEX_INVALID_PATH = "(/\.)|(//)|([\\:\*\?\""\<\>\|]|[\u0000-\u001F]|\u007F)"
	''
	' Main config parser
	'
	'
	' @package CKFinder
	' @subpackage Config
	' @copyright CKSource - Frederico Knabben
	' @global oCKFinder_Factory.Config
	'
class CKFinder_Connector_Core_Config
	''
	' Is CKFinder enabled
	'
	' @var boolean
	' @access private
	'
	private isEnabled
	''
	' License Name
	'
	' @var string
	' @access private
	'
	private licenseName
	''
	' License Key
	'
	' @var string
	' @access private
	'
	private licenseKey
	''
	' Role session variable name
	'
	' @var string
	' @access private
	'
	private roleSessionVar
	''
	' Access Control Configuration
	'
	' @var CKFinder_Connector_Core_AccessControlConfig
	' @access private
	'
	private accessControlConfigCache
	''
	' ResourceType config cache
	'
	' @var array
	' @access private
	'
	private resourceTypeConfigCache
	''
	' Images config cache
	'
	' @var CKFinder_Connector_Core_ImagesConfig
	' @access private
	'
	private imagesConfigCache
	''
	' Thumbnails config cache
	'
	' @var CKFinder_Connector_Core_ThumbnailsConfig
	' @access private
	'
	private thumbnailsConfigCache
	''
	' Array with default resource types names
	'
	' @access private
	' @var array
	'
	Private defaultResourceTypes

	''
	' Check double extension
	'
	' @var boolean
	'
	Private checkDoubleExtension

	''
	' Valid extensions for html files
	'
	' @var string
	'
	Private htmlExtensions

	''
	' Should images be checked to see if they are valid?
	'
	' @var boolean
	'
	Private SecureImageUploads

	''
	' Regexps to check if a file or folder must be hidden
	'
	Private HideFoldersRegex
	Private HideFilesRegex

	''
	' Strings that will be used to create the regexp if neccesary
	'
	Private HideFoldersPattern
	Private HideFilesPattern

	''
	' Sets if the max file must be enforced just after upload of after image scaling
	' @var boolean
	'
	Private CheckSizeAfterScaling

	Private Sub Class_Initialize()
		' Defaults
		isEnabled = false
		licenseName = ""
		licenseKey = ""
		roleSessionVar = "CKFinder_UserRole"
		Set resourceTypeConfigCache = Server.CreateObject("Scripting.Dictionary")
		checkDoubleExtension = True
		htmlExtensions = "html|htm|xml|xsd|txt|js"
		SecureImageUploads = True
		CheckSizeAfterScaling = False
		loadValues
	End Sub

	Private Sub Class_Terminate()
		Set resourceTypeConfigCache = Nothing
		Set HideFoldersRegex = Nothing
		Set HideFilesRegex = Nothing
	End Sub

'	''
'	' Get file system encoding, returns null if encoding is not set
'	'
'	' @access public
'	' @return string
'	'
'	function getFilesystemEncoding()
'		return this._filesystemEncoding
'	end function
'
	''
	' Get "Check double extension" value
	'
	' @access public
	' @return boolean
	'
	Public Property get getCheckDoubleExtension()
		getCheckDoubleExtension = checkDoubleExtension
	end Property
	''
	' Get default resource types
	'
	' @access public
	' @return array()
	'
	Public Property get getDefaultResourceTypes()
		getDefaultResourceTypes = defaultResourceTypes
	end Property

	''
	' File extensions where HTML is allowed
	'
	' @access public
	' @return string
	'
	Public Property get getHtmlExtensions()
		getHtmlExtensions = HtmlExtensions
	end Property

	''
	' Get images config
	'
	' @access public
	' @return CKFinder_Connector_Core_ImagesConfig
	'
	function getImagesConfig()
		if (IsEmpty(imagesConfigCache)) then
			Set imagesConfigCache = New CKFinder_Connector_Core_ImagesConfig
			If CKFinder_Config.Exists("Images") Then imagesConfigCache.init CKFinder_Config.Item("Images")
		end if

		Set getImagesConfig = imagesConfigCache
	end Function

	''
	' Is CKFinder enabled
	'
	' @access public
	' @return boolean
	'
	Public Property get getIsEnabled()
		getIsEnabled = isEnabled
	end Property

	''
	' Get license key
	'
	' @access public
	' @return string
	'
	Public Property get getLicenseKey()
		getLicenseKey = licenseKey
	end Property

	''
	' Get license name
		'
	' @access public
	' @return string
		'
	Public Property get getLicenseName()
		getLicenseName = licenseName
	end Property

	''
	' Get role sesion variable name
	'
	' @access public
	' @return string
	'
	Public Property get getRoleSessionVar()
		getRoleSessionVar = roleSessionVar
	end Property

	''
	' Get resourceTypeName config
	'
	' @param string resourceTypeName
	' @return CKFinder_Connector_Core_ResourceTypeConfig|null
	' @access public
	'
	function getResourceTypeConfig(resourceTypeName)
		if ( resourceTypeConfigCache.Exists(resourceTypeName) ) then
			Set getResourceTypeConfig = resourceTypeConfigCache.Item( resourceTypeName )
			Exit function
		end if

		if not(CKFinder_Config.exists( "ResourceType" ) ) then
			Set getResourceTypeConfig = nothing
			Exit function
		end if

		Dim resourceType, i, lb, ub, resourceTypeNode, oTmp
		resourceType = CKFinder_Config.item( "ResourceType" )
		if not(isArray(resourceType)) then
			Set getResourceTypeConfig = nothing
			Exit function
		end if

		lb = LBound(resourceType)
		ub = UBound(resourceType)
		For i = lb To ub
			Set resourceTypeNode = resourceType(i)
			If (resourceTypeNode.Item("name") = resourceTypeName) Then
				Set oTmp = new CKFinder_Connector_Core_ResourceTypeConfig
				oTmp.Init resourceTypeNode

				resourceTypeConfigCache.Add resourceTypeName, oTmp
				Set getResourceTypeConfig = oTmp
				Exit Function

			End if
		next

		Set getResourceTypeConfig = nothing
	end function

	''
	' Should extra checks be performed on image uploads?
	'
	' @access public
	' @return boolean
	'
	Public Property get getSecureImageUploads()
		getSecureImageUploads = SecureImageUploads
	end Property

	''
	' Get thumbnails config
	'
	' @access public
	' @return CKFinder_Connector_Core_ThumbnailsConfig
	'
	function getThumbnailsConfig()
		if (IsEmpty(thumbnailsConfigCache)) then
			Set thumbnailsConfigCache = New CKFinder_Connector_Core_ThumbnailsConfig
			If CKFinder_Config.Exists("Thumbnails") Then thumbnailsConfigCache.init CKFinder_Config.Item("Thumbnails")
		end if

		Set getThumbnailsConfig = thumbnailsConfigCache
	end function

	''
	' Get access control config
	'
	' @access public
	' @return CKFinder_Connector_Core_AccessControlConfig
	'
	Public Property Get getAccessControlConfig()
		if (isEmpty(accessControlConfigCache)) then
			Set accessControlConfigCache = new CKFinder_Connector_Core_AccessControlConfig
			If (CKFinder_Config.Exists("AccessControl")) Then
				accessControlConfigCache.Init CKFinder_Config.Item("AccessControl") '(isset(GLOBALS['config']['AccessControl']) ? : array())
			End if
		end if

		Set getAccessControlConfig = accessControlConfigCache
	end property

	''
	' Load values from config
	'
	' @access private
	'
	Private function loadValues()
		isEnabled = CheckAuthentication()

		If (CKFinder_Config.Exists("LicenseName")) then
			licenseName = CKFinder_Config.Item("LicenseName")
		end if
		If (CKFinder_Config.Exists("LicenseKey")) then
			licenseKey = CKFinder_Config.Item("LicenseKey")
		end if
		If (CKFinder_Config.Exists("RoleSessionVar")) then
			roleSessionVar = CKFinder_Config.Item("RoleSessionVar")
		end If
		If (CKFinder_Config.Exists("CheckDoubleExtension")) then
			checkDoubleExtension = CBool(CKFinder_Config.Item("CheckDoubleExtension"))
		end if
		If (CKFinder_Config.Exists("SecureImageUploads")) then
			SecureImageUploads = CBool(CKFinder_Config.Item("SecureImageUploads"))
		end if
		If (CKFinder_Config.Exists("DefaultResourceTypes")) then
			defaultResourceTypes = cStr(CKFinder_Config.Item("DefaultResourceTypes"))
			if (defaultResourceTypes <> "") then
				defaultResourceTypes = split(defaultResourceTypes, ",")
			end if
		end If

		Dim tmp, i
		if (CKFinder_Config.Exists("HtmlExtensions")) then
			Tmp = CKFinder_Config.Item("HtmlExtensions")
			If (IsArray(tmp)) Then
				HtmlExtensions = LCase( Join(tmp, "|") )
			Else
				HtmlExtensions = LCase( Replace(tmp, ",", "|")  )
			End If
		end if

		If (CKFinder_Config.Exists("HideFolders")) then
			HideFoldersPattern = CKFinder_Config.Item("HideFolders")
		end if
		If (CKFinder_Config.Exists("HideFiles")) then
			HideFilesPattern = CKFinder_Config.Item("HideFiles")
		end if

		If (CKFinder_Config.Exists("CheckSizeAfterScaling")) then
			CheckSizeAfterScaling = CBool(CKFinder_Config.Item("CheckSizeAfterScaling"))
		end if

	end function

	''
	' Helper function to generate the proper regex to hide folders and files
	'
	Private Function BuildHideRegex( entries )
		Dim pattern, oRegex
		pattern = entries
		' There's no regexp.escape in asp
		pattern = Replace(pattern, ".", "\.")
		pattern = Replace(pattern, "*", ".*")
		pattern = Replace(pattern, "?", ".")
		pattern = "^(?:" & pattern & ")$"

		Set oRegex	= New RegExp
		oRegex.IgnoreCase	= True
		oRegex.Global		= True
		oRegex.Pattern	= pattern
		Set BuildHideRegex = oRegex
	End function

	Function getHideFoldersRegEx()
		if (IsEmpty(HideFoldersRegex)) then
			Set HideFoldersRegex = BuildHideRegex(HideFoldersPattern)
		end if

		Set getHideFoldersRegEx = HideFoldersRegex
	End Function

	Function getHideFilesRegEx()
		if (IsEmpty(HideFilesRegex)) then
			Set HideFilesRegex = BuildHideRegex(HideFilesPattern)
		end if

		Set getHideFilesRegEx = HideFilesRegex
	End Function

	''
	' Get all resource type names defined in config
	'
	' @return array
	'
	function getResourceTypeNames()
		getResourceTypeNames = Array()

		If not(CKFinder_Config.Exists("ResourceType")) Then Exit Function

		Dim aResources
		Dim aNames(), i, count
		aResources = CKFinder_Config.Item("ResourceType")
		If Not(IsArray(aResources)) Then Exit Function

		count = UBound(aResources)
		ReDim aNames(count)
		For i = 0 To count
			aNames(i) = aResources(i).Item("name")
		next

		getResourceTypeNames = aNames
	end function

	Public Property Get getCheckSizeAfterScaling()
		getCheckSizeAfterScaling = CheckSizeAfterScaling
	End Property
End Class

</script>
