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

Const CKFINDER_DEFAULT_BASEPATH = "/ckfinder/"

Class CKFinder
	private sBasePath
	private sWidth
	private sHeight
	private sSelectFunction
	Private sSelectFunctionData
	Private sSelectThumbnailFunction
	Private sSelectThumbnailFunctionData
	Private bDisableThumbnailSelection
	private sClassName
	Private sId
	Private sStartupPath
	Private sType
	Private bRememberLastFolder
	Private bStartupFolderExpanded

	Private Sub Class_Initialize()
		sBasePath		= CKFINDER_DEFAULT_BASEPATH
		sWidth			= "100%"
		sHeight			= "400"
		sSelectFunction	= ""
		sSelectFunctionData	= ""
		sSelectThumbnailFunction	= ""
		sSelectThumbnailFunctionData	= ""
		bDisableThumbnailSelection = false
		sClassName		= ""
		sId = ""
		sStartupPath = ""
		sType = ""
		bRememberLastFolder = True
		bStartupFolderExpanded = false
	End Sub

	Public Property Let BasePath( basePathValue )
		sBasePath = basePathValue
	End Property

	Public Property Let Width( widthValue )
		If Not( IsEmpty(widthValue) ) then
			sWidth = widthValue
		End if
	End Property

	Public Property Let Height( heightValue )
		If Not( IsEmpty(heightValue) ) then
			sHeight = heightValue
		End if
	End Property

	Public Property Let SelectFunction( value )
		sSelectFunction = value
	End Property

	Public Property Let SelectFunctionData( value )
		sSelectFunctionData = value
	End Property

	Public Property Let SelectThumbnailFunction( value )
		sSelectThumbnailFunction = value
	End Property

	Public Property Let SelectThumbnailFunctionData( value )
		sSelectThumbnailFunctionData = value
	End Property

	Public Property Let DisableThumbnailSelection( value )
		bDisableThumbnailSelection = value
	End Property

	Public Property Let ClassName( value )
		sClassName = value
	End Property

	Public Property Let Id( value )
		sId = value
	End Property

	Public Property Let StartupPath( value )
		sStartupPath = value
	End Property

	Public Property Let ResourceType( value )
		sType = value
	End Property

	Public Property Let RememberLastFolder( value )
		bRememberLastFolder = value
	End Property

	Public Property Let StartupFolderExpanded( value )
		bStartupFolderExpanded = value
	End Property

	' Renders CKFinder in the current page.
	Public Sub Create()
		response.write CreateHtml()
	end Sub

	' Returns the html code that must be used to generate an instance of CKFinder.
	Public Function CreateHtml()
		Dim sClass, id
		sClass = sClassName
		if ( sClass <> "" ) Then sClass = " class=""" & sClass & """"

		If (sId<>"") Then
			Id = " id=""" & sId & """"
		Else
			Id = ""
		End If

		CreateHtml = "<iframe src=""" & BuildUrl("") & """ width=""" & sWidth & """ " & _
			"height=""" & sHeight & """" & sClass & id & " frameborder=""0"" scrolling=""no""></iframe>"
	End Function

	public function BuildCKFinderDirUrl()
		Dim url
		url = sBasePath

		if ( url = "" ) Then url = CKFINDER_DEFAULT_BASEPATH

		if ( Right(url, 1) <> "/") Then url = url & "/"

		BuildCKFinderDirUrl = url
	End Function

	public function BuildUrl(url)
		Dim qs
		If (url="") Then url = BuildCKFinderDirUrl()
		qs = ""

		url = url & "ckfinder.html"

		if ( sSelectFunction <> "" ) then
			qs = "?action=js&amp;func=" & sSelectFunction

			if ( sSelectFunctionData <> "" ) then
				qs = qs & "&amp;data=" & Server.UrlEncode(sSelectFunctionData)
			End If
		End If

		if ( bDisableThumbnailSelection ) then
			qs = qs & iif(qs="", "?", "&amp;") & "dts=1"
		elseif ( sSelectThumbnailFunction <> "" Or sSelectFunction <> "") Then
			qs = qs & iif(qs="", "?", "&amp;") & "thumbFunc=" & iif(sSelectThumbnailFunction <> "", sSelectThumbnailFunction, sSelectFunction)

			if ( sSelectThumbnailFunctionData <> "" ) then
				qs = qs & "&amp;tdata=" & Server.UrlEncode(sSelectThumbnailFunctionData)
			ElseIf ( sSelectThumbnailFunction = "" And sSelectFunctionData <> "" ) then
				qs = qs & "&amp;tdata=" & Server.UrlEncode(sSelectFunctionData)
			End If
		End If

		if ( sStartupPath <> "" ) then
			qs = qs & iif(qs="", "?", "&amp;") & "start=" & Server.UrlEncode( sStartupPath & iif(bStartupFolderExpanded, ":1", ":0") )
		End If

		if ( sType <> "" ) then
			qs = qs & iif(qs="", "?", "&amp;") & "type=" & Server.UrlEncode( sType )
		End If

		if ( Not(bRememberLastFolder) ) then
			qs = qs & iif(qs="", "?", "&amp;") & "rlf=0"
		End If

		if ( sId <> "" ) then
			qs = qs & iif(qs="", "?", "&amp;") & "id=" & Server.UrlEncode( sId )
		End If

		BuildUrl = url & qs
	End Function

	Private Function iif(test, a, b)
		If (test) Then
			iif = a
		Else
			iif = b
		End If
	End Function

	Public sub SetupFCKeditor( editorObj, imageType, flashType )
		if ( isempty( imageType ) ) Then imageType = "Images"
		if ( isempty( flashType ) ) Then flashType = "Flash"

		Dim url, QuickUploadUrl
		QuickUploadUrl = BuildCKFinderDirUrl() & "core/connector/asp/connector.asp?command=QuickUpload"
		url = BuildUrl("")

		if ( sWidth <> "100%" And  isnumeric( Replace(sWidth, "px", "") ) ) Then
			Dim w
			w = CInt(sWidth)
			editorObj.Config("LinkBrowserWindowWidth") = w
			editorObj.Config("ImageBrowserWindowWidth") = w
			editorObj.Config("FlashBrowserWindowWidth'") = w
		End if
		if ( sHeight <> "400" And  isnumeric( Replace(sHeight, "px", "") ) ) Then
			Dim h
			h = CInt(sHeight)
			editorObj.Config("LinkBrowserWindowHeight") = h
			editorObj.Config("ImageBrowserWindowHeight") = h
			editorObj.Config("FlashBrowserWindowHeight") = h
		End if

		editorObj.Config("LinkBrowserURL") = url
		editorObj.Config("ImageBrowserURL") = url & "?type=" & imageType
		editorObj.Config("FlashBrowserURL") = url & "?type=" & flashType

		editorObj.Config("LinkUploadURL")  = QuickUploadUrl & "&type=Files"
		editorObj.Config("ImageUploadURL") = QuickUploadUrl & "&type=" & imageType
		editorObj.Config("FlashUploadURL") = QuickUploadUrl & "&type=" & flashType
	End Sub

	' Non-static method of attaching CKFinder to CKEditor
	Public sub SetupCKEditorObject( editorObj, imageType, flashType )
		if ( isempty( imageType ) ) Then imageType = "Images"
		if ( isempty( flashType ) ) Then flashType = "Flash"

		Dim QuickUploadUrl, url, w, h, qs
		QuickUploadUrl = BuildCKFinderDirUrl() & "core/connector/asp/connector.asp?command=QuickUpload"
		url = BuildUrl("")

		qs = iif( instr(url, "?") = -1 , "&", "?")

		if ( sWidth <> "100%" And  isnumeric( Replace(sWidth, "px", "") ) ) Then
			w = CInt(sWidth)
			editorObj.Config("filebrowserWindowWidth") = w
		End if
		if ( sHeight <> "400" And  isnumeric( Replace(sHeight, "px", "") ) ) Then
			h = CInt(sHeight)
			editorObj.Config("filebrowserWindowHeight") = h
		End if

		editorObj.Config("filebrowserBrowseUrl") = url
		editorObj.Config("filebrowserImageBrowseUrl") = url & qs & "type=" & imageType
		editorObj.Config("filebrowserFlashBrowseUrl") = url & qs & "type=" & flashType

		editorObj.Config("filebrowserUploadUrl")  = QuickUploadUrl & "&type=Files"
		editorObj.Config("filebrowserImageUploadUrl") = QuickUploadUrl & "&type=" & imageType
		editorObj.Config("filebrowserFlashUploadUrl") = QuickUploadUrl & "&type=" & flashType
	End Sub

End Class



' Static "Create".
Sub CKFinder_CreateStatic( basePath, width, height, selectFunction )
	Dim oFinder
	Set oFinder = new CKFinder
	oFinder.basePath = basePath
	oFinder.width = width
	oFinder.height = height
	oFinder.selectFunction = selectFunction
	oFinder.SelectThumbnailFunction = selectFunction
	oFinder.Create
End Sub

' Static "SetupFCKeditor".
Sub CKFinder_SetupFCKeditor( editorObj, basePath, imageType, flashType )
	if ( isempty( basePath ) ) Then basePath = CKFINDER_DEFAULT_BASEPATH

	' If it is a path relative to the current page.
	if ( Left(basePath, 1) <> "/" ) Then
		Dim requestUrl
		requestUrl = Request.ServerVariables("URL")
		basePath = mid( requestUrl, 1, instrrev( requestUrl, "/") ) & basePath
	End if

	Dim oCKFinder
	Set oCKFinder = new CKFinder
	oCKFinder.basePath = basePath
	oCKFinder.SetupFCKeditor editorObj, imageType, flashType
End Sub

' Static "SetupCKEditor".
sub CKFinder_SetupCKEditor( editorObj, basePath, imageType, flashType )
	if ( isempty( basePath ) ) Then basePath = CKFINDER_DEFAULT_BASEPATH

	Dim oCKFinder
	Set oCKFinder = new CKFinder
	oCKFinder.basePath = basePath
	oCKFinder.SetupCKEditorObject editorObj, imageType, flashType
End sub

</script>
