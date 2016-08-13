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

Class CKFinder_Connector_CommandHandler_CommandHandlerInit
	'pseudo inheritance
	private base

	Private Sub Class_Initialize()
		Set base = new CKFinder_Connector_CommandHandler_XmlCommandHandlerBase
		Set base.child = me
		base.mustCheckRequest = false
		base.mustIncludeCurrentFolder = false
	End Sub

	Private Sub Class_Terminate()
		Set base.child = Nothing
		Set base = nothing
	End Sub

	Public Sub sendResponse(response)
		base.sendResponse(response)
	End sub

	function buildXml( oXML )
		Dim config, connectorInfo, imagesConfig, thumbnailsConfig, oUFS
		Set config = oCKFinder_Factory.Config
		Set oUFS = oCKFinder_Factory.UtilsFileSystem

		' Create the "ConnectorInfo" node.
		Set connectorInfo = oXML.connectorNode.addChild("ConnectorInfo")
		connectorInfo.addAttribute "enabled", config.getIsEnabled()

		if not(config.getIsEnabled()) then
			base.raiseError CKFinder_Connector_Error_ConnectorDisabled, "", ""
		end if

		Dim ln, lc
		ln = ""
		lc = UCase(config.getLicenseKey()) & "                              "
		if ( 1 = ( (InStr(CKFINDER_CHARS, Mid(lc, 1, 1) ) - 1) mod 5 ) ) then
			ln = config.getLicenseName()
		End if

		set imagesConfig = oCKFinder_Factory.Config.getImagesConfig
		connectorInfo.addAttribute "imgWidth", imagesConfig.getMaxWidth()
		connectorInfo.addAttribute "imgHeight", imagesConfig.getMaxHeight()

		connectorInfo.addAttribute "s", ln
		connectorInfo.addAttribute "c", Trim( Mid(lc, 12, 1) & Mid(lc, 1, 1) & Mid(lc, 9, 1) & Mid(lc, 13, 1) & Mid(lc, 27, 1) & Mid(lc, 3, 1) & Mid(lc, 4, 1) & Mid(lc, 26, 1) & Mid(lc, 2, 1))
		set thumbnailsConfig = config.getThumbnailsConfig()
		Dim thumbsEnabled
		thumbsEnabled = thumbnailsConfig.getIsEnabled()
		connectorInfo.addAttribute "thumbsEnabled", thumbsEnabled
		If (thumbsEnabled) Then
			connectorInfo.AddAttribute "thumbsUrl", thumbnailsConfig.getUrl()
			If thumbnailsConfig.getDirectAccess() then
				connectorInfo.AddAttribute "thumbsDirectAccess", "true"
			else
				connectorInfo.AddAttribute "thumbsDirectAccess", "false"
			End if
		End if

		Dim oResourceTypes, aTypes, aTypesSize, i, resourceTypeName, acl, aclMask, oPluginsInfo
		Dim requestedType
		requestedType = request.queryString("type") & ""

		' Create the "ResourceTypes" node.
		Set oResourceTypes = oXML.connectorNode.addChild("ResourceTypes")
        ' Create the "PluginsInfo" node.
		Set oPluginsInfo = oXML.connectorNode.addChild("PluginsInfo")

		' Load the resource types in an array.
		aTypes = config.getDefaultResourceTypes

		if (Not isArray(aTypes)) then
			aTypes = config.getResourceTypeNames
		End if

		aTypesSize = ubound(aTypes)
		Dim oTypeInfo, oResourceType, deniedExtensions
		For i=0 To aTypesSize
			resourceTypeName = aTypes(i)

			Set acl = config.getAccessControlConfig()
			aclMask = acl.getComputedMask(resourceTypeName, "/")

			if ( (aclMask And CKFINDER_CONNECTOR_ACL_FOLDER_VIEW) = CKFINDER_CONNECTOR_ACL_FOLDER_VIEW ) then
				if ( (requestedType = "") or (requestedType = resourceTypeName) ) then
					Set oTypeInfo = config.getResourceTypeConfig(resourceTypeName)

					Set oResourceType = oResourceTypes.addChild("ResourceType")

					oResourceType.addAttribute "name", resourceTypeName
					oResourceType.addAttribute "url", oTypeInfo.getUrl
					oResourceType.addAttribute "allowedExtensions", replace(oTypeInfo.getAllowedExtensions, "|", ",")
					' Let's "hide" the fact that the ckfindertemp extension is denied
					deniedExtensions =  replace(oTypeInfo.getDeniedExtensions, "|", ",")
					deniedExtensions = Replace(deniedExtensions, "ckfindertemp", "")
					If (Right(deniedExtensions, 1) = ",") Then deniedExtensions = Left(deniedExtensions, Len(deniedExtensions)-1)

					oResourceType.addAttribute "deniedExtensions", deniedExtensions

					oResourceType.addAttribute "hash", left( hex_sha1( oTypeInfo.getDirectory() ), 16)
					oResourceType.addAttribute "hasChildren", oUFS.hasChildren( oTypeInfo.getDirectory() )
					oResourceType.addAttribute "acl", aclMask
				End if
			End if
		next

		If CKFinder_Config.Exists("Plugins") Then
			Dim plugins
			plugins = CKFinder_Config("Plugins")
			connectorInfo.addAttribute "plugins", Join(plugins, ",")
		End if

		Dim args(0)
		Set args(0) = oXML.connectorNode
		oCKFinder_Factory.Hooks.run "InitCommand", args

	End Function

End Class

</script>
