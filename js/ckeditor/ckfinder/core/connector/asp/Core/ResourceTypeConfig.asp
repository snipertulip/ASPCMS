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
	' This class keeps resource types configuration
	'
	' @package CKFinder
	' @subpackage Config
	' @copyright CKSource - Frederico Knabben
	'
class CKFinder_Connector_Core_ResourceTypeConfig
	''
	' Resource name
	'
	' @var string
	' @access private
	'
	private name
	''
	' Resource url
	'
	' @var string
	' @access private
	'
	private url
	''
	' Directory path on a server
	'
	' @var string
	' @access private
	'
	private directory
	''
	' Max size
	'
	' @var long
	' @access private
	'
	private maxSize
	''
	' String with allowed extensions
	'
	' @var string
	' @access private
	'
	private allowedExtensions
	''
	' String with denied extensions
	'
	' @var string
	' @access private
	'
	private deniedExtensions
	''
	' used for CKFinder_Connector_Core_Config object caching
	'
	' @var CKFinder_Connector_Core_Config
	'
	private config


	Private Sub Class_Initialize()
		name = ""
		url = ""
		directory = ""
		maxSize = 0
		allowedExtensions = ""
		deniedExtensions = ""
	End Sub

	function Init(resourceTypeNode)
		if (resourceTypeNode.Exists("name")) then
			name = resourceTypeNode.Item("name")
		end if

		if (resourceTypeNode.Exists("url")) then
			url = resourceTypeNode.Item("url")
		end if

		If ( url = "" ) Then
			url = "/"
		Else
			If (Right(url, 1) <> "/") Then url = url & "/"
		End if


		if (resourceTypeNode.Exists("maxSize")) then
			maxSize = parseNumber( resourceTypeNode.Item("maxSize") )
		end if

		if (resourceTypeNode.Exists("directory")) then
			directory = resourceTypeNode.Item("directory")
		end If
		If (directory = "") Then directory = server.mapPath(url)

		Dim tmp, i
		if (resourceTypeNode.Exists("allowedExtensions")) then
			Tmp = resourceTypeNode.Item("allowedExtensions")
			If (IsArray(tmp)) Then
				allowedExtensions = LCase( Join(tmp, "|") )
			Else
				allowedExtensions = LCase( Replace(tmp, ",", "|")  )
			End If
		end if

		if (resourceTypeNode.Exists("deniedExtensions")) then
			Tmp = resourceTypeNode.Item("deniedExtensions")
			If (IsArray(tmp)) Then
				deniedExtensions = LCase( Join(tmp, "|") )
			Else
				deniedExtensions = LCase( Replace(tmp, ",", "|") )
			End if
		end if
		' We always add ckfindertemp as a denied extension:
		If deniedExtensions<>"" Then deniedExtensions = deniedExtensions & "|"
		deniedExtensions = deniedExtensions & "ckfindertemp"

	End function

	''
	' Get name
	'
	' @access public
	' @return string
	'
	Public Property Get getName
		getName = name
	End Property

	''
	' Get url
	'
	' @access public
	' @return string
	'
	Public Property Get getUrl
		getUrl = url
	End Property

	''
	' Get directory
	'
	' @access public
	' @return string
	'
	Public Property Get getDirectory
		getDirectory = directory
	End Property

	''
	' Get max size
	'
	' @access public
	' @return int
	'
	Public Property Get getMaxSize
		getMaxSize = maxSize
	End Property

	''
	' Get allowed extensions
	'
	' @access public
	' @return array[]string
	'
	Public Property Get getAllowedExtensions
		getAllowedExtensions = allowedExtensions
	End Property

	''
	' Get denied extensions
	'
	' @access public
	' @return array[]string
	'
	Public Property Get getDeniedExtensions
		getDeniedExtensions = deniedExtensions
	End Property

	''
	' Get default view
	'
	' @access public
	' @return string
	'
	Public Property Get getDefaultView
		getDefaultView = DefaultView
	End Property

	''
	' Check extension, return true if file name is valid.
	' Return false if extension is on denied list.
	' If allowed extensions are defined, return false if extension isn't on allowed list.
	'
	' @access public
	' @param string fileName with extension
	' @return boolean
	'
	function checkExtension(fileName)
		if (InStr(fileName, ".")=0) then
			checkExtension = true
			Exit function
		End if

		if (isEmpty(config)) then
			Set config = oCKFinder_Factory.Config
		End if

		if (config.getCheckDoubleExtension()) Then
			Dim pieces, i, lb, ub
			pieces = Split(fileName, ".")
			lb = LBound(pieces)
			ub = UBound(pieces)
			If Not(checkSingleExtension( pieces(ub) )) Then
				checkExtension = false
				Exit function
			End if

			' Check the other extensions, rebuilding the file name. If an extension is
			' not allowed, replace the dot with an underscore.
			fileName = pieces(lb)
			for i = lb+1 To ub-1
				If (checkSingleExtension( pieces(i) )) Then
					fileName = fileName & "." & pieces(i)
				Else
					fileName = fileName & "_" & pieces(i)
				End if
			next

			' Add the last extension to the final name.
			fileName = fileName & "." & pieces(ub)
			checkExtension = true
		else
			' Check only the last extension (ex. in file.php.jpg, only "jpg").
			checkExtension = checkSingleExtension( LCase(oCKFinder_Factory.UtilsFileSystem.GetExtension(fileName)) )
		End If
	End function

	' Checks that the extension is allowed
	Private function checkSingleExtension(extension)
		If deniedExtensions<>"" And oCKFinder_Factory.RegExp.MatchesPattern( deniedExtensions, extension ) Then
			checkSingleExtension = False
			Exit function
		End If

		If allowedExtensions<>"" And Not oCKFinder_Factory.RegExp.MatchesPattern( allowedExtensions, extension ) Then
			checkSingleExtension = False
			Exit function
		End If

		checkSingleExtension = true
	End Function

	''
	' Check if a folder must be hidden
	'
	Function checkIsHiddenFolder( folderName )
		if (isEmpty(config)) then
			Set config = oCKFinder_Factory.Config
		End if
		Dim oRegex
		Set oRegex = config.getHideFoldersRegex()
		checkIsHiddenFolder = oRegex.Test( folderName )
		Set oRegex = Nothing
	End Function

	''
	' Check if a file must be hidden
	'
	Public Function checkIsHiddenFile( fileName )
		if (isEmpty(config)) then
			Set config = oCKFinder_Factory.Config
		End if
		Dim oRegex
		Set oRegex = config.getHideFilesRegex()
		checkIsHiddenFile = oRegex.Test( fileName )
		Set oRegex = Nothing
	End Function

    ''
     ' Check given path
     ' Return true if path contains folder name that matches hidden folder names list
     '
     ' @param string $folderName
     ' @access public
     ' @return boolean
     '
    Public function checkIsHiddenPath(path)
		Dim clientPathParts, i, part, lb, ub

        clientPathParts = Split(path, "/")
		lb = LBound(clientPathParts)
		ub = UBound(clientPathParts)
		For i=lb To ub
			part = clientPathParts(i)
                if (checkIsHiddenFolder(part)) then
                    checkIsHiddenPath = True
                    Exit function
                End if
        next

        checkIsHiddenPath = false
    End function

	''
	' Given a string, it returns a number, converting the sufixes as necessary
	' 1K -> 1024, 1M-> 10^20
	Private Function parseNumber( sNumber )
		Dim tmp, suffix
		If (sNumber="") Then
			parseNumber = 0
			Exit function
		End If

		tmp = 1
		suffix = UCase(Right(sNumber, 1))
		If (suffix="B") Then
			sNumber = Left(sNumber, Len(sNumber)-1)
			suffix = UCase(Right(sNumber, 1))
		End if
		If (suffix="K") Then
			tmp = 1024
			sNumber = Left(sNumber, Len(sNumber)-1)
		End if
		If (suffix="M") Then
			tmp = 1024 * 1024
			sNumber = Left(sNumber, Len(sNumber)-1)
		End if
		If (suffix="G") Then
			tmp = 1024 * 1024 * 1024
			sNumber = Left(sNumber, Len(sNumber)-1)
		End If

		If IsNumeric(sNumber) then
			parseNumber = CLng(sNumber) * tmp
		Else
			parseNumber = 0
		End if
	End function
End Class

</script>
