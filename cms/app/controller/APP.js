Ext.define('CMS.controller.APP', {
    extend: 'Ext.app.Controller',

    views: ['Login'
	, 'Viewport'
	],

    stores: ['MenuTree'],

    init: function() {

        this.control({
            'viewport > applicationlist': {
                itemdblclick: this.showUpdatePanel
            },
            'applicationedit button[action=update]': {
                click: this.updateData
            },
            'viewport > applicationlist button[action=create]': {
                click: this.showCreatePanel
            },
            'applicationcreate button[action=create]': {
                click: this.createData
            },
            'viewport > applicationlist button[action=destroy]': {
                click: this.destroyData
            },
            'viewport > applicationlist button[action=query]': {
                click: this.queryData
            },
            'viewport > applicationlist button[action=queryAll]': {
                click: this.queryAll
            },
            'Login': {
                close: this.createViewport
            }
        });

    },
    createViewport: function() {
        		this.getView('Viewport').create();
    },
    queryAll: function(button) {
        var form = button.up('#queryContainer').getForm();
        form.reset();
        var grid = Ext.widget('applicationlist');
        var store = grid.getStore();
        store.proxy.extraParams = {
            keywords: ''
        };
        store.load();
    },
    queryData: function(button) {

        var form = button.up('#queryContainer').getForm();

        if (!form.isValid()) {
            return false;
        }
        //		var keywords = Ext.urlEncode(button.up('#queryContainer').down('#username').getValue());
        var keywords = button.up('#queryContainer').down('#title').getValue();
        var grid = Ext.widget('applicationlist');
        var store = grid.getStore();
        store.proxy.setExtraParam('keywords', keywords);
        grid.down('pagingtoolbar').moveFirst();

        //		store.on('beforeload', function(thiz,options) {
        //			Ext.apply(thiz.baseParams,{keywords: 0});
        //			//这个也行
        //			//gridStore.baseParams["comboValue"]=Ext.getCmp("input").getValue()
        //		});
        ////		gridStore.reload({params:{start:0,limit:20,comboValue:Ext.getCmp("input").getValue()}});
        store.load();

    },
    destroyData: function(button) {
        if (!confirm('确认删除吗？')) {
            return false;
        }
        var grid = Ext.widget('applicationlist');
        var store = grid.getStore();
        //		store.remove(button.up('grid').selModel.lastSelected);
        store.remove(button.up('grid').getSelectionModel().getSelection());
        //		这种方法多页时不能删除
        //		var index = button.up('grid').selModel.lastSelected.index;
        //		store.removeAt(index);
        store.sync({
            success: function(batch, option) {
                //				alert(this.getReader().rawData.msg);
                var applicationList = Ext.widget('applicationlist');
                applicationList.getStore().load();
            },
            failure: function(batch, option) {
                alert(this.getReader().rawData.msg);
                var applicationList = Ext.widget('applicationlist');
                applicationList.getStore().load();
            }
        });
    },
    showCreatePanel: function(button) {
        if (Ext.getCmp('applicationcreate')) return;
        var view = Ext.widget('applicationcreate'),
        form = view.down('form');
        var model = new Ext.create(this.getModel('APP'));
        form.loadRecord(model);
    },
    createData: function(button) {
        var win = button.up('window'),
        form = win.down('form');
        if (!form.form.isValid()) {
            return false;
        }
        record = form.getRecord(),
        values = form.getValues();
        record.set(values);
        win.close();

        //		var grid = Ext.getCmp('al');
        //		var pl = grid.getPlugin('rowexpander');
        //		pl.destroy();
        ////		grid.remove(pl);
        this.getAPPStore().insert(0, record);
        this.getAPPStore().sync({
            success: function(batch, option) {
                //				alert(this.getReader().rawData.msg);
                var applicationList = Ext.widget('applicationlist');
                //				applicationList.getStore().load();
            },
            failure: function(batch, option) {
                alert(this.getReader().rawData.msg);
                var applicationList = Ext.widget('applicationlist');
                applicationList.getStore().load();
            }

        });
    },
    showUpdatePanel: function(grid, record) {
        if (Ext.getCmp('applicationedit')) return;
        var view = Ext.widget('applicationedit');
        view.down('form').loadRecord(record);
    },
    updateData: function(button) {
        var win = button.up('window'),
        form = win.down('form');
        if (!form.form.isValid()) {
            return false;
        }
        record = form.getRecord();
        values = form.getValues();

        record.set(values);
        win.close();
        this.getAPPStore().sync({
            success: function(batch, option) {
                //				alert(this.getReader().rawData.msg);
            },
            failure: function(batch, option) {
                alert(this.getReader().rawData.msg);
                var applicationList = Ext.widget('applicationlist');
                //				applicationList.getStore().load();
            }

        });
    }
});