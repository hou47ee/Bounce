TITLE final project          
INCLUDE Irvine32.inc
main	EQU start@0
recHeight = 7
recWidth = 2
wwidth = 98
height = 29

.data
outputHandle DWORD 0
bytesWritten DWORD 0
outHandle DWORD 0
count DWORD 0
consoleInfo CONSOLE_SCREEN_BUFFER_INFO <>
windowsize COORD <100,30>
cellsWritten DWORD ?
; 開始畫面 標題設定
topic	BYTE 67 DUP(0B0h)
topic2	BYTE 0B0h, 8 DUP(' '), 58 DUP(0B0h)
topic3	BYTE 0B0h, 2 DUP(' '), 4 DUP (0B0h),2 DUP(' '),58 DUP(0B0h)
topic4	BYTE 0B0h, 10 DUP(' '), 0B0h, 10 DUP(' '), 0B0h, 2 DUP(' '), 6 DUP (0B0h),2 DUP(' '), 0B0h, 10 DUP(' '), 0B0h, 10 DUP(' '), 0B0h, 10 DUP(' '), 0B0h
topic51	BYTE 0B0h, 2 DUP(' '), 6 DUP (0B0h),2 DUP(' '), 0B0h, 2 DUP(' '), 6 DUP (0B0h),2 DUP(' '), 0B0h, 2 DUP(' '), 6 DUP (0B0h),2 DUP(' '), 0B0h, 2 DUP(' '), 6 DUP (0B0h),2 DUP(' ')
topic52	BYTE 0B0h, 2 DUP(' '), 9 DUP (0B0h), 2 DUP(' '), 6 DUP (0B0h),2 DUP(' '), 0B0h
topic62	BYTE 0B0h, 2 DUP(' '), 9 DUP (0B0h), 10 DUP(' '), 0B0h
topic72	BYTE 0B0h, 2 DUP(' '), 9 DUP (0B0h), 2 DUP(' '), 9 DUP (0B0h)
topic8	BYTE 0B0h, 10 DUP(' '), 0B0h, 10 DUP(' '), 0B0h, 10 DUP(' '), 0B0h, 2 DUP(' '), 6 DUP (0B0h),2 DUP(' '), 0B0h, 10 DUP(' '), 0B0h, 10 DUP(' '), 0B0h
; 遊戲畫面設定
; 形狀
rec	BYTE recWidth DUP(0B3h)			; 兩根桿桿
ball	BYTE 0FEh				; 球
Uline	BYTE 0DAh, (wwidth-2) DUP(0C4h), 0BFh	; 上邊框線
Dline	BYTE 0C0h, (wwidth-2) DUP(0C4h),0D9h	; 左右框線
LRline	BYTE 0B3h				; 左右框線
; 座標
lrxy COORD <2,12>
rrxy COORD <96,12>
bxy COORD <4,15>
UBound COORD <1,0>
DBound COORD <1,30>
LBound COORD <1,1>
RBound COORD <98,1>
player1_score BYTE 0
player2_score BYTE 0
text1 BYTE "Player1_Score:"
text2 BYTE "Player2_Score:"
text3 BYTE "Player1 wins !!!"
text4 BYTE "Player2 wins !!!"
text5 BYTE "Press Space to Start The Ping Pong Game !"
textPos COORD <99,2> 
textPos2 COORD <99,7>
textPos3 COORD <48,15>
textPos4 COORD <48,15>
move_bxy COORD<1,1>
start COORD <16,5>
press COORD <29, 23>

; Color Attributes
lcolor WORD recWidth DUP(0Eh)
rcolor WORD recWidth DUP(0Ah)
bcolor  BYTE 0BBh
erase WORD recWidth DUP(00h)	; 讓物體移動前要先擦除原本的(讓他變成底的顏色--黑色)
drawR PROTO, color: PTR WORD, len: DWORD, xy: COORD	; 畫桿桿的prototype
drawC PROTO, color: PTR WORD, len: DWORD, xy: COORD	; 畫球的prototype

.code
main PROC
	INVOKE GetStdHandle,STD_OUTPUT_HANDLE
	mov outputHandle, eax
	call Clrscr	
	;  印出開始畫面的標題"Bounce"
	mov ecx,lengthof topic
	INVOKE WriteConsoleOutputCharacter,outputHandle, ADDR topic, lengthof topic, start,ADDR cellsWritten
	inc start.y
	mov ecx,lengthof topic2
	INVOKE WriteConsoleOutputCharacter,outputHandle, ADDR topic2, lengthof topic2, start,ADDR cellsWritten
	inc start.y
	mov ecx,lengthof topic3
	INVOKE WriteConsoleOutputCharacter,outputHandle, ADDR topic3, lengthof topic3, start,ADDR cellsWritten
	inc start.y
	mov ecx,lengthof topic3
	INVOKE WriteConsoleOutputCharacter,outputHandle, ADDR topic3, lengthof topic3, start,ADDR cellsWritten
	inc start.y
	mov ecx,lengthof topic4
	INVOKE WriteConsoleOutputCharacter,outputHandle, ADDR topic4, lengthof topic4, start,ADDR cellsWritten
	inc start.y
	mov ecx,lengthof topic51	; 因為一行太長 print 不出來 所以分成前半後半print
	INVOKE WriteConsoleOutputCharacter,outputHandle, ADDR topic51, lengthof topic51, start,ADDR cellsWritten
	add start.x, lengthof topic51
	INVOKE WriteConsoleOutputCharacter,outputHandle, ADDR topic52, lengthof topic52, start,ADDR cellsWritten
	mov start.x, 16
	inc start.y
	mov ecx,lengthof topic51
	INVOKE WriteConsoleOutputCharacter,outputHandle, ADDR topic51, lengthof topic51, start,ADDR cellsWritten
	add start.x, lengthof topic51
	INVOKE WriteConsoleOutputCharacter,outputHandle, ADDR topic62, lengthof topic62, start,ADDR cellsWritten
	mov start.x, 16
	inc start.y
	mov ecx,lengthof topic51
	INVOKE WriteConsoleOutputCharacter,outputHandle, ADDR topic51, lengthof topic51, start,ADDR cellsWritten
	add start.x, lengthof topic51
	INVOKE WriteConsoleOutputCharacter,outputHandle, ADDR topic72, lengthof topic72, start,ADDR cellsWritten
	mov start.x, 16
	inc start.y
	mov ecx,lengthof topic8
	INVOKE WriteConsoleOutputCharacter,outputHandle, ADDR topic8, lengthof topic8, start,ADDR cellsWritten
	inc start.y
	mov ecx,lengthof topic
	INVOKE WriteConsoleOutputCharacter,outputHandle, ADDR topic, lengthof topic, start,ADDR cellsWritten
	mov ecx,lengthof text5	;出現text5的文字
	INVOKE WriteConsoleOutputCharacter,outputHandle, ADDR text5, lengthof text5, press,ADDR cellsWritten
Begin:
	call ReadChar 	;判斷輸入的按鍵 
	.IF ax == 3920h	 ;按空白鍵開始遊戲，否則不開始
		call Clrscr
		INVOKE GetConsoleScreenBufferInfo,outHandle,ADDR consoleInfo
		INVOKE SetConsoleScreenBufferSize,outHandle,windowsize
		INVOKE GetStdHandle,STD_OUTPUT_HANDLE
		mov outputHandle, eax
		call drawW	;畫遊戲邊框
		xor eax, eax
		mov ecx, recHeight
		invoke drawR, ADDR lcolor,LENGTHOF lcolor, lrxy		;畫左邊桿桿
		invoke drawR, ADDR rcolor,LENGTHOF rcolor, rrxy	;畫右邊桿桿
		invoke drawC, ADDR bcolor, LENGTHOF bcolor, bxy	;畫球
	.ELSE
		jmp Begin	;如果沒按空白鍵,繼續判斷輸入是否為空白鍵
	.ENDIF
	
MOVE:	
	;player 1 分數
	INVOKE SetConsoleCursorPosition, outputHandle, textPos 	     ;利用eax顯現出目前玩家的分數
	INVOKE WriteConsole,outputHandle,ADDR text1,14,ADDR bytesWritten,0
	movzx eax,player1_score
	call WriteDec
	;player 2 分數
	INVOKE SetConsoleCursorPosition, outputHandle, textPos2
	INVOKE WriteConsole,outputHandle,ADDR text2,14,ADDR bytesWritten,0 
	movzx eax,player2_score
	call WriteDec
	xor eax,eax
	
	mov ax,50	;設定球的移動速度
	call Delay	
	call ball_move
	invoke drawC, ADDR bcolor, LENGTHOF bcolor, bxy
	
	;移動按鍵判斷
	call readkey
	.IF ax == 4800h	;R up
		.IF rrxy.y == 1	; right up bound
			jmp MOVE
		.ENDIF
		invoke drawR, ADDR erase,LENGTHOF erase, rrxy ;
		dec rrxy.y
		invoke drawR, ADDR rcolor,LENGTHOF rcolor, rrxy
	.ENDIF
	.IF ax == 5000h	; R down
		.IF rrxy.y == 23	; right down bound
			jmp MOVE
		.ENDIF
		invoke drawR, ADDR erase,LENGTHOF erase, rrxy;
		inc rrxy.y
		invoke drawR, ADDR rcolor,LENGTHOF rcolor, rrxy
	.ENDIF
	.IF ax == 1177h	; L up
		.IF lrxy.y == 1	; left up bound
			jmp MOVE
		.ENDIF
		invoke drawR, ADDR erase,LENGTHOF erase, lrxy;
		dec lrxy.y
		invoke drawR, ADDR lcolor,LENGTHOF lcolor, lrxy
	.ENDIF
	.IF ax == 1F73h	; L down
		.IF lrxy.y == 23	; left down bound
			jmp MOVE
		.ENDIF
		invoke drawR, ADDR erase,LENGTHOF erase, lrxy;
		inc lrxy.y
		invoke drawR, ADDR lcolor,LENGTHOF lcolor, lrxy
	.ENDIF
	
	;分數判斷
	.IF player1_score == 5
		call Clrscr
		INVOKE SetConsoleCursorPosition, outputHandle, textPos3 	; print player1 wins
		INVOKE WriteConsole,outputHandle,ADDR text3,16,ADDR bytesWritten,0
		
	.ELSEIF player2_score == 5
		call Clrscr
		INVOKE SetConsoleCursorPosition, outputHandle, textPos3	; print player2 wins
		INVOKE WriteConsole,outputHandle,ADDR text4,16,ADDR bytesWritten,0
		
	.ELSE
		jmp MOVE
	.ENDIF
	
	mov eax, 5000
	call Delay
	exit
main ENDP

;球的移動&反彈
 ball_move PROC
	invoke drawC, ADDR erase, LENGTHOF bcolor, bxy	
	mov eax , dword ptr [bxy.x]
	add eax , dword ptr [move_bxy.x]
	mov bxy.x , ax
	mov eax , dword ptr [bxy.y]
	add eax , dword ptr [move_bxy.y]
	mov bxy.y , ax
		
	mov bx , wwidth
	sub bx , lengthof bcolor
	.IF bxy.x >= bx ;球是否碰到畫面左右邊界
		neg move_bxy.x
		.IF bxy.x <= 2
			inc player2_score
		.ELSE
			inc player1_score
		.ENDIF	
	.ENDIF
	
	.IF bxy.x <= 2 ;球是否碰到畫面左右邊界
		neg move_bxy.x
		.IF bxy.x <= 2
			inc player2_score
		.ELSE
			inc player1_score
		.ENDIF	
	.ENDIF
	
	mov bx , height
	.IF bxy.y >= bx
		neg move_bxy.y
	.ENDIF
	
	.IF bxy.y <= LENGTHOF bcolor
		neg move_bxy.y
	.ENDIF	
	mov bx , word ptr [lrxy.x] ;球是否碰到左邊板子
	add bx , recWidth
	.IF bxy.x <= bx 
		mov bx , word ptr [lrxy.x]
		.IF bxy.x >= bx
			mov bx , word ptr [lrxy.y]
			add bx, recHeight
			.IF bxy.y <= bx
				mov bx , word ptr [lrxy.y]
				.IF bxy.y >= bx
					neg move_bxy.x
				.ENDIF
			.ENDIF	
		.ENDIF
	.ENDIF
	
	mov bx , rrxy.x  ;球是否碰到右邊板子
	add bx , recWidth
	sub bx , LENGTHOF bcolor
	.IF bxy.x <= bx
		mov bx , rrxy.x
		sub bx , LENGTHOF bcolor
		.IF bxy.x >= bx
			mov bx , rrxy.y
			add bx , recHeight
			.IF bxy.y <= bx
				mov bx , rrxy.y
				.IF bxy.y >= bx
					neg move_bxy.x
				.ENDIF
			.ENDIF
		.ENDIF
	.ENDIF
	ret
ball_move ENDP

; 畫邊框
drawW PROC
	push ecx
	INVOKE WriteConsoleOutputCharacter,outputHandle, ADDR Uline, lengthof Uline, Ubound,ADDR cellsWritten	; draw the up bound
	pop ecx
	mov ecx, height
L:	push ecx
	INVOKE WriteConsoleOutputCharacter,outputHandle, ADDR LRline, lengthof LRline, Lbound,ADDR cellsWritten	; draw the left bound
	inc Lbound.y
	pop ecx
	loop L
	mov ecx, height
L2:	push ecx
	INVOKE WriteConsoleOutputCharacter,outputHandle, ADDR LRline, lengthof LRline, Rbound,ADDR cellsWritten	; draw the right bound
	inc Rbound.y
	pop ecx
	loop L2
	push ecx
	INVOKE WriteConsoleOutputCharacter,outputHandle, ADDR Dline, lengthof Dline, Dbound,ADDR cellsWritten	; draw the down bound
	pop ecx
	ret
drawW ENDP

; 畫桿桿	       ; 桿桿的顏色 	   ; 桿桿的長度     ; 桿桿的初始座標
drawR PROC color: PTR WORD, len: DWORD , xy: COORD
	mov ecx, RecHeight
L1:	push ecx
	INVOKE WriteConsoleOutputAttribute,outputHandle, color, len, xy, ADDR cellsWritten
	INVOKE WriteConsoleOutputCharacter,outputHandle, ADDR rec, lengthof rec, xy,ADDR cellsWritten
	inc xy.y	; 由上往下畫
	pop ecx
	loop L1
	ret
drawR ENDP

; 畫球	       ; 球的顏色 	   ; 球的長度        ; 球的初始座標
drawC PROC color: PTR WORD, len: DWORD, xy: COORD
	push ecx
	INVOKE WriteConsoleOutputAttribute,outputHandle, color, len, xy ,ADDR cellsWritten
	INVOKE WriteConsoleOutputCharacter, outputHandle,ADDR ball,lengthof ball,bxy ,ADDR cellsWritten  
	pop ecx
	ret
drawC ENDP

END main

