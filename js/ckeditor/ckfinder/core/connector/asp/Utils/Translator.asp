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
	' @subpackage Utils
	' @copyright CKSource - Frederico Knabben
	'

	''
	' Simple class to provide translations
	'
	' @package CKFinder
	' @subpackage Utils
	' @copyright CKSource - Frederico Knabben
	'
class Ckfinder_Connector_Utils_Translator

	Private Sub Class_Initialize()
	End Sub

	Private Sub Class_Terminate()
	End Sub

	Public Function getErrorMessage(number, fileName)
		Dim langCode, tempCode, langFile, oUFS, contents, xml
		' Don't waste time getting the message if there's no error
		If (number=0) Then Exit Function

		langCode = "en"
		tempCode = Request.QueryString("langCode")
		Set oUFS = oCKFinder_Factory.UtilsFileSystem
		If Not(IsEmpty(tempCode)) Then
			If (oCKFinder_Factory.RegExp.MatchesPattern("^[a-z\-]+$", tempCode)) Then
				langFile = server.MapPath(getBasePath & "lang/" & tempCode & ".xml")
				If (oUFS.FileExists(langFile)) Then langCode = tempCode
			End if
		End if

		langFile = server.MapPath(getBasePath & "lang/" & langCode & ".xml")
		Set xml = Server.CreateObject("Microsoft.XMLDOM")
		xml.async = False
		xml.load langFile
		getErrorMessage = getNodeValue(xml, "messages/errors/error[@number='" & number & "']")
		If getErrorMessage="" Then getErrorMessage = getNodeValue(xml, "messages/errorUnknown")

		getErrorMessage = Replace(getErrorMessage, "%1", fileName)

		Set oUFS = Nothing
	End function

	Private Function getNodeValue(xml, nodeXPath)
		Dim node
		Set node = xml.SelectSingleNode( nodeXPath )
		If (node Is Nothing) Then
			getNodeValue = ""
			Exit function
		End if

		if ( node.FirstChild Is Nothing ) Then
			getNodeValue = node.NodeValue
		Else
			getNodeValue = node.FirstChild.NodeValue
		End if
	End Function

	Private function getBasePath()
		dim sValue, i, j
		sValue=request.ServerVariables("URL")
		for i=1 to 1
			j = instrrev(sValue, "/")
			sValue = left(sValue, j-1)
		next
		getBasePath = sValue & "/"
	end Function

End class

</script>
