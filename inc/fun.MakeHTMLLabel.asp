<%
'---------------------------------------------------------------------------------------------------------------------
'MakeHTMLLabel(true,"img","id$sniper#",vbNullString)
'MakeHTMLLabel(false,"label","id$sniper#","sniper")
'---------------------------------------------------------------------------------------------------------------------
'property's spec:{[property's name$property's value[#]]}
	Private Function MakeHTMLLabel(ByVal singleLabel,ByVal label,ByVal property,ByVal content)
		singleLabel=CBool(singleLabel)
		Dim template,temp : template=vbNullString : temp=vbNullString
		Const startTemplate="<#label#property>",endTemplate="#content</#label>"
		'-----------------------------------------------------------------------------------------------------------------
		property=Split(property,"#")
		Dim i : i=i Xor i
		Do While i<=UBound(property)
			temp=Split(property(i),"$")
			If property(i)<>vbNullString Then
				template=template & Space(1) & temp(0) & "=" & Chr(34) & temp(1) & Chr(34)
			End If
			i=i+1
		Loop
		If singleLabel Then
			template=Replace(startTemplate,"#property",template)
			template=Replace(template,"#label",label)
		Else
			template=Replace(startTemplate,"#property",template)
			template=Replace(template,"#label",label)
			template=template & endTemplate
			template=Replace(template,"#label",label)
			template=Replace(template,"#content",content)
		End If
		MakeHTMLLabel=template' & vbCrLf
		Exit Function
	End Function
'---------------------------------------------------------------------------------------------------------------------
%>