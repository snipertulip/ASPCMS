Ext.define('WebManager.view.message.List', {
	extend: 'Ext.grid.Panel',
	alias: 'widget.gridlist',
	id: 'gridlist',

	store: 'Message',

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
			itemId: 'editMessage',
			xtype: 'button',
			text: '修改',
			action: 'edit',
			iconCls: 'btn-edit',
			disabled: true
		},
		{
			itemId: 'removeMessage',
			xtype: 'button',
			text: '删除',
			action: 'destroy',
			iconCls: 'btn-delete',
			disabled: true
		}

	],

    bbar: {
        xtype: 'pagingtoolbar',
        store: 'Message',
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
			{header: '昵称/姓名', dataIndex: 'Fullname'},
			{header: '反馈', dataIndex: 'Title', width: 400},
			{header: '回复', dataIndex: 'Reply', width: 400},
			{header: '修改时间', dataIndex: 'MODDatetime', width: 140},
			{header: '排序', dataIndex: 'SortIndex'}
		];
		this.callParent(arguments);
	}

});
