Ext.define('CMS.Article', {
	extend: 'Ext.app.Application',
	name: 'CMS',

	controllers: [
		'Article'
	],

	autoCreateViewport: false,


	onBeforeLaunch: function() {
		CMS.App = this;

		this.launch.call(this.scope || this);
		this.launched = true;
		this.fireEvent('launch', this);

		this.controllers.each(function(controller) {
			controller.onLaunch(this);
		}, this);

	},

	launch: function() {
/*		Ext.create('Ext.container.Viewport', {
			layout: 'fit',
			items: {
				padding: '5',
				xtype: 'gridlist'
			}
		});
*/	}
});
