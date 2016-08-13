Ext.define('CMS.view.sysmodel.Create', {
	extend: 'Ext.window.Window',
	alias: 'widget.createpanel',
	id: 'createpanel',

	title: '添加',
	layout: 'fit',
	width: 400,
	autoShow: true,
	modal: true,

	initComponent: function () {

		this.items = [
			{
				xtype: 'form',
				bodyStyle: 'padding:15px;',
				border: false,
				defaults: {
					anchor: '100%',
					labelAlign: 'right'
				},
				items: [
					{
						xtype: 'textfield',
						name: 'Username',
						allowBlank: false,
						maxWinth: 32,
						fieldLabel: '用户名'
					}
					,
					{
						xtype: 'textfield',
						name: 'Password',
						allowBlank: false,
						maxWinth: 32,
						fieldLabel: '密码'
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