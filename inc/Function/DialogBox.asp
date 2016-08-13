<%
'location.href 已被废弃
'location.replace 取代
'ver: 1.0.1
	Const FontS="<font size=""2"" color=""#FF0000"">"
	Const FontE="</font>"
	Const JS_S="<SCRIPT LANGUAGE=""JavaScript"">#</SCRIPT>"
	Const Alert_S="alert('#');"								'ID=1
	Const LHref_S="location.replace('#');"					'ID=2
	Const HBack_S="history.back();"							'ID=3
	Const PLReplace_S="parent.location.replace('#');"		'ID=4
	Const CHBack_S="if(!confirm('#')){##}"					'ID=1
	Const CLHref_S="if(confirm('#')){##1}else{##2}"			'ID=2		
	Const CYLHref_S="if(confirm('#')){##}"					'ID=3		
	Const CNLHref_S="if(!confirm('#')){##}"					'ID=4		
	Const ALERT_=1											'ID=1
	Const ALHREF=2											'ID=2
	Const AHBACK=3											'ID=3
	Const APLREPLACE=4										'ID=4
	Const CHBack=1											'ID=1
	Const CLHref=2											'ID=2		
	Const CYLHref=3											'ID=3		
	Const CNLHref=4											'ID=4		
	Private Sub Alert(ByVal ID,ByVal INFO,ByVal TargetFile)
		Rem WS-->WriteSentence
		Dim WS
		if replace(INFO," ","")="" then
			response.write FontS&"AlertFunction's second parameter can't be empty!"&FontE
			response.end
		end if
		select case ID
			case 1
				WS=Alert_S
			case 2
				WS=LHref_S
				WS=replace(WS,"#",TargetFile)
				WS=Alert_S & WS
				if replace(TargetFile," ","")="" then
					response.write FontS&"AlertFunction's third parameter can't be target Page!"&FontE
					response.end
				end if
			case 3
				WS=HBack_S
				WS=Alert_S & WS
			case 4
				WS=PLReplace_S
				WS=replace(WS,"#",TargetFile)
				WS=PLReplace_S & WS
				if replace(TargetFile," ","")="" then
					response.write FontS&"AlertFunction's third parameter can't be target Page!"&FontE
					response.end
				end if
		end select
		WS=replace(WS,"#",INFO)
		WS=replace(JS_S,"#",WS)
		response.write WS
		response.end
	End SUb
	Private Sub Confirm(ByVal ID,ByVal INFO,ByVal TargetFile)
		Rem WS-->WriteSentence
		Dim WS
		if replace(INFO," ","")="" then
			response.write FontS&"ConfirmFunction's second parameter can't be empty!"&FontE
			response.end
		end if
		select case ID
			case 1
				WS=replace(CHBack_S,"##",HBack_S)
			case 2
				TargetFile=split(TargetFile,"|")
				TargetFile(0)=replace(LHref_S,"#",TargetFile(0))
				TargetFile(1)=replace(LHref_S,"#",TargetFile(1))
				WS=replace(CLHref_S,"##1",TargetFile(0))
				WS=replace(WS,"##2",TargetFile(1))
			case 3
				TargetFile=replace(LHref_S,"#",TargetFile)
				WS=replace(CYLHref_S,"##",TargetFile)
			case 4
				TargetFile=replace(LHref_S,"#",TargetFile)
				WS=replace(CNLHref_S,"##",TargetFile)
		end select
		WS=replace(WS,"#",INFO)
		WS=replace(JS_S,"#",WS)
		response.write WS
		response.write server.htmlencode(WS)
	End SUb
%>