Ext.define('CMS.controller.MenuTree', {
	extend: 'Ext.app.Controller',

	views: ['menutree.List', 'menutree.Edit', 'menutree.Create'],

	stores: ['MenuTree', 'SYSModel'],

	models: ['MenuTree'],

	init: function() {

		this.getStore('MenuTree').on('load', function(store, node) {
			Ext.each(node.childNodes, function (item, index, allItems) {
				if(!item.isLoaded() && !item.isLeaf()) {
					store.load({node: item});
				}
			});
		});

		this.control({
			'viewport > gridlist button[action=destroy]': {
				click: this._DestroyData
			},
			'editpanel button[action=update]': {
				click: this._UpdateData
			},
			'viewport > gridlist': {
				itemdblclick: this._ShowUpdatePanel,
				selectionchange: this._SelectionChange
			},
			'viewport > gridlist button[action=create]': {
				click: this._ShowCreatePanel
			},
			'createpanel button[action=create]': {
				click: this._CreateData
			},
			'viewport > gridlist button[action=edit]': {
				click: this._ShowUpdatePanelByBtn
			}
			/*,
			 'viewport > gridlist button[action=refresh]': {
			 click: this._DataRefresh
			 }*/

		});

	},
	
	_UpdateData: function(button) {
		
		var win = button.up('window'),
			form = win.down('form');
		if (!form.form.isValid()) {
				return false;
			};
		values = form.getValues();
		win.close();
		
		var grid = Ext.getCmp('gridlist')
		var store = grid.getStore('MenuTree');
		var selectedModels = grid.getSelectionModel().getSelection();
		

		var object_data = {		
			MenuID : values.id,
			ParentID : values.ParentID,
			ModelID : values.ModelID,
			MenuName : values.text,
			Expanded : values.expanded,
			Leaf : values.leaf,
			SortIndex : values.SortIndex
		};
		
		if(typeof(object_data.Expanded) === 'undefined'){
			object_data.Expanded = false;
		}
		if(typeof(object_data.Leaf) === 'undefined'){
			object_data.Leaf = false;
		}
		
		Ext.Ajax.request({
			url: grid.getStore().getProxy().api['update'],
			jsonData: object_data,
			success: function(batch, option) {
				Ext.getCmp('gridlist').getStore().load({
					node: selectedModels[0].parentNode,
					//读取当前节点  
					callback: function() {
						Ext.getCmp('gridlist').getView().refresh(); //刷新树视图！ 
					}
				});
			},
			failure: function(batch, option) {
				alert(this.getReader().rawData.msg);
				Ext.getCmp('gridlist').getStore().reload();
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

	/*	_DataRefresh: function(button){
	 
	 Ext.getCmp('gridlist').getStore().load({  
	 node : Ext.getCmp('gridlist').getStore().getRootNode() ,//读取当前节点  
	 callback : function() {  
	 Ext.getCmp('gridlist').getView().refresh();//刷新树视图！  
	 }  
	 });
	 
	 },
	 */
	_CreateData: function(button) {
		var win = button.up('window'),
			form = win.down('form');
		if (!form.form.isValid()) {
				return false;
			};

		//		var record = new Ext.create(this.getModel('MenuTree'));
		//		record.set(form.getValues());

		record = form.getValues();

		if(typeof(record.Expanded) === 'undefined'){
			record.Expanded = false;
		}
		if(typeof(record.Leaf) === 'undefined'){
			record.Leaf = false;
		}
		
		win.close();

		var grid = Ext.getCmp('gridlist')
		var store = grid.getStore('MenuTree');
		var selectedModels = grid.getSelectionModel().getSelection();

		//没有选择,0
		if (selectedModels[0]) {
				//子节点，退出
				if (store.getNodeById(selectedModels[0].internalId).isLeaf()) {
					alert('不能为子节点添加节点！');
					return;
				} else {
					//文件夹，获取ParentID
					//record.set('ParentID', selectedModels[0].getId());

					record.ParentID = selectedModels[0].getData().id;

					Ext.Ajax.request({
						url: grid.getStore().getProxy().api['create'],
						jsonData: record,
						success: function(batch, option) {
							Ext.getCmp('gridlist').getStore().load({
								node: selectedModels[0],
								//读取当前节点  
								callback: function() {
									Ext.getCmp('gridlist').getView().refresh(); //刷新树视图！  
								}
							});
						},
						failure: function(batch, option) {
							alert(this.getReader().rawData.msg);
							Ext.getCmp('gridlist').getStore().reload();
						}
					});

				}

			} else {
				//添加至root
				record.ParentID = 1

				Ext.Ajax.request({
					url: grid.getStore().getProxy().api['create'],
					jsonData: record,
					success: function(batch, option) {
						Ext.getCmp('gridlist').getStore().load({
							node: store.getRootNode(),
							//读取当前节点  
							callback: function() {
								Ext.getCmp('gridlist').getView().refresh(); //刷新树视图！  
							}
						});
					},
					failure: function(batch, option) {
						alert(this.getReader().rawData.msg);
						Ext.getCmp('gridlist').getStore().reload();
					}
				});
			}
	},

	_ShowCreatePanel: function(button) {
		if (Ext.getCmp('createpanel')) return;
		Ext.widget('createpanel');
	},

	_SelectionChange: function(view, records) {

		Ext.getCmp('gridlist').down('#removeMenuTree').setDisabled(!records.length);
		Ext.getCmp('gridlist').down('#editMenuTree').setDisabled(records.length === 1 ? false : true);
	},

	_DestroyData: function(button) {

		var grid = Ext.getCmp('gridlist')
		var store = grid.getStore('MenuTree');
		var selectedModels = grid.getSelectionModel().getSelection();

		if (!store.getNodeById(selectedModels[0].internalId).hasChildNodes()) {

			if (!confirm('确认删除吗？')) {
				return false;
			}
			/*
			 selectedModels[0].internalId === selectedModels[0].getData().id
			 selectedModels[0] === store.getNodeById(selectedModels[0].getData().id)
			 */
			selectedModels[0].remove();

			Ext.Ajax.request({
				url: grid.getStore().getProxy().api['destroy'],
				jsonData: selectedModels[0].raw,
				success: function(batch, option) {
					//Ext.getCmp('gridlist').getStore().reload();	删除无需reload();
				},
				failure: function(batch, option) {
					alert(this.getReader().rawData.msg);
					Ext.getCmp('gridlist').getStore().reload();
				}
			});

		} else {
			//console.log();
			alert('对不起，该节点包含子节点！');
		}
	}

});