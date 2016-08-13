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
	' @subpackage ErrorHandler
	' @copyright CKSource - Frederico Knabben

	''
	' HTTP error handler
	'
	' @package CKFinder
	' @subpackage ErrorHandler
	' @copyright CKSource - Frederico Knabben
	'
class CKFinder_Connector_ErrorHandler_Http
	'pseudo inheritance
	private base

	Private Sub Class_Initialize()
		Set base = new CKFinder_Connector_ErrorHandler_Base
	End Sub

	Private Sub Class_Terminate()
		Set base = nothing
	End Sub

	Public Property Let setCatchAllErrors(newValue)
		base.setCatchAllErrors newValue
	End Property

	function setSkipErrorsArray(newArray)
		base.setSkipErrorsArray newArray
	End Function

	''
	' Throw file upload error, return true if error has been thrown, false if error has been catched
	'
	' @param int $number
	' @param string $text
	' @access public
	'
	function throwError(number, text, debugText)
		If (base.SkipError(number)) Then Exit Function

		Dim sResponse

		If (CKFinder_Debug) Then
			Response.ContentType	= "text/plain"
			sResponse = sResponse & "CKFinder connector for classic ASP. The connector is in Debug Mode." & vblf
			sResponse = sResponse & "In order to use the connector you'll have to set CKFinder_Debug = false." & vblf
			sResponse = sResponse & "Response from the connector (including debugging messages):" & vblf
			sResponse = sResponse & "                                                                        " & vblf
			sResponse = sResponse & "Response Number: " & number & vblf
			sResponse = sResponse & "Response Text: " & text & vblf
			sResponse = sResponse & "Debug Text: " & debugText & vblf

			response.write sResponse
		Else
			Select Case(number)
				case CKFINDER_CONNECTOR_ERROR_INVALID_REQUEST:
					response.status = 403
				case CKFINDER_CONNECTOR_ERROR_INVALID_NAME:
					response.status = 403
				case CKFINDER_CONNECTOR_ERROR_THUMBNAILS_DISABLED:
					response.status = 403
				case CKFINDER_CONNECTOR_ERROR_UNAUTHORIZED:
					response.status = 403

				case CKFINDER_CONNECTOR_ERROR_ACCESS_DENIED:
					response.status = 500

				Case else
					response.status = 404
			End select
			Response.AddHeader "X-CKFinder-Error", number

		End if
		response.end
	end Function
End Class

</script>
