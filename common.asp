<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<%
'================================================================================================================================
'Versions: 3.0
'Updated Date: 2013-04-21
'================================================================================================================================
Option Explicit
Server.ScriptTimeOut = 999
Response.Buffer = True
Response.ContentType = "text/html"
'Response.ContentType = "application/json"
Response.CodePage = 65001
Response.CharSet = "utf-8"
Session.CodePage = 65001
Session.LCID = 2052'Chinsese

ON ERROR RESUME NEXT
'Const Open_Debug_Switch = true
Const Open_Debug_Switch = false

Dim CONFIG : Set CONFIG = Server.CreateObject("Scripting.Dictionary")
CONFIG.Add "SiteName", "宿迁市中邦智能科技有限公司"
CONFIG.Add "Keywords", "中邦，中邦智能，监控，网站，企业管理软件，弱电，宿迁监控，宿迁网络布线，熔纤，宿迁熔纤，周界报警，宿迁周界报警，宿迁门禁考勤，电脑维护"
CONFIG.Add "Description", "宿迁市中邦智能科技有限公司主要从事智能系统弱电，公共安全防范领域内的网络电视监控系统、周界防护系统、门禁系统、巡更系统、住宅小区智能化、银行、商场、工矿企事业单位的重要部门、个人家庭防盗报警以及智能家庭等项目的设计、施工、安装、调试和售后服务工作。"
CONFIG.Add "Author", "Feva"
CONFIG.Add "SiteUrl", "http:\\www.sq900.com"

Const Attachments_Path = "/attachments/"'文件上传路径
Const AccessFile = "/db/database.mdb"'定义数据库链接文件,根据自己的情况修改
Dim conn, rst, sqlStr'定义数据库连接
Dim ra : ra = 0'获取无返回记录命令执行影响的数据行数 备注：用于更新数据时判断是否实行成功

'列表生成器使用
Dim il_iniItems '列表类
Dim il_template '模板
Dim il_counts '条数
Dim il_table '表名
Dim il_category '分类
Dim il_showlink '显示地址

Dim comm
Set comm = Server.Createobject("ADODB.COMMAND") 

Set conn = Server.CreateObject("ADODB.connection")
conn.connectionString="Provider=Microsoft.Jet.OLEDB.4.0;Data Source=" & Server.MapPath(AccessFile)
conn.Open
If Err Then
	If Open_Debug_Switch Then
		Response.Write("<meta http-equiv=""Content-Type"" content=""text/html; charset=utf-8"" /><div style=""font-size:12px;font-weight:bold;border:1px solid #006;padding:6px;background:#fcc"">")
		Response.Write(Err.Description)
		Response.Write("</div>")
	Else
		Response.Redirect("/error.html")
	End If
	Err.Clear
	Set conn = Nothing
	Response.End
End If

%>