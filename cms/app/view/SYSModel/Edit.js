Ext.define('CMS.view.sysmodel.Edit', {
	extend: 'Ext.window.Window',
	alias: 'widget.editpanel',
	id: 'editpanel',

	title: '修改',
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
						xtype: 'displayfield',
						name: 'ModelID',
						fieldLabel: '系统编号',
						allowBlank: false,
						minLength: 1
					}
					,
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
					,
					{
						xtype: 'numberfield',
						name: 'SortIndex',
						allowBlank: false,
						fieldLabel: '排序编号'
					}
				]

			}
		];

		this.buttons = [
			{
				text: '保存',
				action: 'update'
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