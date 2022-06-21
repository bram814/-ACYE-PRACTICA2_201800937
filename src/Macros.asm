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

GetShow macro txt, operator, bufferInfo, operatorAux
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
					je Lsalida2
					
					mov operator[DI], al
					
					jmp Lpalabra

	Lsalida2:
		mov operator[DI], 24h
		Analyzer bufferInfo, operator, operatorAux
		; GetPrint _salto
		; GetPrint operator
		jmp Lsalida

    Lsalida:

  		pop di 
  		pop si
  		pop ax

endm



Analyzer macro txt, compare, operator
	local Lsalida, Ls1, L0, L1, L2, L3, L4, L5, L6, L7, L8, L9, L10, L11, L12, L13, L14, L15, L16, L17, L18, L19, L20, L21, L22, L23, L24, L25, L26, L27, L200, L700, L110, L150, L170, L180
	

	push ax
  	push si
  	push di 

  	xor si, si 
	xor di, di 
	xor ax, ax



	cmp txt[si], 7bh ; Codigo ASCCI [{ -> Hexadecimal]
	je L0

	Ls1:
		inc si
		cmp txt[si], 7bh ; Codigo ASCCI [{ -> Hexadecimal]
		je L0
		jmp Ls1

	L0:
		inc si
		cmp txt[si], 22h ; Codigo ASCCI [" -> Hexadecimal]
		je L1
		jmp L0

	L1: ; conca Padre

		inc si
		cmp txt[si], 22h ; Codigo ASCCI [" -> Hexadecimal]
		je L2

		jmp L1

	L2:

		inc si
		cmp txt[si], 3Ah ; Codigo ASCCI [: -> Hexadecimal]
		je L3

		jmp L2

	L3:
		inc si
		cmp txt[si], 5Bh ; Codigo ASCCI [[ -> Hexadecimal]
		je L4

		jmp L3

	L4: ; aca va resursivo
		inc si
		cmp txt[si], 7Bh ; Codigo ASCCI [{ -> Hexadecimal]
		jne L4
		jne L5
		jmp L5

	L5: ; busca el operator

		inc si
		cmp txt[si], 22h ; Codigo ASCCI [" -> Hexadecimal]
		jne L5
		xor di, di
		je L6

		jmp L5

	L6: ; busca el operator

		inc si

		xor ax, ax
		mov al, txt[si]

		cmp txt[si], 22h ; Codigo ASCCI [" -> Hexadecimal]
		je L700

		mov operator[di], al
		inc di
		; conca operator "operacionN"
		jmp L6

	L700:

		mov operator[di], 24h
		xor di, di
		GetPrint _salto
		GetPrint operator
	
		jmp L7
	L7:
		
		inc si
		cmp txt[si], 3AH ; Codigo ASCCI [: -> Hexadecimal]
		je L8

		jmp L7

	L8: ;
		inc si
		cmp txt[si], 7BH ; Codigo ASCCI [{ -> Hexadecimal]
		je L9

		jmp L8

	L9: ; busca la aritmética

		inc si
		cmp txt[si], 22H ; Codigo ASCCI [" -> Hexadecimal]
		je L10
		
		jmp L9

	L10: ; conca nombre aritmética

		inc si

		xor ax, ax
		mov al, txt[si]
		cmp txt[si], 22H ; Codigo ASCCI [" -> Hexadecimal]
		je L110
		; conca aritmética
		mov _aritmethic[di], al
		inc di
		jmp L10

	L110:
		mov _aritmethic[di], 24h
		xor di, di
		GetPrint _salto
		GetPrint _aritmethic
		jmp L11
	L11:

		inc si
		cmp txt[si], 3AH ; Codigo ASCCI [: -> Hexadecimal]
		je L12

		jmp L11

	L12:
		inc si
		cmp txt[si], 7BH ; Codigo ASCCI [{ -> Hexadecimal]
		je L13

		jmp L12
	
	L13: ; conca 1° operator

		inc si
		cmp txt[si], 22H ; Codigo ASCCI [" -> Hexadecimal]
		je L14
		
		jmp L13

	L14: ; conca 1° operator

		inc si
		xor ax, ax
		mov al, txt[si]

		cmp txt[si], 22H ; Codigo ASCCI [" -> Hexadecimal]
		je L150
		; conca operator # or stringOperator
		mov _num1S[di], al
		inc di
		jmp L14

	L150:
	mov _num1S[di], 24h
	xor di, di
	GetPrint _salto
	GetPrint _num1S
	jmp L15

	L15:

		inc si

		cmp txt[si], 3AH ; Codigo ASCCI [: -> Hexadecimal]
		je L16

		jmp L15

	L16:

		inc si
		xor ax, ax
		mov al, txt[si]
		cmp txt[si], 2ch ; Codigo ASCCI [, -> Hexadecimal]
		je L170
		mov _num1S[di], al
		inc di
		jmp L16

	L170:
		mov _num1S[di], 24h
		xor di, di
		GetPrint _num1S
		jmp L17

	L17: ; conca 1° operator

		inc si
		cmp txt[si], 22H ; Codigo ASCCI [" -> Hexadecimal]
		je L18
		
		jmp L17

	L18: ; conca 1° operator

		inc si
		xor ax, ax
		mov al, txt[si]

		cmp txt[si], 22H ; Codigo ASCCI [" -> Hexadecimal]
		je L180
		; conca operator # or stringOperator
		mov _num2S[di], al
		inc di
		jmp L18

	L180:
	mov _num2S[di], 24h
	xor di, di
	GetPrint _salto
	GetPrint _num2S
	jmp L19

	L19:

		inc si

		cmp txt[si], 3AH ; Codigo ASCCI [: -> Hexadecimal]
		je L20

		jmp L19

	L20:
		inc si
		xor ax, ax
		mov al, txt[si]
		cmp txt[si], 0ah ; Codigo ASCCI [\n -> Hexadecimal]
		je L21
		mov _num2S[di], al
		inc di
		jmp L20
	L21:
		mov _num2S[di], 24h
		xor di, di
		GetPrint _num2S
		jmp L23

	L23:
		inc si
		cmp txt[si], 7DH ; Codigo ASCCI [} -> Hexadecimal]
		je L24

		jmp L23


	L24:
		inc si
		cmp txt[si], 7DH ; Codigo ASCCI [} -> Hexadecimal]
		je L25

		jmp L24


	L25:

		inc si
		cmp txt[si], 7DH ; Codigo ASCCI [} -> Hexadecimal]
		je L26

		jmp L25
	
	L26:

		inc si
		
		cmp txt[si], 5dh ; Codigo ASCCI [] -> Hexadecimal]
		je L27 ;  sale

		cmp txt[si], 2ch ; Codigo ASCCI [, -> Hexadecimal]
		je L4 ; aca debe de regresar

		jmp L26

	L27:

		inc si
		cmp txt[si], 7DH ; Codigo ASCCI [} -> Hexadecimal]
		je Lsalida

		jmp Lsalida
	L200:

	Lsalida:
  		pop di 
  		pop si
  		pop ax

endm



getCompare macro compare1, compare2
	local LF, LE, Lsalida, L0
	push si
	push ax

	xor ax, ax
	xor si, si


	mov al, compare1[si]
	cmp compare2[si], al
	je L0
	jne LF

	L0:
		inc si

		xor ax, ax
		mov al, compare1[si]
		cmp al, 24h
		je LE
		cmp compare2[si], al
		je L0
		jne LF

	LE:
		cmp compare2[si], 24h
		jne LF
		GetPrint _true
		jmp Lsalida
	LF:
		GetPrint _false
		jmp Lsalida
	Lsalida:
		pop ax
		pop si

endm