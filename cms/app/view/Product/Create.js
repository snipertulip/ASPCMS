Ext.define('CMS.view.product.Create', {
	extend: 'Ext.window.Window',
	alias: 'widget.createpanel',
	id: 'createpanel',

	title: '添加',
//	layout: 'fit',
//	width: 800,
//	height: 500,
	autoShow: true,
	modal: true,
//	maximizable: true,
	maximized: true,
	autoScroll:true,


	initComponent: function () {

		this.items = [
			{
				xtype: 'form',
				itemId: 'form',
				bodyStyle: 'padding:15px 15px 0 15px;',
				border: false,
				defaults: {
					anchor: '90%',
					labelAlign: 'right'
				},

//				autoScroll:true,
				maxHeight: 902,

				items: [
					{
						xtype: 'textfield',
						name: 'Title',
						maxWinth: 255,
						allowBlank: false,
						fieldLabel: '标题'
					},
					{
						xtype: 'checkbox',
						fieldLabel: '推荐设置',
						boxLabel: '推荐',
						name: 'Recommend',
						inputValue: true
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
//						width: 600,
						height : 600,
						CKConfig: {
		//                    /* Enter your CKEditor config paramaters here or define a custom CKEditor config file. */
		//                    //customConfig : '/ckeditor/config.js', // This allows you to define the path to a custom CKEditor config file.
		//                    //toolbar: 'Basic',
//							height : 50,
//							width: 600,
							height : 600,
							baseFloatZIndex : 19900
						}
					},
					{
						xtype: 'textfield',
						name: 'Source',
						maxWinth: 255,
						fieldLabel: '来源'
					},
//					{
//						xtype: 'textfield',
//						name: 'Author',
//						maxWinth: 255,
//						fieldLabel: '作者'
//					},
					{
						xtype: 'textfield',
						name: 'Label',
						maxWinth: 255,
						fieldLabel: '标签'
					},
					{
						xtype: 'textfield',
						name: 'ExternalLinks',
						maxWinth: 255,
						fieldLabel: '外部链接'
					},
					{
						xtype: 'textfield',
						name: 'Attachment',
						maxWinth: 255,
						fieldLabel: '附件'
						//,readOnly: true
					},
					{
						xtype: 'textfield',
						name: 'Attachment1',
						maxWinth: 255,
						fieldLabel: '附件1'
						//,readOnly: true
					}
				]

			},{
                xtype: 'form',
				itemId: 'formFile',
				bodyStyle:'padding:0 15px 0 15px;',
				border: false,

				defaults: {
					anchor: '90%',
					labelAlign: 'right'
				},
                items: [
					{
						xtype: 'filefield',
						name: 'filename',
						itemId: 'filename',
						fieldLabel: '上传附件',
						allowBlank: false,
						buttonText: '浏览...'
					},
					{
						xtype: 'hiddenfield',
						name: 'type',
						value: 'image'
					}
               ]
            },{
                xtype: 'form',
				itemId: 'formFile1',
				bodyStyle:'padding:0 15px 15px 15px;',
				border: false,

				defaults: {
					anchor: '90%',
					labelAlign: 'right'
				},
                items: [
					{
						xtype: 'filefield',
						name: 'filename1',
						itemId: 'filename1',
						fieldLabel: '上传附件1',
						allowBlank: false,
						buttonText: '浏览...'
					},
					{
						xtype: 'hiddenfield',
						name: 'type',
						value: 'image'
					}
               ]
            }
		];

		this.buttons = [
			{
				text: '保存',
				action: 'create'
			},
			{
				text: '取消',
				scope: this,
				handler: this.close
			}
		];

		this.callParent(arguments);
	}
});