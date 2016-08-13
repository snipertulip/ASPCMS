Ext.define('CMS.store.Friendlink', {
	extend: 'Ext.data.Store',
	model: 'CMS.model.Friendlink',

	autoLoad: true,
	pageSize: 16,

	proxy: {
		type: 'ajax',
		headers: {
			'Content-Type': 'application/json; charset=utf-8'
		},
		api: {
			read: 'data/Friendlink.asp?action=read',
			update: 'data/Friendlink.asp?action=update',
			create: 'data/Friendlink.asp?action=create',
			destroy: 'data/Friendlink.asp?action=destroy'
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