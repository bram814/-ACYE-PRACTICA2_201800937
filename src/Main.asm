; Teclado español con keyb la
; Teclado ingeles con keyb us

; ================ [SEGMENTO][LIBS] ================
include Macros.asm

.model small 

; ================ [SEGMENTO][STACK] ================
.stack 


; ================ SEGMENTO DE DATOS ================
.data  
	
	;db -> dato byte -> 8 bits
	;dw -> dato word -> 16 bits
	;dd -> doble word -> 32 bits

	; ************** [IDENTIFICADOR] **************
	_cadena0        db 0ah,0dh,               "===================================================","$"
	_cadena1        db 0ah,0dh,               "UNIVERSIDAD DE SAN CARLOS DE GUATEMALA$","$"
	_cadena2        db 0ah,0dh,               "FACULTAD DE INGENIERIA$","$"
	_cadena3        db 0ah,0dh,               "ESCUELA DE CIENCIAS Y SISTEMAS", "$"
	_cadena4        db 0ah,0dh,               "ARQUITECTURA DE COMPILADORES Y ENSAMBLADORES 1", "$"
	_cadena5        db 0ah,0dh,               "SECCION A", "$"
	_cadena6        db 0ah,0dh,               "Jose Abraham Solorzano Herrera$"
	_cadena7        db 0ah,0dh,               "201800937$"


	; ************** [MENU] **************
	_menu1          db 0ah,0dh,               "1) CARGAR ARCHIVO$"
	_menu2          db 0ah,0dh,               "2) CONSOLA$"
	_menu3        	db 0ah,0dh,               "3) SALIR$"

	; ************** [CHOOSE] **************
	_salto         	db 0ah,0dh,               "$"
	_choose        	db        	              "Escoga Opcion: $"

	; ************** [CHARGE FILE] **************
	_file0         	db 0ah,0dh,               "============ CARGAR ARCHIVO ============ $"
	_file1         	db                        "Ingrese Ruta: $"
	_file         	db 0ah,0dh,               "Archivo leido con exito!$"

	; ************** [CONSOLE] **************
	_console0     	db 0ah,0dh,               "============ CONSOLA ============ $"
	_console1       db                        ">> $"

; ================ SEGMENTO DE PROC ================

; **************************** [IDENTIFICADOR] **************************** 
identificador proc far
    GetPrint _cadena0
    GetPrint _cadena1
    GetPrint _cadena2
    GetPrint _cadena3
    GetPrint _cadena4
    GetPrint _cadena5
    GetPrint _cadena6
    GetPrint _cadena7
    ret
identificador endp

menu proc far
	GetPrint _menu1
	GetPrint _menu2
	GetPrint _menu3
    GetPrint _salto
    GetPrint _choose
    ret
menu endp

jump proc far
	GetPrint _salto
	ret
jump endp

; ================ SEGMENTO DE CODIGO ================
.code 
	main proc

		MOV dx, @data
		MOV ds, dx

		CALL identificador

		LMenu:
			CALL jump
			CALL menu

			; Obtenemos el Caracter
        	GetInput

			cmp al,31H ; Codigo ASCCI [1 -> Hexadecimal]
	        je Lfile
	        cmp al,32H ; Codigo ASCCI [2 -> Hexadecimal]
	        je LMenu
	        cmp al,33H ; Codigo ASCCI [3 -> Hexadecimal]
	        je Lout 
	        jmp LMenu

	    LFile:
	    	CALL jump
	    	GetPrint _file0
	    	CALL jump
	    	GetPrint _file1
	    	CALL jump
	    	jmp LMenu

	    LConsole:

		Lout:
			MOV ah,4ch
			int 21h
	main endp
end