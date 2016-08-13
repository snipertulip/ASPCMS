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
						name: 'ModelName',
						allowBlank: false,
						maxWinth: 50,
						fieldLabel: '模型名称'
					}
					,
					{
						xtype: 'textfield',
						name: 'ModelURL',
						allowBlank: false,
						maxWinth: 255,
						fieldLabel: '模型地址'
					}
					,
					{
						xtype: 'textareafield',
						name: 'ModelRemark',
						maxWinth: 255,
						fieldLabel: '模型注释'
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