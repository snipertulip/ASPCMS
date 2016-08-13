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

Class CKFinder_Connector_CommandHandler_XmlCommandHandlerBase
	''
	' Pseudo inheritance
	' CKFinder_Connector_CommandHandler_CommandHandlerInit object
	'
	' @access protected
	'
	private base
	public child
	Private oXML
	' boolean
	Public mustCheckRequest
	Public mustIncludeCurrentFolder

	Private Sub Class_Initialize()
		Set base = new CKFinder_Connector_CommandHandler_CommandHandlerBase
		mustCheckRequest = true
		mustIncludeCurrentFolder = true
	End Sub

	Private Sub Class_Terminate()
		Set base = nothing
	End Sub

	Public Function sendResponse( response )
		Set oXML = oCKFinder_Factory.XML
		Dim connectorNode, nodeCurrentFolder
		Set connectorNode = oXML.ConnectorNode

		Call base.checkConnector()
		if (mustCheckRequest) then
			base.checkRequest()
		End if

		If ( Len( currentFolder.getResourceTypeName() ) > 0 ) Then
			connectorNode.addAttribute "resourceType", currentFolder.getResourceTypeName()
		End If

		If ( mustIncludeCurrentFolder ) Then
			Set nodeCurrentFolder = connectorNode.addChild("CurrentFolder")
			nodeCurrentFolder.addAttribute "path", currentFolder.getClientPath()

			errorHandler.setCatchAllErrors true
			nodeCurrentFolder.addAttribute "url", currentFolder.getUrl()
			errorHandler.setCatchAllErrors False

			nodeCurrentFolder.addAttribute "acl", currentFolder.getAclMask()
		End If

		child.buildXml( oXML )

		response.write oXML.getXML
	End Function

	Public Property Get ErrorHandler()
		Set ErrorHandler = base.ErrorHandler
	End Property

	function raiseError( number, text)
		oXML.raiseError number, text
	End Function

	Public Property Get currentFolder()
		Set currentFolder = base.currentFolder
	End Property
End Class


</script>
