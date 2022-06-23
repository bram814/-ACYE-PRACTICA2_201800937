; Teclado español con keyb la
; Teclado ingeles con keyb us

; ================ [SEGMENTO][LIBS] ================
include Macros.asm
include File.asm

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
	_true           db 0ah,0dh,               "true$"
	_false          db 0ah,0dh,               "false$"
	_choose        	db        	              "Escoga Opcion: $"
	_RESULT        	db        	              "Resultado de $"
	_ResultMayor   	db        	              "Estadistico Mayor: $"
	_ResultMenor   	db        	              "Estadistico Menor: $"
	_ResultMedia   	db        	              "Estadistico Media: $"
	_ResultMediana 	db        	              "Estadistico Mediana: $"
	TK_DOSPUNTOS  	db 0ah,0dh, ": $"

	; ************** [CHARGE FILE] **************
	_file0         	db 0ah,0dh,               "============ CARGAR ARCHIVO ============ $"
	_file1         	db 0ah,0dh,               "Ingrese Ruta: $"
	_file2         	db 0ah,0dh,               "Archivo leido con exito!$"

	; ************** [CONSOLE] **************
	_console0     	db 0ah,0dh,               "============ CONSOLA ============ $"
	_console1       db                        ">> $"

	; ************** [ERRORES] **************
	_error1         db 0ah,0dh,               "> Error al Abrir Archivo, no Existe ",   "$"
	_error2         db 0ah,0dh,               "> Error al Cerrar Archivo",              "$"
	_error3         db 0ah,0dh,               "> Error al Escribir el Archivo",         "$"
	_error4         db 0ah,0dh,               "> Error al Crear el Archivo",            "$"
	_error5         db 0ah,0dh,               "> Error al Leer al Archivo",             "$"
	_error6         db 0ah,0dh,               "> Error en el Archivo",                  "$"
	_error7         db 0ah,0dh,               "> Error al crear el Archivo",                  "$"

	; ************** [INPUT] **************
	_inputMax       db 50 dup(' '), "$"
	_operator       db 50 dup(' '), "$" 
	_operatorAux    db 50 dup('$') 
	_aritmethic     db 50 dup(' '), "$" 
	_padre          db 50 dup('reporte.jso$')
	_num1S    		db 50 dup(' '), "$" 
	_num2S    		db 50 dup(' '), "$" 
	_numResult    	db 50 dup(' '), "$" 
	_numero1        dw 0                ; Sirve para almacenar el numero 1 en int
	_numero2        dw 0                ; Sirve para almacenar el numero 2 en int
	_numero3        dw 0 
	_calcuResultado dw 0                ; Sirve para almacenar el Resultado


	; ************** [FILE] **************
	_bufferInput    db 50 dup('$')
	_handleInput    dw ? 
	_bufferInfo     db 50000 dup('$')
	contadorBuffer  dw 0 ; Contador para todos los WRITE FILE, para escribir sin que se vean los $

	_Reporte00S     db 0ah,0dh,               "Reporte Generado",'$'
	_createFile     db 'reporte.jso' ; variable para crear archivo
	_reporteHandle  dw ?
	_Reporte0S      db 0ah,0dh,               "{",'$'
	_Reporte1S      db 0ah,0dh,               '    "reporte":{ $'
	_Reporte2S      db 0ah,0dh,               '        "Datos":{ $'
	_Reporte3S      db 0ah,0dh,               '            "Nombre":"Jose Abraham Solorzano Herrera",$'
	_Reporte4S      db 0ah,0dh,               '            "Carnet":"201800937",$'
	_Reporte5S      db 0ah,0dh,               '            "Curso":"Arquitectura de compiladores y ensambladores 1",$'
	_Reporte6S      db 0ah,0dh,               '            "Seccion":"A"$'
	_Reporte7S      db 0ah,0dh,               '        }, $'
	_Reporte8S      db 0ah,0dh,               '        "Fecha":{ $'
	_Reporte9S      db 0ah,0dh,               '            "Dia":$'
	_Reporte10S     db 0ah,0dh,               '            "Mes":$'
	_Reporte11S     db 0ah,0dh,               '            "Año":$'
	_Reporte12S     db 0ah,0dh,               '        }, $'
	_Reporte13S     db 0ah,0dh,               '        "Hora":{ $'
	_Reporte14S     db 0ah,0dh,               '            "Hora":$'
	_Reporte15S     db 0ah,0dh,               '            "Minuto":$'
	_Reporte16S     db 0ah,0dh,               '            "Segundo":$'
	_Reporte17S     db 0ah,0dh,               '        }, $'
	_Reporte18S     db 0ah,0dh,               '        "Resultados":{ $'
	_Reporte19S     db 0ah,0dh,               '            "Media":$'
	_Reporte20S     db 0ah,0dh,               '            "Mediana":$'
	_Reporte21S     db 0ah,0dh,               '            "Menor":$'
	_Reporte22S     db 0ah,0dh,               '            "Mayor":$'
	_Reporte25S     db 0ah,0dh,               '        }, $'
	_Reporte26S     db 0ah,0dh,               '        "Operaciones":{ $'
	_Reporte27S     db 0ah,0dh,               '        }$'
	_Reporte28S     db 0ah,0dh,               '    }$'
	_Reporte29S     db 0ah,0dh,               '}$'
	_Reporte30S     db                        '"$'
	_Reporte31S     db                        ',$'

	_digito1 db 0
	_digito2 db 0

	_Media 	 dw 0
	_Mediana dw 0
	_Menor   dw 0 
	_Mayor   dw 0 

	_MediaS  	db 10 dup(' '), "$" 
	_MedianaS   db 10 dup(' '), "$" 
	_MenorS  	db 10 dup(' '), "$" 
	_MayorS  	db 10 dup(' '), "$" 

	_digitoFDia1  db 0
	_digitoFDia2  db 0
	_digitoFMes1  db 0
	_digitoFMes2  db 0
	_digitoFYear1 db 0
	_digitoFYear2 db 0

	_digitoHHora1 db 0
	_digitoHHora2 db 0
	_digitoHMin1  db 0
	_digitoHMin2  db 0
	_digitoHSec1  db 0
	_digitoHSec2  db 0
	
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

	sendConsole proc far
		GetPrint _console0
		GetPrint _salto
		GetPrint _console1
		ret
	sendConsole endp

; ================ SEGMENTO DE CODIGO ================
.code 
	main proc

		MOV AX, @data ; segmento de datos
		MOV DS, AX ; mover a ds
		MOV ES, AX

		CALL identificador

		LMenu:
			CALL jump
			CALL menu

			; Obtenemos el Caracter
        	GetInput

			cmp al,31H ; Codigo ASCCI [1 -> Hexadecimal]
	        je LFile
	        cmp al,32H ; Codigo ASCCI [2 -> Hexadecimal]
	        je LConsole
	        cmp al,33H ; Codigo ASCCI [3 -> Hexadecimal]
	        je Lout 
	        jmp LMenu

	    LFile:
	    	CALL jump
	    	GetPrint _file0
	    	CALL jump
	    	GetPrint _file1
	    	CALL jump
	    	
	    	GetRoot _bufferInput                                        ; Capturar Path

	        GetOpenFile _bufferInput,_handleInput                          ; Abrir file
	        GetReadFile _handleInput,_bufferInfo,SIZEOF _bufferInfo 
	        GetPrint _file2   
	        GetCloseFile _handleInput   
	        jmp LMenu

	    LConsole:
	    	GetPrint _salto
	    	CALL sendConsole
	    	GetInputMax _inputMax

	    	GetExit _inputMax
	    	GetShowMayor _inputMax
	    	GetShowMenor _inputMax
	    	GetShowMedia _inputMax
	    	GetShowMediana _inputMax
	    	GetShow _inputMax, _operator, _bufferInfo, _operatorAux
	    	GetShowPadre _inputMax

	    	jmp LConsole

	    Lerror1:
	        GetPrint _salto
	        GetPrint _error1
	        jmp Lmenu
	    Lerror2:
	        GetPrint _salto
	        GetPrint _error2
	        jmp Lmenu
	    Lerror3:
	        GetPrint _salto
	        GetPrint _error3
	        jmp Lmenu
	    Lerror4:
	        GetPrint _salto
	        GetPrint _error4
	        jmp Lmenu
	    Lerror5:
	        GetPrint _salto
	        GetPrint _error5
	        jmp Lmenu
	    Lerror7:
	        GetPrint _salto
	        GetPrint _error7
	        jmp Lout

		Lout:
			;GetPrint _salto

			;reporte

			MOV ah,4ch
			int 21h

	main endp

end main