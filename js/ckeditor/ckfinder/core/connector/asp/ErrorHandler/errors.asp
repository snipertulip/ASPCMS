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
	' Error constants
	'
	' @package CKFinder
	' @subpackage ErrorHandler
	' @copyright CKSource - Frederico Knabben
	'

	public const CKFinder_Connector_Error_None = 0
	public const CKFINDER_CONNECTOR_ERROR_CUSTOM_ERROR = 1
	public const CKFINDER_CONNECTOR_ERROR_INVALID_COMMAND = 10
	public const CKFinder_Connector_Error_TypeNotSpecified = 11
	public const CKFINDER_CONNECTOR_ERROR_INVALID_TYPE = 12
	public const CKFINDER_CONNECTOR_ERROR_INVALID_NAME = 102
	public const CKFinder_Connector_Error_Unauthorized = 103
	public const CKFINDER_CONNECTOR_ERROR_ACCESS_DENIED = 104
	public const CKFINDER_CONNECTOR_ERROR_INVALID_EXTENSION = 105
	public const CKFINDER_CONNECTOR_ERROR_INVALID_REQUEST = 109
	public const CKFinder_Connector_Error_Unknown = 110
	public const CKFINDER_CONNECTOR_ERROR_ALREADY_EXIST = 115
	public const CKFINDER_CONNECTOR_ERROR_FOLDER_NOT_FOUND = 116
	public const CKFINDER_CONNECTOR_ERROR_FILE_NOT_FOUND = 117
	Public Const CKFINDER_CONNECTOR_ERROR_SOURCE_AND_TARGET_PATH_EQUAL = 118
	public const CKFINDER_CONNECTOR_ERROR_UPLOADED_FILE_RENAMED = 201
	public const CKFINDER_CONNECTOR_ERROR_UPLOADED_INVALID = 202
	public const CKFINDER_CONNECTOR_ERROR_UPLOADED_TOO_BIG = 203
	public const CKFINDER_CONNECTOR_ERROR_UPLOADED_CORRUPT = 204
	public const CKFinder_Connector_Error_UploadedNoTmpDir = 205
	public const CKFinder_Connector_Error_UploadedWrongHtmlFile = 206
	Public Const CKFINDER_CONNECTOR_ERROR_UPLOADED_INVALID_NAME_RENAMED = 207
	Public Const CKFINDER_CONNECTOR_ERROR_MOVE_FAILED = 300
	Public Const CKFINDER_CONNECTOR_ERROR_COPY_FAILED = 301
	public const CKFINDER_CONNECTOR_ERROR_CONNECTOR_DISABLED = 500
	public const CKFINDER_CONNECTOR_ERROR_THUMBNAILS_DISABLED = 501

</script>
