<%@ language="VBScript" @codepage=65001%>
<%
  Option Explicit
response.charset="utf-8"
  Const lngMaxFormBytes = 200

  Dim objASPError, blnErrorWritten, strServername, strServerIP, strRemoteIP
  Dim strMethod, lngPos, datNow, strQueryString, strURL

  If Response.Buffer Then
    Response.Clear
    Response.Status = "500 Internal Server Error"
    Response.ContentType = "text/html"
	Response.Charset = "utf-8"
    Response.Expires = 0
  End If

  Set objASPError = Server.GetLastError
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd">
<HTML><HEAD><TITLE>无法显示此页</TITLE>
<META HTTP-EQUIV="Content-Type" Content="text/html; charset=utf-8">
<STYLE type="text/css">
  BODY { font: 9pt/12pt 宋体 }
  H1 { font: 12pt/15pt 宋体 }
  H2 { font: 9pt/12pt 宋体 }
  A:link { color: red }
  A:visited { color: maroon }
</STYLE>
</HEAD><BODY><TABLE width=500 border=0 cellspacing=10><TR><TD>

<h1>无法显示此页</h1>
您要访问的页面存在问题，因此无法显示。
<hr>
<p>请尝试以下操作：</p>
<ul>
<li>请与网站管理员联系，通知他们此 URL 地址出现了该错误。</li>  
</ul>
<h2>HTTP 500.100 - 内部服务器错误：ASP 错误。<br>Internet 信息服务</h2>  
<hr>
<p>技术信息（为技术支持人员提供）</p>
<ul>
<li>错误类型：<br> <%
  Dim bakCodepage
  on error resume next
	bakCodepage = Session.Codepage
	Session.Codepage = 1252
	Session.Codepage = 65001
  on error goto 0
  Response.Write Server.HTMLEncode(objASPError.Category)
  If objASPError.ASPCode > "" Then Response.Write Server.HTMLEncode(", " & objASPError.ASPCode)
    Response.Write Server.HTMLEncode(" (0x" & Hex(objASPError.Number) & ")" ) & "<br>"
  If objASPError.ASPDescription > "" Then 
	Response.Write Server.HTMLEncode(objASPError.ASPDescription) & "<br>"
  elseIf (objASPError.Description > "") Then 
	Response.Write Server.HTMLEncode(objASPError.Description) & "<br>" 
  end if
  blnErrorWritten = False
  ' Only show the Source if it is available and the request is from the same machine as IIS
  If objASPError.Source > "" Then
    strServername = LCase(Request.ServerVariables("SERVER_NAME"))
    strServerIP = Request.ServerVariables("LOCAL_ADDR")
    strRemoteIP =  Request.ServerVariables("REMOTE_ADDR")
    If (strServerIP = strRemoteIP) And objASPError.File <> "?" Then
      Response.Write Server.HTMLEncode(objASPError.File)
      If objASPError.Line > 0 Then Response.Write ", line " & objASPError.Line
      If objASPError.Column > 0 Then Response.Write ", column " & objASPError.Column
      Response.Write "<br>"
      Response.Write "<font style=""COLOR:000000; FONT: 8pt/11pt courier new""><b>"
      Response.Write Server.HTMLEncode(objASPError.Source) & "<br>"
      If objASPError.Column > 0 Then Response.Write String((objASPError.Column - 1), "-") & "^<br>"
      Response.Write "</b></font>"
      blnErrorWritten = True
    End If
  End If
  If Not blnErrorWritten And objASPError.File <> "?" Then
    Response.Write "<b>" & Server.HTMLEncode(  objASPError.File)
    If objASPError.Line > 0 Then Response.Write Server.HTMLEncode(", line " & objASPError.Line)
    If objASPError.Column > 0 Then Response.Write ", column " & objASPError.Column
    Response.Write "</b><br>"
  End If
%>
</li>
<li>浏览器类型：<br> <%= Server.HTMLEncode(Request.ServerVariables("HTTP_USER_AGENT")) %> <br><br></li>
<li>页面：<br> <%
  strMethod = Request.ServerVariables("REQUEST_METHOD")
  Response.Write strMethod & " "
  If strMethod = "POST" Then
    Response.Write Request.TotalBytes & " bytes to "
  End If
  Response.Write Request.ServerVariables("SCRIPT_NAME")
  Response.Write "</li>"
  If strMethod = "POST" Then
    Response.Write "<p><li>POST Data:<br>"
    ' On Error in case Request.BinaryRead was executed in the page that triggered the error.
    On Error Resume Next
    If Request.TotalBytes > lngMaxFormBytes Then
      Response.Write Server.HTMLEncode(Left(Request.Form, lngMaxFormBytes)) & " . . ."
    Else
      Response.Write Server.HTMLEncode(Request.Form)
    End If
    On Error Goto 0
    Response.Write "</li>"
  End If
%> <br><br></li>
<li>时间：<br> <%
  datNow = Now()
  Response.Write Server.HTMLEncode(FormatDateTime(datNow, 1) & ", " & FormatDateTime(datNow, 3))
  on error resume next
	Session.Codepage = bakCodepage 
  on error goto 0
%> <br><br></li>
<li>详细信息：<br> <%  
  strQueryString = "prd=iis&sbp=&pver=5.0&ID=500;100&cat=" & Server.URLEncode(objASPError.Category) & "&os=&over=&hrd=&Opt1=" & Server.URLEncode(objASPError.ASPCode)  & "&Opt2=" & Server.URLEncode(objASPError.Number) & "&Opt3=" & Server.URLEncode(objASPError.Description) 
  strURL = "http://www.microsoft.com/ContentRedirect.asp?" & strQueryString
%>
  <ul>
<li>单击 <a href="<%= strURL %>">Microsoft 支持</a>获得指向关于该错误的文章的链接。</li>  
<li>转到 <a href="http://go.microsoft.com/fwlink/?linkid=8180" target="_blank">Microsoft 产品支持服务</a>并搜索包括&ldquo;HTTP&rdquo;和&ldquo;500&rdquo;的标题。</li> 
<li>打开&ldquo;IIS 帮助&rdquo;文档（位于 IIS 6.0 的 IIS 管理器 (inetmgr) 中），然后搜索标题为&ldquo;网站管理&rdquo;和&ldquo;关于自定义错误消息&rdquo;的主题。</li>  
<li>在 IIS 软件开发工具包 (SDK) 或 <a href="http://go.microsoft.com/fwlink/?LinkId=8181">MSDN 
  </a> <a href="http://go.microsoft.com/fwlink/?LinkId=8181">Online Library</a> 
  中，搜索标题为&ldquo;Debugging ASP Scripts&rdquo;、&ldquo;Debugging Components&rdquo;和&ldquo;Debugging ISAPI Extensions and Filters&rdquo;的主题。</li> 
  </ul>
</li>
</ul>

</TD></TR></TABLE></BODY></HTML>