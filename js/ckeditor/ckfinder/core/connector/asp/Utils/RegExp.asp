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
	' Simple class which provides simplified functions to work with regular expressions
	'
	' @package CKFinder
	' @subpackage Utils
	' @copyright CKSource - Frederico Knabben
	'
class Ckfinder_Connector_Utils_RegExp
	Private oRegex

	Private Sub Class_Initialize()
		Set oRegex	= New RegExp
	End Sub

	Private Sub Class_Terminate()
		Set oRegex	= Nothing
	End Sub

	' Checks if a string matches a regexp pattern
	Public Function MatchesPattern( pattern, text)
		If (pattern = "") Then
			MatchesPattern = False
			Exit function
		End If

		oRegex.IgnoreCase	= True
		oRegex.Global		= True
		oRegex.Pattern	= pattern

		MatchesPattern	= oRegex.Test(text)
	End Function

	Public Function ReplacePattern( pattern, text, replacement)
		oRegex.IgnoreCase	= True
		oRegex.Global		= True
		oRegex.pattern = pattern
		ReplacePattern = oRegex.Replace(text, replacement)
	End function

End class

</script>
