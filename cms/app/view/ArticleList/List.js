Ext.define('WebManager.view.articlelist.List', {
	extend: 'Ext.grid.Panel',
	alias: 'widget.gridlist',
	id: 'gridlist',

	store: 'ArticleList',

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
			itemId: 'editArticleList',
			xtype: 'button',
			text: '修改',
			action: 'edit',
			iconCls: 'btn-edit',
			disabled: true
		},
		{
			itemId: 'removeArticleList',
			xtype: 'button',
			text: '删除',
			action: 'destroy',
			iconCls: 'btn-delete',
			disabled: true
		}

	],

    bbar: {
        xtype: 'pagingtoolbar',
        store: 'ArticleList',
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
			{header: '作者', dataIndex: 'Author'},
			{header: '修改时间', dataIndex: 'MODDatetime', width: 140},
			{header: '排序', dataIndex: 'SortIndex'}
		];
		this.callParent(arguments);
	}

});
