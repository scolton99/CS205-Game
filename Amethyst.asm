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

 Amethyst EECS205BITMAP <32, 32, 255,, offset Amethyst + sizeof Amethyst>
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
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,021h,021h,021h,021h,0ffh,0ffh,021h,021h
	BYTE 021h,021h,021h,021h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,021h,021h,021h,021h,0ffh,0ffh,021h,021h
	BYTE 021h,021h,021h,021h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,021h,021h,087h,087h,087h,087h,021h,021h,042h,042h
	BYTE 046h,046h,067h,067h,021h,021h,042h,042h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,021h,021h,087h,087h,087h,087h,021h,021h,042h,042h
	BYTE 046h,046h,067h,067h,021h,021h,042h,042h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,021h,021h,087h,087h,0abh,0abh,0abh,0abh,042h,042h,046h,046h
	BYTE 087h,087h,0abh,0abh,0afh,0afh,067h,067h,042h,042h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,021h,021h,087h,087h,0abh,0abh,0abh,0abh,042h,042h,046h,046h
	BYTE 087h,087h,0abh,0abh,0afh,0afh,067h,067h,042h,042h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,021h,021h,067h,067h,087h,087h,067h,067h,042h,042h,067h,067h
	BYTE 087h,087h,0afh,0afh,0d7h,0d7h,0afh,0afh,021h,021h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,021h,021h,067h,067h,087h,087h,067h,067h,042h,042h,067h,067h
	BYTE 087h,087h,0afh,0afh,0d7h,0d7h,0afh,0afh,021h,021h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,021h,021h,042h,042h,046h,046h,046h,046h,042h,042h,046h,046h
	BYTE 087h,087h,0abh,0abh,0afh,0afh,0abh,0abh,087h,087h,021h,021h,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,021h,021h,042h,042h,046h,046h,046h,046h,042h,042h,046h,046h
	BYTE 087h,087h,0abh,0abh,0afh,0afh,0abh,0abh,087h,087h,021h,021h,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,021h,021h,046h,046h,067h,067h,0abh,0abh,0afh,0afh,0abh,0abh,042h,042h
	BYTE 046h,046h,087h,087h,087h,087h,087h,087h,067h,067h,046h,046h,021h,021h,0ffh,0ffh
	BYTE 0ffh,0ffh,021h,021h,046h,046h,067h,067h,0abh,0abh,0afh,0afh,0abh,0abh,042h,042h
	BYTE 046h,046h,087h,087h,087h,087h,087h,087h,067h,067h,046h,046h,021h,021h,0ffh,0ffh
	BYTE 0ffh,0ffh,021h,021h,046h,046h,087h,087h,0afh,0afh,0d7h,0d7h,0afh,0afh,046h,046h
	BYTE 042h,042h,046h,046h,067h,067h,067h,067h,067h,067h,042h,042h,021h,021h,0ffh,0ffh
	BYTE 0ffh,0ffh,021h,021h,046h,046h,087h,087h,0afh,0afh,0d7h,0d7h,0afh,0afh,046h,046h
	BYTE 042h,042h,046h,046h,067h,067h,067h,067h,067h,067h,042h,042h,021h,021h,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,021h,021h,067h,067h,0abh,0abh,0afh,0afh,0abh,0abh,0abh,0abh
	BYTE 067h,067h,042h,042h,046h,046h,046h,046h,042h,042h,021h,021h,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,021h,021h,067h,067h,0abh,0abh,0afh,0afh,0abh,0abh,0abh,0abh
	BYTE 067h,067h,042h,042h,046h,046h,046h,046h,042h,042h,021h,021h,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,021h,021h,021h,021h,042h,042h,087h,087h,087h,087h
	BYTE 087h,087h,042h,042h,042h,042h,021h,021h,021h,021h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,021h,021h,021h,021h,042h,042h,087h,087h,087h,087h
	BYTE 087h,087h,042h,042h,042h,042h,021h,021h,021h,021h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,021h,021h,046h,046h,067h,067h
	BYTE 046h,046h,042h,042h,021h,021h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,021h,021h,046h,046h,067h,067h
	BYTE 046h,046h,042h,042h,021h,021h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,021h,021h,021h,021h
	BYTE 021h,021h,021h,021h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,021h,021h,021h,021h
	BYTE 021h,021h,021h,021h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
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

 END
