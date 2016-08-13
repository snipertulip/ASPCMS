Ext.define('CMS.store.Product', {
	extend: 'Ext.data.Store',
	model: 'CMS.model.Product',

	autoLoad: true,
	pageSize: 16,

	proxy: {
		type: 'ajax',
		headers: {
			'Content-Type': 'application/json; charset=utf-8'
		},
		api: {
			read: 'data/Product.asp?action=read',
			update: 'data/Product.asp?action=update',
			create: 'data/Product.asp?action=create',
			destroy: 'data/Product.asp?action=destroy',
			move: 'data/Product.asp?action=move',
			moveall: 'data/Product.asp?action=moveall'
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