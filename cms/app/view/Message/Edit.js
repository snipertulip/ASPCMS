Ext.define('CMS.view.message.Edit', {
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
						xtype: 'textarea',
						name: 'Title',
						maxWinth: 255,
						allowBlank: false,
						fieldLabel: '反馈'
					},
					{
						xtype: 'textfield',
						name: 'Fullname',
						maxWinth: 50,
						fieldLabel: '昵称/姓名'
					},
					{
						xtype: 'textfield',
						name: 'Telephone',
						maxWinth: 50,
						fieldLabel: '电话'
					},
					{
						xtype: 'textfield',
						name: 'Email',
						maxWinth: 50,
						fieldLabel: '邮箱'
					},
					{
						xtype: 'textarea',
						name: 'Reply',
						maxWinth: 255,
						fieldLabel: '回复'
					},
					{
						xtype: 'checkbox',
						fieldLabel: '公开显示',
						boxLabel: '显示',
						name: 'Public',
						inputValue: true
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