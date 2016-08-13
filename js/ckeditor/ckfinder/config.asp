<%
' You can increase the time allowed for the script to avoid problems with large uploads
' Server.ScriptTimeout = 120
'
' ### CKFinder : Configuration File - Basic Instructions
'
' In a generic usage case, the following tasks must be done to configure
' CKFinder:
'     1. Check the baseUrl and baseDir variables.
'     2. If available, paste your license key in the "LicenseKey" setting.
'     3. Create the CheckAuthentication() function that enables CKFinder for authenticated users.
'
' Other settings may be left with their default values, or used to control
' advanced features of CKFinder.
'
Dim CKFinder_Config
Set CKFinder_Config = Server.CreateObject("Scripting.Dictionary")

' SECURITY: You must explicitly enable it. (Set it to "true").

' This function must check the user session to be sure that he/she is
' authorized to upload and access files in the File Browser.
function CheckAuthentication()
	' WARNING : DO NOT simply return "true". By doing so, you are allowing
	' "anyone" to upload and list the files in your server. You must implement
	' some kind of session validation here. Even something very simple as...
	'
	'              CheckAuthentication = ( Session( "IsAuthorized" ) )
	'
	' ... where Session( "IsAuthorized" ) is set to "true" as soon as the
	' user logs in your system.

	If Session("IsOnline") = True Then
		CheckAuthentication = true
	Else
		CheckAuthentication = false
	End If
	
	CheckAuthentication = true
	
End function

' In order to find out what's wrong if you have some problems setting up the editor you
' can enable this setting, it will give more detailed info on the errors, including
' server paths that are hidden for security reasons with the default settings.
Dim CKFinder_Debug
CKFinder_Debug = false


' LicenseKey : Paste your license key here. If left blank, CKFinder will be
' fully functional, in demo mode.
CKFinder_Config.Add "LicenseName", ""
CKFinder_Config.Add "LicenseKey", ""


'To make it easy to configure CKFinder, the baseUrl and baseDir can be used.
'Those are helper variables used later in this config file.

Dim baseUrl, baseDir

'baseUrl : the base path used to build the final URL for the resources handled
'in CKFinder. If empty, the default value (/userfiles/) is used.
'
'Examples:
'	baseUrl = "http://example.com/ckfinder/files/"
'	baseUrl = "/userfiles/"
'
'ATTENTION: The trailing slash is required.

baseUrl = "/attachments/"

'baseDir : the path to the local directory (in the server) which points to the
'above baseUrl URL. This is the path used by CKFinder to handle the files in
'the server. Full write permissions must be granted to this directory.
'
'Examples:
'	// You may point it to a directory directly:
'	baseDir = "C:\SiteDir\CKFinder\userfiles\"
'
'	// Or you may let CKFinder discover the path, based on baseUrl:
'	baseDir = server.MapPath(baseUrl) & "\"
'
'ATTENTION: The trailing slash is required.

baseDir = server.MapPath(baseUrl) & "\"

'
' ### Advanced Settings
'

'
' Thumbnails : thumbnails settings. All thumbnails will end up in the same
' directory, no matter the resource type.
'
' You must select which component will take care of the thumbnail creation and image reescaling
' Possible options:
' "Asp.Net", it should work with Asp.Net 1.1 and 2.0 without any extra software
' "Persits.Jpeg" Commercial component from Persits
' "briz.AspThumb" Commercial component from BRIZ Software
' "AspImage.Image" Commercial component from ServerObjects. It doesn't seems to handle gifs properly
' "shotgraph.image" Commercial component from ShotGraph. The demo version doesn't allow resizing
' "Auto": It will try to autodetect which one is available, in the order described above
' "None": Image manipulation (thumbnails, maximum dimensions, validation) won't be available.
'
' Note: In order to avoid running the autodetection routine in every request, you should set the
' component that you want to use, that will give a slightly better performance.
'
Dim Thumbnails, Images

Set Thumbnails = server.CreateObject("Scripting.Dictionary")
	Thumbnails.Add "url", baseUrl & "_thumbs"
	Thumbnails.Add "directory", baseDir & "_thumbs"
	Thumbnails.Add "enabled", true
	Thumbnails.Add "maxWidth", 100
	Thumbnails.Add "maxHeight", 100
	Thumbnails.Add "quality", 80
	Thumbnails.Add "directAccess", false

Set Images = server.CreateObject("Scripting.Dictionary")
	Images.Add "maxWidth", 1600
	Images.Add "maxHeight", 1200
	Images.Add "quality", 80
	'Images.Add "component", "Auto"
	Images.Add "component", "none"

CKFinder_Config.Add "Thumbnails", Thumbnails
CKFinder_Config.Add "Images", Images

'	RoleSessionVar : the session variable name that CKFinder must use to retrieve
'	the "role" of the current user. The "role", can be used in the "AccessControl"
'	settings (below in this page).
CKFinder_Config.Add "RoleSessionVar", "CKFinder_UserRole"


'	By default the asp code will call asp.net and use the system
'	temp folder to create an athentication file that can be validated,
'	but in some shared hosting situations the security settings
'	in the Asp.Net side might not allow to read that file.
'	In those situations, you can assign a path here (full system
'	path, ex: c:\inetpub\wwwroot\userfiles\_aspNet\ )
'	and put that same value in the config.asp file and it will be used
'	instead of the default temp path
' If you don't set it properly in BOTH config.asp and web.config you
'	will get an error: 403 Forbidden
'
Dim CKFinderTempPath
CKFinderTempPath=""

'	AccessControl : used to restrict access or features to specific folders.
'
'	Many "AccessControl" entries can be added. All attributes are optional.
'	Subfolders inherit their default settings from their parents' definitions.
'
'		- The "role" attribute accepts the special '*' value, which means
'		  "everybody".
'		- The "resourceType" attribute accepts the special value '*', which
'		  means "all resource types".

Dim accessControl(0)

Set accessControl(0) = DefineAccessControlItem("*", "*", "/", true, true, true, true, true, true, true, true)

' Helper function to return a dictionary with all the properties.
Function DefineAccessControlItem(role, resourceType, folder, folderView, folderCreate, folderRename, folderDelete, fileView, fileUpload, fileRename, fileDelete)
	Dim ControlItem
	Set ControlItem = server.CreateObject("Scripting.Dictionary")
	ControlItem.Add "role", role
	ControlItem.Add "resourceType", resourceType
	ControlItem.Add "folder", folder

	If Not(IsEmpty(folderView)) Then ControlItem.Add "folderView", folderView
	If Not(IsEmpty(folderCreate)) Then ControlItem.Add "folderCreate", folderCreate
	If Not(IsEmpty(folderRename)) Then ControlItem.Add "folderRename", folderRename
	If Not(IsEmpty(folderDelete)) Then ControlItem.Add "folderDelete", folderDelete

	If Not(IsEmpty(fileView)) Then ControlItem.Add "fileView", fileView
	If Not(IsEmpty(fileUpload)) Then ControlItem.Add "fileUpload", fileUpload
	If Not(IsEmpty(fileRename)) Then ControlItem.Add "fileRename", fileRename
	If Not(IsEmpty(fileDelete)) Then ControlItem.Add "fileDelete", fileDelete

	Set DefineAccessControlItem = ControlItem
End function



'	For example, if you want to restrict the upload, rename or delete of files in
'	the "Logos" folder of the resource type "Images", you may uncomment the
'	following definition, leaving the above one:
'	Please, remember to adjust Dim accessControl(0) to Dim accessControl(1)
'
' Set accessControl(1) = DefineAccessControlItem("*", "Images", "/Logos", true, true, true, true, true, false, false, false)
'

CKFinder_Config.Add "AccessControl", accessControl



'ResourceType : defines the "resource types" handled in CKFinder. A resource
'type is nothing more than a way to group files under different paths, each one
'having different configuration settings.
'
'Each resource type name must be unique.
'
'When loading CKFinder, the "type" querystring parameter can be used to display
'a specific type only. If "type" is omitted in the URL, the
'"DefaultResourceTypes" settings is used (may contain the resource type names
'separated by a comma). If left empty, all types are loaded.
'
'maxSize is defined in bytes, but shorthand notation may be also used.
'Available options are: G, M, K (case insensitive).
'1M equals 1048576 bytes (one Megabyte), 1K equals 1024 bytes (one Kilobyte), 1G equals one Gigabyte.
'Example: 'maxSize' => "8M",

CKFinder_Config.Add "DefaultResourceTypes", ""

'Change the number to match the number of resource types that you want to use minus one (it starts at 0)
Dim ResourceTypes(2)

Set ResourceTypes(0) = DefineResourceType( _
	"Files", _
	baseUrl & "files", _
	baseDir & "files", _
	0, _
	"7z,aiff,asf,avi,bmp,csv,doc,docx,fla,flv,gif,gz,gzip,jpeg,jpg,mid,mov,mp3,mp4,mpc,mpeg,mpg,ods,odt,pdf,png,ppt,pptx,pxd,qt,ram,rar,rm,rmi,rmvb,rtf,sdc,sitd,swf,sxc,sxw,tar,tgz,tif,tiff,txt,vsd,wav,wma,wmv,xls,xlsx,zip", _
	"" _
	)

Set ResourceTypes(1) = DefineResourceType( _
	"Images", _
	baseUrl & "images", _
	baseDir & "images", _
	0, _
	"bmp,gif,jpeg,jpg,png", _
	"" _
	)

Set ResourceTypes(2) = DefineResourceType( _
	"Flash", _
	baseUrl & "flash", _
	baseDir & "flash", _
	0, _
	"swf,flv", _
	"" _
	)
'Remember to increase the index for each new resource type that you add.


CKFinder_Config.Add "ResourceType", ResourceTypes

' Helper function to return a dictionary with all the properties.
Function DefineResourceType(name, url, directory, maxSize, allowedExtensions, deniedExtensions)
	Dim ResourceType
	Set ResourceType = server.CreateObject("Scripting.Dictionary")
	ResourceType.Add "name", name
	ResourceType.Add "url", url
	ResourceType.Add "directory", directory
	ResourceType.Add "maxSize", maxSize
	ResourceType.Add "allowedExtensions", allowedExtensions
	ResourceType.Add "deniedExtensions", deniedExtensions

	Set DefineResourceType = ResourceType
End function


'
' Security checks.
'

'This is due to a security problem in Apache, but it might be better to leave it enabled to protect against unknown bugs in IIS
CKFinder_Config.Add "CheckDoubleExtension", True

' Indicates that the file size (MaxSize) for images must be checked only
' after scaling them. Otherwise, it is checked right after uploading.
CKFinder_Config.Add "CheckSizeAfterScaling", True

' For security, HTML is allowed in the first Kb of data for files having the
' following extensions only.
CKFinder_Config.Add "HtmlExtensions", "html,htm,xml,js"

' Folders to not display in CKFinder, no matter their location. No
' paths are accepted, only the folder name.
' The * and ? wildcards are accepted.
' put different options separated by the pipe |
CKFinder_Config.Add "HideFolders", ".svn|CVS"

' Files to not display in CKFinder, no matter their location. No
' paths are accepted, only the file name, including extension.
' The * and ? wildcards are accepted.
' put different options separated by the pipe |
CKFinder_Config.Add "HideFiles", ".*"

' Perform additional checks for image files
' if set to true, validate that the image can be parsed by the server so it isn't a bogus file
CKFinder_Config.Add "SecureImageUploads", true

%>


<!-- #INCLUDE file="plugins/imageresize/plugin.asp" -->
<!-- #INCLUDE file="plugins/fileeditor/plugin.asp" -->
<% '<!-- #INCLUDE file="plugins/watermark/plugin.asp" --> %>
