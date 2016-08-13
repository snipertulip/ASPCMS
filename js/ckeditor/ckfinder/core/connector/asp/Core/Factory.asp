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
	' Factory object
	'
	' @package CKFinder
	' @subpackage Core
	' @copyright CKSource - Frederico Knabben
	'

' Takes care of creating and returning a single instance of several classes
Class CKFinder_Factory
	Private oConnector
	Private oFolderHandler
	Private oConfig
	Private oUtilsFileSystem
	Private oUtilsImage
	Private oXML
	Private oRegistry
	Private oRegExp
	Private oTranslator
	Private oHooks

	Private Sub Class_Terminate()
		Set oConnector = Nothing
		Set oFolderHandler = Nothing
		Set oConfig = Nothing
		Set oUtilsFileSystem = Nothing
		Set oUtilsImage = Nothing
		Set oXML = Nothing
		Set oRegistry = Nothing
		Set oRegExp = Nothing
		Set oTranslator = Nothing
		Set oHooks = Nothing
	End Sub

	Public Property Get Connector
		If IsEmpty(oConnector) Then
			Set oConnector = new CKFinder_Connector_Core_Connector
		End If
		Set Connector = oConnector
	End property

	Public Property Get FolderHandler
		If IsEmpty(oFolderHandler) Then
			Set oFolderHandler = new CKFinder_FolderHandler
		End If
		Set FolderHandler = oFolderHandler
	End Property

	Public Property Get Config
		If IsEmpty(oConfig) Then
			Set oConfig = new CKFinder_Connector_Core_Config
		End If
		Set Config = oConfig
	End Property

	Public Property Get UtilsFileSystem
		If IsEmpty(oUtilsFileSystem) Then
			Set oUtilsFileSystem = new CKFinder_Connector_Utils_FileSystem
		End If
		Set UtilsFileSystem = oUtilsFileSystem
	End Property

	Public Property Get UtilsImage
		If IsEmpty(oUtilsImage) Then
			Set oUtilsImage = new CKFinder_Connector_Utils_Image
		End If
		Set UtilsImage = oUtilsImage
	End Property

	Public Property Get XML
		If IsEmpty(oXML) Then
			Set oXML = new CKFinder_Connector_Core_Xml
		End If
		Set XML = oXML
	End Property

	Public Property Get Registry
		If IsEmpty(oRegistry) Then
			Set oRegistry = Server.CreateObject("Scripting.Dictionary")
		End If
		Set Registry = oRegistry
	End Property

	Public Property Get RegExp
		If IsEmpty(oRegExp) Then
			Set oRegExp = new Ckfinder_Connector_Utils_RegExp
		End If
		Set RegExp = oRegExp
	End Property

	Public Property Get Translator
		If IsEmpty(oTranslator) Then
			Set oTranslator = new Ckfinder_Connector_Utils_Translator
		End If
		Set Translator = oTranslator
	End Property

	Public Property Get Hooks
		If IsEmpty(oHooks) Then
			Set oHooks = new CKFinder_Connector_Core_Hooks
		End If
		Set Hooks = oHooks
	End Property

End class


'There will be only one instance of the CKFinder_Factory class
'that will take care of creating the rest of the objects
Dim oCKFinder_Factory
Set oCKFinder_Factory = new CKFinder_Factory

</script>
