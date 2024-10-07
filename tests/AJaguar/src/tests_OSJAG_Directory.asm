; Files structures for the OSJag support
;

; Files specific support
;
; TBD


	.globl OSJAG_Directory
	.globl OSJAG_SeekPosition
	.globl OSJAG_PtrBuffer


	.data


;**************************
;* Game files descriptions
;**************************
;
	.even
OSJAG_Directory_File0_Info:
	dc.l	OSJAG_Directory_File0_File
	dc.l	OSJAG_Directory_File0_End-OSJAG_Directory_File0_Deb
	dc.b	"CONIN$", 0
	.even
OSJAG_Directory_File0_File:
OSJAG_Directory_File0_Deb:
;	.incbin	""
OSJAG_Directory_File0_End:
;
	.even
OSJAG_Directory_File1_Info:
	dc.l	OSJAG_Directory_File1_File
	dc.l	OSJAG_Directory_File1_End-OSJAG_Directory_File1_Deb
	dc.b	"CONOUT$", 0
	.even
OSJAG_Directory_File1_File:
OSJAG_Directory_File1_Deb:
;	.incbin	""
OSJAG_Directory_File1_End:
;
	.even
OSJAG_Directory_File2_Info:
	dc.l	OSJAG_Directory_File2_File
	dc.l	OSJAG_Directory_File2_End-OSJAG_Directory_File2_Deb
	dc.b	"CONERR$", 0
	.even
OSJAG_Directory_File2_File:
OSJAG_Directory_File2_Deb:
;	.incbin	""
OSJAG_Directory_File2_End:
;
;***********************
;* Game files directory
;***********************
;
	.even
OSJAG_Directory:
OSJAG_Directory_Deb:
	dc.l	OSJAG_Directory_File0_Info
	dc.l	OSJAG_Directory_File1_Info
	dc.l	OSJAG_Directory_File2_Info
OSJAG_Directory_End:
	dc.l	0


	.bss

; Seek positions
	.even
OSJAG_SeekPosition:	ds.l	(OSJAG_Directory_End-OSJAG_Directory_Deb) / 4
; Buffer pointers
	.even
OSJAG_PtrBuffer:	ds.l	(OSJAG_Directory_End-OSJAG_Directory_Deb) / 4
