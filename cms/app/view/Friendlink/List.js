Ext.define('WebManager.view.friendlink.List', {
	extend: 'Ext.grid.Panel',
	alias: 'widget.gridlist',
	id: 'gridlist',

	store: 'Friendlink',

	title: '管理员',

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
			itemId: 'editFriendlink',
			xtype: 'button',
			text: '修改',
			action: 'edit',
			iconCls: 'btn-edit',
			disabled: true
		},
		{
			itemId: 'removeFriendlink',
			xtype: 'button',
			text: '删除',
			action: 'destroy',
			iconCls: 'btn-delete',
			disabled: true
		}

	],

    bbar: {
        xtype: 'pagingtoolbar',
        store: 'Friendlink',
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
			{header: '标题', dataIndex: 'Title', width: 200},
			{header: '地址', dataIndex: 'Href', width: 400},
			{header: '修改时间', dataIndex: 'MODDatetime', width: 140},
			{header: '排序', dataIndex: 'SortIndex'}
		];
		this.callParent(arguments);
	}

});
