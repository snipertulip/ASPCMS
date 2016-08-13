Ext.define('Ext.ux.CKeditor', {
	extend: 'Ext.form.field.TextArea',
	alias: 'widget.ckeditor',
	initComponent: function() {
		this.callParent(arguments);
		this.on('afterrender', function() {
			Ext.apply(this.CKConfig, {
				height: this.getHeight()
			});

//			CKEDITOR.config.customConfig = 'myConfig.js';

			this.editor = CKEDITOR.replace(this.inputEl.id, this.CKConfig);
			CKFinder.setupCKEditor(this.editor, '../js/ckeditor/ckfinder/');
			this.editorId = this.editor.id;
		}, this)
	},
	onRender: function(ct, position) {
		if (!this.el) {
			this.defaultAutoCreate = {
				tag: 'textarea',
				autocomplete: 'off'
			}
		}
		this.callParent(arguments);
	},

	//    beforeDestroy: function () {
	//        var me = this,
	//            doc, prop;
	//
	//        if (me.rendered) {
	//            try {
	//                doc = me.getDoc();
	//                if (doc) {
	//                    Ext.EventManager.removeAll(doc);
	//                    for (prop in doc) {
	//                        if (doc.hasOwnProperty && doc.hasOwnProperty(prop)) {
	//                            delete doc[prop];
	//                        }
	//                    }
	//                }
	//            } catch(e) { }
	//        }
	//
	//        me.callParent();
	//    },

	setValue: function(value) {
		this.callParent(arguments);
		if (this.editor) {
			this.editor.setData(value);
		}
	},
	getRawValue: function() {
		if (this.editor) {
			return this.editor.getData();
		} else {
			return '';
		}
	}
});

CKEDITOR.on('instanceReady', function(e) {

		var id=e.editor.name;//////////这个就是
//	 var td = document.getElementById('cke_contents_' + e.editor.name);
//	 var tbody = td.parentNode.parentNode;
//	 
//	 var o = Ext.ComponentQuery.query('ckeditor[editorId="' + e.editor.id + '"]'), comp = o[0];
//	 
//	 td.style.height = (comp.getHeight() - (151 + (6 * 4)) - tbody.rows[0].offsetHeight - tbody.rows[2].offsetHeight) + 'px';
//	 td.style.height = '436px';
//	 

	//校正宽高
//	 
//	 var o = Ext.ComponentQuery.query('ckeditor[editorId="' + e.editor.id + '"]'), comp = o[0];
//	 e.editor.resize(comp.getWidth(), comp.getHeight());
//	 comp.on('resize', 
//	 function(c, adjWidth, adjHeight) {
//	 c.editor.resize(adjWidth, adjHeight);
//	 })
//	 
	e.editor.resize('100%', 600);
//	console.log(e.editor);

	e.editor.on('resize', function(c) {
		c.editor.resize('100%', 600);
	})
	
});

/*
 CKEDITOR.on('instanceReady', function(e) {
 
 var o = Ext.ComponentQuery.query('ckeditor[editorId="' + e.editor.id + '"]'),
 comp = o[0];
 e.editor.resize(comp.getWidth(), comp.getHeight())
 comp.on('resize', function(c, adjWidth, adjHeight) {
 c.editor.resize(adjWidth, adjHeight)
 
 })
 });
 */