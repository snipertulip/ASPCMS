<%@ codepage="65001" language="VBScript" %>
<% Option Explicit %>
<%
Response.CharSet = "utf-8"
' CKFinder
' ========
' http://ckfinder.com
' Copyright (C) 2007-2010, CKSource - Frederico Knabben. All rights reserved.
'
' The software, this file and its contents are subject to the CKFinder
' License. Please read the license.txt file before using, installing, copying,
' modifying or distribute this file or part of its contents. The contents of
' this file is part of the Source Code of CKFinder.
%>
<!-- #INCLUDE file="core/factory.asp" -->
<!-- #INCLUDE file="core/AccessControlConfig.asp" -->
<!-- #INCLUDE file="core/folderHandler.asp" -->
<!-- #INCLUDE file="core/xml.asp" -->
<!-- #INCLUDE file="core/config.asp" -->
<!-- #INCLUDE file="core/ImagesConfig.asp" -->
<!-- #INCLUDE file="core/ThumbnailsConfig.asp" -->
<!-- #INCLUDE file="core/ResourceTypeConfig.asp" -->
<!-- #INCLUDE file="core/connector.asp" -->
<!-- #INCLUDE file="core/hooks.asp" -->

<!-- #INCLUDE file="errorHandler/Errors.asp" -->
<!-- #INCLUDE file="errorHandler/base.asp" -->
<!-- #INCLUDE file="errorHandler/FileUpload.asp" -->
<!-- #INCLUDE file="errorHandler/QuickUpload.asp" -->
<!-- #INCLUDE file="errorHandler/http.asp" -->

<!-- #INCLUDE file="commandHandler/commandHandlerBase.asp" -->
<!-- #INCLUDE file="commandHandler/XmlCommandHandlerBase.asp" -->
<!-- #INCLUDE file="commandHandler/CopyFiles.asp" -->
<!-- #INCLUDE file="commandHandler/CreateFolder.asp" -->
<!-- #INCLUDE file="commandHandler/DeleteFile.asp" -->
<!-- #INCLUDE file="commandHandler/DeleteFolder.asp" -->
<!-- #INCLUDE file="commandHandler/DownloadFile.asp" -->
<!-- #INCLUDE file="commandHandler/FileUpload.asp" -->
<!-- #INCLUDE file="commandHandler/GetFolders.asp" -->
<!-- #INCLUDE file="commandHandler/GetFiles.asp" -->
<!-- #INCLUDE file="commandHandler/init.asp" -->
<!-- #INCLUDE file="commandHandler/MoveFiles.asp" -->
<!-- #INCLUDE file="commandHandler/RenameFile.asp" -->
<!-- #INCLUDE file="commandHandler/RenameFolder.asp" -->
<!-- #INCLUDE file="commandHandler/QuickUpload.asp" -->
<!-- #INCLUDE file="commandHandler/Thumbnail.asp" -->

<!-- #INCLUDE file="utils/FileSystem.asp" -->
<!-- #INCLUDE file="utils/Image.asp" -->
<!-- #INCLUDE file="utils/Netrube_upload.asp" -->
<!-- #INCLUDE file="utils/RegExp.asp" -->
<!-- #INCLUDE file="utils/sha1.asp" -->
<!-- #INCLUDE file="utils/Time.asp" -->
<!-- #INCLUDE file="utils/xmlNode.asp" -->
<!-- #INCLUDE file="utils/Translator.asp" -->

<!-- #INCLUDE file="../../../config.asp" -->
<script runat="server" language="VBScript">
Dim sCommand
sCommand = request.queryString("command")

oCKFinder_Factory.Connector.executeCommand(sCommand)
</script>
