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
	' @subpackage CommandHandlers
	' @copyright CKSource - Frederico Knabben
	'

	''
	' Handle QuickUpload command
	'
	' @package CKFinder
	' @subpackage CommandHandlers
	' @copyright CKSource - Frederico Knabben
	'
class CKFinder_Connector_CommandHandler_QuickUpload


	''
	' Command name
	'
	' @access private
	' @var string
	'
	private command
	private base

	Private Sub Class_Initialize()
		Set base = new CKFinder_Connector_CommandHandler_FileUpload
		command = "QuickUpload"
	End Sub

	Private Sub Class_Terminate()
		Set base = nothing
	End Sub


	Public Property Get ErrorHandler()
		Set ErrorHandler = base.ErrorHandler
	End Property

	Public Property Get currentFolder()
		Set currentFolder = base.currentFolder
	End Property

	function sendResponse( response )
		Dim oRegistry
		set oRegistry = oCKFinder_Factory.Registry
		oRegistry.Item("FileUpload_url") = currentFolder.getUrl()

		sendResponse = base.sendResponse( response )
	End function
End Class

</script>
