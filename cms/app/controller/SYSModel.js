Ext.define('CMS.controller.SYSModel', {
	extend: 'Ext.app.Controller',

	views: ['sysmodel.List', 'sysmodel.Edit', 'sysmodel.Create'],

	stores: ['SYSModel'],

	models: ['SYSModel'],

	init: function() {
		

		this.control({
			'createpanel button[action=create]': {
				click: this._CreateData
			},
			'editpanel button[action=update]': {
				click: this._UpdateData
			},
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
			'viewport > gridlist button[action=edit]': {
				click: this._ShowUpdatePanelByBtn
			},
			'viewport > gridlist button[action=destroy]': {
				click: this._DestroyData
			},
			//			'viewport > gridlist button[action=query]': {
			//				click: this._DueryData
			//			},
			//			'viewport > gridlist button[action=queryAll]': {
			//				click: this._QueryAll
			//			},
			'viewport > gridlist actioncolumn': {
				click: this._OnAction
			}

		});

	},

	_OnAction: function(view, cell, row, col, e) {

		var m = e.getTarget().className.match(/\bicon-(\w+)\b/);

		var rec = this.getStore('SYSModel').getAt(row);

		if (m) {
			switch (m[1]) {
			case 'edit':
				this._ShowUpdatePanel(view, rec)
				break;
			case 'delete':
				this._DestroyDataByCursor(row)
				break;
			}
		}

	},

	_DestroyData: function(button) {
		if (!confirm('确认删除已选数据吗？')) {
			return false;
		}

		var grid = Ext.getCmp('gridlist')
		var store = grid.getStore();

		store.remove(grid.getSelectionModel().getSelection());

		store.sync({
			success: function(batch, option) {
				Ext.getCmp('gridlist').getStore().load();
			},
			failure: function(batch, option) {
				alert(this.getReader().rawData.msg);
				Ext.getCmp('gridlist').getStore().load();
			}
		});
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
	},

	_DataRefresh: function() {
		Ext.getCmp('gridlist').getStore().load();
	},

	_SelectionChange: function(view, records) {

		Ext.getCmp('gridlist').down('#removeMenuTree').setDisabled(!records.length);
		Ext.getCmp('gridlist').down('#editMenuTree').setDisabled(records.length === 1 ? false : true);
	},

	_DestroyDataByCursor: function(row) {
		if (!confirm('确认删除吗？')) {
			return false;
		}
		var grid = Ext.getCmp('gridlist')
		var store = grid.getStore();

		store.removeAt(row);

		store.sync({
			success: function(batch, option) {
				Ext.getCmp('gridlist').getStore().load();
			},
			failure: function(batch, option) {
				alert(this.getReader().rawData.msg);
				Ext.getCmp('gridlist').getStore().load();
			}
		});
	},

	_ShowCreatePanel: function(button) {
		if (Ext.getCmp('createpanel')) return;
		Ext.widget('createpanel');
	},

	_CreateData: function(button) {
		var win = button.up('window'),
			form = win.down('form');
		if (!form.form.isValid()) {
				return false;
			};

		var record = new Ext.create(this.getModel('SYSModel'));
		record.set(form.getValues());

		win.close();

		this.getSYSModelStore().insert(0, record);
		this.getSYSModelStore().sync({
				success: function(batch, option) {
					Ext.getCmp('gridlist').getStore().load();

				},
				failure: function(batch, option) {
					alert(this.getReader().rawData.msg);
					Ext.getCmp('gridlist').getStore().load();
				}

			});
	},

	_UpdateData: function(button) {
		var win = button.up('window'),
			form = win.down('form');
		if (!form.form.isValid()) {
				return false;
			};
		record = form.getRecord();
		values = form.getValues();
		record.set(values);
		win.close();
		this.getSYSModelStore().sync({
				success: function(batch, option) {
					Ext.getCmp('gridlist').getStore().load();
				},
				failure: function(batch, option) {
					alert(this.getReader().rawData.msg);
					Ext.getCmp('gridlist').getStore().load();

				}

			});
	}
});