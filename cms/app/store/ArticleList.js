Ext.define('CMS.store.ArticleList', {
	extend: 'Ext.data.Store',
	model: 'CMS.model.ArticleList',

	autoLoad: true,
	pageSize: 16,

	proxy: {
		type: 'ajax',
		headers: {
			'Content-Type': 'application/json; charset=utf-8'
		},
		api: {
			read: 'data/ArticleList.asp?action=read',
			update: 'data/ArticleList.asp?action=update',
			create: 'data/ArticleList.asp?action=create',
			destroy: 'data/ArticleList.asp?action=destroy'
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