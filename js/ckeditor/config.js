/*
Copyright (c) 2003-2010, CKSource - Frederico Knabben. All rights reserved.
For licensing, see LICENSE.html or http://ckeditor.com/license
*/

CKEDITOR.editorConfig = function( config )
{
	// Define changes to default configuration here. For example:
	 config.language = 'zh-cn';
	// config.uiColor = '#AADC6E';

	config.toolbar = 'MyToolbar';
	 
	config.toolbar_MyToolbar = [
		['Source','-','-','Templates']
		,['Cut','Copy','Paste','PasteText','PasteFromWord','-','Preview','Print']
		,['Undo','Redo','-','Find','Replace','-']
		,'/'
		,['Image','Flash','Table','HorizontalRule','SpecialChar']
		,['Link','Unlink','Anchor']
		,'/'
		,['Bold','Italic','Underline','Strike','-','Subscript','Superscript']
		,['NumberedList','BulletedList','-','Outdent','Indent']
		,['JustifyLeft','JustifyCenter','JustifyRight','JustifyBlock']
		,['SelectAll','RemoveFormat']
		,['BidiLtr','BidiRtl']
		,'/'
		,['Styles','Format','Font','FontSize']
		,['TextColor','BGColor']
		,['Maximize','ShowBlocks']
	];
	
};
