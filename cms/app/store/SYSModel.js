Ext.define('CMS.store.SYSModel', {
    extend: 'Ext.data.Store',
	model: 'CMS.model.SYSModel',

	autoLoad: true,
	
	pageSize: 1,
    proxy: {
        type: 'ajax',
		headers: { 'Content-Type': 'application/json; charset=utf-8'},
		api: {
			read: 'data/SYSModel.asp?action=read',
			update: 'data/SYSModel.asp?action=update',
			create  : 'data/SYSModel.asp?action=create',
			destroy : 'data/SYSModel.asp?action=destroy'
		},
		reader: {
			type: 'json',
			root: 'data',
			totalProperty: 'total',
			successProperty: 'success'
		}
    }
});