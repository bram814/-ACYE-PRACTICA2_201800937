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
