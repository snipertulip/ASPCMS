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
'
' CKFinder extension: resize image according to a given size

class CKFinder_Watermark

	' Event listeners:
    public function onAfterFileUpload( currentFolder, uploadedFile, sFilePath)
		Dim watermarkSettings, mark
		Set watermarkSettings = CKFinder_Config("Plugin_Watermark")
		mark = server.mapPath(watermarkSettings("source"))

		If Not(oCKFinder_Factory.UtilsFileSystem.FileExists(mark)) Then
			Exit function
		End If

		onAfterFileUpload = oCKFinder_Factory.UtilsImage.createWatermark(sFilePath, mark, watermarkSettings("marginRight"), _
			watermarkSettings("marginBottom"), watermarkSettings("quality"), watermarkSettings("transparency"))
    End Function

End Class

	Dim oWaterMark, watermarkSettings

If (TypeName(oCKFinder_Factory) <> "Empty") then
	Set oWaterMark = new CKFinder_Watermark
	CKFinder_AddHook "AfterFileUpload", oWaterMark

	Set watermarkSettings = server.CreateObject("Scripting.Dictionary")
	watermarkSettings.Add "source", "..\..\..\_source\plugins\watermark\logo.gif"
	watermarkSettings.Add "marginRight", 5
	watermarkSettings.Add "marginBottom", 5
	watermarkSettings.Add "quality", 90
	watermarkSettings.Add "transparency", 80

	CKFinder_Config.Add "Plugin_Watermark", watermarkSettings
End If

</script>
