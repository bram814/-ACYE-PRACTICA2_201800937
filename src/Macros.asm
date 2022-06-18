; **************************** [MACROS] ****************************
; ************** [IMPRIMIR] **************
GetPrint macro buffer
	MOV AX,@data
	MOV DS,AX
	MOV AH,09H
	MOV DX,OFFSET buffer
	INT 21H
endm


; ************** [CAPTURAR ENTRADA] **************
GetInput macro
	MOV AH,01H
	int 21H
endm