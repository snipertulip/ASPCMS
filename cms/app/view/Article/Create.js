Ext.define('CMS.view.article.Create', {
	extend: 'Ext.form.Panel',
	alias: 'widget.createpanel',
	id: 'createpanel',

	autoShow: true,
	autoRender: true,
	bodyStyle: 'padding:15px;',
	defaults: {
		anchor: '100%',
		labelAlign: 'right'
	},

	initComponent: function() {

		this.items = [
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
				height : 600,
//				width: 900
                }
			}
		];

		this.buttons = [{
			text: '保存',
			action: 'create'
		}];

		this.callParent(arguments);
	}
});