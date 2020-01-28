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

 RockCrabActive EECS205BITMAP <32, 32, 255,, offset RockCrabActive + sizeof RockCrabActive>
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,044h,044h
	BYTE 044h,044h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,044h,044h
	BYTE 044h,044h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,044h,044h,044h,089h,089h
	BYTE 069h,069h,044h,044h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,044h,044h,044h,089h,089h
	BYTE 069h,069h,044h,044h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,044h,044h,044h,044h,089h,069h,069h
	BYTE 089h,089h,089h,089h,044h,044h,044h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,020h,020h,044h,044h,069h,069h,069h,089h,089h
	BYTE 089h,089h,08dh,08dh,089h,089h,069h,044h,044h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,020h,020h,044h,044h,069h,069h,069h,089h,089h
	BYTE 089h,089h,08dh,08dh,089h,089h,069h,044h,044h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,020h,044h,044h,044h,044h,069h,069h,089h,089h,089h
	BYTE 089h,089h,089h,089h,08dh,08dh,089h,089h,089h,044h,044h,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,020h,044h,044h,044h,044h,069h,069h,089h,089h,089h
	BYTE 089h,089h,089h,089h,08dh,08dh,089h,089h,089h,044h,044h,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,020h,020h,044h,044h,044h,069h,069h,069h,069h,069h,089h,089h
	BYTE 089h,089h,089h,089h,089h,089h,089h,089h,089h,089h,089h,044h,044h,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,020h,020h,044h,044h,044h,069h,069h,069h,069h,069h,089h,089h
	BYTE 089h,089h,089h,089h,089h,089h,089h,089h,089h,089h,089h,044h,044h,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,020h,020h,044h,044h,044h,044h,044h,044h,044h,069h,069h,069h,069h,069h
	BYTE 089h,089h,089h,089h,089h,089h,089h,069h,069h,08dh,08dh,089h,089h,044h,0ffh,0ffh
	BYTE 0ffh,0ffh,020h,020h,044h,044h,044h,044h,044h,044h,044h,044h,044h,069h,089h,089h
	BYTE 069h,069h,089h,089h,089h,089h,069h,089h,089h,089h,089h,08dh,08dh,044h,0ffh,0ffh
	BYTE 0ffh,0ffh,020h,020h,044h,044h,044h,044h,044h,044h,044h,044h,044h,069h,089h,089h
	BYTE 069h,069h,089h,089h,089h,089h,069h,089h,089h,089h,089h,08dh,08dh,044h,0ffh,0ffh
	BYTE 0ffh,0ffh,020h,020h,044h,044h,044h,044h,044h,044h,044h,044h,044h,069h,069h,069h
	BYTE 089h,089h,069h,069h,069h,069h,044h,089h,089h,069h,069h,089h,089h,020h,0ffh,0ffh
	BYTE 0ffh,0ffh,020h,020h,044h,044h,044h,044h,044h,044h,044h,044h,044h,069h,069h,069h
	BYTE 089h,089h,069h,069h,069h,069h,044h,089h,089h,069h,069h,089h,089h,020h,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,020h,020h,044h,044h,044h,044h,044h,044h,044h,044h,044h,044h
	BYTE 069h,069h,069h,069h,069h,069h,069h,044h,044h,044h,044h,020h,020h,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,020h,020h,044h,044h,044h,044h,044h,044h,044h,044h,044h,044h
	BYTE 069h,069h,069h,069h,069h,069h,069h,044h,044h,044h,044h,020h,020h,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,040h,040h,020h,020h,020h,044h,044h,044h,044h,044h,044h,044h
	BYTE 044h,044h,044h,044h,069h,069h,044h,020h,020h,020h,020h,040h,040h,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,040h,040h,020h,020h,020h,044h,044h,044h,044h,044h,044h,044h
	BYTE 044h,044h,044h,044h,069h,069h,044h,020h,020h,020h,020h,040h,040h,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,040h,040h,0ech,0ech,084h,040h,040h,020h,020h,044h,044h,044h,044h,044h
	BYTE 044h,044h,044h,044h,020h,020h,020h,044h,044h,084h,084h,0ech,0ech,040h,0ffh,0ffh
	BYTE 0ffh,0ffh,040h,040h,0a8h,0a8h,040h,084h,084h,084h,084h,020h,020h,020h,020h,020h
	BYTE 020h,020h,020h,020h,044h,044h,084h,0ech,0ech,040h,040h,0a8h,0a8h,040h,0ffh,0ffh
	BYTE 0ffh,0ffh,040h,040h,0a8h,0a8h,040h,084h,084h,084h,084h,020h,020h,020h,020h,020h
	BYTE 020h,020h,020h,020h,044h,044h,084h,0ech,0ech,040h,040h,0a8h,0a8h,040h,0ffh,0ffh
	BYTE 0ffh,0ffh,040h,040h,0a8h,0a8h,040h,0a8h,0a8h,040h,040h,0a8h,0a8h,000h,084h,084h
	BYTE 000h,000h,0a8h,0a8h,040h,040h,0a8h,0ech,0ech,040h,040h,084h,084h,040h,0ffh,0ffh
	BYTE 0ffh,0ffh,040h,040h,0a8h,0a8h,040h,0a8h,0a8h,040h,040h,0a8h,0a8h,000h,084h,084h
	BYTE 000h,000h,0a8h,0a8h,040h,040h,0a8h,0ech,0ech,040h,040h,084h,084h,040h,0ffh,0ffh
	BYTE 0ffh,0ffh,0b6h,0b6h,040h,040h,0b6h,040h,040h,0ech,0ech,040h,040h,084h,0a8h,0a8h
	BYTE 084h,084h,040h,040h,0b6h,0b6h,040h,0a8h,0a8h,040h,040h,040h,040h,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0b6h,0b6h,040h,040h,0b6h,040h,040h,0ech,0ech,040h,040h,084h,0a8h,0a8h
	BYTE 084h,084h,040h,040h,0b6h,0b6h,040h,0a8h,0a8h,040h,040h,040h,040h,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0b6h,0b6h,0b6h,040h,040h,0a8h,0a8h,040h,040h,040h,0a8h,0a8h
	BYTE 040h,040h,0b6h,0b6h,0b6h,0b6h,040h,0a8h,0a8h,040h,040h,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0b6h,0b6h,040h,0a8h,0a8h,084h,084h,040h,040h,0b6h,040h,040h
	BYTE 0b6h,0b6h,0b6h,0b6h,0b6h,0b6h,040h,084h,084h,0ech,0ech,040h,040h,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0b6h,0b6h,040h,0a8h,0a8h,084h,084h,040h,040h,0b6h,040h,040h
	BYTE 0b6h,0b6h,0b6h,0b6h,0b6h,0b6h,040h,084h,084h,0ech,0ech,040h,040h,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0b6h,040h,040h,040h,040h,0ffh,0ffh,0b6h,0b6h,0b6h
	BYTE 0b6h,0b6h,0b6h,0b6h,0ffh,0ffh,0ffh,040h,040h,040h,040h,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0b6h,040h,040h,040h,040h,0ffh,0ffh,0b6h,0b6h,0b6h
	BYTE 0b6h,0b6h,0b6h,0b6h,0ffh,0ffh,0ffh,040h,040h,040h,040h,0ffh,0ffh,0ffh,0ffh,0ffh

 END
