; #########################################################################
;
;   game.inc - Includes for EECS205 Assignment 4/5
;
;
; #########################################################################

;; Library Definitions
MouseInfo STRUCT
 horiz		DWORD ?
 vert		DWORD ?
 buttons	DWORD ?
MouseInfo ENDS

;; Represents an enemy in the game
Enemy STRUCT
	X			DWORD	?	; Grid X Coordinate of enemy
	Y			DWORD	?	; Grid Y coordinate of enemy
	bmp			DWORD	?	; pointer to sprite for this bitmap
	health		DWORD	100	; enemy's remaining health
Enemy ENDS

;; Represents a mineral in the game
Mineral	STRUCT
	X			DWORD	?	; Grid X Coordinate of mineral
	Y			DWORD	?	; Grid Y Coordinate of mineral
	bmp			DWORD	?	; pointer to sprite for this mineral
	exist		DWORD	1	; 1 if not collected, 0 otherwise
	pts			DWORD	?	; point value
Mineral ENDS

MK_CONTROL  = 0008h  ;; The CTRL key is down.
MK_LBUTTON  = 0001h  ;; The left mouse button is down.
MK_MBUTTON  = 0010h  ;; The middle mouse button is down.
MK_RBUTTON  = 0002h  ;; The right mouse button is down.
MK_SHIFT    = 0004h  ;; The SHIFT key is down.
MK_XBUTTON1 = 0020h  ;; The first X button is down.
MK_XBUTTON2 = 0040h  ;; The second X button is down.

;; Library Functions
BlackStarField	PROTO
DrawStr PROTO myStr:PTR BYTE, x:DWORD, y:DWORD, color:DWORD

;; Library Data
EXTERNDEF StarBitmap:EECS205BITMAP
EXTERNDEF MouseStatus:MouseInfo
EXTERNDEF KeyUp:DWORD
EXTERNDEF KeyDown:DWORD
EXTERNDEF KeyPress:DWORD
EXTERNDEF AlexE:EECS205BITMAP
EXTERNDEF AlexN:EECS205BITMAP
EXTERNDEF AlexS:EECS205BITMAP
EXTERNDEF AlexW:EECS205BITMAP
EXTERNDEF Level:EECS205BITMAP
EXTERNDEF Amethyst:EECS205BITMAP
EXTERNDEF Aquamarine:EECS205BITMAP
EXTERNDEF Ruby:EECS205BITMAP
EXTERNDEF Topaz:EECS205BITMAP
EXTERNDEF Emerald:EECS205BITMAP
EXTERNDEF RockCrabActive:EECS205BITMAP
EXTERNDEF GameSword:EECS205BITMAP
EXTERNDEF Beetle:EECS205BITMAP
EXTERNDEF Display:EECS205BITMAP

;; User Defined Functions
GameInit PROTO
GamePlay PROTO
CheckIntersect PROTO oneX:DWORD, oneY:DWORD, oneBitmap:PTR EECS205BITMAP, twoX:DWORD, twoY:DWORD, twoBitmap:PTR EECS205BITMAP 
ClearScreen PROTO color_c:BYTE
DrawBackground PROTO
NormalizeScreenValues PROTO
CalcPlayerPos PROTO
DrawPlayer PROTO
Move PROTO
InitMinerals PROTO
DrawMinerals PROTO
CalcScreenX PROTO pos:DWORD
CalcScreenY PROTO pos:DWORD
FixIntersections PROTO
MoveBackground PROTO
PickUp PROTO
DrawEnemies PROTO
InitEnemies PROTO
FindEnemyAtLoc PROTO x:DWORD, y:DWORD
FindMineralAtLoc PROTO x:DWORD, y:DWORD
Strike PROTO
MoveEnemies PROTO
CheckIntersectPlayer PROTO x:DWORD, y:DWORD
CheckIntersectAny PROTO x:DWORD, y:DWORD
EnemyStrike PROTO
CheckPause PROTO
DrawDisplay PROTO
FixStats PROTO
CheckWinLose PROTO