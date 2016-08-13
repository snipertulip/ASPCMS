Ext.define('CMS.controller.Product', {
	extend: 'Ext.app.Controller',

	requires: ['Ext.ux.UrlParameters'],

	views: ['product.List', 'product.Create'
			,'product.Edit'
	],

	stores: ['Product', 'MenuTreeForMove'],

	models: ['Product'],

	init: function() {

		this.getStore('Product').on({
			beforeload: function(store, operation, eOpts) {
				store.proxy.extraParams.category = Ext.ux.UrlParameters.getParameter('category');
			},
			scope: this
		});

		this.getStore('MenuTreeForMove').on({
			beforeload: function(store, operation, eOpts) {
				store.proxy.extraParams.category = Ext.ux.UrlParameters.getParameter('category');
			},
			scope: this
		});

		//		this.getStore('Product').load();

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
			'viewport > gridlist button[action=move]': {
				click: this._Move
			},
			'viewport > gridlist button[action=moveAll]': {
				click: this._MoveAll
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
			'createpanel #filename1': {
				change: this._UploadFile1
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
			'editpanel #filename1': {
				change: this._UploadFile1
			},
			'viewport > gridlist button[action=destroy]': {
				click: this._DestroyData
			}

		});

	},
	
	_Move: function(button){
		if (!confirm('确认需要转移数据吗？')) {
			return false;
		}

		var grid = Ext.getCmp('gridlist')
		var store = grid.getStore();

		var selectionModels = button.up('grid').getSelectionModel().getSelection();
		if(selectionModels.length == 0){
			alert('没有选择数据！');
			return;
		}

		var toCategory = grid.getDockedItems(toolbar[dock="top"])[1].getComponent('categoryTo').getValue();
		
		if(toCategory == null){
			alert('请选择目标分类！');
			return;
		}

		var obj = new Array();
		for (var i in selectionModels) 
		{ 
			obj.push(selectionModels[i].getData());
		}

		store.remove(button.up('grid').getSelectionModel().getSelection());

		Ext.Ajax.request({
			url: Ext.getStore('Product').proxy.api.move,
			dataType: 'json',
			jsonData: Ext.encode(obj),
			params: {
				toCategory: toCategory
			},
			success: function(response, opts) {
				var obj = Ext.decode(response.responseText);
				Ext.getCmp('gridlist').getStore().reload();
			},
			failure: function(response, opts) {
				Ext.getCmp('gridlist').getStore().load();
				//console.log('server-side failure with status code ' + response.status);
			}
		});

	},
	
	_MoveAll: function(button){
		if (!confirm('确认需要转移数据吗？')) {
			return false;
		}

		var grid = Ext.getCmp('gridlist')
		var store = grid.getStore();

		var toCategory = grid.getDockedItems(toolbar[dock="top"])[1].getComponent('categoryTo').getValue();
		
		if(toCategory == null){
			alert('请选择目标分类！');
			return;
		}

		store.removeAll();

		Ext.Ajax.request({
			url: Ext.getStore('Product').proxy.api.moveall,
			dataType: 'json',
			params: {
				toCategory: toCategory,
				Category: Ext.ux.UrlParameters.getParameter('category')
			},
			success: function(response, opts) {
				var obj = Ext.decode(response.responseText);
				Ext.getCmp('gridlist').getStore().reload();
			},
			failure: function(response, opts) {
				Ext.getCmp('gridlist').getStore().load();
				//console.log('server-side failure with status code ' + response.status);
			}
		});

	},
	
	_fuckckeditorrender: function(me){
		//console.log(me.getHeight( ))
	},

	_UploadFile1: function(fileuploadfile, value, opt) {
		var panel = Ext.getCmp('createpanel') ? Ext.getCmp('createpanel') : Ext.getCmp('editpanel') ;
		var form = panel.getComponent('form');
		var formFile = panel.getComponent('formFile1');

		formFile.getForm().submit({
			url: 'data/UploadFile1.asp?category=' + Ext.ux.UrlParameters.getParameter('category'),
			waitMsg: '文件上传中...',
			success: function(fp, o) {
				Ext.Msg.alert('上传', '"' + o.result.file + '" 上传成功！');
				form.getForm().setValues({
					Attachment1: o.result.file
				});
			},
			failure: function(fp, o) {
				Ext.Msg.alert('上传', '"' + o.result.msg + '"');
			}
		});

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
				//				var productList = Ext.widget('gridlist');
				//				productList.getStore().load();
				Ext.getCmp('gridlist').getStore().load();
			},
			failure: function(batch, option) {
				alert(this.getReader().rawData.msg);
				//				var productList = Ext.widget('gridlist');
				//				productList.getStore().load();
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
		if(typeof(values.Recommend) === 'undefined'){
			record.set({Recommend: false});
		}
		win.close();
		this.getProductStore().sync({
				success: function(batch, option) {
					//				alert(this.getReader().rawData.msg);
					Ext.getCmp('gridlist').getStore().load();
				},
				failure: function(batch, option) {
					alert(this.getReader().rawData.msg);
					//				var productList = Ext.widget('gridlist');
					//				productList.getStore().load();
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
		var record = new Ext.create(this.getModel('Product'));
		record.set(form.getValues());
		if(typeof(record.getData().Recommend) === 'undefined' || record.getData().Recommend==''){
			record.set({Recommend: false});
		}

		win.close();
		this.getProductStore().insert(0, record);
		this.getProductStore().sync({
				success: function(batch, option) {
					//alert(this.getReader().rawData.msg);
					//var productList = Ext.widget('gridlist');
					//productList.getStore().load();
					Ext.getCmp('gridlist').getStore().load();

				},
				failure: function(batch, option) {
					//alert(this.getReader().rawData.msg);
					Ext.Msg.alert('警告', this.getReader().rawData.msg);
					//				var productList = Ext.widget('gridlist');
					//				productList.getStore().load();
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
		Ext.getCmp('gridlist').down('#removeProduct').setDisabled(!records.length);
		Ext.getCmp('gridlist').down('#editProduct').setDisabled(records.length === 1 ? false : true);
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