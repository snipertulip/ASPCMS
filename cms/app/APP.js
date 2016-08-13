Ext.define('CMS.APP', {
    extend: 'Ext.app.Application',
    id: 'CMS',
    name: 'CMS',

    controllers: ['APP'],
	
	autoCreateViewport: false,

//    constructor: function(config) {
//		
//        var me = this;
//
//        Ext.apply(me, config);
//
//        me.callParent(arguments);
//
//        Ext.direct.Manager.addProvider(Ext.app.REMOTING_API);
//		
//    },

    onBeforeLaunch: function() {
        CMS.App = this;

        this.launch.call(this.scope || this);
        this.launched = true;
        this.fireEvent('launch', this);

        this.controllers.each(function(controller) {
            controller.onLaunch(this);
        },
        this);

    },

    launch: function() {
		this.getView('Login').create().show();
//        this.getView('Viewport').create();
    }

});