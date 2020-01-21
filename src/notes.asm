%ifndef NOTES_ASM
%define NOTES_ASM
section .text
	DB 'A4', 0, 0, 0, 0, 0, 0;, 0, 0
	note_names:
		db 0xe2, 0x99, 0xa9, 0
		db 0xe2, 0x99, 0xaa, 0
		db 0xe2, 0x99, 0xab, 0
		db 0xe2, 0x99, 0xac, 0
		db 0xe2, 0x99, 0xad, 0
		db 0xe2, 0x99, 0xae, 0
		db 0xe2, 0x99, 0xaf, 0
		db 'A♩', 0, 0
		db 'B♪', 0, 0
		db 'C♫', 0, 0
		db 'D♬', 0, 0
		db 'E♭', 0, 0
		db 'F♮', 0, 0
		db 'G♯', 0, 0
		; DB 'A4', 0, 0, 0, 0, 0, 0;, 0, 0
		; DB 'B4', 0, 0, 0, 0, 0, 0;, 0, 0
		; DB 'C4', 0, 0, 0, 0, 0, 0;, 0, 0
		; DB 'D4', 0, 0, 0, 0, 0, 0;, 0, 0
		; DB 'E4', 0, 0, 0, 0, 0, 0;, 0, 0
		; DB 'F4', 0, 0, 0, 0, 0, 0;, 0, 0
		; DB 'G4', 0, 0, 0, 0, 0, 0;, 0, 0

	DD 0			;-1: NO
	notes0:
		DD 27		; 0: A
		DD 31		; 1: B
		DD 16		; 2: C
		DD 18		; 3: D
		DD 21		; 4: E
		DD 22		; 5: F
		DD 24		; 6: G
		
	DD 0			;-1: NO
	notes1:
		DD 55		; 0: A
		DD 62		; 1: B
		DD 33		; 2: C
		DD 37		; 3: D
		DD 41		; 4: E
		DD 44		; 5: F
		DD 49		; 6: G
		
	dd 0			;-1: NO
	notes2:
		DD 110	; 0: A
		DD 123	; 1: B
		DD 65		; 2: C
		DD 73		; 3: D
		DD 82		; 4: E
		DD 87		; 5: F
		DD 99		; 6: G
		
	DD 0			;-1: NO
	notes3:
		DD 220	; 0: A3
		DD 247	; 1: B3
		DD 130	; 2: C3
		DD 147	; 3: D3
		DD 165	; 4: E3
		DD 177	; 5: F3
		DD 196	; 6: G3
			
	DD 0			;-1: NO
	notes4:
		DD 440	; 0: A4
		DD 494	; 1: B4
		DD 262	; 2: C4
		DD 294	; 3: D4
		DD 330	; 4: E4
		DD 349	; 5: F4
		DD 392	; 6: G4
	
	DD 0			;-1: NO
	notes5:
		DD 880	; 0: A5
		DD 988	; 1: B5
		DD 523	; 2: C5
		DD 587	; 3: D5
		DD 659	; 4: E5
		DD 698	; 5: F5
		DD 784	; 6: G5

	DD 0			;-1: NO
	notes6:
		DD 1760	; 0: A6
		DD 1976	; 1: B6
		DD 1047	; 2: C6
		DD 1175	; 3: D6
		DD 1319	; 4: E6
		DD 1397	; 5: F6
		DD 1568	; 6: G6

%endif