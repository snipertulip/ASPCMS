Ext.define('CMS.view.menutree.Create', {
	extend: 'Ext.window.Window',
	alias: 'widget.createpanel',
	id: 'createpanel',

	title: '添加',
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
			// 'MenuID',  'MenuName',  'ParentID',  'ModelID',  'Style',  'FormConfig',  'FormExtral',  'Image',  'URLParameters',  'Expanded',  'Leaf',  'Remark',  'SortIndex',  'ModelName',  'ModelURL',  'ModelRemark'

			items: [
			{
				xtype: 'textfield',
				name: 'MenuName',
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

							combo.select(store.getAt(0));

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
				inputValue: true,
				checked: true
			}
/*			,{
				xtype: 'radiogroup',
				fieldLabel: '是否展开',
				items: [{
					boxLabel: '展开',
					name: 'Expanded',
					inputValue: true
				},
				{
					boxLabel: '关闭',
					name: 'Expanded',
					inputValue: false,
					checked: true
				}]
			},
			{
				xtype: 'radiogroup',
				fieldLabel: '节点/文件夹',
				items: [{
					boxLabel: '子节点',
					name: 'Leaf',
					inputValue: true,
					checked: true
				},
				{
					boxLabel: '文件夹',
					name: 'Leaf',
					inputValue: false
				}]
			}
*/			
			]

		}];

		this.buttons = [{
			text: '保存',
			action: 'create'
		},
		{
			text: '取消',
			scope: this,
			handler: this.close
		}];

		this.callParent(arguments);
	}
});