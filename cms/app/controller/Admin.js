Ext.define('CMS.controller.Admin', {
	extend: 'Ext.app.Controller',

	views: ['admin.List',
		'admin.Create',
		'admin.Edit'
	],

	stores: ['Admin'],

	models: ['Admin'],

	init: function() {


		this.control({
			'viewport > gridlist': {
				itemdblclick: this._ShowUpdatePanel,
				selectionchange: this._SelectionChange
			},
			'viewport > gridlist button[action=refresh]': {
				click: this._DataRefresh
			},
			'viewport > gridlist button[action=create]': {
				click: this._ShowCreatePanel
			},
			'createpanel button[action=create]': {
				click: this._CreateData
			},
			'viewport > gridlist button[action=edit]': {
				click: this._ShowUpdatePanelByBtn
			},
			'editpanel button[action=update]': {
				click: this._UpdateData
			},
			'viewport > gridlist button[action=destroy]': {
				click: this._DestroyData
			}

		});

	},

	_DestroyData: function(button){
		if(!confirm('确认删除吗？')){
			return false;	
		}
//		var grid = Ext.widget('gridlist');
//		var store = grid.getStore();
		
		var grid = Ext.getCmp('gridlist')
		var store = grid.getStore();
		
//		store.remove(button.up('grid').selModel.lastSelected);
		store.remove(button.up('grid').getSelectionModel().getSelection());
//		这种方法多页时不能删除
//		var index = button.up('grid').selModel.lastSelected.index;
//		store.removeAt(index);

		store.sync({
			success: function(batch, option){
//				alert(this.getReader().rawData.msg);
//				var adminList = Ext.widget('gridlist');
//				adminList.getStore().load();
				Ext.getCmp('gridlist').getStore().load();
			}
			,failure: function(batch, option){
				alert(this.getReader().rawData.msg);
//				var adminList = Ext.widget('gridlist');
//				adminList.getStore().load();
				Ext.getCmp('gridlist').getStore().load();
			}
		});
	},
	
	_UpdateData: function(button) {
		var win    = button.up('window'),
			form   = win.down('form');
			if(!form.form.isValid()){
				return false;
			};
			record = form.getRecord();
			values = form.getValues();
		record.set(values);
		win.close();
		this.getAdminStore().sync({
			success: function(batch, option){
//				alert(this.getReader().rawData.msg);
				Ext.getCmp('gridlist').getStore().load();
			}
			,failure: function(batch, option){
				alert(this.getReader().rawData.msg);
//				var adminList = Ext.widget('gridlist');
//				adminList.getStore().load();
				Ext.getCmp('gridlist').getStore().load();
				
			}

		});
	},

	_CreateData: function(button) {
		var win = button.up('window'),
			form = win.down('form');
			if(!form.form.isValid()){
				return false;
			};
//			record = form.getRecord(),
//			values = form.getValues();
//		record.set(values);
		var record = new Ext.create(this.getModel('Admin'));
		record.set(form.getValues());
		
		win.close();
		this.getAdminStore().insert(0, record);
		this.getAdminStore().sync({
			success: function(batch, option){
				//alert(this.getReader().rawData.msg);
				//var adminList = Ext.widget('gridlist');
				//adminList.getStore().load();
				Ext.getCmp('gridlist').getStore().load();
				
			}
			,failure: function(batch, option){
				//alert(this.getReader().rawData.msg);
				Ext.Msg.alert('警告', this.getReader().rawData.msg);
//				var adminList = Ext.widget('gridlist');
//				adminList.getStore().load();
				Ext.getCmp('gridlist').getStore().load();
			}

		});
    },
	
	_ShowCreatePanel: function(button) {
		if (Ext.getCmp('createpanel')) return;
		Ext.widget('createpanel');
	},

	_DataRefresh: function() {
		Ext.getCmp('gridlist').getStore().load();
	},

	_SelectionChange: function(view, records) {
		Ext.getCmp('gridlist').down('#removeAdmin').setDisabled(!records.length);
		Ext.getCmp('gridlist').down('#editAdmin').setDisabled(records.length === 1 ? false : true);
	},

	_ShowUpdatePanelByBtn: function() {

		if (Ext.getCmp('editpanel')) return;
		var view = Ext.widget('editpanel');
		view.down('form').loadRecord(Ext.getCmp('gridlist').getSelectionModel().getSelection()[0]);
	},

	_ShowUpdatePanel: function(grid, record) {
		if (Ext.getCmp('editpanel')) return;
		var view = Ext.widget('editpanel');
		view.down('form').loadRecord(record);
	}

});