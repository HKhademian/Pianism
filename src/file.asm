%ifndef FILE_ASM
%define FILE_ASM

global file.open
global file.read
global file.write
global file.GetConsoleHandle

extern GetStdHandle
extern CreateFileA
extern CloseHandle
extern WriteFile
extern ReadFile
extern SetFilePointer
extern FindFirstFileA

FILE_GENERIC_READ 		EQU 0x80_00_00_00 ;1<<30
FILE_GENERIC_WRITE 		EQU 0x40_00_00_00 ;1<<29
FILE_GENERIC_RW 			EQU (FILE_GENERIC_READ | FILE_GENERIC_WRITE)

;;; https://stackoverflow.com/a/14469641/1803735
;;;	if file											+Exists			-NotExists
FILE_CREATE_NEW					EQU 1 ; +Fails			-Creates
FILE_CREATE_ALWAYS			EQU 2 ; +Truncates	-Creates
FILE_OPEN_ALWAYS				EQU 4 ; +Opens			-Creates
FILE_OPEN_EXISTING			EQU 3 ; +Opens			-Fails
FILE_TRUNCATE_EXISTING	EQU 5 ; +Truncates	-Fails

FILE_SEEK_BEGIN		EQU 0
FILE_SEEK_CURRENT	EQU 1
FILE_SEEK_END			EQU 2

section .code

;;; file.open( path, mode )
%macro file.open 2
	;;; DEP: https://docs.microsoft.com/en-us/windows/win32/api/winbase/nf-winbase-openfile
	;;; https://docs.microsoft.com/en-us/windows/win32/api/fileapi/nf-fileapi-createfilea
	;;; https://docs.microsoft.com/en-us/windows/win32/fileio/creating-and-opening-files
	;;; opens existing or create new file at path(arg0:DWORD) with mode(arg1:DWORD)
	;;; return file handle in eax
	;enter 0,0
	push ecx ; changed in CreateFileA
	push edx ; changed in CreateFileA

	; CreateFileA( path, GENERIC_RW, 0, NULL, mode, FILE_ATTRIBUTE_NORMAL, NULL );
	push	DWORD NULL						; NULL									: hTemplateFile
	push	DWORD 128							; FILE_ATTRIBUTE_NORMAL	: dwFlagsAndAttributes
	mov		eax, %2
	push	eax										; mode									: dwCreationDisposition
	push	DWORD NULL						; NULL									: lpSecurityAttributes
	push	DWORD 0								; 0											: dwShareMode
	push	DWORD FILE_GENERIC_RW	; GENERIC_RW						: dwDesiredAccess
	mov		eax, %1
	push	eax										; path									: lpFileName
	call	CreateFileA

	pop edx
	pop ecx
	;leave
%endmacro

;;; file.close( hfile )
%macro file.close 1
	;;; return file handle in eax
	; CloseHandle( hFile );
	push	eax
	mov		eax, %1
	push	eax ; path
	call	CloseHandle
	pop eax
%endmacro

;;; file.write( hFile, buffer, len )
%macro file.write 3
	;;; https://docs.microsoft.com/en-us/windows/win32/api/fileapi/nf-fileapi-writefile
	;;; writes len(arg2:DWORD) bytes buffer(arg1:DWORD) in file(arg0:DWORD)
	;;; return writed bytes in eax
	enter 4,0
	push ecx ; changed in CreateFileA
	push edx ; changed in CreateFileA

	lea		eax, [ebp-4]
	; WriteFile( hFile, buffer, len, &bytes, NULL);
	push	NULL	; NULL
	push	eax		; &bytes
	mov		eax, %3
	push	%3		; maxLen
	mov		eax, %2
	push	%2		; buffer
	mov		eax, %1
	push	eax		; hFile
	call	WriteFile
	mov		eax, [ebp-4]

	pop edx
	pop ecx
	leave
%endmacro

;;; file.read( hFile, buffer, maxLen )
%macro file.read 3
	;;; reads maxLen(arg2:DWORD) bytes to buffer(arg1:DWORD) from file(arg0:DWORD)
	;;; return readed bytes in eax
	enter 4,0
	push ecx ; changed in ReadFile
	push edx ; changed in ReadFile

	lea		eax, [ebp-4]
	; ReadFile( hFile, buffer, maxLen, &bytes, NULL );
	push	NULL	; NULL
	push	eax		; &bytes
	mov		eax, %3
	push	%3		; maxLen
	mov		eax, %2
	push	%2		; buffer
	mov		eax, %1
	push	eax		; hFile
	call	ReadFile
	mov		eax, [ebp-4]

	pop edx
	pop ecx
	leave
%endmacro

;;; file.seek( hFile, dist, mode )
;;; return readed bytes in eax
%macro file.seek 3
	enter 0,0
	push ecx ; changed in CreateFileA
	push edx ; changed in CreateFileA

	; SetFilePointer( hFile, dist, NULL, mode );
	mov		eax, %3
	push	eax					; mode
	push	DWORD NULL	; NULL
	mov		eax, %2
	push	eax					; dist
	mov		eax, %1
	push	eax					; hFile
	call	SetFilePointer

	pop edx
	pop ecx
	leave
%endmacro

;;; file.GetStdHandle( mode )
;;; return handler in eax
%macro file.GetStdHandle 1
	; hStdOut = GetStdHandle( mode )
	push	DWORD %1
	call	GetStdHandle
%endmacro
%define file.GetStdInHandle file.GetStdHandle(-10)
%define file.GetStdOutHandle file.GetStdHandle(-11)
%define file.GetStdErrHandle file.GetStdHandle(-12)

%macro file.FindFirstFile 2
	; handle = FindFirstFile ( path, &data )
	push	DWORD %2
	push	DWORD %1
	call	FindFirstFileA
%endmacro
%endif
