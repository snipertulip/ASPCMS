Ext.define('CMS.model.Admin',{
	extend: 'Ext.data.Model',
	fields: [
		'UserID', 'Username', 'Password', 'LastLoginDatetime', 'SortIndex'
	]
	,idProperty: 'UserID'
});

/*
UserID
Username
Password
LastLoginDatetime
SortIndex
*/