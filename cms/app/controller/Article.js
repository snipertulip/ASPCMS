Ext.define('CMS.controller.Article', {
	extend: 'Ext.app.Controller',

	requires: ['Ext.ux.UrlParameters'],

	views: [
		//'article.List',
		'article.Create',
		'article.Edit'
	],

	stores: ['Article'],

	models: ['Article'],

	init: function() {
		
		this.getStore('Article').on({
			beforeload: function( store, operation, eOpts ){
				store.proxy.extraParams.category = Ext.ux.UrlParameters.getParameter('category');
			},
			
			load: function( me, records, successful, eOpts){
				if(records.length < 1){
					this._ShowCreatePanel();
				}else{
					this._ShowUpdatePanel(records[0]);
				}
			},
			scope: this
		});
		
		this.getStore('Article').load();

		this.control({
			'createpanel button[action=create]': {
				click: this._CreateData
			},
			'editpanel button[action=update]': {
				click: this._UpdateData
			}

		});

	},

	_CreateData: function(button) {
		var form = button.up('form')
			if(!form.form.isValid()){
				return false;
			};

		var record = new Ext.create(this.getModel('Article'));
		record.set(form.getValues());
		
		this.getArticleStore().insert(0, record);
		this.getArticleStore().sync({
			success: function(batch, option){
				//alert(this.getReader().rawData.msg);
				window.location.href=window.location.href;

			}
			,failure: function(batch, option){
				Ext.Msg.alert('警告', this.getReader().rawData.msg);
			}

		});
    },
	
	_ShowCreatePanel: function(button) {
		if (Ext.getCmp('createpanel')) return;
		Ext.widget('createpanel');
		
	},
	
	_UpdateData: function(button) {
		var form = button.up('form')
			if(!form.form.isValid()){
				return false;
			};
			record = form.getRecord();
			values = form.getValues();
		record.set(values);

		this.getArticleStore().sync({
			success: function(batch, option){
				alert(this.getReader().rawData.msg);
				Ext.getStore('Article').load({
					scope: this,
					callback: function(records, operation, success) {
						var view = Ext.getCmp('editpanel');
						view.loadRecord(records[0]);
					}
				});
			}
			,failure: function(batch, option){
				alert(this.getReader().rawData.msg);
			}
		});
	},

	_ShowUpdatePanel: function(record) {
		if (Ext.getCmp('editpanel')) return;
		var view = Ext.widget('editpanel');
		view.loadRecord(record);
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
//				var articleList = Ext.widget('gridlist');
//				articleList.getStore().load();
				Ext.getCmp('gridlist').getStore().load();
			}
			,failure: function(batch, option){
				alert(this.getReader().rawData.msg);
//				var articleList = Ext.widget('gridlist');
//				articleList.getStore().load();
				Ext.getCmp('gridlist').getStore().load();
			}
		});
	},

	_DataRefresh: function() {
		Ext.getCmp('gridlist').getStore().load();
	},

	_SelectionChange: function(view, records) {
		Ext.getCmp('gridlist').down('#removeArticle').setDisabled(!records.length);
		Ext.getCmp('gridlist').down('#editArticle').setDisabled(records.length === 1 ? false : true);
	},

	_ShowUpdatePanelByBtn: function() {

		if (Ext.getCmp('editpanel')) return;
		var view = Ext.widget('editpanel');
		view.down('form').loadRecord(Ext.getCmp('gridlist').getSelectionModel().getSelection()[0]);
	}

});