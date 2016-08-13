Ext.define('CMS.view.Viewport', {
	extend: 'Ext.container.Viewport',
	alias: 'widget.Viewport',
	requires: ['Ext.ux.IFrame'],

	id: 'Viewport',
	layout: {
		type: 'border'
	},

	items: [
		{
			region: 'north',
			height: 46,
			border: false,
			items: [
				{
					layout: 'hbox',
					defaults: {
						border: false
					},
					bodyCls: 'appHeaderBG',
					items: [
						{
							xtype: 'panel',
							width: 200,
							height: 46,
							bodyCls: 'appHeaderTitle appHeaderBG'
						},
						{
							xtype: 'panel',
							layout: 'hbox',
							height: 46,
							bodyCls: 'appHeaderBG',
							items: [
								{
									xtype: 'button',
									margin: '12 0 0 16',
									text: '控制台首页',
									handler: function () {
										(Ext.getCmp('myiframe')).load('welcome.asp');
									}
								},
								{
									xtype: 'button',
									margin: '12 0 0 16',
									text: '帮助文档',
									handler: function () {
										(Ext.getCmp('myiframe')).load('welcome_chm.asp');
									}
								},
								{
									xtype: 'button',
									margin: '12 0 0 16',
									text: '安全退出',
									handler: function () {
										location.replace("data/loginOut.asp");
									}
								}
							]
						}
					]
				}
			]
		},
		{
			region: 'west',
			collapsible: true,
			title: '控制菜单',
			split: true,
			width: 200,
			minWidth: 100,
			minHeight: 140,
			layout: 'fit',
			items: [
				{
					xtype: 'treepanel',
					flex: 1,
					border: false,
					store: 'MenuTree',
					animate: false,
					rootVisible: false,
					useArrows:true,
					listeners: {
						itemclick: function (view, record, item, index, e) {
							if (record.data.leaf && (e.type != 'dblclick') && (record.data.ModelURL.toString() != '')) {
								var _url = record.data.ModelURL.toString();
								if(_url == '#') return;

								_url = record.data.ModelURL.toString() + '?category=' + record.data.id.toString();
								if (Ext.getCmp('myiframe').src != _url) {
									Ext.getCmp('myiframe').load(_url)
								}
							}
						}
					}
				}
			]
		},
		{
			region: 'center',
			id: 'center-container',
			layout: {
				type: 'fit',
				padding: 0
			},
			border: false,
			minWidth: 800,
			items: [
				{
					id: 'container',
					xtype: 'container',
					layout: 'card',
					items: [
						{
							id: 'myiframe',
							xtype: 'uxiframe',
							border: 1,
							style: {
								borderColor: '#99BCE8',
								borderStyle: 'solid',
								backgroundColor: '#fff'
							},
							src: 'welcome.asp'
						}
					]
				}
			]
		}/*,
		 {
		 region: 'south',
		 id: 'copyright-container',
		 height: 24,
		 bodyCls: 'copyright',
		 border: false,
		 layout: {
		 type: 'border',
		 padding: 5
		 },
		 html: 'Copyright © 2013 Zhang Weidong! Individual. All rights reserved. Technical support: SI NUO TECH., TEL: 15189050194.'
		 }*/
	]
});