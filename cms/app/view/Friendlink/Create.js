Ext.define('CMS.view.friendlink.Create', {
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
				maxHeight: 874,

				items: [
					{
						xtype: 'textfield',
						name: 'Title',
						maxWinth: 255,
						allowBlank: false,
						fieldLabel: '标题'
					},
					{
						xtype: 'textarea',
						name: 'Href',
						maxWinth: 255,
						fieldLabel: '地址'
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