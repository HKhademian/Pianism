%include "file.asm"

%ifndef CONSOLE_ASM
%define CONSOLE_ASM

global console.write

extern GetConsoleMode, SetConsoleMode
extern ReadConsoleA, WriteConsoleA

CONSOLE_EN_PROCESSED_INPUT				EQU 0x0001
CONSOLE_EN_LINE_INPUT							EQU 0x0002
CONSOLE_EN_ECHO_INPUT							EQU 0x0004
CONSOLE_EN_WINDOW_INPUT						EQU 0x0008
CONSOLE_EN_MOUSE_INPUT						EQU 0x0010
CONSOLE_EN_INSERT_MODE						EQU 0x0020
CONSOLE_EN_QUICK_EDIT_MODE				EQU 0x0040
CONSOLE_EN_EXTENDED_FLAGS					EQU 0x0080
CONSOLE_EN_VIRTUAL_TERMINAL_INPUT	EQU 0x0200

SCREEN_EN_PROCESSED_OUTPUT						EQU 0x0001
SCREEN_EN_WRAP_AT_EOL_OUTPUT 					EQU 0x0002
SCREEN_EN_VIRTUAL_TERMINAL_PROCESSING	EQU 0x0004
SCREEN_DIS_NEWLINE_AUTO_RETURN 				EQU 0x0008
SCREEN_EN_LVB_GRID_WORLDWIDE 					EQU 0x0010

section .code
%macro console.write 2
	;;; console.write(str, len)
	;;; writes len(arg1:DWORD) char str(arg1:DWORD) in console
	;enter 0,0
	;;push eax
	;push ecx
	;push edx

	file.GetStdOutHandle		; eax = std_out_hand
	file.write eax, %1, %2	; eax = writed characters

	;pop edx
	;pop ecx
	;;pop eax
	;leave
%endmacro

%macro console.read 2
	;;; console.read( buffer, maxLen )
	;;; reads max len(arg1:DWORD) char to str(arg1:DWORD) from console
	enter 4,0
	push ecx
	push edx

	;file.read	eax, %1, %2		; eax = readed characters

	push DWORD NULL
	lea eax, [ebp-4]
	push DWORD eax
	push DWORD %2
	push DWORD %1
	file.GetStdInHandle			; eax = std_in_hand
	push DWORD eax
	call ReadConsoleA


	pop edx
	pop ecx
	leave
%endmacro

%macro console.getMode 0
	;;; console.getMode( )
	;;; https://docs.microsoft.com/en-us/windows/console/getconsolemode
	;;; eax = console mode
	push ecx
	push edx

	push	dword 0 ; temp
	lea		eax, [esp]
	push	DWORD eax
	file.GetStdInHandle			; eax = std_in_hand
	push	DWORD eax
	call	GetConsoleMode
	pop eax
	
	pop edx
	pop ecx
%endmacro

%macro console.setMode 0
	;;; console.getMode( eax=>mode )
	;;; https://docs.microsoft.com/en-us/windows/console/setconsolemode
	;;; set console mode from eax
	push ecx
	push edx

	push	DWORD eax
	file.GetStdInHandle	; eax = std_in_hand
	push	DWORD eax
	call	SetConsoleMode
	
	pop edx
	pop ecx
%endmacro

%endif