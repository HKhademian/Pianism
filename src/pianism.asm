%include "core.asm"
%include "util.asm"
%include "console.asm"
%include "piano.asm"

global _start

section .data
	%define APP_NAME "Pianism"
	%define SONGS_BASE_PATH "D:\Media\University\981Assembly\Pianism\songs\0.song"
	file1 dd 0
	defstr delSongCmd, 'DEL "', SONGS_BASE_PATH, '"'
	defstr songPath, SONGS_BASE_PATH

section .bss
	resb 10
	buffer resb 1024
	findData resb 100

section .code
showMenu:
	cls
	putstr MSG_MENU
	ret
	MSG_MENU:
		db "---| ", APP_NAME, " |---", LF,
		db "1) Play free", LF,
		db "2) Play a save", LF,
		db "3) Play a file", LF,
		db "4) Show Help", LF,
		db "5) Show About", LF,
		db "0) Exit", LF,
		db "-- Please choose: ", NULL

playSave:
	enter 0,0
	pushad

	.getSlot:
	putcstr "Enter slot number [1:9]: "
	getchar
	putln
	cmp al, '0'
	jb .getSlot
	cmp al, '9'
	jg .getSlot

	mov [songPath+songPath_len-5-1], al
	mov [delSongCmd+delSongCmd_len-6-1], al
	; putstr songPath
	file.open songPath, FILE_OPEN_EXISTING
	cmp eax, -1
	jne .getSlot_done
	putcstr "Slot is not saved before", LF
	pause
	jmp .done
	.getSlot_done:

	.play:
	putln
	mov [file1], EAX
	file.read [file1], buffer, 100
	file.close [file1]
	mov eax, buffer
	call piano_string

	putstr MSG_MENU_SAVE
	getchar
	cmp al, '1'
	je .play
	cmp al, '2'
	je .delete
	jmp .done

	.delete:
		putcstr LF, "Are you sure you want to delete this save slot (y/N)? "
		getchar
		cmp al, 'y'
		jne .done
		; puts delSongCmd
		sys delSongCmd
		putcstr LF, "Save Slot Deleted!", LF
		pause

	.done:
	popad
	leave
	ret
	MSG_MENU_SAVE:
		DB LF, "What to you want to do with this save slot:",LF
		DB "1) Play again", LF
		DB "2) Delete it", LF
		DB "any) return to main meny", LF
		DB "-- Please choose: ", NULL

playFile:
	enter 0,0
	.getPath:
	putcstr "Enter file path: "
	fgets buffer, 1000

	file.open buffer, FILE_OPEN_EXISTING
	cmp eax, -1
	jne .getPath_done
	putcstr "File Not Found", LF
	pause
	jmp .done
	.getPath_done:

	.play:
		mov [file1], EAX
		file.read [file1], buffer, 100
		file.close [file1]
		mov eax, buffer
		call piano_string

	putln
	pause

	.done:
	leave
	ret

playFree:
	call showHelp
	putcstr "Free Play Mode: "
	cls

	.play:
		lea eax, [buffer]
		call piano_keyboard

	.replay:
		putcstr CRLF, "Do you want to listen to your play (y/N)? "
		getchar
		cmp al, 'y'
		jne .skip_replay
		mov eax, buffer
		call piano_string
		jmp .replay
		.skip_replay:

	.save:
		putcstr CRLF, "Do you want to save your play (Y/n)? "
		getchar
		cmp al, 'n'
		je .skip_save
		.getSlot
			putcstr CRLF, "Enter Slot number [1:9]: "
			getchar
			cmp al, '1'
			jb .getSlot
			cmp al, '9'
			jg .getSlot
		mov [songPath+songPath_len-5-1], al
		file.open songPath, FILE_CREATE_ALWAYS
		mov [file1], EAX
		file.write [file1], buffer, 1000
		file.close [file1]
		putcstr CRLF, "Your play saved!", CRLF
		pause

		.skip_save:

	.done:
	ret

showHelp:
	putstr MSG_HELP
	getch
	ret
	MSG_HELP:
		DB "TIME is how long does an action takes to pass to next action", CRLF
		DB "1 time UNIT is 250ms", CRLF
		DB "While in free play:", CRLF
		DB "	press `A`,`B`,`C`,`D`,`E`,`F` keys to play note by TIME miliseconds", CRLF
		DB "	press ` ` to hold instead of play", CRLF
		DB "	press `+` to increase time by 1 unit", CRLF
		DB "	press `-` to decrease time by 1 unit", CRLF
		DB "	press `*` to double time", CRLF
		DB "	press `/` to half time", CRLF
		DB "	press `x` to end the play", CRLF
		DB "Press any key to continue ...", CRLF
		DB NULL


showAbout:
	putstr MSG_ABOUT
	getch
	ret
	MSG_ABOUT:
		DB APP_NAME, " v0.1", CRLF
		DB "final project for 'Machine Language' by 'Ashkan Sami, Ph.D'", CRLF
		DB "Developed by Hossain Khademian Fall-2020", CRLF
		DB "Links: ", CRLF
		DB "Prof.: https://shirazu.ac.ir/faculty/home/sami/en", CRLF
		DB "Dev. Github: https://github.com/HKhademian/", CRLF
		DB "Dev. Github: https://github.com/HossainKhademian/", CRLF
		DB "Mail: hco@post.com", CRLF
		DB "Press any key to continue ...", CRLF
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
		cmp al, 5
		jg .menu
		mov ebx, [ MENU_JMP + eax*4 ]
		cls
		call ebx
		jmp .menu
		.menu_end:

	cls
	putcstr "GoodBye!", LF

	leave
	ret
	MENU_JMP DD 0, playFree, playSave, playFile, showHelp, showAbout
