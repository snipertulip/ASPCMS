<%
'--------------------------------------------------------------------------------------------------------------------------------------------------
Function BinaryToString(Binary) 
'Antonin Foller, http://www.pstruh.cz 
'Optimized version of a simple BinaryToString algorithm. 

	Dim cl1, cl2, cl3, pl1, pl2, pl3 
	Dim L 
	cl1 = 1 
	cl2 = 1 
	cl3 = 1 
	L = LenB(Binary) 
	
	Do While cl1<=L 
		pl3 = pl3 & Chr(AscB(MidB(Binary,cl1,1))) 
		cl1 = cl1 + 1 
		cl3 = cl3 + 1 
		If cl3>300 Then 
			pl2 = pl2 & pl3 
			pl3 = "" 
			cl3 = 1 
			cl2 = cl2 + 1 
			If cl2>200 Then 
				pl1 = pl1 & pl2 
				pl2 = "" 
				cl2 = 1 
			End If 
		End If 
	Loop 
	BinaryToString = pl1 & pl2 & pl3 
End Function 

'--------------------------------------------------------------------------------------------------------------------------------------------------
Function RSBinaryToString(xBinary)
  'Antonin Foller, http://www.motobit.com
  'RSBinaryToString converts binary data (VT_UI1 | VT_ARRAY Or MultiByte string)
  'to a string (BSTR) using ADO recordset

  Dim Binary
  'MultiByte data must be converted To VT_UI1 | VT_ARRAY first.
  If vartype(xBinary)=8 Then Binary = MultiByteToBinary(xBinary) Else Binary = xBinary
  
  Dim RS, LBinary
  Const adLongVarChar = 201
  Set RS = CreateObject("ADODB.Recordset")
  LBinary = LenB(Binary)
  
  If LBinary>0 Then
    RS.Fields.Append "mBinary", adLongVarChar, LBinary
    RS.Open
    RS.AddNew
      RS("mBinary").AppendChunk Binary 
    RS.Update
    RSBinaryToString = RS("mBinary")
  Else
    RSBinaryToString = ""
  End If
End Function

Function MultiByteToBinary(MultiByte)
  '© 2000 Antonin Foller, http://www.motobit.com
  ' MultiByteToBinary converts multibyte string To real binary data (VT_UI1 | VT_ARRAY)
  ' Using recordset
  Dim RS, LMultiByte, Binary
  Const adLongVarBinary = 205
  Set RS = CreateObject("ADODB.Recordset")
  LMultiByte = LenB(MultiByte)
  If LMultiByte>0 Then
    RS.Fields.Append "mBinary", adLongVarBinary, LMultiByte
    RS.Open
    RS.AddNew
      RS("mBinary").AppendChunk MultiByte & ChrB(0)
    RS.Update
    Binary = RS("mBinary").GetChunk(LMultiByte)
  End If
  MultiByteToBinary = Binary
End Function

'--------------------------------------------------------------------------------------------------------------------------------------------------
Function Stream_BinaryToString(Binary, CharSet)
  Const adTypeText = 2
  Const adTypeBinary = 1
  
  'Create Stream object
  Dim BinaryStream 'As New Stream
  Set BinaryStream = CreateObject("ADODB.Stream")
  
  'Specify stream type - we want To save text/string data.
  BinaryStream.Type = adTypeBinary
  
  'Open the stream And write text/string data To the object
  BinaryStream.Open
  BinaryStream.Write Binary
  
  
  'Change stream type To binary
  BinaryStream.Position = 0
  BinaryStream.Type = adTypeText
  
  'Specify charset For the source text (unicode) data.
  If Len(CharSet) > 0 Then
    BinaryStream.CharSet = CharSet
  Else
    BinaryStream.CharSet = "us-ascii"
  End If
  
  'Open the stream And get binary data from the object
  Stream_BinaryToString = BinaryStream.ReadText
End Function
%>