%ifndef CORE_ASM
%define CORE_ASM

extern Sleep
extern Beep

%macro sleep 1
; %macro sleep 0-1 500
	;;; sleep(dur=500)
	;;push eax
	push ecx
	push edx

	push DWORD %1		; dur milis
	call Sleep			; eax = if err

	pop edx
	pop ecx
	;;pop eax
%endmacro

%macro beep 2
	;;; console.beep(freq, dur=500)
	;;; beeps in freq(arg0:DWORD) for dur(arg1:DWORD) mili-secs
	;enter 0,0
	;push eax
	push ecx
	push edx

	push DWORD %2		; dur
	push DWORD %1		; freq
	call Beep				; eax = if err

	pop edx
	pop ecx
	;pop eax
	;leave
%endmacro

%endif