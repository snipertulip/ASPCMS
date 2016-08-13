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
	'

	''
	' Basic error handler
	'
	' @package CKFinder
	' @subpackage ErrorHandler
	' @copyright CKSource - Frederico Knabben
	'
class CKFinder_Connector_ErrorHandler_Base
	''
	' Try/catch emulation, if set to true, error handler will not throw any error
	'
	' @var boolean
	'
	Dim catchAllErrors
	''
	' Array with error numbers that should be ignored
	'
	' @var array[]int
	'
	private skipErrorsArray

	''
	' Set whether all errors should be ignored
	'
	' @param boolean newValue
	' @access public
	'
	Public function setCatchAllErrors(newValue)
		If (newValue) then
			catchAllErrors = true
		Else
			catchAllErrors = False
		End if
	End function

	''
	' Set which errors should be ignored
	'
	' @param array newArray
	'
	function setSkipErrorsArray(newArray)
' FIXME
'		if (is_array(newArray)) {
	'		this->_skipErrorsArray = newArray
	'	}
	End function

	''
	' Access protected
	' returns true if it should skip this error
	'
	Public Function SkipError(number)
		SkipError = true
		If (catchAllErrors) Then Exit Function
' FIXME
'		if (in_array(number, this->_skipErrorsArray)) then exit function

		SkipError = false
	End function
	''
	' Throw connector error, return true if error has been thrown, false if error has been catched
	'
	' @param int number
	' @param string text
	' @access public
	'
	Public function throwError(number, text, debugText)
		If (SkipError(number)) Then Exit Function

		Dim oXML
		Set oXML = oCKFinder_Factory.XML
		oXML.raiseError number, text, debugText
	End Function

End Class

</script>
