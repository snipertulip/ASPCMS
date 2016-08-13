Ext.define('WebManager.view.product.List', {
	extend: 'Ext.grid.Panel',
	alias: 'widget.gridlist',
	id: 'gridlist',

	store: 'Product',

	title: '列表',

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
			itemId: 'editProduct',
			xtype: 'button',
			text: '修改',
			action: 'edit',
			iconCls: 'btn-edit',
			disabled: true
		},
		{
			itemId: 'removeProduct',
			xtype: 'button',
			text: '删除',
			action: 'destroy',
			iconCls: 'btn-delete',
			disabled: true
		},
		'-'
		,{
			xtype: 'label',
			text: '转移数据到：'
		}
		,{
			itemId: 'categoryTo',
			xtype: 'combo',
			text: '类别：',
			store: 'MenuTreeForMove',
			displayField: 'text',
			valueField: 'id',
			editable: false
		},
		{
			itemId: 'moveProduct',
			xtype: 'button',
			text: '转移已选',
			action: 'move',
			iconCls: 'btn-move'
		},
		{
			itemId: 'moveAllProduct',
			xtype: 'button',
			text: '转移全部',
			action: 'moveAll',
			iconCls: 'btn-move'
		}

	],

    bbar: {
        xtype: 'pagingtoolbar',
        store: 'Product',
        displayInfo: true
        //		displayMsg: 'Displaying topics {0} - {1} of {2}',
        //		emptyMsg: "No topics to display",
//        items: [
//            '-', 
//        ]
    },
	selModel: Ext.create('Ext.selection.CheckboxModel'),

	initComponent: function () {
		this.columns = [
			{header: '系统编号', dataIndex: 'ID'},
			{header: '标题', dataIndex: 'Title', width: 400},
			{header: '来源', dataIndex: 'Source'},
//			{header: '作者', dataIndex: 'Author'},
			{header: '修改时间', dataIndex: 'MODDatetime', width: 140},
			{header: '排序', dataIndex: 'SortIndex'}
		];
		this.callParent(arguments);
	}

});
