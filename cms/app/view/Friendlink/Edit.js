Ext.define('CMS.view.friendlink.Edit', {
	extend: 'Ext.window.Window',
	alias: 'widget.editpanel',
	id: 'editpanel',

	title: '修改',
//	layout: 'fit',
//	width: 800,
//	height: 500,
	autoShow: true,
	modal: true,
//	maximizable: true,
	maximized: true,
	autoScroll:true,

	initComponent: function() {

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
					},
					{
						xtype: 'numberfield',
						name: 'SortIndex',
						allowBlank: false,
						fieldLabel: '排序编号'
					}
				]

			}
		];

		this.buttons = [{
			text: '保存',
			action: 'update'
		},
		{
			text: '取消',
			scope: this,
			handler: this.close
		}];

		this.callParent(arguments);
	}
});