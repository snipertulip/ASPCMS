<%
Function file_get_contents(filename)
  Dim fso, f
  Set fso = Server.CreateObject("Scripting.FilesystemObject")
    Set f = fso.OpenTextFile(Server.MapPath(filename), 1)
      file_get_contents = f.ReadAll
      f.Close
    Set f = Nothing
  Set fso = Nothing
End Function

function ReadFile(File)
	Dim st
	Set st=Server.CreateObject("ADODB.Stream")
	st.Type=2
	st.Mode=3
	st.Charset="utf-8"
	st.Open()
	st.LoadFromFile Server.MapPath(File)
	ReadFile = st.ReadText
	st.Close()
	Set st=Nothing
End function

Function class_get_contents(filename)
	Dim contents
	contents = ReadFile(filename)
	contents = Replace(contents, "<" & "%", "")
	contents = Replace(contents, "%" & ">", "")
	class_get_contents = contents
End Function
%>