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
; ************** [PATH][OPEN] **************
GetOpenFile macro buffer,handler
	mov ah,3dh
	mov al,02h
	lea dx,buffer
	int 21h
	jc Lerror1
	mov handler,ax
endm
; ************** [PATH][CLOSE] **************
GetCloseFile macro handler
	mov ah,3eh
	mov bx,handler
	int 21h
	jc Lerror2
endm
; ************** [PATH][READ] **************
GetReadFile macro handler,buffer,numbytes
	mov ah,3fh
	mov bx,handler
	mov cx,numbytes
	lea dx,buffer
	int 21h
	jc Lerror5
endm


; ============================== REPORTE ==============================

; ************** [PATH][CREATE] **************
GetCreateFile macro buffer,handler
    MOV AX,@data
    MOV DS,AX
    MOV AH,3ch
    MOV CX,00h
    LEA DX,buffer
    INT 21h
    ;jc Error4
    MOV handler, AX
endm
; ************** [PATH][WRITE] **************
GetWriteFile macro handler, buffer
    LOCAL ciclo_Ini, ciclo_Fin
    MOV AX,@data
    MOV DS,AX
    ; MOV AH,40h
    ; MOV BX,handler
    ; MOV CX, SIZEOF buffer 

    XOR BX, BX
    XOR AX, AX 
    ciclo_Ini:
      MOV AL, buffer[ BX ]
      CMP AL, '$'
      JE ciclo_Fin

      INC BX 
      JMP ciclo_Ini
    ciclo_Fin:
    XOR AX, AX

    MOV contadorBuffer, BX
    XOR BX, BX
    
    MOV AH,40h
    MOV BX,handler
    MOV CX, contadorBuffer
    LEA DX, buffer
    INT 21h
endm

GetWriteFileN macro handler, buffer
    LOCAL ciclo_Ini, ciclo_Fin
    MOV AX,@data
    MOV DS,AX

    MOV AH,40h
    MOV BX, handler
    MOV CX, SIZEOF buffer 
    LEA DX, buffer
    INT 21h
endm

; ************** [DATE][WRITE] **************
saveNumber macro d1, d2
	aam           ; Ajuste Ascii para la multiplicacion
    mov bx, ax    ; se carga el registro ya ajustado en bx
    add bx, 3030h ; Se le suma un 3030h

    mov dl, bh    ; Imprimimos el primer digito
    mov d1, bh
    mov ah, 02h
    int 21h
    mov dl, bl    ; Imprimimos el segundo digito
	mov d2, bl
    mov ah, 02h
    int 21h

endm



GetWriteDate macro handler
	; Salto de linea
    mov dl, 0Ah
    mov ah, 02h
    int 21h
	; ======================= FECHA =======================
    mov ah, 2ah
    int 21h

    ; ======================= dia =======================
    mov al, dl
    saveNumber _digitoFDia1, _digitoFDia2


    mov dl, '/'
    mov ah, 02h
    int 21h

    ; ======================= mes =======================
    mov al, dh
    saveNumber _digitoFMes1, _digitoFMes2

    mov dl, '/'
    mov ah, 02h
    int 21h

    ; ======================= año =======================
    add cx, 0F830h  ; Suma para ajustar el año correcto
    mov ax, cx
    saveNumber _digitoFYear1, _digitoFYear2

    ; Imprimir los dos digitos finales
    mov dl, 0Dh
    mov ah, 02h
    int 21h

    ; Salto de linea
    mov dl, 0Ah
    mov ah, 02h
    int 21h



	; ======================= HORA =======================
    mov ah, 2ch ; Obtenemos hora del sistema
    int 21h

    ; ======================= hora =======================
    mov al, ch
    saveNumber _digitoHHora1, _digitoHHora2

    ; Se imprimen :
    mov dl, ':'
    mov ah, 02h
    int 21h

    ; ======================= minutos =======================
    mov al, cl
    saveNumber _digitoHMin1, _digitoHMin2

    ; Se imprimen :
    mov dl, ':'
    mov ah, 02h
    int 21h

    ; ======================= segundos =======================
    mov al, dh
    saveNumber _digitoHSec1, _digitoHSec2

    ; Dejamos un espacio y un salto de linea
    mov dl, 0Dh
    mov ah, 02h
    int 21h

    mov dl, 0Ah
    mov ah, 02h
    int 21h


    ; 			FECHA
    GetWriteFile handler, _Reporte8S
    ; dia
    GetWriteFile handler, _Reporte9S
	GetWriteFileN handler, _digitoFDia1
	GetWriteFileN handler, _digitoFDia2 
	GetWriteFile handler, _Reporte31S
	GetWriteFile handler, _salto

	; mes
	GetWriteFile handler, _Reporte10S
	GetWriteFileN handler, _digitoFMes1
	GetWriteFileN handler, _digitoFMes2 
	GetWriteFile handler, _Reporte31S
	GetWriteFile handler, _salto

	; year
	GetWriteFile handler, _Reporte10S
	GetWriteFileN handler, _digitoFYear1
	GetWriteFileN handler, _digitoFYear2 
	GetWriteFile handler, _Reporte31S
	GetWriteFile handler, _salto

	; fin
	GetWriteFile handler, _Reporte12S

	; 			HORA 
	GetWriteFile handler, _Reporte13S
	; hora
    GetWriteFile handler, _Reporte14S
	GetWriteFileN handler, _digitoHHora1
	GetWriteFileN handler, _digitoHHora2 
	GetWriteFile handler, _Reporte31S
	GetWriteFile handler, _salto

	; minutos
	GetWriteFile handler, _Reporte15S
	GetWriteFileN handler, _digitoHMin1
	GetWriteFileN handler, _digitoHMin2 
	GetWriteFile handler, _Reporte31S
	GetWriteFile handler, _salto

	; segundos
	GetWriteFile handler, _Reporte16S
	GetWriteFileN handler, _digitoHSec1
	GetWriteFileN handler, _digitoHSec2 
	GetWriteFile handler, _salto


	GetWriteFile handler, _Reporte17S


endm