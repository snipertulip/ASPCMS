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
	' XML document
	'
	' @package CKFinder
	' @subpackage Core
	' @copyright CKSource - Frederico Knabben
	'
Class CKFinder_Connector_Core_Xml
	Private oXML
	''
	' Connector node (root)
	'
	' @var Ckfinder_Connector_Utils_XmlNode
	'
	Private mConnectorNode
	''
	' Error node
	'
	' @var Ckfinder_Connector_Utils_XmlNode
	'
	Private mErrorNode

	Private Sub Class_Initialize()
		sendXmlHeaders

		Set oXML = server.CreateObject("MSXML2.DOMDocument")

		' Create the XML document header.
		Dim pi
		Set pi = oXML.createProcessingInstruction("xml", " version=""1.0"" encoding=""utf-8""")
		oXML.appendChild(pi)

		'create the root node
		Set mConnectorNode = new Ckfinder_Connector_Utils_XmlNode
		mConnectorNode.Init oXML, "Connector"
		oXML.appendChild mConnectorNode.node

		Set mErrorNode = mConnectorNode.addChild("Error")
		' By default OK
		mErrorNode.addAttribute "number", 0
	End sub

	Private Sub Class_Terminate()
		Set mErrorNode = Nothing
		Set mConnectorNode = Nothing
		Set oXML = nothing
	End Sub

	Public Property Get getXML()
		Dim text
		text = oXML.xml

		If (CKFinder_Debug) Then
			text = Replace(text, "><", ">" & vblf & "<")
		End If
		getXML = text
	End Property

	''
	' Return connector node
	'
	' @return Ckfinder_Connector_Utils_XmlNode
	'
	Public Property Get connectorNode()
		Set connectorNode = mConnectorNode
	End property

	''
	' Return error node
	'
	' @return Ckfinder_Connector_Utils_XmlNode
	'
	Public Property Get errorNode()
		Set errorNode = mErrorNode
	End property

	''
	' Send XML headers to the browser (and force browser not to use cache)
	' @access private
	'
	Private function sendXmlHeaders()
'		Response.Clear

		' Prevent the browser from caching the result.
		Response.CacheControl = "no-cache"

		' Set the response format.
		Response.CharSet		= "UTF-8"
		If (CKFinder_Debug) Then
			Response.ContentType	= "text/plain"
			' IE needs some text at the beggining to avoid detecting the whole response as XML
			Response.Write "CKFinder connector for classic ASP. The connector is in Debug Mode." & vblf
			Response.Write "In order to use the connector you'll have to set CKFinder_Debug = false." & vblf
			Response.Write "Response from the connector <including debugging messages>:" & vblf
			Response.Write "                                                                        " & vblf
		Else
			Response.ContentType	= "text/xml"
		End if
	End function

	Public Function createChild(name)
		Set createChild = new Ckfinder_Connector_Utils_XmlNode
		createChild.init oXML, name
	End function
'	''
'	' Return XML declaration
'	'
'	' @access private
'	' @return string
'	'
'	Private Property Get XMLDeclaration()
'		XMLDeclaration = "<?xml version=""1.0"" encoding=""utf-8""?>"
'	End Property

	''
	' Send error message to the browser. If error number is set to 1, $text (custom error message) will be displayed
	' Don't call this function directly
	'
	' @access public
	' @param int $number error number
	' @param string $text Custom error message (optional)
	'
	Public Function raiseError( number, text, debugText)
		errorNode.addAttribute "number", number
		if (text <> "") then
			errorNode.addAttribute "text", text
		End if

		If (CKFinder_Debug) Then
			errorNode.addAttribute "debugText", debugText
		End if

		response.write getXML()
		response.end
	End Function

End class

</script>
