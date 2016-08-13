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
	' Simple class which provides some basic API for creating XML nodes and adding attributes
	'
	' @package CKFinder
	' @subpackage Utils
	' @copyright CKSource - Frederico Knabben
	'
class Ckfinder_Connector_Utils_XmlNode
	Private oXML
	public node

	Private Sub Class_Initialize()
	End Sub

	Private Sub Class_Terminate()
		Set node = Nothing
		Set oXML = nothing
	End Sub

	Public Function Init(xmlTree, name)
		Set oXML = xmlTree
		Set node = oXML.createElement(name)

		Set Init = node
	End Function

	Public Sub re_init(xmlTree, xmlNode)
		Set oXML = xmlTree
		Set node = xmlNode
	End Sub

    Public function getChild(name)
		Dim child, i, childNode
		For i=0 To node.childNodes.length-1
			Set child = node.childNodes(i)
			If (child.nodeName = name) Then
				Set childNode = new Ckfinder_Connector_Utils_XmlNode
				childNode.re_init oXML, child
				Set getChild = childNode
				Exit function
			End If
		next

        Set getChild = nothing
    End function

	''
	' Adds an attribute to a node.
	Public sub addAttribute(attributeName, attributeValue)
		Dim att
		Set att = oXML.createAttribute(attributeName)
		' handle automatically booleans:
		Select Case VarType(attributeValue)
			Case vbDate
				att.value = FormatUTC( attributeValue )
			Case vbBoolean
				If (attributeValue = true) Then
					att.value = "true"
				Else
					att.value = "false"
				End if

			Case else
				att.value = attributeValue
		End select
		node.attributes.setNamedItem att
	End Sub

	' returns a date formated as yyyyMMddHHmm
	Private Function FormatUTC( v )
		FormatUTC = Year(v) & leftPad(Month(v), 2, "0") & leftPad(day(v), 2, "0") & leftPad(Hour(v), 2, "0") & leftPad(Minute(v), 2, "0")
	End Function

	Private Function leftPad( txt, length, pad)
		Dim l
		l = length - Len(txt)
		leftPad = String(l, pad) & txt
	End Function

	' Creates a new child named childName, appends it to this node and returns it
	Public function addChild( childName )
		Dim child
		Set Child = new Ckfinder_Connector_Utils_XmlNode
		Child.init oXML, childName

		node.appendChild child.node
		Set addChild = child
	End function

End class

</script>
