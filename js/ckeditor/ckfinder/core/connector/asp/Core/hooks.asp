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
Class CKFinder_Connector_Core_Hooks
    ''
     ' Run user defined hooks
     '
     ' @param string $event
     ' @param object $errorHandler
     ' @param array $args
     ' @return boolean (true to continue processing, false otherwise)
     '
    Public function run(eventName, args)
		Dim hooks, errorHandler
        if (Not CKFinder_Config.Exists("Hooks")) then
            run = true
			Exit function
        End if


        if not(CKFinder_Config("Hooks").Exists(eventName)) then
            run = true
			Exit function
        End if
		hooks = CKFinder_Config("Hooks")(eventName)

        Set errorHandler = oCKFinder_Factory.Connector.ErrorHandler()

		Dim i, hook, lb, ub, ret, retType, callback, params

		lb = LBound(args)
		ub = UBound(args)
		params = ""
		For i=lb To ub
			If params<>"" Then params = params & ", "
			params = params & "args(" & i & ")"
		next

		lb = LBound(hooks)
		ub = UBound(hooks)
		For i=lb To ub
			Set hook = hooks(i)

			' hook can be an object with a function named "on" + the event that it's handling
			callback = "hook.on" & eventName & "(" & params & ")"
			ret = eval(callback)

			retType = TypeName(ret)
            ' String return is a custom error
			if (retType = "String") then
				errorHandler.throwError CKFINDER_CONNECTOR_ERROR_CUSTOM_ERROR, ret, "custom error"
				run = False
				Exit Function
			End if

			' hook returned an error code, user error codes start from 50000
			' error codes are important because this way it is possible to create multilanguage extensions
			' TODO: two custom extensions may be popular and return the same error codes
			' recomendation: create a function that calculates the error codes starting number
			' for an extension, a pool of 100 error codes for each extension should be safe enough
			if (retType = "Integer" ) then
				errorHandler.throwError ret, "", "custom numeric error"
				run = False
				Exit Function
			End If

			'no value returned
'			if( $ret === null ) {
'				$functionName = CKFinder_Connector_Core_Hooks::_printCallback($callback);
'				$errorHandler->throwError(CKFINDER_CONNECTOR_ERROR_CUSTOM_ERROR,
'				"CKFinder extension returned an invalid value (null)." .
'				"Hook " . $functionName . " should return a value.");
'				return false;
'			}
			if not(ret) then
				run = False
				Exit function
			End if

		Next

		run = true
	End Function

End class


Public Sub CKFinder_AddHook(eventName, handler)
	Dim hooks, data, size

	If Not(CKFinder_Config.Exists("Hooks")) then
		CKFinder_Config.Add "Hooks", server.CreateObject("Scripting.Dictionary")
	End If

	Set hooks = CKFinder_Config("Hooks")
	If (hooks.Exists(eventName)) Then
		data = hooks(eventName)
		size = UBound(data)
		ReDim preserve data(size+1)
	else
		Dim arr(0)
		hooks.Add eventName, arr
		data = arr
		size = -1
	End If

	Set data(size+1) = handler

	hooks.item(eventName) = data
End Sub

Public Sub CKFinder_AddPlugin(name)
	Dim plugins, size

	If CKFinder_Config.Exists("Plugins") then
		plugins = CKFinder_Config("Plugins")
		size = UBound(plugins)
		ReDim preserve plugins(size+1)
	Else
		Dim tmp(0)
		plugins = tmp
		CKFinder_Config.Add "Plugins", plugins
		size = -1
	End If
	plugins(size+1) = name

	CKFinder_Config("Plugins") = plugins
End Sub

</script>
