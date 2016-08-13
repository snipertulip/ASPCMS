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

	''
	' This class keeps thumbnails configuration
	'
	' @package CKFinder
	' @subpackage Config
	' @copyright CKSource - Frederico Knabben
	'
class CKFinder_Connector_Core_ThumbnailsConfig
	''
	' Url to thumbnails directory
	'
	' @var string
	' @access private
	'
	private url
	''
	' Directory where thumbnails are stored
	'
	' @var string
	' @access private
	'
	private directory
	''
	' Are thumbnails enabled
	'
	' @var boolean
	' @access private
	'
	private isEnabled

	''
	' Direct access to thumbnails
	'
	' @var boolean
	' @access private
	'
	Private directAccess

	''
	' Max width for thumbnails
	'
	' @var int
	' @access private
	'
	private maxWidth
	''
	' Max height for thumbnails
	'
	' @var int
	' @access private
	'
	private maxHeight
	''
	' Quality of thumbnails
	'
	' @var int
	' @access private
	'
	private quality

	Private Sub Class_Initialize()
		url = ""
		directory = ""
		isEnabled = false
		maxWidth = 100
		maxHeight = 100
		quality = 100
		directAccess = false
	End Sub

	function init(thumbnailsNode)
		If thumbnailsNode.Exists("enabled") then
			isEnabled = thumbnailsNode.Item("enabled")
			'Now validate that there's a valid image manipulation component:
			If (isEnabled) Then isEnabled = (oCKFinder_Factory.UtilsImage.ComponentName <> "None")
		end if
		If thumbnailsNode.Exists("directAccess") then
			directAccess = thumbnailsNode.Item("directAccess")
		end if

		Dim width, height, q
		If thumbnailsNode.Exists("maxWidth") Then
			width = CInt(thumbnailsNode.item("maxWidth"))
			If width>=0 Then maxWidth = width
		End if
		If thumbnailsNode.Exists("maxHeight") Then
			height = CInt(thumbnailsNode.item("maxHeight"))
			If height>=0 Then maxHeight = height
		End if
		If thumbnailsNode.Exists("quality") Then
			q = CInt(thumbnailsNode.item("quality"))
			If q>0 And q<=100 Then quality = q
		End if
		If thumbnailsNode.Exists("url") Then
			url = thumbnailsNode.item("url")
		End If
		If (url="") Then
			url = "/"
		Else
			If (Right(url, 1) <> "/") Then url = url & "/"
		End If

		If thumbnailsNode.Exists("directory") Then
			directory = thumbnailsNode.item("directory")
		End if
	End function

	''
	' Get URL
	'
	' @access public
	' @return string
	'
	public property get getUrl()
		getUrl = url
	end property

	''
	' Get directory
	'
	' @access public
	' @return string
	'
	public property get getDirectory()
		getDirectory = directory
	end property

	''
	' Get is enabled setting
	'
	' @access public
	' @return boolean
	'
	public property get getIsEnabled()
		getIsEnabled = isEnabled
	end property

	''
	' Is direct access to thumbnails enabled?
	'
	' @access public
	' @return boolean
	'
	public property get getDirectAccess()
		getDirectAccess = directAccess
	end property

	''
	' Get maximum width of a thumbnail
	'
	' @access public
	' @return int
	'
	public property get getMaxWidth()
		getMaxWidth = maxWidth
	end property

	''
	' Get maximum height of a thumbnail
	'
	' @access public
	' @return int
	'
	public property get getMaxHeight()
		getMaxHeight = maxHeight
	end property

	''
	' Get quality of a thumbnail (1-100)
	'
	' @access public
	' @return int
	'
	public property get getQuality()
		getQuality = quality
	end property

End Class

</script>
