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
	' @package CKFinder
	' @subpackage Utils
	' @copyright CKSource - Frederico Knabben
	'
class CKFinder_Connector_Utils_Image
	' Name of the component that should be used for image manipulation
	Private sComponentName
	Private oImageHandler

	Private Sub Class_Initialize()

	End Sub

	Private Sub Class_Terminate()
		Set oImageHandler = Nothing
	End sub

	Private Function throwError( number, text, debugText)
		oCKFinder_Factory.Connector.ErrorHandler.throwError number, text, debugText
	End Function

	''
	' Detects which component is available to handle image manipulation
	'
	' @return String
	'
	private Function DetectComponent()
		Dim component, expireDate

		Set component = new CKFinder_Utils_ImageHandler_AspNet
		If component.Enabled() then
			DetectComponent = "Asp.Net"
			Exit function
		End If

		Set component = new CKFinder_Utils_ImageHandler_Persits
		If component.Enabled() then
			DetectComponent = "Persits.Jpeg"
			Exit function
		End If

		Set component = new CKFinder_Utils_ImageHandler_Briz
		If component.Enabled() then
			DetectComponent = "briz.AspThumb"
			Exit Function
		End If

		Set component = new CKFinder_Utils_ImageHandler_AspImage
		If component.Enabled() then
			DetectComponent = "AspImage.Image"
			Exit function
		End If

		Set component = new CKFinder_Utils_ImageHandler_ShotGraph
		If component.Enabled() then
			DetectComponent = "shotgraph.image"
			Exit Function
		End If

		throwError CKFINDER_CONNECTOR_ERROR_CUSTOM_ERROR, "Unable to find an image manipulation component", ""
	End function

	' Find out which component should be used
	Public Property Get ComponentName()
		If (IsEmpty(sComponentName)) then
			sComponentName = oCKFinder_Factory.Config.getImagesConfig.Component
			If sComponentName = "" Or LCase(sComponentName)="none" Then sComponentName = "None"

			If (sComponentName = "Auto") Then
				sComponentName = DetectComponent()
				oCKFinder_Factory.Config.getImagesConfig.Component = sComponentName
			End If
		End If
		ComponentName = sComponentName
	End Property

	Private Property Get ImageHandler()
		If IsEmpty(oImageHandler) then
			Select Case ComponentName
				Case "Asp.Net"
					Set oImageHandler = new CKFinder_Utils_ImageHandler_AspNet

				Case "Persits.Jpeg"
					Set oImageHandler = new CKFinder_Utils_ImageHandler_Persits

				Case "briz.AspThumb"
					Set oImageHandler = new CKFinder_Utils_ImageHandler_Briz

				' Doesn't deal properly with gifs and the current demo is expired, so it won't work in normal servers.
				' It also tends to generate crashes very easily.
				Case "AspImage.Image"
					Set oImageHandler = new CKFinder_Utils_ImageHandler_AspImage

				Case "shotgraph.image"
					Set oImageHandler = new CKFinder_Utils_ImageHandler_ShotGraph

				Case else
					throwError CKFINDER_CONNECTOR_ERROR_CUSTOM_ERROR, "Invalid image manipulation component", ComponentName
			End select
		End If
		Set ImageHandler = oImageHandler
	End Property


	''
	' Checks that a file is an image
	' It only checks the extension
	' @return Boolean
	'
	Public Function isImage( filePath )
		Dim extension
		extension = LCase( oCKFinder_Factory.UtilsFileSystem.GetExtension( filePath ) )
		If (extension="jpg" Or extension="jpeg" Or extension="bmp" Or extension="png" Or extension="gif") then
			isImage = True
		Else
			isImage = false
		End if
	End Function

	''
	' Checks that a file is really a valid image
	' @return Boolean
	'
	Public Function isImageValid( filePath )
		isImageValid = False
		If Not(isImage( filePath ) ) Then
			Exit function
		End If

		' If there is no component selected, then everything is valid.
		If (ComponentName="None") Then
			isImageValid = True
		else
			' It will try to open the file, if it works, we assume that it was a good file.
			isImageValid = ImageHandler.validateImage(filePath)
		End If
	End Function

	Public Function getImageSize( filePath )
		Set getImageSize = ImageHandler.getImageSize( filePath )
	End Function

	Public function createThumb(sourceFile, targetFile, maxWidth, maxHeight, quality, preserveAspectRatio)
		If Not( isImage( sourceFile ) ) Then Exit Function

		createThumb = ImageHandler.createThumb(sourceFile, targetFile, CInt(maxWidth), CInt(maxHeight), CInt(quality), preserveAspectRatio)
	End function

	Public function createWatermark(sourceFile, watermarkFile, marginLeft, marginBottom, quality, transparency)
		If Not( isImage( sourceFile ) ) Then Exit Function

		createWatermark = ImageHandler.createWatermark(sourceFile, watermarkFile, CInt(marginLeft), CInt(marginBottom), CInt(quality), CInt(transparency))
	End function


	''
	' Return aspect ratio size, returns class CKFinder_Size
	' <pre>
	'	[Width] => 80
	'	[Heigth] => 120
	' </pre>
	'
	' @param int maxWidth
	' @param int maxHeight
	' @param int actualWidth
	' @param int actualHeight
	' @return CKFinder_Size
	'
	public Function GetAspectRatioSize( maxWidth, maxHeight, actualWidth, actualHeight )
		' Creates the Size object to be returned
		dim oSize, iFactorX, iFactorY

		Set oSize = new CKFinder_Size
		oSize.Width = maxWidth
		oSize.Height = maxHeight

		' Calculates the X and Y resize factors
		iFactorX = CSng(maxWidth) / cSng(actualWidth)
		iFactorY = CSng(maxHeight) / CSng(actualHeight)

		' If some dimension have to be scaled
		if ( iFactorX <> 1 or iFactorY <> 1 ) then
			' Uses the lower Factor to scale the oposite size
			if ( iFactorX < iFactorY ) then
				oSize.Height = cInt( CSng(actualHeight) * iFactorX )
			else
				if ( iFactorX > iFactorY ) then oSize.Width = cInt( cSng(actualWidth) * iFactorY )
			End if
		End if

		if ( oSize.Height <= 0 ) Then oSize.Height = 1
		if ( oSize.Width <= 0 ) Then oSize.Width = 1

		' Returns the Size
		Set GetAspectRatioSize = oSize
	End Function

End Class ' Main Image class

' Auxiliary class
Class CKFinder_Size
	Public Width
	Public Height
End Class

' .Net Implementation
Class CKFinder_Utils_ImageHandler_AspNet

	' Xml node returned by the call to Asp.Net
	Private responseNode

	Private Function throwError( number, text, debugText)
		oCKFinder_Factory.Connector.ErrorHandler.throwError number, text, debugText
	End Function

	Public function Enabled()
		enabled = false

		On Error Resume next

		LoadUrl AspNetUrl() & "&command=IsEnabled"
		If ( Err.Number=0) Then
			Enabled= true
		End If
		On Error GoTo 0
	End Function

	Public function createThumb(sourceFile, targetFile, maxWidth, maxHeight, quality, preserveAspectRatio)
		createThumb = CallAspNet( "&command=CreateThumbnail" & _
					"&InputImage=" & server.urlEncode(sourceFile) & _
					"&OutputThumbnail=" & server.urlEncode(targetFile) & _
					"&maxWidth=" & maxWidth & _
					"&maxHeight=" & maxHeight & _
					"&quality=" & quality )
	End function

	Public function ValidateImage(sourceFile)
		ValidateImage = CallAspNet( "&command=ValidateImage" & _
					"&InputImage=" & server.urlEncode(sourceFile) )
	End function


	Public function getImageSize(sourceFile)
		CallAspNet( "&command=GetImageSize" & _
					"&InputImage=" & server.urlEncode(sourceFile) )

		Dim oSize
		Set oSize = new CKFinder_Size

		oSize.Width =   CInt(responseNode.SelectSingleNode( "@Width" ).value)
		oSize.Height =  CInt(responseNode.SelectSingleNode( "@Height" ).value)

		Set getImageSize = oSize
	End Function

	Public function createWatermark(sourceFile, watermarkFile, marginLeft, marginBottom, quality, transparency)
		createWatermark = CallAspNet( "&command=CreateWatermark" & _
					"&InputImage=" & server.urlEncode(sourceFile) & _
					"&watermarkFile=" & server.urlEncode(watermarkFile) & _
					"&marginLeft=" & marginLeft & _
					"&marginBottom=" & marginBottom & _
					"&transparency=" & transparency & _
					"&quality=" & quality )
	End function

	Private Function CallAspNet( parameters )
		Dim url, errNumber, errDescription
		url = AspNetUrl() & parameters

		On Error Resume next
		If not LoadUrl( url ) Then
			errNumber = Err.Number
			errDescription = Err.Description
			On Error goto 0

			If errNumber<>0 Then
				If (errNumber = vbObjectError + CKFINDER_CONNECTOR_ERROR_UPLOADED_INVALID) Then
					CallAspNet = False
					Exit function
				End If

				throwError CKFINDER_CONNECTOR_ERROR_CUSTOM_ERROR, "Error returned in call to Asp.Net", "Error returned in call to " & url & ". (" & (errNumber - vbObjectError) & ", " & errDescription & ")"
			End If
			throwError CKFINDER_CONNECTOR_ERROR_CUSTOM_ERROR, "Failed to call Asp.Net", "Failed to call url " & url
		End If
		On Error Goto 0

		CallAspNet = true
	End Function

	''
	' Builds the full url to the asp.net loopback page
	' it should be placed in the same folder than the connector.asp
	'
	Private Property Get AspNetUrl()
		Dim url
		url = ""
		If (UCase(Request.ServerVariables("HTTPS")) = "ON") Then
			url = "https://"
		Else
			url = "http://"
		End if
		url = url & Request.ServerVariables("SERVER_NAME")
		Dim port
		port = request.ServerVariables("SERVER_PORT")
		If (port<>"80") Then url = url & ":" & port
		url = url & oCKFinder_Factory.RegExp.ReplacePattern( "/connector.asp$", Request.ServerVariables("URL"), "/")
		url = url & "loopback.aspx"

		' Generate a temporary file for "authentication".
		url = url & "?tmp=" & oCKFinder_Factory.UtilsFileSystem.createTempFile()

		AspNetUrl = url
	End Property

	''
	' Calls an url
	' The url must return a XML response or an error will be raised.
	' returns true if the call was OK (0 in value of Connector/Error/@number)
	'
	Private Function LoadUrl( sUrlToCall )
		Dim oXmlHttp
		Dim node, value

		Set oXmlHttp = Server.CreateObject("Msxml2.ServerXMLHTTP.3.0")

		oXmlHttp.Open "GET", sUrlToCall, False, Request.ServerVariables("AUTH_USER") & "", Request.ServerVariables("AUTH_PASSWORD") & ""
		oXmlHttp.Send

		if ( (oXmlHttp.status = 200 or oXmlHttp.status = 304) and Not(IsNull(oXmlHttp.responseXML) ) And Not(IsNull( oXmlHttp.responseXML.firstChild)) ) then
		'	this.DOMDocument = oXmlHttp.responseXML ;
		Else
			Err.Raise vbObjectError + CKFINDER_CONNECTOR_ERROR_CUSTOM_ERROR, "Unable to LoadUrl (" & sUrlToCall & ")", oXmlHttp.responseText
		End if

		On Error Resume next
		Set node = oXmlHttp.responseXML.SelectSingleNode( "Connector/Error/@number" )
		On Error goto 0
		If (node Is Nothing) Then
			Err.Raise vbObjectError + CKFINDER_CONNECTOR_ERROR_CUSTOM_ERROR, "Invalid XML response", oXmlHttp.responseText
		End if

		value = CInt(node.value)
		If (value<>0) Then
			Err.Raise vbObjectError + value, "Error returned in LoadUrl",  oXmlHttp.responseText
		End If

		' If the response includes a "Response" node, store it to parse it outside this function.
		Set responseNode = oXmlHttp.responseXML.SelectSingleNode( "Connector/Response" )

		Set oXmlHttp = Nothing

		LoadUrl = true
	End Function

End Class


' Persits Implementation
Class CKFinder_Utils_ImageHandler_Persits

	Private Function throwError( number, text, debugText)
		oCKFinder_Factory.Connector.ErrorHandler.throwError number, text, debugText
	End Function

	Public Function version(obj)
		Dim data
		' Returns the current version of the component in the format "1.6.0.0"
		data = obj.version
		' Convert it to a Long
		version = CLng(Replace(data, ".", ""))
	End Function

	Public Function Enabled()
		Dim component, expireDate
		On Error resume next
		Enabled = false
		Set component = Server.CreateObject("Persits.Jpeg")
		If (Err.number=0) Then
			' Check now that it isn't an expired version
			expireDate = component.expires

			Set component = Nothing
			If (expireDate = #9/9/9999# Or expireDate>Now()) then
				Enabled = true
			End if
		End If
		On Error goto 0
	End Function

	Private Function openImage(sourceFile)
		Dim Jpeg
		' Create instance of AspJpeg
		On Error Resume next
		Set Jpeg = Server.CreateObject("Persits.Jpeg")

		If (Err.number<>0) Then
			Set Jpeg = nothing
			throwError CKFINDER_CONNECTOR_ERROR_CUSTOM_ERROR, "Unable to create Persits.Jpeg component.", Err.description
			Exit function
		End if

		' Open source image
		Jpeg.Open sourceFile

		If (Err.number<>0) Then
			On Error goto 0
			Set Jpeg = nothing
			Set openImage = Nothing
			Exit function
		End if
		On Error goto 0

		Set openImage = Jpeg
	End function

	Public function getImageSize(sourceFile)
		Dim Jpeg, oSize
		' Create instance of AspJpeg
		Set Jpeg = openImage(sourceFile)

		Set oSize = new CKFinder_Size

		If (Jpeg Is Nothing) Then
			Set getImageSize = oSize
			Exit function
		End if

		oSize.Width =  Jpeg.Width
		oSize.Height =  Jpeg.Height

		Set Jpeg = nothing
		Set getImageSize = oSize
	End Function

	Public function createThumb(sourceFile, targetFile, maxWidth, maxHeight, quality, preserveAspectRatio)
		Dim Jpeg
		' Create instance of AspJpeg
		Set Jpeg = openImage(sourceFile)

		If (Jpeg Is Nothing) Then
			createThumb = false
			Exit function
		End if

		dim iFinalWidth, iFinalHeight
		' If 0 is passed in any of the max sizes it means that that size must be ignored,
		' so the original image size is used.
		iFinalWidth = maxWidth
		If (iFinalWidth = 0) Then iFinalWidth = Jpeg.Width
		iFinalHeight = maxHeight
		If (iFinalHeight = 0) Then iFinalHeight = Jpeg.Height

		if ( Jpeg.Width <= iFinalWidth and Jpeg.Height <= iFinalHeight ) then
			Set Jpeg = Nothing
			createThumb = oCKFinder_Factory.UtilsFileSystem.CopyFile( sourceFile, targetFile )
			Exit function
		End If

		dim oSize
		if ( preserveAspectRatio ) then
			' Gets the best size for aspect ratio resampling
			Set oSize = oCKFinder_Factory.UtilsImage.GetAspectRatioSize( iFinalWidth, iFinalHeight, Jpeg.Width, Jpeg.Height )
		else
			Set oSize = new CKFinder_Size
			oSize.Width = iFinalWidth
			oSize.Height = iFinalHeight
		End if

		' Resize
		Jpeg.Width = oSize.Width
		Jpeg.Height = oSize.Height

		' Avoid problems with CMYK
		Jpeg.ToRGB

		Jpeg.Quality = quality

		' create thumbnail and save it to disk
		Jpeg.Save targetFile

		Set Jpeg = Nothing

		createThumb = true
	End function


	Public function ValidateImage(sourceFile)
		Dim Jpeg
		' Create instance of AspJpeg
		Set Jpeg = openImage(sourceFile)

		If (Jpeg Is Nothing) Then
			ValidateImage = False
			Exit function
		End if

		ValidateImage = True
		Set Jpeg = nothing
	End Function

	Public function createWatermark(sourceFile, watermarkFile, marginLeft, marginBottom, quality, transparency)
		Dim Jpeg, Logo
		' Create instance of AspJpeg
		Set Jpeg = openImage(sourceFile)

		If (Jpeg Is Nothing) Then
			createWatermark = False
			Exit function
		End if

		Set Logo = openImage(watermarkFile)

		If (Logo Is Nothing) Then
			Set Jpeg = nothing
			createWatermark = False
			Exit function
		End if

		Dim marginTop, opacity
		marginTop = Jpeg.Height - (marginBottom + Logo.Height)

		' Avoid problems with CMYK
		Jpeg.ToRGB

		If version(Jpeg)<2100 Then

			opacity = 1 - transparency/100
			Jpeg.Canvas.DrawImage marginLeft, MarginTop, Logo, opacity
		else
			Jpeg.Canvas.DrawPng marginLeft, MarginTop, watermarkFile

			' Output as PNG
			'Jpeg.PNGOutput = True
		End if
		Set Logo = Nothing

		Jpeg.Quality = quality

		' create thumbnail and save it to disk
		Jpeg.Save sourceFile

		Set Jpeg = Nothing

		createWatermark = true
	End function
End Class

' Briz.AspThumb Implementation
Class CKFinder_Utils_ImageHandler_Briz

	Private Function throwError( number, text, debugText)
		oCKFinder_Factory.Connector.ErrorHandler.throwError number, text, debugText
	End Function

	Public Function Enabled()
		Dim component
		On Error resume next
		Enabled = false
		Set component = Server.CreateObject("briz.AspThumb")
		If (Err.number=0) Then
			Set component = Nothing
			enabled = true
		End If

		On Error goto 0
	End Function

	Public function createThumb(sourceFile, targetFile, maxWidth, maxHeight, quality, preserveAspectRatio)
		Dim tn
		' Create instance of AspThumb
		On Error Resume next
		Set tn = Server.CreateObject("briz.AspThumb")

		If (Err.number<>0) Then
			Set tn = nothing
			throwError CKFINDER_CONNECTOR_ERROR_CUSTOM_ERROR, "Unable to create briz.AspThumb component.", Err.description
			Exit function
		End if

		' Open source image
		tn.Load sourceFile

		If (Err.number<>0) Then
			Set tn = nothing
			createThumb = false
			Exit function
		End if
		On Error goto 0

		dim iFinalWidth, iFinalHeight
		' If 0 is passed in any of the max sizes it means that that size must be ignored,
		' so the original image size is used.
		iFinalWidth = maxWidth
		If (iFinalWidth = 0) Then iFinalWidth = tn.Width
		iFinalHeight = maxHeight
		If (iFinalHeight = 0) Then iFinalHeight = tn.Height

		if ( tn.Width <= iFinalWidth and tn.Height <= iFinalHeight ) then
			Set tn = Nothing
			createThumb = oCKFinder_Factory.UtilsFileSystem.CopyFile( sourceFile, targetFile )
			Exit function
		End If

		dim oSize
		if ( preserveAspectRatio ) then
			' Gets the best size for aspect ratio resampling
			Set oSize = oCKFinder_Factory.UtilsImage.GetAspectRatioSize( iFinalWidth, iFinalHeight, tn.Width, tn.Height )
		else
			Set oSize = new CKFinder_Size
			oSize.Width = iFinalWidth
			oSize.Height = iFinalHeight
		End if

		tn.ResizeQuality = quality
		' Resize
		tn.Resize oSize.Width, oSize.Height

		' create thumbnail and save it to disk
		tn.Save targetFile

		Set tn = Nothing

		createThumb = true
	End function

	Public function ValidateImage(sourceFile)
		Dim tn
		' Create instance of AspThumb
		On Error Resume next
		Set tn = Server.CreateObject("briz.AspThumb")

		If (Err.number<>0) Then
			Set tn = nothing
			throwError CKFINDER_CONNECTOR_ERROR_CUSTOM_ERROR, "Unable to create briz.AspThumb component.", Err.description
			Exit function
		End if

		' Open source image
		tn.Load sourceFile

		If (Err.number<>0) Then
			Set tn = nothing
			ValidateImage = False
			Exit function
		End if
		On Error goto 0

		ValidateImage = true
	End Function

	Public function createWatermark(sourceFile, watermarkFile, marginLeft, marginBottom, quality, transparency)
		' FIXME
	End function

End Class


' ServerObjects AspImage Implementation
Class CKFinder_Utils_ImageHandler_AspImage

	Private Function throwError( number, text, debugText)
		oCKFinder_Factory.Connector.ErrorHandler.throwError number, text, debugText
	End Function

	Public Function Enabled()
		Dim component, expireDate

		Enabled = false
		On Error Resume next
		Set component = Server.CreateObject("AspImage.Image")
		If (Err.number=0) Then
			' Check now that it isn't an expired version
			expireDate = component.expires
			If (expireDate="N/A") Then expireDate = #01/01/2050#

			Set component = Nothing
			' It's trickier to find out if it can work or not.
			If (IsNull(expireDate) Or DateDiff("d", expireDate, Now())<0 ) then
				enabled = true
			End If

		End If
		On Error goto 0
	End function


	' It seems that it can fail to get the dimensions of gif files
	Public function createThumb(sourceFile, targetFile, maxWidth, maxHeight, quality, preserveAspectRatio)
		Dim Image, expireDate
		' Create instance of AspImage
		On Error Resume next
		Set Image = Server.CreateObject("AspImage.Image")

		If (Err.number<>0) Then
			Set Image = nothing
			throwError CKFINDER_CONNECTOR_ERROR_CUSTOM_ERROR, "Unable to create AspImage.Image component.", Err.description
			Exit function
		End if
		On Error goto 0

		' Check now that it isn't an expired version
		expireDate = Image.expires
		If (expireDate="N/A") Then expireDate = #01/01/2050#

		' It's trickier to find out if it can work or not.
		If not(IsNull(expireDate) Or DateDiff("d", expireDate, Now())<0 ) then
			throwError CKFINDER_CONNECTOR_ERROR_CUSTOM_ERROR, "The AspImage.Image component has expired on " & expireDate & ".", ""
			Exit function
		End If

		' Open source image
		If Not(Image.LoadImage(sourceFile)) Then
			Set Image = Nothing
			createThumb = False
			Exit function
		End If

		' with gifs it returns 0x0
'		Response.Write "Image Height = " & Image.MaxY & " - Image Width = " & Image.MaxX

		dim iFinalWidth, iFinalHeight
		' If 0 is passed in any of the max sizes it means that that size must be ignored,
		' so the original image size is used.
		iFinalWidth = maxWidth
		If (iFinalWidth = 0) Then iFinalWidth = Image.MaxX
		iFinalHeight = maxHeight
		If (iFinalHeight = 0) Then iFinalHeight = Image.MaxY

		if ( Image.MaxX <= iFinalWidth and Image.MaxY <= iFinalHeight ) then
			Set Image = Nothing
			createThumb = oCKFinder_Factory.UtilsFileSystem.CopyFile( sourceFile, targetFile )
			Exit function
		End If

		dim oSize
		if ( preserveAspectRatio ) then
			' Gets the best size for aspect ratio resampling
			Set oSize = oCKFinder_Factory.UtilsImage.GetAspectRatioSize( iFinalWidth, iFinalHeight, Image.MaxX, Image.MaxY )
		else
			Set oSize = new CKFinder_Size
			oSize.Width = iFinalWidth
			oSize.Height = iFinalHeight
		End if

		' Resize
		Image.ResizeR oSize.Width, oSize.Height

		Dim extension
		extension = LCase(oCKFinder_Factory.UtilsFileSystem.GetExtension( targetFile ) )
		Select Case extension
			Case "jpg", "jpeg"
				Image.ImageFormat = 1
				Image.JPEGQuality = quality
			Case "bmp"
				Image.ImageFormat = 2
			Case "png"
				Image.ImageFormat = 3
			Case "gif"
				Image.ImageFormat = 5
		End select

		' create thumbnail and save it to disk
		Image.FileName = targetFile
		if Image.SaveImage() then
			createThumb = True
			' It can change automatically the extension to jpg
			If (extension = "jpeg") Then
				Dim savedName
				savedName = Left( targetFile, Len(targetFile)-4) & "jpg"
				createThumb = oCKFinder_Factory.UtilsFileSystem.RenameFile( savedName, targetFile )
			End if
		else
		' Something happened and we couldn't save the image so just use an HTML header
		' We need to debug the script and find out what went wrong.
			createThumb = False
			Dim message
			message = Image.Error
			Set Image = nothing
			throwError CKFINDER_CONNECTOR_ERROR_CUSTOM_ERROR, "Unable to save thumbnail. ", message
			Exit function
		end if

		Set Image = Nothing
	End Function

	Public function ValidateImage(sourceFile)
		Dim Image
		' Create instance of AspImage
		On Error Resume next
		Set Image = Server.CreateObject("AspImage.Image")

		If (Err.number<>0) Then
			Set Image = nothing
			throwError CKFINDER_CONNECTOR_ERROR_CUSTOM_ERROR, "Unable to create AspImage.Image component.", Err.description
			Exit function
		End if
		On Error goto 0

		' Open source image
		If Not(Image.LoadImage(sourceFile)) Then
			Set Image = Nothing
			ValidateImage = False
			Exit function
		End If

		Set Image = Nothing
		ValidateImage = true
	End Function

	Public function createWatermark(sourceFile, watermarkFile, marginLeft, marginBottom, quality, transparency)
		' FIXME
	End function
End class



' ShotGraph Implementation
Class CKFinder_Utils_ImageHandler_ShotGraph

	Private Function throwError( number, text, debugText)
		oCKFinder_Factory.Connector.ErrorHandler.throwError number, text, debugText
	End Function

	Public Function Enabled()
		Dim component

		Enabled = false
		On Error Resume Next
		Set component = Server.CreateObject("shotgraph.image")
		If (Err.number=0) Then
			' Validate that it isn't in demo mode.
			component.CreateImage 1, 1, 32
			If (Err.number=0) then
				Enabled = true
			End if
			Set component = Nothing
		End If
		On Error goto 0
	End function

	Public function createThumb(sourceFile, targetFile, maxWidth, maxHeight, quality, preserveAspectRatio)
		Dim sg
		' Create instance of ShotGraph
		On Error Resume next
		Set sg = Server.CreateObject("shotgraph.image")

		If (Err.number<>0) Then
			Set sg = nothing
			throwError CKFINDER_CONNECTOR_ERROR_CUSTOM_ERROR, "Unable to create shotgraph.image component.", Err.description
			Exit function
		End if

		' Validate that it isn't in demo mode.
		sg.CreateImage 1, 1, 32
		If (Err.number<>0) Then
			Set sg = nothing
			throwError CKFINDER_CONNECTOR_ERROR_CUSTOM_ERROR, "The shotgraph.image component has expired.", Err.description
			Exit function
		End if

		Dim palete, imagetype, xsize, ysize
		' Open source image
		imagetype = sg.GetFileDimensions( sourceFile, xsize, ysize)

		If (Err.number<>0) Or imagetype=0 Or imagetype=4 Or imagetype>=6 Then
			Set sg = nothing
			createThumb = false
			Exit function
		End if
		On Error goto 0

		dim iFinalWidth, iFinalHeight
		' If 0 is passed in any of the max sizes it means that that size must be ignored,
		' so the original image size is used.
		iFinalWidth = maxWidth
		If (iFinalWidth = 0) Then iFinalWidth = xsize
		iFinalHeight = maxHeight
		If (iFinalHeight = 0) Then iFinalHeight = ysize

		if ( xsize <= iFinalWidth and ysize <= iFinalHeight ) then
			Set tn = Nothing
			createThumb = oCKFinder_Factory.UtilsFileSystem.CopyFile( sourceFile, targetFile )
			Exit function
		End If

		dim oSize
		if ( preserveAspectRatio ) then
			' Gets the best size for aspect ratio resampling
			Set oSize = oCKFinder_Factory.UtilsImage.GetAspectRatioSize( iFinalWidth, iFinalHeight, xsize, ysize )
		else
			Set oSize = new CKFinder_Size
			oSize.Width = iFinalWidth
			oSize.Height = iFinalHeight
		End if

		' Resize
		sg.CreateImage oSize.Width, oSize.Height, 32
		sg.InitClipboard xsize, ysize
		sg.SelectClipboard True
		sg.ReadImage sourceFile, palete, 0, 0
		sg.Stretch 0, 0, oSize.Width, oSize.Height, 0, 0, xsize, ysize, "SRCCOPY", "HALFTONE"
		sg.SelectClipboard False
		sg.Sharpen

		' create thumbnail and save it to disk
		Select Case imagetype
			Case 1
				sg.GifImage -1, 0, targetFile
			Case 2
				sg.JpegImage quality, 0, targetFile
			Case 3
				sg.BmpImage 0, targetFile
			Case 5
				sg.PngImage -1, 1, targetFile
		End select

		Set sg = Nothing

		createThumb = true
	End function

	Public function ValidateImage(sourceFile)
		Dim sg
		' Create instance of ShotGraph
		On Error Resume next
		Set sg = Server.CreateObject("shotgraph.image")

		If (Err.number<>0) Then
			Set sg = nothing
			throwError CKFINDER_CONNECTOR_ERROR_CUSTOM_ERROR, "Unable to create shotgraph.image component.", Err.description
			Exit function
		End if

		Dim palete, imagetype, xsize, ysize
		' Open source image
		imagetype = sg.GetFileDimensions( sourceFile, xsize, ysize)

		If (Err.number<>0) Or imagetype=0 Or imagetype=4 Or imagetype>=6 Then
			Set sg = nothing
			ValidateImage = false
			Exit function
		End if
		On Error goto 0

		Set sg = nothing
		ValidateImage = true
	End function

	Public function createWatermark(sourceFile, watermarkFile, marginLeft, marginBottom, quality, transparency)
		' FIXME
	End function
End Class

</script>
