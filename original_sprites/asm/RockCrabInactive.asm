.586
.MODEL FLAT,STDCALL
.STACK 4096
option casemap :none  ; case sensitive

include stars.inc
include lines.inc
include trig.inc
include blit.inc
include game.inc

.DATA

 RockCrabInactive EECS205BITMAP <32, 32, 255,, offset RockCrabInactive + sizeof RockCrabInactive>
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,044h,044h
	BYTE 044h,044h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,044h,044h
	BYTE 044h,044h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,044h,044h,044h,044h,089h,089h
	BYTE 069h,069h,044h,044h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,044h,044h,044h,044h,089h,089h
	BYTE 069h,069h,044h,044h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,044h,044h,044h,044h,089h,089h,069h,069h
	BYTE 089h,089h,089h,089h,044h,044h,044h,044h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,044h,044h,044h,044h,089h,089h,069h,069h
	BYTE 089h,089h,089h,089h,044h,044h,044h,044h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,020h,020h,044h,044h,069h,069h,069h,069h,089h,089h
	BYTE 089h,089h,08dh,08dh,089h,089h,069h,069h,044h,044h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,020h,020h,044h,044h,069h,069h,069h,069h,089h,089h
	BYTE 089h,089h,08dh,08dh,089h,089h,069h,069h,044h,044h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,020h,020h,044h,044h,044h,044h,069h,069h,089h,089h,089h,089h
	BYTE 089h,089h,089h,089h,08dh,08dh,089h,089h,089h,089h,044h,044h,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,020h,020h,044h,044h,044h,044h,069h,069h,089h,089h,089h,089h
	BYTE 089h,089h,089h,089h,08dh,08dh,089h,089h,089h,089h,044h,044h,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,020h,020h,044h,044h,044h,044h,069h,069h,069h,069h,069h,069h,089h,089h
	BYTE 089h,089h,089h,089h,089h,089h,089h,089h,089h,089h,089h,089h,044h,044h,0ffh,0ffh
	BYTE 0ffh,0ffh,020h,020h,044h,044h,044h,044h,069h,069h,069h,069h,069h,069h,089h,089h
	BYTE 089h,089h,089h,089h,089h,089h,089h,089h,089h,089h,089h,089h,044h,044h,0ffh,0ffh
	BYTE 020h,020h,044h,044h,044h,044h,044h,044h,044h,044h,069h,069h,069h,069h,069h,069h
	BYTE 089h,089h,089h,089h,089h,089h,089h,089h,069h,069h,08dh,08dh,089h,089h,044h,044h
	BYTE 020h,020h,044h,044h,044h,044h,044h,044h,044h,044h,069h,069h,069h,069h,069h,069h
	BYTE 089h,089h,089h,089h,089h,089h,089h,089h,069h,069h,08dh,08dh,089h,089h,044h,044h
	BYTE 020h,020h,044h,044h,044h,044h,044h,044h,044h,044h,044h,044h,069h,069h,089h,089h
	BYTE 069h,069h,089h,089h,089h,089h,069h,069h,089h,089h,089h,089h,08dh,08dh,044h,044h
	BYTE 020h,020h,044h,044h,044h,044h,044h,044h,044h,044h,044h,044h,069h,069h,089h,089h
	BYTE 069h,069h,089h,089h,089h,089h,069h,069h,089h,089h,089h,089h,08dh,08dh,044h,044h
	BYTE 020h,020h,044h,044h,044h,044h,044h,044h,044h,044h,044h,044h,069h,069h,069h,069h
	BYTE 089h,089h,069h,069h,069h,069h,044h,044h,089h,089h,069h,069h,089h,089h,020h,020h
	BYTE 020h,020h,044h,044h,044h,044h,044h,044h,044h,044h,044h,044h,069h,069h,069h,069h
	BYTE 089h,089h,069h,069h,069h,069h,044h,044h,089h,089h,069h,069h,089h,089h,020h,020h
	BYTE 0b6h,0b6h,020h,020h,044h,044h,044h,044h,044h,044h,044h,044h,044h,044h,044h,044h
	BYTE 069h,069h,069h,069h,069h,069h,069h,069h,044h,044h,044h,044h,020h,020h,0ffh,0ffh
	BYTE 0b6h,0b6h,020h,020h,044h,044h,044h,044h,044h,044h,044h,044h,044h,044h,044h,044h
	BYTE 069h,069h,069h,069h,069h,069h,069h,069h,044h,044h,044h,044h,020h,020h,0ffh,0ffh
	BYTE 0ffh,0ffh,0b6h,0b6h,020h,020h,020h,020h,044h,044h,044h,044h,044h,044h,044h,044h
	BYTE 044h,044h,044h,044h,069h,069h,044h,044h,020h,020h,020h,020h,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0b6h,0b6h,020h,020h,020h,020h,044h,044h,044h,044h,044h,044h,044h,044h
	BYTE 044h,044h,044h,044h,069h,069h,044h,044h,020h,020h,020h,020h,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0b6h,0b6h,0b6h,0b6h,020h,020h,044h,044h,044h,044h,044h,044h
	BYTE 044h,044h,044h,044h,020h,020h,020h,020h,044h,044h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0b6h,0b6h,0b6h,0b6h,020h,020h,044h,044h,044h,044h,044h,044h
	BYTE 044h,044h,044h,044h,020h,020h,020h,020h,044h,044h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0b6h,0b6h,020h,020h,020h,020h,020h,020h
	BYTE 020h,020h,020h,020h,044h,044h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0b6h,0b6h,020h,020h,020h,020h,020h,020h
	BYTE 020h,020h,020h,020h,044h,044h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh

 END
