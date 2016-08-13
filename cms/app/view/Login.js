Ext.define('CMS.view.Login', {
    extend: 'Ext.window.Window',
    alias: 'widget.Login',
    requires: ['Ext.ux.VCode', 'Ext.ux.UrlParameters'],

    id: 'Login',
    title: '用户登录',
    headerPosition: 'right',
    bodyPadding: 15,
    closable: false,
    draggable: false,
    resizable: false,

    listeners: {
        render: function(ct, option) {
            Ext.EventManager.onWindowResize(function(w, h) {
                ct.center();
            });
        }
    },

    items: [{
        xtype: 'form',
        defaults: {
            border: 0,
            labelAlign: 'right'
        },

        listeners: {
            afterrender: function(ct, option) {
				if(!Ext.util.Cookies.get('User'))return;
				var cookiesUserConllection = (Ext.util.Cookies.get('User')).split("&");
				var cookiesUserArray, cookiesUser = cookiesUser ? cookiesUser : {};
				for(var item in cookiesUserConllection){
					cookiesUserArray = cookiesUserConllection[item].split("=");
					eval('cookiesUser.' + cookiesUserArray[0] + '="' + cookiesUserArray[1] + '"');
				}

                ct.getForm().setValues({username: cookiesUser.username, password: cookiesUser.password, keeponline:cookiesUser.keeponline, isKeeponline: 1});

            }
        },

        items: [{
            xtype: 'textfield',
            name: 'username',
            fieldLabel: '用户名',
            allowBlank: false,
            blankText: '请输入用户名！',
            minLength: 2,
            listeners: {
                afterrender: function(The, eOpts) {
                    this.focus(false, 500);
                },
                specialkey: function(field, e) {
                    if (e.getKey() == Ext.EventObject.ENTER) {
                        if (this.isValid()) {
                            this.ownerCt.getForm().findField('password').focus();
                        }
                    }
                }
            }
        },
		{
            xtype: 'textfield',
            name: 'password',
            fieldLabel: '密码',
            inputType: 'password',
            allowBlank: false,
            blankText: '请输入密码！',
            minLength: 2,
            listeners: {
                specialkey: function(field, e) {
                    if (e.getKey() == Ext.EventObject.ENTER) {
                        if (this.isValid()) {
                            this.ownerCt.getForm().findField('vcode').focus();
                        }
                    }
                }
            }
        },
        {
            xtype: 'uxvcodefield',
            name: 'vcode',
            fieldLabel: '验证码',
            allowBlank: false,
            maxLength: 4,
            minLength: 4,
            codeUrl: '../js/vCode/GetCode.asp',
            listeners: {
                specialkey: function(field, e) {
                    if (e.getKey() == Ext.EventObject.ENTER) {
                        if (this.isValid()) {
                            this.ownerCt.formSubmit();
                        }
                    }
                }
            }
        },
        {
            xtype: 'hiddenfield',
            name: 'isKeeponline',
			inputValue: 0
        },
		{
			xtype: 'radiogroup',
			fieldLabel: '记住密码',
            name: 'keeponlineGroup',
			columns: 3,
			items: [
				{ boxLabel: '1天', name: 'keeponline', inputValue: '1' },
				{ boxLabel: '1周', name: 'keeponline', inputValue: '7'},
				{ boxLabel: '1月', name: 'keeponline', inputValue: '30' },
			]
		}],
        buttons: [{
            text: '登陆',
            id: 'btnSubmit',
            formBind: true,
            handler: function(button, e) {
                this.up('form').formSubmit();
            }
        },
        {
            text: '重置',
            id: 'btnReset',
            handler: function(button, e) {
                this.up('form').getForm().reset();
            }
        }],
        formSubmit: function() {
            this.getForm().submit({
                url: 'data/login.asp',
                submitEmptyText: false,
                waitMsg: '正在登录……',
                success: function(form, action) {
                    Ext.Msg.alert(Ext.getCmp('Login').title, action.result.msg,
                    function() {
                        //location.replace('application.html');
                        //this.close();
                        Ext.getCmp('Login').close();
                    });
                },
                failure: function(form, action) {
                    switch (action.failureType) {
                    case Ext.form.action.Action.CLIENT_INVALID:
                        //Ext.Msg.alert('CLIENT_INVALID', 'Form fields may not be submitted with invalid values');
                        Ext.Msg.alert(Ext.getCmp('Login').title, '请输入登录信息！');
                        break;
                    case Ext.form.action.Action.CONNECT_FAILURE:
                        Ext.Msg.alert('CONNECT_FAILURE', 'Ajax communication failed');
                        break;
                    case Ext.form.action.Action.LOAD_FAILURE:
                        Ext.Msg.alert('LOAD_FAILURE', 'LOAD_FAILURE');
                        break;
                    case Ext.form.action.Action.SERVER_INVALID:
                        //Ext.Msg.alert('SERVER_INVALID', action.result.msg);
                        Ext.Msg.alert(Ext.getCmp('Login').title, action.result.msg);
                    }
                },
                scope: this
            });
        }
    }]
});