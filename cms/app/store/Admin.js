Ext.define('CMS.store.Admin', {
	extend: 'Ext.data.Store',
	model: 'CMS.model.Admin',

	autoLoad: true,
	pageSize: 16,

	proxy: {
		type: 'ajax',
		headers: {
			'Content-Type': 'application/json; charset=utf-8'
		},
		api: {
			read: 'data/Admin.asp?action=read',
			update: 'data/Admin.asp?action=update',
			create: 'data/Admin.asp?action=create',
			destroy: 'data/Admin.asp?action=destroy'
		},
		reader: {
			type: 'json',
			root: 'data',
			totalProperty: 'total',
			successProperty: 'success'
		}
	}
});