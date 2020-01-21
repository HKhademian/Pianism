%include "util.asm"
%include "core.asm"
global _start

section .bss
	resb 10
	buffer resb 1024

section .code
_start:
	enter 4,0

	DUR EQU 100

regza
reglog
	sleep 1000
reglog
	beep 350, DUR
	beep 400, DUR
	beep 450, DUR

	; mov ecx, 10
	; play:
	; beep 440, 100
	; sleep 100
	; loop play

	leave
	ret
