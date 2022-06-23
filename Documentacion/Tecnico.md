# [Manual Técnico](../README.md)



___
### Índice
1. [Requerimientos](#reque)
2. [Instalar Requerimientos](#instalarReque)
2. [Especificaciones del Sistema](#especifa)
3. [Clases que Conforman la Estructura del Proyecto](#estrucProye)
4. [Métodos de Macros](#mMacros)
4. [Métdos de File](#exprTec)
4. [Main](#main)

____
### Requerimientos <a name="reque"></a>
-   Contar con la herramienta DOSBox version 0.74-3
-   Tener Microsoft Macro Assembler (**MASM**) es un ensamblador para la familia x86 de microprocesadores.
-   Algún editor de código para Masm, de preferencia **Sublime Text**

___
### Instalando requerimientos <a name="instalarReque"></a>

Para instalar **dosbox** en Ubuntu ejecutar los siguientes comandos:
```bash
sudo apt-get update
sudo apt-get install dosbox
```
___
### Especificaciones del sistema <a name="especifa"></a>

El sistema fue desarrollado en **Masm**, por medio de una interfaz dosbox, está conformado por la clase main (principal), file y macros.

__
### Clases que conforman la estructura del proyecto <a name="estrucProye"></a>

-   **Main.asm**
Esta clase tendrá todos los segmentos, como de liberías, stack, datos y codigo.

-   **Macros.asm**
Está clase está conformado por todos los macros utilizados en el proyecto.

-   **File.asm**
Está clase está conformada por métodos en cargados de lectura, escritura, creación y cerrado de archivos.

_____
### Métodos de Macros <a name="mMacros"></a>

El macro GetPrint es el encargo de imprimir una variable.

```java
; ************** [IMPRIMIR] **************
GetPrint macro buffer
	MOV AX,@data
	MOV DS,AX
	MOV AH,09H
	MOV DX,OFFSET buffer
	INT 21H
endm
```

Son los métodos en cargados de obtener la entrada por teclado.
```java
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
```

Estos métodos son los encargados de conertir un strin a int, y viceversa.
```java


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


```
Forma de como operar la suma

```java
Ldivision:
    xor ax, ax
    String_Int _num1S
    mov _numero1, ax
    GetMayor _numero1
    GetMenor _numero1

    xor ax, ax
    String_Int _num2S
    mov _numero2, ax
    GetMayor _numero2
    GetMenor _numero2


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
```
Forma de como obtener la multiplicación
```java
Lmultiplicacion:
    xor ax, ax
    String_Int _num1S
    mov _numero1, ax
    GetMayor _numero1
    GetMenor _numero1

    xor ax, ax
    String_Int _num2S
    mov _numero2, ax
    GetMayor _numero2
    GetMenor _numero2

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
```
Forma de como obtener la resta
```java
Lresta:
    xor ax, ax
    String_Int _num1S
    mov _numero1, ax
    GetMayor _numero1
    GetMenor _numero1


    xor ax, ax
    String_Int _num2S
    mov _numero2, ax
    GetMayor _numero2
    GetMenor _numero2


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
```

Forma de como obtener la suma
```java
Lsuma:
    xor ax, ax
    String_Int _num1S
    mov _numero1, ax
    GetMayor _numero1
    GetMenor _numero1


    xor ax, ax
    String_Int _num2S
    mov _numero2, ax
    GetMayor _numero2
    GetMenor _numero2


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
```




- **Analyzer**
Es el encargo de recorrer el archivo **.json** , está compuesto por estados y al final tiene una comparión que es la encargada de verificar si la operación es la acertada.


____

### Métodos de File <a name="exprTec"></a>

Es el encargado de obtener la ruta a leer.
```java
; ************** [PATH][GET] **************
GetRoot macro buffer
	LOCAL Ltext, Lout
	xor si,si  ; Es igual a mov si,0

	Ltext:
		GetInput
		cmp al,0DH ; Codigo ASCCI [\n -> Hexadecimal]
		je Lout
		mov buffer[si],al ; mov destino,fuente
		inc si ; si = si + 1
		jmp Ltext

	Lout:
		mov al,00H ; Codigo ASCCI [null -> Hexadecimal]
		mov buffer[si],al
endm

```

El macro GetOpen es el encargo de abrir el archivo.

```java
; ************** [PATH][OPEN] **************
GetOpenFile macro buffer,handler
	mov ah,3dh
	mov al,02h
	lea dx,buffer
	int 21h
	jc Lerror1
	mov handler,ax
endm

```


Este macro es el encargado de cerrar el archivo por medio del handle.

```java
; ************** [PATH][CLOSE] **************
GetCloseFile macro handler
	mov ah,3eh
	mov bx,handler
	int 21h
	jc Lerror2
endm
```

Este macro es el encargo de obtener toda la información del archivo **.jso**.
```java
; ************** [PATH][READ] **************
GetReadFile macro handler,buffer,numbytes
	mov ah,3fh
	mov bx,handler
	mov cx,numbytes
	lea dx,buffer
	int 21h
	jc Lerror5
endm

```

___
### Main<a name="main"></a>

El  main tiene la siguiente estructura

```java
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

.code 
	main proc

		MOV AX, @data ; segmento de datos
		MOV DS, AX ; mover a ds
		MOV ES, AX
        CALL identificador
        jmp Lout
        Lout:
			;GetPrint _salto

			;reporte

			MOV ah,4ch
			int 21h

	main endp

end main
```

