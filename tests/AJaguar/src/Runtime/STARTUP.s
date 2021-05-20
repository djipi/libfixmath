;-----------------------------------------------------------------------------
; Warning!!! Warning!!! Warning!!! Warning!!! Warning!!! Warning!!! Warning!!!
; Warning!!! Warning!!! Warning!!! Warning!!! Warning!!! Warning!!! Warning!!!
;-----------------------------------------------------------------------------
; Do not change any of the code in this file except where explicitly noted.
; Making other changes can cause your program's startup code to be incorrect.
;-----------------------------------------------------------------------------


;----------------------------------------------------------------------------
; Jaguar Development System Source Code
; Copyright (c)1995 Atari Corp.
; ALL RIGHTS RESERVED
;
; Module: startup.s - Hardware initialization/License screen display
;
; Revision History:
;  1/12/95 - SDS: Modified from MOU.COF sources.
;  2/28/95 - SDS: Optimized some code from MOU.COF.
;  3/14/95 - SDS: Old code preserved old value from INT1 and OR'ed the
;                 video interrupt enable bit. Trouble is that could cause
;                 pending interrupts to persist. Now it just stuffs the value.
;  4/17/95 - MF:  Moved definitions relating to startup picture's size and
;                 filename to top of file, separate from everything else (so
;                 it's easier to swap in different pictures).
;----------------------------------------------------------------------------
; Program Description:
; Jaguar Startup Code
;
; Steps are as follows:
; 1. Set GPU/DSP to Big-Endian mode
; 2. Set VI to $FFFF to disable video-refresh.
; 3. Initialize a stack pointer to high ram.
; 4. Initialize video registers.
; 5. Create an object list as follows:
;            BRANCH Object (Branches to stop object if past display area)
;            BRANCH Object (Branches to stop object if prior to display area)
;            BITMAP Object (Jaguar License Acknowledgement - see below)
;            STOP Object
; 6. Install interrupt handler, configure VI, enable video interrupts,
;    lower 68k IPL to allow interrupts.
; 7. Use GPU routine to stuff OLP with pointer to object list.
; 8. Turn on video.
; 9. Jump to _start.
;
; Notes:
; All video variables are exposed for program use. 'ticks' is exposed to allow
; a flicker-free transition from license screen to next. gSetOLP and olp2set
; are exposed so they don't need to be included by exterior code again.
;-----------------------------------------------------------------------------

	.include	"JAGUAR.INC"

;*****************
;* ASM Conditional
;*****************
;
SETGPU			=	0				; Set the GPU
UNDERSCORE_DEF	=	0				; Underscore at the beginning of functions
MAIN_C			=	1				; main c funtion
PROFILE			=	0

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Begin STARTUP PICTURE CONFIGURATION -- Edit this to change startup picture
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PPP     		.equ    8      			; Pixels per Phrase (1-bit)
BMP_WIDTH   	.equ    320     		; Width in Pixels
BMP_HEIGHT  	.equ    240     			; Height in Pixels

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; End of STARTUP PICTURE CONFIGURATION
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;***********
;* Externals
;***********
;
	.extern	__bss_start__
	;.extern	__bss_end__
	.extern	__bss_size__
	.extern __Stack
	;.extern	_main
	.extern	main
	.if PROFILE = 1
	.extern	__text_end__
	.extern	__text_start__
	.extern	monstartup
	.extern	_mcleanup
	.endif

;*********
;* Globals
;*********
;
	.globl	_start
	.globl	_text_start
	.globl	_reset
	.globl	_exit
	.globl	___main
	.globl	_video_height
	.globl	_a_vdb
	.globl	_a_vde
	.globl	_video_width
	.globl	_a_hdb
	.globl	_a_hde
	.globl	_vblPerSec

;**********************
;* Constant definitions
;**********************
;
;Objects list information
;
LISTSIZE    	.equ    5					; Objects List length (in Phrases) must include the Stop
											; 0: 1st Branch
											; 1: 2nd Branch
											; 2: Standart Bitmap
											; 3:
											; 4: Stop
BMP_PHRASES 	.equ    (BMP_WIDTH/PPP)		; Width in Phrases
BMP_LINES   	.equ    (BMP_HEIGHT*2)  	; Height in Half Scanlines
BITMAP_OFF  	.equ    (2*8)       		; Two Phrases

	
;************
;* 68000 CODE
;************
;
	.text
.if	"SMAC"==1
	.68000
.endif


;*********************
;* Program Entry Point
;*********************
;
_start:
_reset:	
_text_start:
;
; Clear BSS section
;
	move.l	#__bss_start__,a0
	move.l	#__bss_size__,d0
.bzero:
	clr.l	(a0)+
	subq.l	#4,d0
	bne.s	.bzero
;
; Jaguar registers initialisations
;
	move.l  #$70007,G_END								; Set Data Organisation Register (F0210C) in BigEndian 
	move.l  #$70007,D_END								; Set DSP Data Organisation Register (F1A10C) in BigEndian
	move.w  #$FFFF,VI									; Set the Vertical Interrupt (F0004E) very high to disable video interrupts
;
; Stack initilisations
;	
	move.l	#__Stack,a7									; Setup a stack
;
; Video initialisations
;
	jsr		InitVideo									; Setup video registers
	jsr		InitLister     								; Initialize Object Display List
;	jsr		InitVBint      								; Initialize the VBLANK routine
;
; Sneaky trick to cause display to popup at first VB
; d0.l comes from InitLister function
;
	move.l	#$0,listbuf+BITMAP_OFF						; ?
	move.l	#$C,listbuf+BITMAP_OFF+4					; ?
;
; Set GPU
;
	.if	SETGPU
	move.l  d0,olp2set      							; Pre-word-swapped address of current Objects List in d0.l (from InitLister function)
	move.l  #gSetOLP,G_PC   							; Set the GPU Program Counter (F02110)
	move.l  #RISCGO,G_CTRL			  					; Set the GPU Control/Status Register (F02114) to start the GPU (GPUGO is also used in the documentation)
;
.waitforset:
	move.l  G_CTRL,d0   								; Read the GPU Control/Status Register (F02114)
	andi.l  #$1,d0						
	bne.s 	.waitforset
	.else
	move.l	d0,OLP
	.endif									; Wait until the GPU has stopped
;
	move.w  #(VIDEN|RGB16|CSYNC|BGEN|PWIDTH4),VMODE     ; Configure video (F00028) to $6C7
;
; Pass information to monstartup
;
	.if PROFILE = 1
	pea.l	__text_end__		; text end
	pea.l	__text_start__		; text start
	jsr		monstartup
	addq.l	#8, sp
	.endif
;
; Pass argc and argv in stack and call main
;
	.if MAIN_C = 1
	pea.l	$0					; argv
	pea.l	$0					; argc
	.endif
	.if	UNDERSCORE_DEF	=	1
	jsr		_main
	.else
	jsr		main
	.endif
	.if MAIN_C = 1
	addq.l	#8, sp
	.endif
;
; Gmon cleanup
;
	.if PROFILE = 1
	jsr		_mcleanup
	.endif
;
; Exit
;
_exit:
	trap	#0
;
; return to game code (for some reason the code call this function right a the main() start)
;
___main:
	rts
	

;**********
;* GPU CODE
;**********
;
	.if	SETGPU
	.long
	.gpu
;
;***************************************************************************
;* Use the GPU to set the Objects List pointer (OLP) and stop the GPU
;*
;* Inputs: olp2set - Variable contains pre-swapped value to stuff OLP with
;*
;* Outputs : None
;*
;* NOTE!!!: This code can run in DRAM only because it contains no JUMP's or
;*          JR's. It will generate a warning with current versions of MADMAC
;*          because it doesn't '.ORG'.
;***************************************************************************
;
gSetOLP:
	movei   #olp2set,r0   		
	load    (r0),r1					; Get the pre-swapped Objects list pointer
	movei   #OLP,r0       		
	store   r1,(r0)					; Set the Object List Pointer (F00020) with the Objects list pointer
	moveq   #0,r0         		
	movei   #G_CTRL,r1
	store   r0,(r1)					; Clear the GPU Control/Status Register (F02114) to stop the GPU
	nop             				; Two "feet" on the brake pedal?
	nop
;
	.68000
	.bss
	.long
;
olp2set:    	.ds.l   1           ; GPU Code Parameter
;
;************
;* 68000 CODE
;************
;
	.text
	.endif


;**********************************************************
;* Install our vertical blank handler and enable interrupts
;*
;* Inputs: None
;*
;* Ouputs: None
;**********************************************************
;
InitVBint:
	move.l  d0,-(sp)				; Save registers
;
;setup CPU and vertical interruptions
;
	move.l  #UpdateList,LEVEL0		; Install the 68000 Level 0 Autovector Interrupt
	move.w  _a_vde,d0        		; Get vertical display end
	ori.w   #1,d0					; Must be ODD
	move.w  d0,VI					; Set the Vertical Interrupt (F0004E) based on the vertical display end
	move.w  #C_VIDENA,INT1         	; Set the CPU Interrupt Control Register (F000E0) to enable Video time-base interrupts
	move.w  sr,d0
	and.w   #$F8FF,d0       		; Lower 68k IPL to allow
	move.w  d0,sr           		; Interrupts
;
;end of function
;
	move.l  (sp)+,d0				; Load saved registers
	rts


;***********************
;* Video initialisations
;*
;* Inputs: None
;*
;* Outputs: None
;*
;* Registers: TBD
;***********************
;	
InitVideo:
;
	movem.l	d0-d6,-(sp)			; Save registers
;
; PAL/NTSC detection
;
	move.w	CONFIG,d0			; Read the Button register (F14002) also a joystick register
	andi.w	#VIDTYPE,d0			; 0=PAL,1=NTSC
	beq.s	.palvals
;
; Get values for NTSC (60Hz) [525 lines]
;
	move.w	#60,_vblPerSec
	move.w	#NTSC_HMID,d2
	move.w	#NTSC_WIDTH,d0
	move.w	#NTSC_VMID,d6
	move.w	#NTSC_HEIGHT,d4
	bra.s	.calc_vals
;
; Get values for PAL (50Hz) [625 lines]
;
.palvals:
	move.w	#50,_vblPerSec
	move.w	#PAL_HMID,d2
	move.w	#PAL_WIDTH,d0
	move.w	#PAL_VMID,d6
	move.w	#PAL_HEIGHT,d4
;
; Setup values depend PAL/NTSC
;
.calc_vals:
	move.w	d0,_video_width
	move.w	d4,_video_height
;
; Horizontal Display calculus
;
	move.w	d0,d1
	asr		#1,d1				; (Width/2) ~ NTSC = 1409/2 = 704 ~ PAL = 1381/2 = 690
	sub.w	d1,d2				; (HMid-(Width/2)) ~ NTSC = 823-704 = 119 ~ PAL = 843-690 = 153
	add.w	#4,d2				; (HMid-(Width/2))+4 ~ NTSC = 119+4 = 123 ~ PAL = 153+4 = 157
	sub.w	#1,d1				; (Width/2)-1 ~ NTSC = 704-1 = 703 ~ PAL = 690-1 = 689
	ori.w	#$400,d1			; (((Width/2)-1) | $400 or 1024) ~ NTSC = 703|$400 = 1727 ~ PAL = 689|$400 = 1713
	move.w	d1,_a_hde			
	move.w	d1,HDE				; Set the Horizontal Display End (F0003C) to 1727 (NTSC) or 1713 (PAL)
	move.w	d2,_a_hdb
	move.w	d2,HDB1				; Set the Horizontal Display Begin 1 (F00038) to 123 (NTSC) or 157 (PAL)
	move.w	d2,HDB2				; Set the Horizontal Display Begin 2 (F0003A) to 123 (NTSC) or 157 (PAL)
;
; Vertical Display calculus
;
	move.w	d6,d5
	sub.w	d4,d5				; (VMID-HEIGHT) ~ NTSC = 266-241 = 15 ~ PAL = 322-287 = 35
	move.w	d5,_a_vdb
	add.w	d4,d6				; (VMID+HEIGHT) ~ NTSC = 266+241 = 507 ~ PAL = 322+287 = 609
	move.w	d6,_a_vde
	move.w	d5,VDB				; Set the Vertical Display Begin (F00046) to 15 (NTSC) or 35 (PAL)
	move.w  #$FFFF,VDE			; Force the Vertical Display End (F00048)
;
; Set "basic" colors
;
	move.l	#0,BORD1			; Set the Border Colour (Red & Green - Blue) [F0002A] to 0
	move.l	#0,BG				; Set the Background Colour (F00058) to 0
;
; End of function
;
	movem.l	(sp)+,d0-d6			; Load saved registers
	rts


;******************************************************************
;* Initialize Object List Processor List
;*
;* Registers: d0.l/d1.l - Phrase being built
;*            d2.l/d3.l - Link address overlays
;*            d4.l      - Work register
;*            a0.l      - Roving object list pointer
;*
;* Outputs: Pre-word-swapped address of current object list in d0.l
;******************************************************************
;	
InitLister:
;
	movem.l d1-d4/a0,-(sp)									; Save registers
;
; Get Object List pointers
;			
	lea     listbuf,a0										; Get the Object List start address
	move.l  a0,d2
	add.l   #(LISTSIZE-1)*8,d2  							; Calcul the Object List STOP address
	move.l	d2,d3											; Copy for low half
	lsr.l	#8,d2											; Shift high half into place
	lsr.l	#3,d2
	swap	d3												; Place low half correctly
	clr.w	d3
	lsl.l	#5,d3
;
; Write first BRANCH object (branch if YPOS > a_vde )
;
	clr.l   d0
	move.l  #(BRANCHOBJ|O_BRLT),d1							; $4000 = VC < YPOS
	or.l	d2,d0											; Do LINK overlay
	or.l	d3,d1
	move.w  _a_vde,d4										; for YPOS
	lsl.w   #3,d4											; Make it bits 13-3
	or.w    d4,d1
	move.l	d0,(a0)+
	move.l	d1,(a0)+
;
; Write second branch object (branch if YPOS < a_vdb)
; Note: LINK address is the same so preserve it
;
	andi.l  #$FF000007,d1									; Mask off CC and YPOS
	ori.l   #O_BRGT,d1										; $8000 = VC > YPOS
	move.w  _a_vdb,d4										; for YPOS
	lsl.w   #3,d4											; Make it bits 13-3
	or.w    d4,d1
	move.l	d0,(a0)+
	move.l	d1,(a0)+
;
; Write a standard BITMAP object
;
	move.l	d2,d0
	move.l	d3,d1
	ori.l	#BMP_HEIGHT<<14,d1								; Height of image
	move.w  _video_height,d4								; Center bitmap vertically
	sub.w   #BMP_HEIGHT,d4
	add.w   _a_vdb,d4
	andi.w  #$FFFE,d4										; Must be even
	lsl.w   #3,d4
	or.w    d4,d1											; Stuff YPOS in low phrase
	move.l	#license,d4
	lsl.l	#8,d4
	or.l	d4,d0
	move.l	d0,(a0)+
	move.l	d1,(a0)+
	movem.l	d0-d1,bmpupdate
;
; Second Phrase of Bitmap
;
	move.l	#BMP_PHRASES>>4,d0								; Only part of top LONG is IWIDTH
	move.l  #O_DEPTH16|O_NOGAP,d1							; Bit Depth = 16-bit, Contiguous data
	move.w  _video_width,d4									; Get width in clocks
	lsr.w   #2,d4											; /4 Pixel Divisor
	sub.w   #BMP_WIDTH,d4
	lsr.w   #1,d4
	or.w    d4,d1
	ori.l	#(BMP_PHRASES<<18)|(BMP_PHRASES<<28),d1			; DWIDTH|IWIDTH
	move.l	d0,(a0)+
	move.l	d1,(a0)+
;
; Write a STOP object at end of the list
;
	clr.l   (a0)+
	move.l  #(STOPOBJ|O_STOPINTS),(a0)+
;
; Return swapped Objects list pointer in D0
;
	move.l  #listbuf,d0
	swap    d0
;
; End of function
;
	movem.l (sp)+,d1-d4/a0									;load saved registers
	rts


;****************************************************************************************
;* Handle Video Interrupt and update object list fields destroyed by the object processor
;*
;* Inputs: None
;*
;* Ouputs: None
;****************************************************************************************
;
UpdateList:
;
	move.l  a0,-(sp)						; Save register
;
;restore the BITMAP pointer in his dedicated Objects List
;
	move.l  #listbuf+BITMAP_OFF,a0
	move.l  bmpupdate,(a0)      			; Phrase = d1.l/d0.l
	move.l  bmpupdate+4,4(a0)
	add.l	#1,ticks						; Increment the vertical blank counter - number of interuptions encountered
	move.w  #$101,INT1      				; Set the CPU Interrupt Control Register (F000E0) - Signal we're done
	move.w  #$0,INT2						; Set the CPU Interrupt resume register (F000E2) - Bus priorities are restored
;
;end of function
;
	move.l  (sp)+,a0						; Load saved register
	rte


	.data
	.phrase
;	.even
;
license:		.ds.b	BMP_WIDTH*BMP_HEIGHT	;license_logo


	.bss
	.dphrase
;	.even
;
listbuf:		.ds.l	LISTSIZE*2  		; Objects List
	.even
bmpupdate:		.ds.l	2       			; One Phrase of Bitmap for Refresh
ticks:			.ds.l	1					; Incrementing # of ticks	
_a_hdb:			.ds.w	1
_a_hde:			.ds.w	1					; Horizontal display end
_a_vdb:			.ds.w	1
_a_vde:			.ds.w	1					; Vertical display end
_video_width:	.ds.w	1
_video_height:	.ds.w	1
_vblPerSec:		.ds.w	1


;*****
;* EOF
;*****
;
	.end