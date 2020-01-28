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

 AlexW EECS205BITMAP <32, 64, 255,, offset AlexW + sizeof AlexW>
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
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,064h,064h
	BYTE 040h,040h,040h,040h,020h,020h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,064h,064h
	BYTE 040h,040h,040h,040h,020h,020h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,064h,064h,064h,064h,0a8h,0a8h
	BYTE 0a8h,0a8h,084h,084h,040h,040h,020h,020h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,064h,064h,064h,064h,0a8h,0a8h
	BYTE 0a8h,0a8h,084h,084h,040h,040h,020h,020h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,064h,064h,0a8h,0a8h,0a8h,0a8h,0a8h,0a8h
	BYTE 084h,084h,084h,084h,064h,064h,040h,040h,020h,020h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,064h,064h,0a8h,0a8h,0a8h,0a8h,0a8h,0a8h
	BYTE 084h,084h,084h,084h,064h,064h,040h,040h,020h,020h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,064h,064h,0a8h,0a8h,0a8h,0a8h,040h,040h,084h,084h
	BYTE 084h,084h,064h,064h,084h,084h,064h,064h,040h,040h,020h,020h,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,064h,064h,0a8h,0a8h,0a8h,0a8h,040h,040h,084h,084h
	BYTE 084h,084h,064h,064h,084h,084h,064h,064h,040h,040h,020h,020h,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,064h,064h,0a8h,0a8h,040h,040h,064h,064h,040h,040h
	BYTE 064h,064h,084h,084h,064h,064h,064h,064h,064h,064h,020h,020h,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,064h,064h,0a8h,0a8h,040h,040h,064h,064h,040h,040h
	BYTE 064h,064h,084h,084h,064h,064h,064h,064h,064h,064h,020h,020h,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,064h,064h,0a8h,0a8h,040h,040h,064h,064h,0d1h,0d1h,0d1h,0d1h
	BYTE 040h,040h,064h,064h,040h,040h,064h,064h,064h,064h,020h,020h,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,064h,064h,0a8h,0a8h,040h,040h,064h,064h,0d1h,0d1h,0d1h,0d1h
	BYTE 040h,040h,064h,064h,040h,040h,064h,064h,064h,064h,020h,020h,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,064h,064h,040h,040h,0d1h,0d1h,020h,020h,020h,020h
	BYTE 0d1h,0d1h,040h,040h,0d1h,0d1h,040h,040h,064h,064h,020h,020h,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,064h,064h,040h,040h,0d1h,0d1h,020h,020h,020h,020h
	BYTE 0d1h,0d1h,040h,040h,0d1h,0d1h,040h,040h,064h,064h,020h,020h,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,064h,064h,0fah,0fah,004h,004h,096h,096h
	BYTE 0fah,0fah,0d1h,0d1h,0fah,0fah,040h,040h,064h,064h,020h,020h,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,064h,064h,0fah,0fah,004h,004h,096h,096h
	BYTE 0fah,0fah,0d1h,0d1h,0fah,0fah,040h,040h,064h,064h,020h,020h,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,064h,064h,0fah,0fah,0fah,0fah,00ch,00ch,0ffh,0ffh
	BYTE 0fah,0fah,0fah,0fah,0fah,0fah,040h,040h,040h,040h,020h,020h,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,064h,064h,0fah,0fah,0fah,0fah,00ch,00ch,0ffh,0ffh
	BYTE 0fah,0fah,0fah,0fah,0fah,0fah,040h,040h,040h,040h,020h,020h,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,064h,064h,0fah,0fah,0fah,0fah,0fah,0fah
	BYTE 0fah,0fah,0fah,0fah,040h,040h,040h,040h,020h,020h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,064h,064h,0fah,0fah,0fah,0fah,0fah,0fah
	BYTE 0fah,0fah,0fah,0fah,040h,040h,040h,040h,020h,020h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,064h,064h,0fah,0fah,0fah,0fah
	BYTE 0fah,0fah,0d1h,0d1h,020h,020h,020h,020h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,064h,064h,0fah,0fah,0fah,0fah
	BYTE 0fah,0fah,0d1h,0d1h,020h,020h,020h,020h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,064h,064h,064h,064h
	BYTE 0d1h,0d1h,028h,028h,040h,040h,004h,004h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,064h,064h,064h,064h
	BYTE 0d1h,0d1h,028h,028h,040h,040h,004h,004h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,004h,004h,028h,028h
	BYTE 0b4h,0b4h,004h,004h,0b4h,0b4h,0f8h,0f8h,004h,004h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,004h,004h,028h,028h
	BYTE 0b4h,0b4h,004h,004h,0b4h,0b4h,0f8h,0f8h,004h,004h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,004h,004h,050h,050h
	BYTE 028h,028h,050h,050h,050h,050h,0f8h,0f8h,004h,004h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,004h,004h,050h,050h
	BYTE 028h,028h,050h,050h,050h,050h,0f8h,0f8h,004h,004h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,004h,004h,028h,028h,0f8h,0f8h
	BYTE 028h,028h,050h,050h,050h,050h,028h,028h,0f8h,0f8h,004h,004h,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,004h,004h,028h,028h,0f8h,0f8h
	BYTE 028h,028h,050h,050h,050h,050h,028h,028h,0f8h,0f8h,004h,004h,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,004h,004h,050h,050h,004h,004h
	BYTE 050h,050h,050h,050h,004h,004h,050h,050h,028h,028h,004h,004h,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,004h,004h,050h,050h,004h,004h
	BYTE 050h,050h,050h,050h,004h,004h,050h,050h,028h,028h,004h,004h,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,004h,004h,004h,004h,050h,050h,0b4h,0b4h
	BYTE 050h,050h,050h,050h,004h,004h,050h,050h,050h,050h,004h,004h,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,004h,004h,004h,004h,050h,050h,0b4h,0b4h
	BYTE 050h,050h,050h,050h,004h,004h,050h,050h,050h,050h,004h,004h,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,004h,004h,004h,004h,028h,028h,004h,004h
	BYTE 050h,050h,028h,028h,004h,004h,050h,050h,050h,050h,004h,004h,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,004h,004h,004h,004h,028h,028h,004h,004h
	BYTE 050h,050h,028h,028h,004h,004h,050h,050h,050h,050h,004h,004h,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,004h,004h,004h,004h,028h,028h,0b4h,0b4h
	BYTE 050h,050h,028h,028h,004h,004h,050h,050h,028h,028h,004h,004h,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,004h,004h,004h,004h,028h,028h,0b4h,0b4h
	BYTE 050h,050h,028h,028h,004h,004h,050h,050h,028h,028h,004h,004h,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,064h,064h,004h,004h,004h,004h,004h,004h
	BYTE 004h,004h,004h,004h,004h,004h,028h,028h,028h,028h,004h,004h,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,064h,064h,004h,004h,004h,004h,004h,004h
	BYTE 004h,004h,004h,004h,004h,004h,028h,028h,028h,028h,004h,004h,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,064h,064h,0d1h,0d1h,004h,004h,026h,026h
	BYTE 026h,026h,026h,026h,0d1h,0d1h,0fah,0fah,0d1h,0d1h,064h,064h,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,064h,064h,0d1h,0d1h,004h,004h,026h,026h
	BYTE 026h,026h,026h,026h,0d1h,0d1h,0fah,0fah,0d1h,0d1h,064h,064h,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,064h,064h,000h,000h,04ah,04ah
	BYTE 04ah,04ah,026h,026h,064h,064h,0fah,0fah,0fah,0fah,064h,064h,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,064h,064h,000h,000h,04ah,04ah
	BYTE 04ah,04ah,026h,026h,064h,064h,0fah,0fah,0fah,0fah,064h,064h,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,000h,000h,04ah,04ah
	BYTE 000h,000h,026h,026h,026h,026h,0d1h,0d1h,064h,064h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,000h,000h,04ah,04ah
	BYTE 000h,000h,026h,026h,026h,026h,0d1h,0d1h,064h,064h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,000h,000h,04ah,04ah
	BYTE 000h,000h,04ah,04ah,026h,026h,000h,000h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,000h,000h,04ah,04ah
	BYTE 000h,000h,04ah,04ah,026h,026h,000h,000h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,000h,000h,04ah,04ah
	BYTE 000h,000h,04ah,04ah,026h,026h,000h,000h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,000h,000h,04ah,04ah
	BYTE 000h,000h,04ah,04ah,026h,026h,000h,000h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,000h,000h,04ah,04ah
	BYTE 000h,000h,04ah,04ah,026h,026h,000h,000h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,000h,000h,04ah,04ah
	BYTE 000h,000h,04ah,04ah,026h,026h,000h,000h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,024h,024h,0b6h,0b6h,0fah,0fah
	BYTE 024h,024h,0fah,0fah,06eh,06eh,024h,024h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,024h,024h,0b6h,0b6h,0fah,0fah
	BYTE 024h,024h,0fah,0fah,06eh,06eh,024h,024h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,024h,024h,06eh,06eh,0fah,0fah,024h,024h
	BYTE 0fah,0fah,0b6h,0b6h,06eh,06eh,024h,024h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,024h,024h,06eh,06eh,0fah,0fah,024h,024h
	BYTE 0fah,0fah,0b6h,0b6h,06eh,06eh,024h,024h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,024h,024h,024h,024h,024h,024h,024h,024h
	BYTE 024h,024h,024h,024h,024h,024h,024h,024h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,024h,024h,024h,024h,024h,024h,024h,024h
	BYTE 024h,024h,024h,024h,024h,024h,024h,024h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh

 END