Ext.define('WebManager.view.sysmodel.List', {
	extend: 'Ext.grid.Panel',
	alias: 'widget.gridlist',
	id: 'gridlist',

	store: 'SYSModel',

	title: '模型',

	tbar: [
		{
			xtype: 'button',
			text: '刷新',
			action: 'refresh',
			iconCls: 'btn-refresh'
		},
		'-',
		{
			xtype: 'button',
			text: '添加',
			action: 'create',
			iconCls: 'btn-add'
		},
		{
			itemId: 'editMenuTree',
			xtype: 'button',
			text: '修改',
			action: 'edit',
			iconCls: 'btn-edit',
			disabled: true
		},
		{
			itemId: 'removeMenuTree',
			xtype: 'button',
			text: '删除',
			action: 'destroy',
			iconCls: 'btn-delete',
			disabled: true
		}

	],

	selModel: Ext.create('Ext.selection.CheckboxModel'),

	initComponent: function () {
		this.columns = [

			
			{header: '系统编号', dataIndex: 'ModelID'},
			{header: '模型名称', dataIndex: 'ModelName'},
			{header: '模型地址', dataIndex: 'ModelURL'},
			{header: '排序', dataIndex: 'SortIndex'}
/*			,
			{
				header: '修改',
				xtype: 'actioncolumn',
				width: 50,
				icon: 'resources/images/icons/application_form_edit.png',  // Use a URL in the icon config
				iconCls: 'icon-edit',
				tooltip: 'edit'//,
				//handler: function(grid, rowIndex, colIndex) {
				//var rec = grid.getStore().getAt(rowIndex);
				//alert("Edit " + rec.get('firstname'));
				//}
			},
			{
				header: '删除',
				xtype: 'actioncolumn',
				width: 50,
				icon: 'resources/images/icons/application_form_delete.png',  // Use a URL in the icon config
				iconCls: 'icon-delete',
				tooltip: 'delete'//,
				//handler: function(grid, rowIndex, colIndex) {
				//var rec = grid.getStore().getAt(rowIndex);
				//alert("Edit " + rec.get('ModelName'));
				//}
			}
*/		];
		this.callParent(arguments);
	}

});
