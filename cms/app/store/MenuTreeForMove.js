Ext.define('CMS.store.MenuTreeForMove', {
	extend: 'Ext.data.Store',
	model: 'CMS.model.MenuTreeForMove',

	autoLoad: true,
	pageSize: 1,

	proxy: {
		type: 'ajax',
		headers: {
			'Content-Type': 'application/json; charset=utf-8'
		},
		api: {
			read: 'data/MenuTreeForMove.asp?action=read'
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