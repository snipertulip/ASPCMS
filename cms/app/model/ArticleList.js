Ext.define('CMS.model.ArticleList',{
	extend: 'Ext.data.Model',
	fields: [
		'ID', 'Title', 'Summary', 'Content', 'Attachment', 'Source', 'Author', 'Label', 'ExternalLinks', 'ADDDatetime', 'MODDatetime', 'SortIndex', 'Category'
	]
});

/*
ID,
Title,
Summary,
Content,
Attachment,
Source,
Author,
Label,
ExternalLinks,
ADDDatetime,
MODDatetime,
SortIndex,
Category
*/