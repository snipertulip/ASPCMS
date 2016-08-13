Ext.define('CMS.store.Article', {	
	extend: 'Ext.data.Store',
	model: 'CMS.model.Article',

	autoLoad: false,
	pageSize: 16,

	proxy: {
		type: 'ajax',
		headers: {
			'Content-Type': 'application/json; charset=utf-8'
		},
		api: {
			read: 'data/Article.asp?action=read',
			update: 'data/Article.asp?action=update',
			create: 'data/Article.asp?action=create',
			destroy: 'data/Article.asp?action=destroy'
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