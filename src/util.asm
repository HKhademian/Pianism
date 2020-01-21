%include "lib.asm"

%ifndef UTIL_ASM
%define UTIL_ASM

NULL	EQU 0
CR		EQU 0DH
LF		EQU 0AH
TAB		EQU '	'
SPC		EQU ' '
DOT		EQU '.'

;;; defstr(lable, text)
;;; lable:			DB text
;;; lable_len:	EQU $-lable
%macro defstr 2
	jmp %%_skip
	%1			db	%2
	%1_len	EQU $-%1
	%%_skip:
%endmacro

%macro putstr 2
	;; wish to use mov+sub insteadof push to preserve parameters order but mov cant opperate on mem2mem
	; mov DWORD [ESP-4], DWORD %2			; size
	; mov DWORD [ESP-8], DWORD %1			; buffer
	; sub ESP, 8											; allocate space
	;; call write(buffer, size)
	push DWORD %2			; size
	push DWORD %1			; buffer
	call write
%endmacro

%macro putstr 1
	pushad
	mov edi, %1
	cmp edi, NULL	; if buffer==NULL then goto skip
	je %%_skip
	mov esi, edi
	dec esi
	%%_get_length:
		inc esi
		cmp BYTE [esi], NULL
		jne %%_get_length
		sub esi, edi	;len = lastP - firstP
		;dec esi				;remove NULL
	cmp esi, 0		; if len<=0 then goto skip
	jle %%_skip
	putstr edi, esi
	%%_skip:
	popad
%endmacro

%macro putcstr 1
	defstr %%_msg, %1
	putstr %%_msg, %%_msg_len
%endmacro

%macro puti 1
	;;; prints given signed 32bit number to console
	i2a DWORD %1, util_buffer2
	putstr util_buffer2
%endmacro

%macro puti 2
	;;; prints given signed 32bit number to console with msg
	putstr DWORD %1
	puti %2
%endmacro

%macro geti 0
	;;; get a line from console
	;;; return signed 32bit number in eax
	fgets util_buffer2, 13
	a2i 13, util_buffer2
%endmacro


%macro regza 0
	mov eax, 0
	mov ebx, 0
	mov ecx, 0
	mov edx, 0
	mov esi, 0
	mov edi, 0
%endmacro

%macro regloga 0
	puti MSG_ESP, esp
	putstr CTAB,1
	puti MSG_EBP, ebp
	putstr CTAB,1
	puti MSG_EAX, eax
	putstr CTAB,1
	puti MSG_EBX, ebx
	putstr CTAB,1
	puti MSG_ECX, ecx
	putstr CTAB,1
	puti MSG_EDX, edx
	putstr CTAB,1
	puti MSG_ESI, esi
	putstr CTAB,1
	puti MSG_EDI, edi
%endmacro
%macro reglogf 0
	push EAX
	pushfd
	pop EAX
	puti MSG_EFLAG, EAX
	pop EAX
%endmacro
%macro reglog 0
	regloga
	putstr CTAB, 2
	reglogf
	putstr CRLF, 2
%endmacro



section .data

section .bss
	util_buffer1 resb 1000
	util_buffer2 resb 25

section .text
	CRLF db CR, LF, NULL
	CTAB db TAB, NULL
	CSPC db SPC, NULL
	CDOT db DOT, NULL

	MSG_ESP db "ESP: ", NULL
	MSG_EBP db "EBP: ", NULL
	MSG_EAX db "EAX: ", NULL
	MSG_EBX db "EBX: ", NULL
	MSG_ECX db "ECX: ", NULL
	MSG_EDX db "EDX: ", NULL
	MSG_ESI db "ESI: ", NULL
	MSG_EDI db "EDI: ", NULL
	MSG_EFLAG db "EFLAG: ", NULL

%endif