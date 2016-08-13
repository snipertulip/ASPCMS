Ext.define('CMS.view.admin.Edit', {
	extend: 'Ext.window.Window',
	alias: 'widget.editpanel',
	id: 'editpanel',

	title: '修改',
	layout: 'fit',
	width: 400,
	autoShow: true,
	modal: true,

	initComponent: function() {

		this.items = [{
			xtype: 'form',
			bodyStyle: 'padding:15px;',
			border: false,
			defaults: {
				anchor: '100%',
				labelAlign: 'right'
			},
			items: [
			{
				xtype: 'displayfield',
				name: 'Username',
				fieldLabel: '用户名'
			},
			{
				xtype: 'textfield',
				name: 'Password',
				maxWinth: 32,
				fieldLabel: '密码'
			},
			{
				xtype: 'displayfield',
				name: 'LastLoginDatetime',
				fieldLabel: '最后登录时间'
			},
			{
				xtype: 'numberfield',
				name: 'SortIndex',
				allowBlank: false,
				fieldLabel: '排序编号'
			}
			]

		}];

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