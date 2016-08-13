Ext.define('CMS.store.MenuTree', {
	extend: 'Ext.data.TreeStore',
	model: 'CMS.model.MenuTree',

	autoLoad: true,

//	clearOnLoad: false,
//	clearRemovedOnLoad: false,
	defaultRootId: 1,
	defaultRootText : '/',

	pageSize: 1,
	proxy: {
		type: 'ajax',
		headers: {
			'Content-Type': 'application/json; charset=utf-8'
		},
		api: {
			read: 'data/MenuTree.asp?action=read',
			update: 'data/MenuTree.asp?action=update',
			create: 'data/MenuTree.asp?action=create',
			destroy: 'data/MenuTree.asp?action=destroy'
		},
		reader: {
			type: 'json',
			root: 'data',
			totalProperty: 'total',
			successProperty: 'success'
		}
	}
	
	
});