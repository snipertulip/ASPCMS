Ext.define('CMS.view.article.Edit', {
	extend: 'Ext.form.Panel',
	alias: 'widget.editpanel',
	id: 'editpanel',
	
	autoShow: true,
	autoRender: true,
	bodyStyle: 'padding:15px;',
	defaults: {
		//anchor: '100%',
		width: '90%',
		labelAlign: 'right'
	},
	layout: 'vbox',

	initComponent: function() {

		this.items = [
//			{
//				xtype: 'displayfield',
//				name: 'ID',
//				fieldLabel: '系统编号'
//			},
			{
				xtype: 'textfield',
				name: 'Title',
				maxWinth: 255,
				allowBlank: false,
				fieldLabel: '标题'
			},
			{
				xtype: 'textarea',
				name: 'Summary',
				maxWinth: 255,
				fieldLabel: '摘要'
			},
			{
				xtype: 'ckeditor',
				name: 'Content',
				maxWinth: 65525,
				fieldLabel: '内容',
//				width: '100%',
				height : 600,
//				deferredRender : false,
                CKConfig: {
//                    /* Enter your CKEditor config paramaters here or define a custom CKEditor config file. */
//                    //customConfig : '/ckeditor/config.js', // This allows you to define the path to a custom CKEditor config file.
//                    //toolbar: 'Basic',
//				height : 500,
//				width: 900
                }
			},
			{
				xtype: 'displayfield',
				name: 'ADDDatetime',
				fieldLabel: '添加时间'
			},
			{
				xtype: 'displayfield',
				name: 'MODDatetime',
				fieldLabel: '修改时间'
			},
			{
				xtype: 'numberfield',
				name: 'SortIndex',
				allowBlank: false,
				fieldLabel: '排序编号'
			}
		];

		this.buttons = [{
			text: '保存',
			action: 'update'
		}];

		this.callParent(arguments);
	}
});