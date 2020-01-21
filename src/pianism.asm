%include "core.asm"
%include "util.asm"
%include "console.asm"
%include "piano.asm"

global _start

section .data
	file1 dd 0

section .bss
	resb 10
	buffer resb 1024

section .code
_start:
	enter 4,0

	putcstr "Enter file path: "
	fgets buffer, 1024
	putcstr `Open:\n`
	file.open buffer, FILE_OPEN_ALWAYS
	mov [file1], EAX
	file.read [file1], buffer, 100
	file.close [file1]
	mov eax, buffer
	call piano.string
	leave
	ret

	;call piano.keyboard
	;leave
	;ret

	;defstr sample1, `EeE  EEE  EGCD*E   FFF   FFx  EE   EE   EDDED   |G     EEE  EEE  EGC  DE  FFFF FEEEE GG FD C\0`
	;defstr sample1, `EeE  EEE  EGCD Ex\0`
	;defstr sample1, `AAA   AA   A   A A   A A A\0`
	;defstr sample1, `G G A G C B\0`
	;defstr sample1, `A B C D E F G\0`
	;mov eax, sample1
	;call piano.string
	;leave
	;ret

    leave
    ret

filePath			db ".\\test.txt", NULL ; "D:\\test.txt", NULL
title					db 'Hossain', NULL
title.len			EQU $-title-1
message				db 'Hello, World', CR, LF, 'How Are you?', CR, LF, NULL
message.len		EQU $-message-1
