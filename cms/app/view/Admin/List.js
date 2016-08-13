Ext.define('WebManager.view.sysmodel.List', {
	extend: 'Ext.grid.Panel',
	alias: 'widget.gridlist',
	id: 'gridlist',

	store: 'Admin',

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
			itemId: 'editAdmin',
			xtype: 'button',
			text: '修改',
			action: 'edit',
			iconCls: 'btn-edit',
			disabled: true
		},
		{
			itemId: 'removeAdmin',
			xtype: 'button',
			text: '删除',
			action: 'destroy',
			iconCls: 'btn-delete',
			disabled: true
		}

	],

    bbar: {
        xtype: 'pagingtoolbar',
        store: 'Admin',
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
			{header: '系统编号', dataIndex: 'UserID'},
			{header: '用户名', dataIndex: 'Username'},
			{header: '最后一次登录时间', dataIndex: 'LastLoginDatetime'},
			{header: '排序', dataIndex: 'SortIndex'}
		];
		this.callParent(arguments);
	}

});
