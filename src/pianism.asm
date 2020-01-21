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
showMenu:
	cls
	putstr MSG_MENU
	ret
	MSG_MENU:
		db "---| Pianism |---", LF,
		db "1) Play a file", LF,
		db "2) Play free", LF,
		db "3) Show Help", LF,
		db "4) Show About", LF,
		db "0) Exit", LF,
		db "-- Please choose: ", NULL

playFile:
	pause
	ret

playFree:
	call piano_keyboard
	ret

showHelp:
	putstr MSG_HELP
	getch
	ret
	MSG_HELP:
		DB "TIME is how long does an action takes to pass to next action"
		DB "1 time UNIT is 250ms", LF
		DB "press `A`,`B`,`C`,`D`,`E`,`F` keys to play note by TIME miliseconds", LF
		DB "press ` ` to hold instead of play", LF
		DB "press `+` to increase time by 1 unit", LF
		DB "press `-` to decrease time by 1 unit", LF
		DB "press `*` to double time", LF
		DB "press `/` to half time", LF
		DB "press `x` to end the play", LF
		DB "Press any key to return", LF
		DB NULL


showAbout:
	putstr MSG_ABOUT
	getch
	ret
	MSG_ABOUT:
		DB "Created by Hossain Khademian 2020", LF
		DB "Press any key to return", LF
		DB NULL

_start:
	enter 0,0
	.menu:
		call showMenu
		getchar
		putln
		sub al, '0'
		jb .menu
		je .menu_end
		cmp al, 4
		jg .menu
		mov ebx, [ MENU_JMP + eax*4 ]
		cls
		call ebx
		jmp .menu
		.menu_end:

	cls
	putcstr "GoodBye!"
	putln

	leave
	ret
	MENU_JMP DD 0, playFile, playFree, showHelp, showAbout
