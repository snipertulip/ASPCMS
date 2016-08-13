Ext.define('CMS.view.menutree.Edit', {
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
				xtype: 'hiddenfield',
				name: 'ParentID',	//MenuID
				fieldLabel: '系统编号'
			},
			{
				xtype: 'hiddenfield',
				name: 'id',	//MenuID
				fieldLabel: '系统编号'
			},
//			{
//				xtype: 'displayfield',
//				name: 'id',	//MenuID
//				fieldLabel: '系统编号'
//			},
			{
				xtype: 'textfield',
				name: 'text',	//MenuName
				allowBlank: false,
				maxWinth: 50,
				fieldLabel: '菜单名称'
			},
			{
				xtype: 'combo',
				name: 'ModelID',
				fieldLabel: '模型',
				allowBlank: false,
				editable: false,

				queryMode: 'local',
				autoSelect: false,

				store: 'SYSModel',
				displayField: 'ModelName',
				valueField: 'ModelID',

				listeners: {
					added: function(combo, contianer, pos) {
						if (combo.store.hasListener('load')) {
							combo.store.clearListeners();
						}

						combo.store.addListener('load', function(store, records, successful, operation) {
							var form = combo.up('form'),
								record = form.getRecord(),
								pos = record.getData().ModelID;
							combo.select(pos);
						}, {
							combo: this,
							pos: pos
						});

						combo.store.reload();

					}
				}
			}
			,
			{
				xtype: 'checkbox',
				fieldLabel: '展开/收缩',
				boxLabel: '展开',
				name: 'expanded',
				inputValue: true
			}
			,
			{
				xtype: 'checkbox',
				fieldLabel: '节点/文件夹',
				boxLabel: '节点',
				name: 'leaf',
				inputValue: true
			}
,
/*			{
				xtype: 'radiogroup',
				fieldLabel: '是否展开',
				items: [{
					boxLabel: '展开',
					name: 'expanded',	//Expanded
					inputValue: true
				},
				{
					boxLabel: '关闭',
					name: 'expanded',
					inputValue: false
				}]
			},
			{
				xtype: 'radiogroup',
				fieldLabel: '节点/文件夹',
				items: [{
					boxLabel: '子节点',
					name: 'leaf',	//Leaf
					inputValue: true
				},
				{
					boxLabel: '文件夹',
					name: 'leaf',
					inputValue: false
				}]
			},
*/			{
				xtype: 'numberfield',
				name: 'SortIndex',
				allowBlank: false,
				fieldLabel: '排序编号'
			}]

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