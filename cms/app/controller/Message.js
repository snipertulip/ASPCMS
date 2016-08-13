Ext.define('CMS.controller.Message', {
	extend: 'Ext.app.Controller',

	requires: ['Ext.ux.UrlParameters'],

	views: ['message.List', 'message.Create'
			,'message.Edit'
	],

	stores: ['Message'],

	models: ['Message'],

	init: function() {

		this.getStore('Message').on({
			beforeload: function(store, operation, eOpts) {
				store.proxy.extraParams.category = Ext.ux.UrlParameters.getParameter('category');
			},
			scope: this
		});

		//		this.getStore('Message').load();

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
			'createpanel #form': {
				afterrender: this._fuckckeditorrender
			},
			'createpanel #filename': {
				change: this._UploadFile
			},
			'viewport > gridlist button[action=edit]': {
				click: this._ShowUpdatePanelByBtn
			},
			'editpanel button[action=update]': {
				click: this._UpdateData
			},
			'editpanel #filename': {
				change: this._UploadFile
			},
			'viewport > gridlist button[action=destroy]': {
				click: this._DestroyData
			}

		});

	},
	
	_fuckckeditorrender: function(me){
		//console.log(me.getHeight( ))
	},

	_UploadFile: function(fileuploadfile, value, opt) {
		var panel = Ext.getCmp('createpanel') ? Ext.getCmp('createpanel') : Ext.getCmp('editpanel') ;
		var form = panel.getComponent('form');
		var formFile = panel.getComponent('formFile');

		formFile.getForm().submit({
			url: 'data/UploadFile.asp?category=' + Ext.ux.UrlParameters.getParameter('category'),
			waitMsg: '文件上传中...',
			success: function(fp, o) {
				Ext.Msg.alert('上传', '"' + o.result.file + '" 上传成功！');
				form.getForm().setValues({
					Attachment: o.result.file
				});
			},
			failure: function(fp, o) {
				Ext.Msg.alert('上传', '"' + o.result.msg + '"');
			}
		});

	},

	_DestroyData: function(button) {
		if (!confirm('确认删除吗？')) {
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
			success: function(batch, option) {
				//				alert(this.getReader().rawData.msg);
				//				var messageList = Ext.widget('gridlist');
				//				messageList.getStore().load();
				Ext.getCmp('gridlist').getStore().load();
			},
			failure: function(batch, option) {
				alert(this.getReader().rawData.msg);
				//				var messageList = Ext.widget('gridlist');
				//				messageList.getStore().load();
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

		if(typeof(values.Public) === 'undefined'){
			record.set({Public: false});
		}
		
		win.close();
		this.getMessageStore().sync({
				success: function(batch, option) {
					//				alert(this.getReader().rawData.msg);
					Ext.getCmp('gridlist').getStore().load();
				},
				failure: function(batch, option) {
					alert(this.getReader().rawData.msg);
					//				var messageList = Ext.widget('gridlist');
					//				messageList.getStore().load();
					Ext.getCmp('gridlist').getStore().load();

				}

			});
	},

	_CreateData: function(button) {
		var win = button.up('window'),
			form = win.down('form');
		if (!form.form.isValid()) {
				return false;
			};
		//			record = form.getRecord(),
		//			values = form.getValues();
		//		record.set(values);
		var record = new Ext.create(this.getModel('Message'));
		record.set(form.getValues());

		if(typeof(record.getData().Public) === 'undefined' || record.getData().Public==''){
			record.set({Public: false});
		}

		win.close();
		this.getMessageStore().insert(0, record);
		this.getMessageStore().sync({
				success: function(batch, option) {
					//alert(this.getReader().rawData.msg);
					//var messageList = Ext.widget('gridlist');
					//messageList.getStore().load();
					Ext.getCmp('gridlist').getStore().load();

				},
				failure: function(batch, option) {
					//alert(this.getReader().rawData.msg);
					Ext.Msg.alert('警告', this.getReader().rawData.msg);
					//				var messageList = Ext.widget('gridlist');
					//				messageList.getStore().load();
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
		Ext.getCmp('gridlist').down('#removeMessage').setDisabled(!records.length);
		Ext.getCmp('gridlist').down('#editMessage').setDisabled(records.length === 1 ? false : true);
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