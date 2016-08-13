Ext.define('CMS.model.MenuTree', {
	extend: 'Ext.data.TreeModel',
	fields: [
		{ name: 'id', type:'int', mapping: 'MenuID'},
		{ name: 'text', type:'string', mapping: 'MenuName'},
		'ParentID',  'ModelID',  'Style',  'FormConfig', 'FormExtral',  'Image',  'URLParameters',
		{ name: 'expanded', type:'boolean', mapping: 'Expanded'},
		{ name: 'leaf', type:'boolean', mapping: 'Leaf'},
		'Remark',  'SortIndex',  'ModelName',  'ModelURL',  'ModelRemark'
	]
});
/*
 'MenuID',  'MenuName',  'ParentID',  'ModelID',  'Style',  'FormConfig',  'FormExtral',  'Image',  'URLParameters',  'Expanded',  'Leaf',  'Remark',  'SortIndex',  'ModelName',  'ModelURL',  'ModelRemark'
 */

