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

 Beetle EECS205BITMAP <32, 32, 255,, offset Beetle + sizeof Beetle>
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,064h,064h,064h,064h,064h,064h,0ffh,0ffh,064h,064h
	BYTE 064h,064h,0ffh,0ffh,064h,064h,064h,064h,064h,064h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,064h,064h,064h,064h,064h,064h,0ffh,0ffh,064h,064h
	BYTE 064h,064h,0ffh,0ffh,064h,064h,064h,064h,064h,064h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,064h,064h,0a9h,0a9h,0a9h,0a9h,0a9h,0a9h,064h,064h,0a9h,0a9h
	BYTE 0a9h,0a9h,064h,064h,0a9h,0a9h,0a9h,0a9h,0a9h,0a9h,064h,064h,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,064h,064h,0a9h,0a9h,0a9h,0a9h,0a9h,0a9h,064h,064h,0a9h,0a9h
	BYTE 0a9h,0a9h,064h,064h,0a9h,0a9h,0a9h,0a9h,0a9h,0a9h,064h,064h,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,064h,064h,0a9h,0a9h,0a9h,0a9h,0a9h,0a9h,0edh,0edh,044h,044h,0a9h,0a9h
	BYTE 0a9h,0a9h,044h,044h,0edh,0edh,0a9h,0a9h,0a9h,0a9h,0a9h,0a9h,064h,064h,0ffh,0ffh
	BYTE 0ffh,0ffh,064h,064h,0a9h,0a9h,0a9h,0a9h,0a9h,0a9h,0edh,0edh,044h,044h,0a9h,0a9h
	BYTE 0a9h,0a9h,044h,044h,0edh,0edh,0a9h,0a9h,0a9h,0a9h,0a9h,0a9h,064h,064h,0ffh,0ffh
	BYTE 0ffh,0ffh,064h,064h,0a9h,0a9h,0edh,0edh,0edh,0edh,064h,064h,044h,044h,0edh,0edh
	BYTE 0edh,0edh,044h,044h,064h,064h,0edh,0edh,0edh,0edh,0a9h,0a9h,064h,064h,0ffh,0ffh
	BYTE 0ffh,0ffh,064h,064h,0a9h,0a9h,0edh,0edh,0edh,0edh,064h,064h,044h,044h,0edh,0edh
	BYTE 0edh,0edh,044h,044h,064h,064h,0edh,0edh,0edh,0edh,0a9h,0a9h,064h,064h,0ffh,0ffh
	BYTE 064h,064h,0a9h,0a9h,0edh,0edh,064h,064h,044h,044h,044h,044h,064h,064h,0a9h,0a9h
	BYTE 0a9h,0a9h,064h,064h,044h,044h,044h,044h,064h,064h,0edh,0edh,0a9h,0a9h,064h,064h
	BYTE 064h,064h,0a9h,0a9h,0edh,0edh,064h,064h,044h,044h,044h,044h,064h,064h,0a9h,0a9h
	BYTE 0a9h,0a9h,064h,064h,044h,044h,044h,044h,064h,064h,0edh,0edh,0a9h,0a9h,064h,064h
	BYTE 064h,064h,064h,064h,044h,044h,044h,044h,029h,029h,064h,064h,0a9h,0a9h,064h,064h
	BYTE 064h,064h,0a9h,0a9h,064h,064h,029h,029h,044h,044h,044h,044h,064h,064h,064h,064h
	BYTE 064h,064h,064h,064h,044h,044h,044h,044h,029h,029h,064h,064h,0a9h,0a9h,064h,064h
	BYTE 064h,064h,0a9h,0a9h,064h,064h,029h,029h,044h,044h,044h,044h,064h,064h,064h,064h
	BYTE 0ffh,0ffh,0dbh,0dbh,092h,092h,052h,052h,029h,029h,044h,044h,05ah,05ah,0a9h,0a9h
	BYTE 0a9h,0a9h,05ah,05ah,044h,044h,029h,029h,052h,052h,092h,092h,0dbh,0dbh,0ffh,0ffh
	BYTE 0ffh,0ffh,0dbh,0dbh,092h,092h,052h,052h,029h,029h,044h,044h,05ah,05ah,0a9h,0a9h
	BYTE 0a9h,0a9h,05ah,05ah,044h,044h,029h,029h,052h,052h,092h,092h,0dbh,0dbh,0ffh,0ffh
	BYTE 0dbh,0dbh,092h,092h,052h,052h,092h,092h,092h,092h,044h,044h,031h,031h,0edh,0edh
	BYTE 0edh,0edh,031h,031h,044h,044h,092h,092h,092h,092h,052h,052h,092h,092h,0dbh,0dbh
	BYTE 0dbh,0dbh,092h,092h,052h,052h,092h,092h,092h,092h,044h,044h,031h,031h,0edh,0edh
	BYTE 0edh,0edh,031h,031h,044h,044h,092h,092h,092h,092h,052h,052h,092h,092h,0dbh,0dbh
	BYTE 0ffh,0ffh,0ffh,0ffh,0dbh,0dbh,0dbh,0dbh,064h,064h,064h,064h,044h,044h,064h,064h
	BYTE 064h,064h,044h,044h,064h,064h,064h,064h,0dbh,0dbh,0dbh,0dbh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0dbh,0dbh,0dbh,0dbh,064h,064h,064h,064h,044h,044h,064h,064h
	BYTE 064h,064h,044h,044h,064h,064h,064h,064h,0dbh,0dbh,0dbh,0dbh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,092h,092h,0dbh,0dbh,064h,064h,0ffh,0ffh,044h,044h
	BYTE 044h,044h,0ffh,0ffh,064h,064h,0dbh,0dbh,092h,092h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,092h,092h,0dbh,0dbh,064h,064h,0ffh,0ffh,044h,044h
	BYTE 044h,044h,0ffh,0ffh,064h,064h,0dbh,0dbh,092h,092h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,064h,064h,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,064h,064h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,064h,064h,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,064h,064h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,064h,064h,0ffh,0ffh
	BYTE 0ffh,0ffh,064h,064h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,064h,064h,0ffh,0ffh
	BYTE 0ffh,0ffh,064h,064h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,064h,064h,0ffh,0ffh
	BYTE 0ffh,0ffh,064h,064h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,064h,064h,0ffh,0ffh
	BYTE 0ffh,0ffh,064h,064h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh

 END
