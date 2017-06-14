#SingleInstance Force
Gui, Add, Edit, x2 y9 w200 h210 vText, DuckyScript here
Gui, Add, Button, x200 y9 w60 h30 , &Encode
Gui, Add, Edit, x260 y9 w200 h210 +ReadOnly vOutput
Gui, Show, Center h400 w500, New GUI Window
Return

ButtonEncode:
	Gui, Submit, NoHide
	Out := ""
	A:= Text
	B:=""
	Loop, parse, A, `n, `r
	{
		if(A_LoopField != ""){
			StringSplit, Ar, A_LoopField, %A_Space%
			StringLower, com, Ar1
			if(com=="delay"){
				Out:= Out "03 "
				temp:= FHex(Ar2,4)
				StringSplit, tar, temp
				temp:= tar1 tar2 " " tar3 tar4
				Out:= Out temp " "
				
			}else if(com=="string"){
				Out:= Out "04 "
				temp:= SubStr(A_LoopField,8)
				Loop, Parse, temp
				{
					Out:= Out FHex(asc(A_LoopField)) " "
				}
				Out:= Out "00 "
				
			}else if(com=="rem"){
			
			}else if(com=="replay"){
				Out:= Out "06 "
				temp:= FHex(Ar2)
				Out:= Out temp " "
			}else if(com=="defaultdelay" or com=="default_delay"){
				Out:= Out "02 "
				temp:= FHex(Ar2,4)
				StringSplit, tar, temp
				temp:= tar1 tar2 " " tar3 tar4
				Out:= Out temp " "
			}else{
				Out:= Out "05 "
				temp:= A_LoopField
				temp:=rplace(temp)
				Loop, Parse, temp
				{
					Out:= Out FHex(asc(A_LoopField)) " "
				}
				Out:= Out "00 "
			}
		}
		
	}
	Out:= Out "00"
	GuiControl,, Output, %Out%
	Gui, Submit, NoHide
return

GuiClose:
	ExitApp

FHex( int, pad=2 ) { ; Function by [VxE]. Formats an integer (decimals are truncated) as hex.

; "Pad" may be the minimum number of digits that should appear on the right of the "0x".

	Static hx := "0123456789ABCDEF"

	If !( 0 < int |= 0 )

		Return !int ? "0x0" : "-" FHex( -int, pad )

	s := 1 + Floor( Ln( int ) / Ln( 16 ) )

	h := SubStr( "0x0000000000000000", 1, pad := pad < s ? s + 2 : pad < 16 ? pad + 2 : 18 )

	u := A_IsUnicode = 1

	Loop % s

		NumPut( *( &hx + ( ( int & 15 ) << u ) ), h, pad - A_Index << u, "UChar" ), int >>= 4
	
	h:= SubStr(h,3)
	Return h

}
rp(S,SText,RText){
	temp:=chr(RText)
	StringReplace,Out,S, %SText% ,%temp%,A
	return Out
}

rps(S,SText,RText){
	StringReplace,Out,S, %SText% ,%RText%,A
	return Out
}
rplace(S){
	O:=S
	O:=rps(O," ","")
	O:=rp(O,"GUI",131)
	O:=rp(O,"WINDOWS",131)
	O:=rp(O,"MENU",93)
	O:=rp(O,"APP",93)
	O:=rp(O,"SHIFT",129)
	O:=rp(O,"ALT",130)
	O:=rp(O,"CTRL",128)
	O:=rp(O,"CONTROL",128)
	O:=rp(O,"DOWNARROW",217)
	O:=rp(O,"DOWN",217)
	O:=rp(O,"LEFTARROW",216)
	O:=rp(O,"LEFT",216)
	O:=rp(O,"RIGHTARROW",215)
	O:=rp(O,"RIGHT",215)
	O:=rp(O,"UPARROW",218)
	O:=rp(O,"UP",218)
	O:=rp(O,"CAPSLOCK",193)
	O:=rp(O,"DELETE",212)
	O:=rp(O,"END",213)
	O:=rp(O,"ESC",177)
	O:=rp(O,"ESCAPE",177)
	O:=rp(O,"HOME",210)
	O:=rp(O,"INSERT",209)
	O:=rp(O,"PAGEUP",211)
	O:=rp(O,"PAGEDOWN",214)
	O:=rp(O,"PRINTSCREEN",206)
	O:=rps(O,"SPACE"," ")
	O:=rp(O,"TAB",179)
	O:=rp(O,"ENTER",176)
	O:=rp(O,"F10",203)
	O:=rp(O,"F11",204)
	O:=rp(O,"F12",205)
	O:=rp(O,"F1",194)
	O:=rp(O,"F2",195)
	O:=rp(O,"F3",196)
	O:=rp(O,"F4",197)
	O:=rp(O,"F5",198)
	O:=rp(O,"F6",199)
	O:=rp(O,"F7",200)
	O:=rp(O,"F8",201)
	O:=rp(O,"F9",202)
	return O
}
;04 68 69 20 74 68 65 72 65 21 21 00 01