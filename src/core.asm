%ifndef CORE_ASM
%define CORE_ASM

extern Sleep
extern Beep
extern system ; system(cmd)
extern _getch ; ch = getch()
extern putchar ; putchar(ch)
extern putwchar ; putwchar(wch)
; extern puts ; puts(str)

;;; basic constant and values declration
section .text
	NULL			EQU 0
	CR				EQU 0DH
	LF				EQU 0AH
	TAB				EQU '	'
	SPC				EQU ' '
	DOT				EQU '.'

	%define CRLF CR,LF

	CTAB db TAB, NULL
	CSPC db SPC, NULL
	CDOT db DOT, NULL
	CMD_CLS		DB  'cls', NULL
	CMD_PAUSE	DB  'pause', NULL
section .code

%macro sys 1
	;pushad
	push ecx
	push edx
	enter 0,0
	push DWORD %1
	call system
	leave
	pop edx
	pop ecx
	;popad
%endmacro

%macro sleep 1
; %macro sleep 0-1 500
	;;; sleep(dur=500)
	push ecx
	push edx
	push DWORD %1		; dur milis
	call Sleep			; eax = if err
	pop edx
	pop ecx
%endmacro

%macro beep 2
	;;; beep(freq, dur=500)
	;;; beeps in freq(arg0:DWORD) for dur(arg1:DWORD) mili-secs
	push ecx
	push edx
	push DWORD %2		; dur
	push DWORD %1		; freq
	call Beep				; eax = if err
	pop edx
	pop ecx
%endmacro

;;; call console CLS command
%define cls sys CMD_CLS

;;; call console PAUSE command
%define pause sys CMD_PAUSE

;;; prints new line
%define putln putcstr LF

;;; get ascci char from console
%macro getch 0
	push ecx
	push edx
	call _getch
	pop edx
	pop ecx
%endmacro

;;; getch also print it
%macro getchar 0
	getch
	putch eax
%endmacro

;;; put ascii char on screen
%macro putch 1
	enter 0,0
	push DWORD %1
	call putchar
	leave
%endmacro

;;; put unicode char on screen
%macro putwch 1
	enter 0,0
	push DWORD %1
	call putwchar
	leave
%endmacro

%endif
