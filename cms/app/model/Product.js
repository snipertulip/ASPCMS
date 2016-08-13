Ext.define('CMS.model.Product',{
	extend: 'Ext.data.Model',
	fields: [
		'ID', 'Title', 'Summary', 'Content', 'Attachment', 'Attachment1', 'Source', 'Label', 'ExternalLinks', 'Recommend', 'ADDDatetime', 'MODDatetime', 'SortIndex', 'Category'
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