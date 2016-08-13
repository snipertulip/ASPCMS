Ext.define('CMS.model.Article',{
	extend: 'Ext.data.Model',
	fields: [
		'ID', 'Title', 'Summary', 'Content', 'ADDDatetime', 'MODDatetime', 'SortIndex', 'Category'
	]
//	,idProperty: 'UserID'
});

/*
ID - 自动编号
Title - 标题
Summary - 摘要
Content - 内容
ADDDatetime - 添加时间
MODDatetime - 修改时间
SortIndex - 排序
*/