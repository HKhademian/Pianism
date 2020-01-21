%include "core.asm"
%include "notes.asm"

%ifndef PIANO_ASM
%define PIANO_ASM

section .data
	input times 10 DB 0

section .text
	base_notes EQU notes4
	base_dur EQU 250 ; ms
	skip EQU 100 ; ms

section .code
%macro piano.note 6
	;;; piano.note ( note<=eax, dur, cond, done, symb, log )
	%define note	%1
	%define dur		%2
	%define cond	%3
	%define done	%4
	%define symb	%5
	%define log		%6
	
	;;; small to cap
	cmp note, 'a'
	jnae %%_skip_small
	cmp note, 'z'
	jnbe %%_skip_small
	sub note, 'a'-'A'
	%%_skip_small:
	
	; x to exit
	cmp note, 'X'
	je done
	
	;; Duration commands
	; +: add
	cmp note, '+'
	je %%_dur_plus
	; -: minus
	cmp note, '-'
	je %%_dur_minus
	; *: duble
	cmp note, '*'
	je %%_dur_dub
	; /: half
	cmp note, '/'
	je %%_dur_half
	
	;; Special Commands
	; spave: hold
	cmp note, ' '
	je %%_hold
	; ~: TODO
	cmp note, '~'
	je %%_cmd_todo
	; !: TODO
	cmp note, '!'
	je %%_cmd_todo
	; @: TODO
	cmp note, '@'
	je %%_cmd_todo
	; $: TODO
	cmp note, '@'
	je %%_cmd_todo
	; %: TODO
	cmp note, '@'
	je %%_cmd_todo
	; ^: TODO
	cmp note, '@'
	je %%_cmd_todo
	; &: TODO
	cmp note, '@'
	je %%_cmd_todo
	; =: TODO
	cmp note, '@'
	je %%_cmd_todo

	; Numeral commands
	cmp note, 0
	jl %%_nums_skip
	cmp note, 9
	jb %%_nums
	%%_nums_skip:

	cmp note, 'A'
	jnae %%_play_skip
	cmp note, 'G'
	jbe %%_play
	%%_play_skip:

	jmp %%_invalid
	
	%%_hold:
		%if log
			putcstr `--- Pause ---\n`
		%endif
		sleep skip
		jmp cond

	%%_play:
		sub note, 'A'
		%if symb
			lea ecx, [note_names + note*4]
			putstr ecx
			putstr CSPC, 1
		%endif
		mov note, [base_notes + note*4] ; now eax is freq
		%if log
			puti dur
			putstr CTAB, 1
			puti note
			putstr CRLF, 2
		%endif
		beep note, dur
		mov dur, base_dur
		jmp cond
	
	%%_nums:
		; sub note, '0'
		jmp cond
	
	%%_cmd_todo:
		%if log
			putcstr `--- TODO ---\n`
		%endif
		jmp cond

	%%_dur_plus:
		%if log
			putcstr `--- Plus ---\n`
		%endif
		add dur, base_dur
		jmp cond
	
	%%_dur_minus:
		%if log
			putcstr `--- Sub ---\n`
		%endif
		sub dur, base_dur
		jmp cond
	
	%%_dur_dub:
		%if log
			putcstr `--- Double ---\n`
		%endif
		shl dur, 1
		jmp cond
	
	%%_dur_half:
		%if log
			putcstr `--- Half ---\n`
		%endif
		shr dur, 1
		jmp cond

	%%_invalid:
		%if log
			putcstr `--- INVALID ---\n`
		%endif
		jmp cond

	%undef note
	%undef dur
	%undef cond
	%undef done
	%undef symb
	%undef log
%endmacro

piano.string:
	enter 0,0
	pushad
	mov esi, eax

	mov ebx, base_dur
	.cond:
		xor eax, eax
		mov al, [esi]
		inc esi
		cmp al, NULL
		je .done
	.play:
		piano.note eax, ebx, .cond, .done, 1, 0
	.done:

	popad
	leave
	ret

piano.keyboard:
	enter 0,0
	pushad

	; piano mode ON
	console.getMode
	and eax, ~CONSOLE_EN_ECHO_INPUT
	and eax, ~CONSOLE_EN_LINE_INPUT
	console.setMode

	mov ebx, base_dur
	.cond:
		console.read input, 5
		movzx eax, byte [input]
	.play:
		piano.note eax, ebx, .cond, .done, 1, 0
	.done:

	; piano mode OFF
	console.getMode
	or eax, CONSOLE_EN_ECHO_INPUT
	or eax, CONSOLE_EN_LINE_INPUT
	console.setMode

	popad
	leave
	ret
%endif