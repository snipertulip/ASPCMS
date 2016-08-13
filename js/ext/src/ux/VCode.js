Ext.define('Ext.ux.VCode', {
	
    extend: 'Ext.form.field.Text',

    alias: 'widget.uxvcodefield',

    alternateClassName: ['Ext.ux.VCodeField', 'Ext.ux.VCode'],
	
	inputType: 'vcodefield',
	
	codeUrl: Ext.BLANK_IMAGE_URL,
	
	isLoader: true,

    initComponent: function () {
        var me = this;
        me.callParent();
	},
	
	onRender: function(ct, position){
	
		var me = this;
		
		me.callParent(arguments);
		
		//me.codeEl = ct.createChild({tag: 'img', src: Ext.BLANK_IMAGE_URL});
		
		//(me.inputEl.parent('tr')).createChild({tag: 'td'});
		
		me.codeEl = ((me.inputEl.parent('tr')).createChild({tag: 'td'})).createChild({tag: 'img', src: Ext.BLANK_IMAGE_URL});
		
		this.codeEl.addCls('x-form-vcode'); 

		this.codeEl.on('click', this.loadCodeImg, this);
		
		if (this.isLoader) this.loadCodeImg(); 
		
	},
	
	alignErrorIcon: function(){
		
		this.errorIcon.alignTo(this.codeEl, 'tl-tr', [2, 0]); 
		
	},
	
	loadCodeImg: function() { 
	
		this.codeEl.set({ src: this.codeUrl + '?id=' + Math.random() });
	
	},
			
    afterRender: function(){
//        var me = this;
//        me.callParent(arguments);
//
////		me.inputEl.setWidth(60);
////		me.autosize
////		me.inputEl.removeCls('x-form-field x-form-text');
//		
//		me.inputEl.setWidth(60);
//		
//		console.log(me.inputEl.dom);
//
//		me.setWidth(150);
//
//		
//		me.updateLayout();
//
//
////		me.setVisible(false);
    }
	
});



