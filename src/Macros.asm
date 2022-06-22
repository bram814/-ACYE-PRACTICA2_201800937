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

;convierte un NUMERO a CADENA que esta guardado en AX 
Int_String macro intNum
  local div10, signoN, unDigito, obtenerDePila
  ;Realizando backup de los registros BX, CX, SI
  push ax
  push bx
  push cx
  push dx
  push si
  xor si,si
  xor cx,cx
  xor bx,bx
  xor dx,dx
  mov bx,0ah 				; Divisor: 10
  test ax,1000000000000000 	; veritficar si es numero negativo (16 bits)
  jnz signoN
  unDigito:
      cmp ax, 0009h
      ja div10
      mov intNum[si], 30h 	; Se agrega un CERO para que sea un numero de dos digitos
      inc si
      jmp div10
  signoN:					; Cambiar de Signo el numero 
  	  neg ax 				; Se niega el numero para que sea positivo
  	  mov intNum[si], 2dh 	; Se agrega el signo negativo a la cadena de salida
  	  inc si
  	  jmp unDigito
  div10:
      xor dx, dx 			; Se limpia el registro DX; Este simulará la parte alta del registro
      div bx 				; Se divide entre 10
      inc cx 				; Se incrementa el contador
      push dx 				; Se guarda el residuo DX
      cmp ax,0h 			; Si el cociente es CERO
      je obtenerDePila
	  jmp div10
  obtenerDePila:
      pop dx 				; Obtenemos el top de la pila
      add dl,30h 			; Se le suma '0' en su valor ascii para numero real
      mov intNum[si],dl 	; Metemos el numero al buffer de salida
      inc si
      loop obtenerDePila
      mov ah, '$' 			; Se agrega el fin de cadena
      mov intNum[si],ah
      						; Restaurando registros
      pop si
      pop dx
      pop cx
      pop bx
      pop ax
endm

;convierte una CADENA A NUMERO, este es guardado en AX.
String_Int macro stringNum
  local ciclo, salida, verificarNegativo, negacionRes
  push bx
  push cx
  push dx
  push si
  ;Limpiando los registros AX, BX, CX, SI
  xor ax, ax
  xor bx, bx
  xor dx, dx
  xor si, si
  mov bx, 000Ah						;multiplicador 10
  ciclo:
      mov cl, stringNum[si]
      inc si
      cmp cl, 2Dh 					; compara para ignorar el "-"
      jz ciclo    					; Se ignora el simbolo '-' de la cadena
      cmp cl, 30h 					; Si el caracter es menor a '0', implica que es negativo (verificacion)
      jb verificarNegativo 			; ir para cuando es un negativo 
      cmp cl, 39h 					; Si el caracter es mayor a '9', implica que es negativo (verificacion)
      ja verificarNegativo
  	  sub cl, 30h					; Se le resta el ascii '0' para obtener el número real
  	  mul bx      					; multplicar ax
      mov ch, 00h
   	  add ax, cx  					; sumar para obtener el numero total
  	  jmp ciclo
  negacionRes:
      neg ax 						; negacion por si es negativo el resultado
      jmp salida
  verificarNegativo: 
      cmp stringNum[0], 2Dh 		; Si existe un signo al inicio del numero, negamos el numero
      jz negacionRes
  salida:
      								; Restaurando los registros AX, BX, CX, SI
      pop si
      pop dx
      pop cx
      pop bx
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
		;GetPrint _salto
		;GetPrint operator
	
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
		;GetPrint _salto
		;GetPrint _aritmethic
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
	;GetPrint _salto
	;GetPrint _num1S
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
		;GetPrint _num1S
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
	;GetPrint _salto
	;GetPrint _num2S
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
		;GetPrint _num2S
		jmp L22

	L22:
		getCompare compare, operator
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
	local LF, LE, Lsalida, L0, Ldivision, Ldivision0, Lmultiplicacion, Lmultiplicacion0, Lresta, Lresta0, Lsuma, Lsuma0
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

		cmp compare2[si], 24h
		je LE

		xor ax, ax
		mov al, compare1[si]
		cmp compare2[si], al
		je L0
		jne LF


		jmp L0

	LE:
		
		; GetPrint _aritmethic
		; GetPrint _salto
		; GetPrint _num1S
		; GetPrint _salto
		; GetPrint _num2S
		; GetPrint _salto


		xor si, si
		; divisón
		cmp _aritmethic[si], 2fh ; Codigo ASCCI [/ -> Hexadecimal]
		je Ldivision
		cmp _aritmethic[si], 64h ; Codigo ASCCI [d -> Hexadecimal]
		je Ldivision0
		; multiplicación
		cmp _aritmethic[si], 2ah ; Codigo ASCCI [* -> Hexadecimal]
		je Lmultiplicacion
		cmp _aritmethic[si], 6dh ; Codigo ASCCI [m -> Hexadecimal]
		je Lmultiplicacion0
		; resta
		cmp _aritmethic[si], 2dh ; Codigo ASCCI [- -> Hexadecimal]
		je Lresta
		cmp _aritmethic[si], 73h ; Codigo ASCCI [s -> Hexadecimal]
		je Lresta0
		; suma
		cmp _aritmethic[si], 2bh ; Codigo ASCCI [+ -> Hexadecimal]
		je Lsuma
		cmp _aritmethic[si], 61h ; Codigo ASCCI [a -> Hexadecimal]
		je Lsuma0
		

		Ldivision0:
			inc si
			cmp _aritmethic[si], 69h ; Codigo ASCCI [i -> Hexadecimal]
			jne Lsalida

			inc si
			cmp _aritmethic[si], 76h ; Codigo ASCCI [v -> Hexadecimal]
			jne Lsalida

			jmp Ldivision
		

		Lmultiplicacion0:
			inc si
			cmp _aritmethic[si], 75h ; Codigo ASCCI [u -> Hexadecimal]
			jne Lsalida

			inc si
			cmp _aritmethic[si], 6ch ; Codigo ASCCI [l -> Hexadecimal]
			jne Lsalida

			jmp Lmultiplicacion

		Lresta0:

			inc si
			cmp _aritmethic[si], 75h ; Codigo ASCCI [u -> Hexadecimal]
			jne Lsalida

			inc si
			cmp _aritmethic[si], 62h ; Codigo ASCCI [b -> Hexadecimal]
			jne Lsalida

			jmp Lresta

		Lsuma0:

			inc si
			cmp _aritmethic[si], 64h ; Codigo ASCCI [d -> Hexadecimal]
			jne Lsalida

			inc si
			cmp _aritmethic[si], 64h ; Codigo ASCCI [d -> Hexadecimal]
			jne Lsalida

			jmp Lsuma0




		Ldivision:
			xor ax, ax
			String_Int _num1S
			mov _numero1, ax

			xor ax, ax
			String_Int _num2S
			mov _numero2, ax

			mov ax,_numero1    
	        cwd                 ; Convertimos a dobleword
	        mov bx,_numero2    
	        idiv bx             ; ax/bx ax = Resultado

	        mov _calcuResultado,ax  ; guardamos en calcuIN1
	        Int_String _numResult ; convierte el numero guardado en ax

	        GetPrint _salto
	        GetPrint _RESULT
	        GetPrint compare1
	        GetPrint _salto
	        GetPrint _numResult
	        
			jmp Lsalida

		Lmultiplicacion:
			xor ax, ax
			String_Int _num1S
			mov _numero1, ax

			xor ax, ax
			String_Int _num2S
			mov _numero2, ax

			mov ax, _numero1
	        mov bx, _numero2
	        imul bx
	        mov _calcuResultado,ax
	        mov ax,_calcuResultado
	        Int_String _numResult ; convierte el numero guardado en ax

	        GetPrint _salto
	        GetPrint _RESULT
	        GetPrint compare1
	        GetPrint _salto
	        GetPrint _numResult

			jmp Lsalida

		Lresta:
			xor ax, ax
			String_Int _num1S
			mov _numero1, ax

			xor ax, ax
			String_Int _num2S
			mov _numero2, ax

			mov dx, _numero1
	        sub dx, _numero2
	        mov _calcuResultado, dx
	        mov ax, _calcuResultado
	        Int_String _numResult ; convierte el numero guardado en ax

	        GetPrint _salto
	        GetPrint _RESULT
	        GetPrint compare1
	        GetPrint _salto
	        GetPrint _numResult

			jmp Lsalida

		Lsuma:
			xor ax, ax
			String_Int _num1S
			mov _numero1, ax

			xor ax, ax
			String_Int _num2S
			mov _numero2, ax


			mov dx, _numero1
	        add dx, _numero2
	        mov _calcuResultado, dx
	        mov ax, _calcuResultado
	        Int_String _numResult ; convierte el numero guardado en ax

	        GetPrint _salto
	        GetPrint _RESULT
	        GetPrint compare1
	        GetPrint _salto
	        GetPrint _numResult

			jmp Lsalida
		
	LF:
		; GetPrint _false
		; GetPrint _salto
		jmp Lsalida
	Lsalida:
		pop ax
		pop si

endm