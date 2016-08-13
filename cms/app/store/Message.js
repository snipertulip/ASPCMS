Ext.define('CMS.store.Message', {
	extend: 'Ext.data.Store',
	model: 'CMS.model.Message',

	autoLoad: true,
	pageSize: 16,

	proxy: {
		type: 'ajax',
		headers: {
			'Content-Type': 'application/json; charset=utf-8'
		},
		api: {
			read: 'data/Message.asp?action=read',
			update: 'data/Message.asp?action=update',
			create: 'data/Message.asp?action=create',
			destroy: 'data/Message.asp?action=destroy'
		},
		reader: {
			type: 'json',
			root: 'data',
			totalProperty: 'total',
			successProperty: 'success'
		},
		extraParams:{category: 0}
	}
});