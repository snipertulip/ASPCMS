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
	' Folder view mask
	'
Const CKFINDER_CONNECTOR_ACL_FOLDER_VIEW = 1
Const CKFINDER_CONNECTOR_ACL_FOLDER_CREATE = 2
Const CKFINDER_CONNECTOR_ACL_FOLDER_RENAME = 4
Const CKFINDER_CONNECTOR_ACL_FOLDER_DELETE = 8
Const CKFINDER_CONNECTOR_ACL_FILE_VIEW = 16
Const CKFINDER_CONNECTOR_ACL_FILE_UPLOAD = 32
Const CKFINDER_CONNECTOR_ACL_FILE_RENAME = 64
Const CKFINDER_CONNECTOR_ACL_FILE_DELETE = 128

	''
	' This class keeps ACL configuration
	'
	' @package CKFinder
	' @subpackage Config
	' @copyright CKSource - Frederico Knabben
	'
class CKFinder_Connector_Core_AccessControlConfig
	''
	' Dictionary with ACL entries
	'
	' @var Dictionary of Dictionary of int
	' @access private
	'
	Private aclEntries

	Private Sub Class_Initialize()
		Set aclEntries = Server.CreateObject("Scripting.Dictionary")
	End Sub

	Private Sub Class_Terminate()
		aclEntries.RemoveAll
		Set aclEntries = nothing
	End Sub

	' Auxiliary function to read a value from a dictionary or return a default value
	Private Function readValue(dict, key, default)
		If (dict.Exists(key)) Then
			readValue = dict.Item(key)
		Else
			readValue = default
		End if
	End Function

	' tristate operation
	Private Function iif(condition, trueValue, falseValue)
		If (condition) Then
			iif = trueValue
		Else
			iif = falseValue
		End if
	End Function

	function Init(accessControlNodes)
		Dim i, node, lb, ub
		Dim	folderView, folderCreate, folderRename, folderDelete, fileView, fileUpload, fileRename, fileDelete, role, resourceType, folder

		lb = LBound(accessControlNodes)
		ub = UBound(accessControlNodes)
		For i = lb To ub
			Set node = accessControlNodes(i)

			folderView = readValue(node, "folderView", false)
			folderCreate = readValue(node, "folderCreate", false)
			folderRename = readValue(node, "folderRename", false)
			folderDelete = readValue(node, "folderDelete", false)

			fileView = readValue(node, "fileView", false)
			fileUpload = readValue(node, "fileUpload", false)
			fileRename = readValue(node, "fileRename", false)
			fileDelete = readValue(node, "fileDelete", false)

			role = readValue(node, "role", "*")
			resourceType = readValue(node, "resourceType", "*")
			folder = readValue(node, "folder", "/")

			me.addACLEntry role, resourceType, folder, _
					iif(folderView, CKFINDER_CONNECTOR_ACL_FOLDER_VIEW, 0) or _
					iif(folderCreate, CKFINDER_CONNECTOR_ACL_FOLDER_CREATE, 0) or _
					iif(folderRename, CKFINDER_CONNECTOR_ACL_FOLDER_RENAME, 0) or _
					iif(folderDelete, CKFINDER_CONNECTOR_ACL_FOLDER_DELETE, 0) or _
					iif(fileView, CKFINDER_CONNECTOR_ACL_FILE_VIEW, 0) or _
					iif(fileUpload, CKFINDER_CONNECTOR_ACL_FILE_UPLOAD, 0) or _
					iif(fileRename, CKFINDER_CONNECTOR_ACL_FILE_RENAME, 0) or _
					iif(fileDelete, CKFINDER_CONNECTOR_ACL_FILE_DELETE, 0) _
				, _
					iif(folderView, 0, CKFINDER_CONNECTOR_ACL_FOLDER_VIEW)or _
					iif(folderCreate, 0, CKFINDER_CONNECTOR_ACL_FOLDER_CREATE)or _
					iif(folderRename, 0, CKFINDER_CONNECTOR_ACL_FOLDER_RENAME)or _
					iif(folderDelete, 0, CKFINDER_CONNECTOR_ACL_FOLDER_DELETE)or _
					iif(fileView, 0, CKFINDER_CONNECTOR_ACL_FILE_VIEW)or _
					iif(fileUpload, 0, CKFINDER_CONNECTOR_ACL_FILE_UPLOAD)or _
					iif(fileRename, 0, CKFINDER_CONNECTOR_ACL_FILE_RENAME)or _
					iif(fileDelete, 0, CKFINDER_CONNECTOR_ACL_FILE_DELETE)

			Set node = nothing
		next

	End function

	''
	' Add ACL entry
	'
	' @param string role role
	' @param string resourceType resource type
	' @param string folderPath folder path
	' @param int allowRulesMask allow rules mask
	' @param int denyRulesMask deny rules mask
	'
	Public sub addACLEntry(role, resourceType, folderPath, allowRulesMask, denyRulesMask)
		Dim entryKey, rulesMasks

		if (Len(folderPath)=0) then
			folderPath = "/"
		else
			if (left(folderPath,1) <> "/") then
				folderPath = "/" & folderPath
			End if

			if (right(folderPath, 1) <> "/") then
				folderPath = folderPath & "/"
			End if
		End if

		entryKey = role & "#@#" & resourceType

		if (aclEntries.Exists(folderPath)) then
			if (aclEntries.Item(folderPath).Exists(entryKey)) then
				rulesMasks = aclEntries.Item(folderPath).Item(entryKey)
				allowRulesMask = allowRulesMask Or rulesMasks(0)
				denyRulesMask = denyRulesMask Or rulesMasks(1)
			End if
		else
			aclEntries.Add folderPath, server.CreateObject("Scripting.Dictionary")
		End if

		aclEntries.Item(folderPath).Item(entryKey) = Array(allowRulesMask, denyRulesMask)
	End sub


	''
	' Get computed mask
	'
	' @param string resourceType
	' @param string folderPath
	' @return int
	'
	function getComputedMask(resourceType, folderPath)
		Dim computedMask, userRole, roleSessionVar
		computedMask = 0

		roleSessionVar = oCKFinder_Factory.Config.getRoleSessionVar()

		userRole = empty
		if ((roleSessionVar<>"") and Not(isempty(session(roleSessionVar))) ) then
			userRole = CStr(session(roleSessionVar))
		End if
		if (userRole = "") then
			userRole = empty
		End If

		Dim sFolderPath, pathParts, currentPath, i
		sFolderPath = trimChar(folderPath, "/")
		pathParts = split(sFolderPath, "/")

		currentPath = "/"

		For i=-1 To UBound(pathParts)
			if (i >= 0) then
				if (pathParts(i) <> "") then
					if (aclEntries.Exists(currentPath & "*/")) then
						computedMask = mergePathComputedMask( computedMask, resourceType, userRole, currentPath & "*/" )
					End If

					currentPath = currentPath & pathParts(i) & "/"
				End if
			End if

			if (aclEntries.Exists(currentPath)) then
				computedMask = mergePathComputedMask( computedMask, resourceType, userRole, currentPath )
			End if
		next

		getComputedMask = computedMask
	End function

	function mergePathComputedMask( currentMask, resourceType, userRole, path )
		Dim folderEntries, possibleKey, r, rulesMasks, iEntries
		Dim possibleEntries(3)
		Set folderEntries = aclEntries.Item(path)

		possibleEntries(0) = "*#@#*"
		possibleEntries(1) = "*#@#" & resourceType
		iEntries = 1

		if (not IsEmpty(userRole)) then
			possibleEntries(2) = userRole & "#@#*"
			possibleEntries(3) = userRole & "#@#" & resourceType
			iEntries = 3
		End if

		for r = 0 To iEntries
			possibleKey = possibleEntries(r)
			if (folderEntries.Exists(possibleKey)) then
				rulesMasks = folderEntries.Item(possibleKey)
				currentMask = currentMask Or rulesMasks(0)
				currentMask = currentMask And not(rulesMasks(1)) ' simpler for me than c = c ^ ( c & r)
			End if
		next

		mergePathComputedMask = currentMask
	End Function

	''
	' Trims instances of char at the begginning and end of "text"
	'
	Private Function trimChar( text, char )
		Dim txt
		txt = text

		txt = oCKFinder_Factory.RegExp.ReplacePattern( "^(\" & char & "+)", txt, "")
		txt = oCKFinder_Factory.RegExp.ReplacePattern( "(\" & char & "+)$", txt, "")

		trimChar = txt
	End Function

End Class

</script>
