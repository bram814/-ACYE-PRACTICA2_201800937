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
	MOV AH,01H ; 1 char
	int 21H
endm

GetInputMax macro cadena
	mov ah, 3fh 					; int21 para leer fichero o dispositivo
	mov bx, 00 						; handel para leer el teclado
	mov cx, 20 						; bytes a leer (aca las definimos con 10)
	mov dx, offset[cadena]
	int 21h
endm



; ************** [RECORRIDO] **************

GetShow macro txt
	local Lsalida, Lh, Lo, Lw, Lsave, Lpalabra, Lsalida2, Lsalida3
	
	push ax
  	push si
  	push di 

  	xor si, si 
	xor di, di 
	xor ax, ax

	cmp _inputMax[si], 73H ; Codigo ASCCI [s -> Hexadecimal]
    je Lh
	cmp _inputMax[si], 53H ; Codigo ASCCI [S -> Hexadecimal]
    je Lh	
    jmp Lsalida	

    Lh:	

    	inc si
    	cmp _inputMax[si], 68H ; Codigo ASCCI [h -> Hexadecimal]
	    je Lo
		cmp _inputMax[si], 48H ; Codigo ASCCI [H -> Hexadecimal]
	    je Lo
    	jmp Lsalida

	    Lo:

    		inc si
	    	cmp _inputMax[si], 6FH ; Codigo ASCCI [o -> Hexadecimal]
		    je Lw
			cmp _inputMax[si], 4FH ; Codigo ASCCI [O -> Hexadecimal]
		    je Lw
	    	jmp Lsalida

	    	Lw:

	    		inc si
		    	cmp _inputMax[si], 77H ; Codigo ASCCI [w -> Hexadecimal]
			    je Lsave
				cmp _inputMax[si], 57H ; Codigo ASCCI [W -> Hexadecimal]
			    je Lsave
		    	jmp Lsalida

				Lsave:

					inc si
					cmp _inputMax[si], 20H ; Codigo ASCCI [space -> Hexadecimal]
					je Lsave
					xor ax, ax
					mov al, _inputMax[si]
					mov _operator[DI], al
					jmp Lpalabra

				Lpalabra:
					inc si
					INC DI
					xor ax, ax
					mov bh, _inputMax[si]
					;mov _operator[DI], bh ; error se cicla
				
					cmp _inputMax[si], 24H ; Codigo ASCCI [$ -> Hexadecimal]
					je Lsalida
					cmp _inputMax[si], 0Ah ; Codigo ASCCI [\n -> Hexadecimal]
					je Lsalida2
					cmp _inputMax[si], 08H ; Codigo ASCCI [\r -> Hexadecimal]
					je Lsalida3
					cmp _inputMax[si], 20H ; Codigo ASCCI [space -> Hexadecimal]
					je Lsalida3
					
					
					
					jmp Lpalabra

	Lsalida2:

		;mov _operator[di], 24h
		GetPrint _salto
		;GetPrint _inputMax
		;GetPrint _operator
		GetPrint _cadena7

		jmp Lsalida

	Lsalida3:
		;mov _operator[di], 24h
		GetPrint _salto
		GetPrint _operator
		GetPrint _cadena5

		jmp Lsalida

    Lsalida:

  		pop dx 
  		pop bx
  		pop cx
    	pop ax

endm
