Ext.define('Ext.ux.UrlParameters', {

    alias: 'widget.urlparameters',
	
	singleton: true,

	config: {
		href: window.location.search.substring(1),
		parameters: null
	},

    constructor: function(config) {
		this.initConfig(config);
		this.config.parameters = this.getParameters(this.config.href);
    },
	
	getParameters: function(href){
		return Ext.urlDecode(href);
	},

	getParameter: function(param){
		return(eval('this.config.parameters.' + param));
	}
});
