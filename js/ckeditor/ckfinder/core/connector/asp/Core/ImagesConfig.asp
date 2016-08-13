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
	' This class keeps Images configuration
	'
	' @package CKFinder
	' @subpackage Config
	' @copyright CKSource - Frederico Knabben
	'
class CKFinder_Connector_Core_ImagesConfig

	''
	' Max width for Images
	'
	' @var int
	' @access private
	'
	private maxWidth
	''
	' Max height for Images
	'
	' @var int
	' @access private
	'
	private maxHeight
	''
	' Quality of Images
	'
	' @var int
	' @access private
	'
	private quality

	' Name of the component that will handle image manipulations
	' String

	Private mComponent

	Private Sub Class_Initialize()
		maxWidth = 0
		maxHeight = 0
		quality = 100
		mComponent = ""
	End Sub

	function init( imagesNode )
		If imagesNode.Exists("component") Then
			mComponent = imagesNode.item("component")
		End if

		Dim width, height, q
		If imagesNode.Exists("maxWidth") Then
			width = CInt(imagesNode.item("maxWidth"))
			If width>=0 Then maxWidth = width
		End if
		If imagesNode.Exists("maxHeight") Then
			height = CInt(imagesNode.item("maxHeight"))
			If height>=0 Then maxHeight = height
		End if
		If imagesNode.Exists("quality") Then
			q = CInt(imagesNode.item("quality"))
			If q>0 And q<=100 Then quality = q
		End If

		'Now validate that there's a valid image manipulation component:
		If (maxWidth>0 Or maxHeight>0) Then
			if (oCKFinder_Factory.UtilsImage.ComponentName = "None") Then
				maxWidth = 0
				maxHeight = 0
			End if
		End if
	End function

	''
	' Get maximum width of an image
	'
	' @access public
	' @return int
	'
	public property get getMaxWidth()
		getMaxWidth = maxWidth
	end property

	''
	' Get maximum height of an image
	'
	' @access public
	' @return int
	'
	public property get getMaxHeight()
		getMaxHeight = maxHeight
	end property

	''
	' Get quality of an image (1-100)
	'
	' @access public
	' @return int
	'
	public property get getQuality()
		getQuality = quality
	end property

	''
	' Get Component name to do image manipulation
	'
	' @access public
	' @return String
	'
	public property get Component()
		Component = mComponent
	end property

	' When the componet is "Auto", we store back the result from the detection:
	public property let Component(name)
		mComponent = name
	end property

End Class

</script>
