Ext.define('CMS.view.menutree.List', {
	extend: 'Ext.tree.Panel',
	alias: 'widget.gridlist',
	id: 'gridlist',

	store: 'MenuTree',

	title: '菜单',

	rootVisible: false,
//	singleExpand:true,
	
	tbar: [
/*	{
		xtype: 'button',
		text: '刷新',
		action: 'refresh',
		iconCls: 'btn-refresh'
	},
	'-',
*/	{
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

//	selModel: Ext.create('Ext.selection.CheckboxModel'),

	initComponent: function() {

		this.columns = [
		{header: '系统编号', dataIndex: 'id'},
		{
			xtype: 'treecolumn',
			header: '控制菜单',
			dataIndex: 'text'
		},
		{
			header: '模型',
			dataIndex: 'ModelName'
		},
		{
			header: '模板地址',
			dataIndex: 'ModelURL'
		},
		{
			header: '排序编号',
			dataIndex: 'SortIndex'
		}];

		this.callParent(arguments);
	}

});