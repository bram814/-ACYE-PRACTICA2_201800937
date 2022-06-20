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

GetShow macro txt, operator
	local Lsalida, Lh, Lo, Lw, Lsave, Lpalabra, Lsalida2, Lsalida3
	
	push ax
  	push si
  	push di 

  	xor si, si 
	xor di, di 
	xor ax, ax

	cmp txt[si], 73H ; Codigo ASCCI [s -> Hexadecimal]
    je Lh
	cmp txt[si], 53H ; Codigo ASCCI [S -> Hexadecimal]
    je Lh	
    jmp Lsalida	

    Lh:	

    	inc si
    	cmp txt[si], 68H ; Codigo ASCCI [h -> Hexadecimal]
	    je Lo
		cmp txt[si], 48H ; Codigo ASCCI [H -> Hexadecimal]
	    je Lo
    	jmp Lsalida

	    Lo:

    		inc si
	    	cmp txt[si], 6FH ; Codigo ASCCI [o -> Hexadecimal]
		    je Lw
			cmp txt[si], 4FH ; Codigo ASCCI [O -> Hexadecimal]
		    je Lw
	    	jmp Lsalida

	    	Lw:

	    		inc si
		    	cmp txt[si], 77H ; Codigo ASCCI [w -> Hexadecimal]
			    je Lsave
				cmp txt[si], 57H ; Codigo ASCCI [W -> Hexadecimal]
			    je Lsave
		    	jmp Lsalida

				Lsave:

					inc si
					cmp txt[si], 20H ; Codigo ASCCI [space -> Hexadecimal]
					je Lsave
					xor ax, ax
					mov al, txt[si]
					mov operator[DI], al
					jmp Lpalabra

				Lpalabra:
					inc si
					INC DI
					xor ax, ax
					mov al, txt[si]
					
				
					cmp txt[si], 24H ; Codigo ASCCI [$ -> Hexadecimal]
					je Lsalida
					cmp txt[si], 0Ah ; Codigo ASCCI [\n -> Hexadecimal]
					je Lsalida2
					cmp txt[si], 08H ; Codigo ASCCI [\r -> Hexadecimal]
					je Lsalida3
					cmp txt[si], 20H ; Codigo ASCCI [space -> Hexadecimal]
					je Lsalida3
					
					mov operator[DI], al ; error se cicla
					
					jmp Lpalabra

	Lsalida2:

		mov operator[DI], 24h
		GetPrint _salto
		;GetPrint txt
		GetPrint operator
		GetPrint _cadena7

		jmp Lsalida

	Lsalida3:
		mov operator[DI], 24h
		GetPrint _salto
		GetPrint operator
		GetPrint _cadena5

		jmp Lsalida

    Lsalida:

  		pop dx 
  		pop bx
  		pop cx
    	pop ax

endm
