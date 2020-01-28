; #########################################################################
;
;   game.asm - Assembly file for EECS205 Assignment 4/5
;
;
; #########################################################################

.586
.MODEL FLAT,STDCALL
.STACK 4096
option casemap :none

include stars.inc
include lines.inc
include trig.inc
include blit.inc
include game.inc
include keys.inc

include		\masm32\include\windows.inc
include		\masm32\include\winmm.inc
include		\masm32\include\user32.inc
include		\masm32\include\masm32.inc
includelib	\masm32\lib\winmm.lib
includelib	\masm32\lib\user32.lib
includelib	\masm32\lib\masm32.lib

;; Global variables
.DATA
	PLAYERX			DWORD				0						; Player's Grid X position
	PLAYERY			DWORD				0						; Player's Grid Y position
	MUSIC_PATH		BYTE				"CaveMusic.wav",0		; Path to music file
	PLAYER_SPRITE	DWORD				?						; pointer to current player sprite
	HEALTH_STR_P	BYTE				"Health: %d",0			; String template to show health
	SCORE_STR_P		BYTE				"Score: %d",0			; String template to show score
	HEALTH_STR		BYTE				100 DUP(?)				; Resultant health string
	SCORE_STR		BYTE				100 DUP(?)				; Resultant score string
	SCREENX			DWORD				-8						; Starting value for background shift x
	SCREENY			DWORD				-3						; Starting value for background shift y
	CSCREENX		DWORD				0						; "Real" value for background shift x
	CSCREENY		DWORD				0						; "Real" value for background shift y
	HI_BG_X_SHIFT	DWORD				10						; Max background shift x (Grid)
	LO_BG_X_SHIFT	DWORD				0						; Min background shift x (Grid)
	HI_BG_Y_SHIFT	DWORD				9						; Max background shift y (Grid)
	LO_BG_Y_SHIFT	DWORD				0						; Min background shift y (Grid)
	PLAYER_X_START	DWORD				48						; Player starting X position
	PLAYER_Y_START	DWORD				128						; Player starting Y position
	PLAYER_X_MIN	DWORD				0						; Player min grid X
	PLAYER_X_MAX	DWORD				27						; Player max grid X
	PLAYER_Y_MIN	DWORD				0						; Player min grid Y
	PLAYER_Y_MAX	DWORD				17						; Player max grid Y
	PLAYERX_REAL	DWORD				?						; Player X coordinate
	PLAYERY_REAL	DWORD				?						; Player Y coordinate
	MINERALS		Mineral				504 DUP(<>)				; Array of all minerals in game
	NUM_MINERALS	DWORD				0						; Number of minerals placed
	PRB_VAL			DWORD				2500					; Probability value for minerals
	PAUSED			DWORD				0						; Paused state
	PLAYERMOVOK		DWORD				1						; Was the player's most recent move attempt allowed?
	SCORE			DWORD				0						; Player score
	HEALTH			DWORD				100						; Player health
	ENEMIES			Enemy				504 DUP(<>)				; Array of all enemies in game
	NUM_ENEMIES		DWORD				0						; Number of spawned enemies
	MINERALS_TC		DWORD				?						; Minerals left to collect
	WIN_STR			BYTE				"You Win!",0			; Win message
	LOSE_STR		BYTE				"You Lose :(",0			; Lose message
	PAUSED_STR		BYTE				"Game Paused",0			; Paused message
	STRICKEN		DWORD				0						; Whether or not the player was attacked this tick

.CODE

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; GameInit
;;;
;;; Initialize all values required for the proper operation of the game
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
GameInit PROC USES eax
	invoke PlaySound, OFFSET MUSIC_PATH, 0, SND_LOOP OR SND_ASYNC OR SND_FILENAME

	mov PLAYER_SPRITE, OFFSET AlexS		; Set initial direction to facing South

	; Set random seed
	rdtsc
	invoke nseed, eax
	xor edx, edx

	; Setup random distributions of rewards and enemies
	invoke InitMinerals
	invoke InitEnemies

	ret
GameInit ENDP

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; GamePlay
;;;
;;; High-level iteration through all game tasks that need to be run per-tick
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
GamePlay PROC
	; Reset values from last tick
	mov PLAYERMOVOK, 1
	mov	STRICKEN, 0

	invoke ClearScreen, 000h

	; Check to see if player has won or lost
	invoke CheckWinLose
	cmp eax, 0
	je game_run
	cmp eax, 1
	je win
	jmp lose
win:
	; Show winning screen
	invoke ClearScreen, 1b
	invoke DrawStr, OFFSET WIN_STR, 260, 200, 0ffh
	invoke DrawStr, OFFSET SCORE_STR, 260, 220, 0ffh
	ret
lose:
	; Show losing screen
	invoke ClearScreen, 1b
	invoke DrawStr, OFFSET LOSE_STR, 260, 200, 0ffh
	invoke DrawStr, OFFSET SCORE_STR, 260, 220, 0ffh
	ret

game_run:
	; Check to see if the pause key is pressed
	invoke CheckPause

	cmp PAUSED, 1
	jne cont

	; If paused, show the pause screen
	invoke ClearScreen, 1b
	invoke DrawStr, OFFSET PAUSED_STR, 260, 200, 0ffh

	ret
cont:
	
	; Move the player if keys are pressed
	invoke Move

	; If player is colliding with anything, move them back
	invoke FixIntersections

	; Shift the background as appropriate for the player's movements
	invoke MoveBackground

	; Clamp actual screen shift values between 0 and HI_BK_SHIFT_[x,y]
	invoke NormalizeScreenValues

	; Enemy AI
	invoke MoveEnemies

	; If health or score is negative, reset to 0
	invoke FixStats

	; Draw the background
	invoke DrawBackground

	; Draw all minerals that haven't been collected
	invoke DrawMinerals

	; Draw all enemies that are alive
	invoke DrawEnemies

	; Draw the player facing the correct direction
	invoke DrawPlayer

	; Show score and health
	invoke DrawDisplay

	cmp STRICKEN, 1
	jne next
	; If the user was hit this tick, show a sword on them
	invoke BasicBlit, OFFSET GameSword, PLAYERX_REAL, PLAYERY_REAL
next:

	; Check for space bar pressed
	; If pressed and facing mineral, pick it up
	invoke PickUp
	; If pressed and facing enemy, attack it
	invoke Strike

	ret
GamePlay ENDP

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; CheckWinLose
;;;
;;; Check global values to see if the player has won, lost, or neither
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
CheckWinLose PROC
	; If no minerals remain to collect, player won
	cmp MINERALS_TC, 0
	je won

	; If health is 0, player lost
	cmp HEALTH, 0
	jle lost

	mov eax, 0
	ret

lost:
	mov eax, -1
	ret

won:
	mov eax, 1
	ret
CheckWinLose ENDP

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; FixStats
;;;
;;; Eliminate negative score or health values
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
FixStats PROC
	cmp SCORE, 0
	jge scoreok
	mov SCORE, 0
scoreok:
	cmp HEALTH, 0
	jge healthok
	mov HEALTH, 0
healthok:
	ret
FixStats ENDP

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; DrawDisplay
;;;
;;; Show the score and health in the info box at the top right
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
DrawDisplay PROC
	; Call to wsprintf to format SCORE as a string
	push SCORE
	push OFFSET SCORE_STR_P
	push OFFSET SCORE_STR
	call wsprintf
	add esp, 12

	; Call to wsprintf to format HEALTH as a string
	push HEALTH
	push OFFSET HEALTH_STR_P
	push OFFSET HEALTH_STR
	call wsprintf
	add esp, 12

	invoke BasicBlit, OFFSET Display, 525, 40
	invoke DrawStr, OFFSET HEALTH_STR, 480, 35, 000h
	invoke DrawStr, OFFSET SCORE_STR, 480, 45, 000h
DrawDisplay ENDP

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; CheckPause
;;;
;;; Check to see if the P key is pressed; if so, toggle pause screen
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
CheckPause PROC USES ecx
	mov ecx, KeyPress
	cmp ecx, VK_P
	jne endall
	
	; Flip the value of PAUSED
	xor PAUSED, 01h

endall:
	ret
CheckPause ENDP

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; FindMineralAtLoc
;;;
;;; Returns a pointer to the Mineral at (x,y), or -1 if none found
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
FindMineralAtLoc PROC USES ebx ecx edx x:DWORD, y:DWORD
	LOCAL i_minerals:DWORD, mem_pos:DWORD

	mov ecx, x
	mov edx, y

	; Iterate through all Minerals in MINERALS
	mov i_minerals, 0
	mov mem_pos, OFFSET MINERALS
	jmp fmal_cond
fmal_body:
	mov ebx, mem_pos

	ASSUME ebx:PTR Mineral
	; Ignore this mineral if it has been collected
	cmp [ebx].exist, 1
	jl fmal_inc

	cmp ecx, [ebx].X
	jne fmal_inc
	cmp edx, [ebx].Y
	jne fmal_inc
	
	; If mineral at this (x,y), return its address
	mov eax, ebx
	ret
	ASSUME ebx:nothing
fmal_inc:
	; Move to next mineral
	inc i_minerals
	add mem_pos, SIZEOF Mineral
fmal_cond:
	; End once all Minerals processed
	mov ebx, NUM_MINERALS
	cmp i_minerals, ebx
	jl fmal_body

	; Failed to find Mineral at (x,y)
	mov eax, -1

	ret
FindMineralAtLoc ENDP

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; FindEnemyAtLoc
;;;
;;; Returns a pointer to the Enemy at (x,y), or -1 if none found
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
FindEnemyAtLoc PROC USES ebx ecx edx x:DWORD, y:DWORD
	LOCAL i_enemies:DWORD, mem_pos:DWORD

	mov ecx, x
	mov edx, y

	; Iterate through all Enemys in ENEMIES
	mov i_enemies, 0
	mov mem_pos, OFFSET ENEMIES
	jmp feal_cond
feal_body:
	mov ebx, mem_pos
	ASSUME ebx:PTR Enemy
	; If this enemy is dead, ignore it
	cmp [ebx].health, 0
	jle feal_inc

	cmp ecx, [ebx].X
	jne feal_inc
	cmp edx, [ebx].Y
	jne feal_inc

	; If enemy at (x,y), return its address
	mov eax, ebx
	ret
	ASSUME ebx:nothing
feal_inc:
	; Move to next Enemy
	inc i_enemies
	add mem_pos, SIZEOF Enemy
feal_cond:
	; End after all enemies processed
	mov ebx, NUM_ENEMIES
	cmp i_enemies, ebx
	jl feal_body

	; Failed to find enemy at (x,y)
	mov eax, -1

	ret
FindEnemyAtLoc ENDP

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Strike
;;;
;;; Check to see if user is pressing space and facing an enemy; attack it if so
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
Strike PROC USES eax ebx ecx
	LOCAL nx:DWORD, ny:DWORD, ep:DWORD
	mov ecx, KeyPress
	cmp ecx, VK_SPACE
	; If space not pressed, return
	je strike
	ret

strike:
	mov ecx, PLAYER_SPRITE
	
	; Figure out which way player facing by sprite address
	cmp ecx, OFFSET AlexS
	je sld
	cmp ecx, OFFSET AlexN
	je slu
	cmp ecx, OFFSET AlexW
	je sll
	cmp ecx, OFFSET AlexE
	je slr
	
	; In each of the following blocks:
		; Calculate the coordinates of the grid position the player is facing
	; South
sld:
	mov ecx, PLAYERY
	inc ecx
	mov ny, ecx
	mov ecx, PLAYERX
	mov nx, ecx
	jmp dss

	; North
slu:
	mov ecx, PLAYERY
	dec ecx
	mov ny, ecx
	mov ecx, PLAYERX
	mov nx, ecx
	jmp dss

	; West
sll:
	mov ecx, PLAYERX
	dec ecx
	mov nx, ecx
	mov ecx, PLAYERY
	mov ny, ecx
	jmp dss

	; East
slr:
	mov ecx, PLAYERX
	inc ecx
	mov nx, ecx
	mov ecx, PLAYERY
	mov ny, ecx
	jmp dss

	; Now find the enemy there (if there is one)
dss:
	invoke FindEnemyAtLoc, nx, ny
	mov ep, eax
	cmp eax, -1
	; If no enemy, return
	je endall

	; Use pseudorandomness to make the damage dealt "fuzzy"
	invoke nrandom, 5
	add eax, 8
	mov ebx, ep
    sub (Enemy PTR [ebx]).health, eax
	; Increase player score by damage dealt	
	add SCORE, eax

	; Find the location to draw the sword blit on top of the enemy
	invoke CalcScreenX, nx
	mov nx, eax

	invoke CalcScreenY, ny
	mov ny, eax

	invoke BasicBlit, OFFSET GameSword, nx, ny
endall:
	ret
Strike ENDP

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; EnemyStrike
;;;
;;; Have an enemy strike the player. Show the sword blit and lower the player's health.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
EnemyStrike PROC
	; Use pseudorandomness to make the damage dealt "fuzzy"
	invoke nrandom, 5
	add eax, 8
	sub HEALTH, eax
	sub SCORE, eax

	; Indicates to main game loop to draw the sword blit later (so it appears on top)
	mov STRICKEN, 1
EnemyStrike ENDP

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; PickUp
;;;
;;; Have an enemy strike the player. Show the sword blit and lower the player's health.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
PickUp PROC USES eax ebx ecx
	mov ecx, KeyPress
	cmp ecx, VK_SPACE
	; If space not pressed, return
	je pickup
	ret

	; Figure out which direction the player is facing based on current sprite address
pickup:
	mov ecx, PLAYER_SPRITE

	cmp ecx, OFFSET AlexS
	je puld
	cmp ecx, OFFSET AlexN
	je pulu
	cmp ecx, OFFSET AlexW
	je pull
	cmp ecx, OFFSET AlexE
	je pulr

	; In each of the following blocks:
		; Find the coordinates where the player is looking
		; Find the mineral at this location (if it exists)
		; If it exists and is not collected (handled by FindMineralAtLoc), collect it
		; Decrement the number of minerals to be collected
		; Add 5 to the player's health (as a reward)
		; Add the value of the mineral to the player's score
	; South
puld:
	mov ebx, PLAYERY
	inc ebx
	invoke FindMineralAtLoc, PLAYERX, ebx
	cmp eax, -1
	je endpu
	ASSUME eax:PTR Mineral
	mov ecx, [eax].pts
	add SCORE, ecx
	mov [eax].exist, 0
	dec MINERALS_TC
	add HEALTH, 5
	ASSUME eax:nothing
	ret

	; North
pulu:
	mov ebx, PLAYERY
	dec ebx
	invoke FindMineralAtLoc, PLAYERX, ebx
	cmp eax, -1
	je endpu
	ASSUME eax:PTR Mineral
	mov ecx, [eax].pts
	add SCORE, ecx
	mov [eax].exist, 0
	dec MINERALS_TC
	add HEALTH, 5
	ASSUME eax:nothing
	ret

	; West
pull:
	mov ebx, PLAYERX
	dec ebx
	invoke FindMineralAtLoc, ebx, PLAYERY
	cmp eax, -1
	je endpu
	ASSUME eax:PTR Mineral
	mov ecx, [eax].pts
	add SCORE, ecx
	mov [eax].exist, 0
	dec MINERALS_TC
	add HEALTH, 5
	ASSUME eax:nothing
	ret

	; East
pulr:
	mov ebx, PLAYERX
	inc ebx
	invoke FindMineralAtLoc, ebx, PLAYERY
	cmp eax, -1
	je endpu
	ASSUME eax:PTR Mineral
	mov ecx, [eax].pts
	add SCORE, ecx
	mov [eax].exist, 0
	dec MINERALS_TC
	add HEALTH, 5
	ASSUME eax:nothing
	ret

endpu:
	ret
PickUp ENDP

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; FixIntersections
;;;
;;; If the player is intersecting any minerals or enemies, undo the movement they just made.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
FixIntersections PROC USES eax ebx ecx edx
	LOCAL i_minerals:DWORD, mem_pos:DWORD

	; Iterate through all minerals
	mov i_minerals, 0
	mov mem_pos, OFFSET MINERALS
	jmp fi_minerals_cond
fi_minerals_body:
	mov ebx, mem_pos	

	; If the mineral has been collected, skip it
	mov edx, (Mineral PTR [ebx]).exist
	test edx, 01h
	jz fi_minerals_inc

	mov eax, (Mineral PTR [ebx]).X
	mov ecx, (Mineral PTR [ebx]).Y

	cmp PLAYERX, eax
	jne fi_minerals_inc

	cmp PLAYERY, ecx
	jne fi_minerals_inc

	; If the player overlaps this mineral, find player direction and move opposite
	cmp PLAYER_SPRITE, OFFSET AlexS
	je fi_minerals_d
	cmp PLAYER_SPRITE, OFFSET AlexN
	je fi_minerals_u
	cmp	PLAYER_SPRITE, OFFSET AlexW
	je fi_minerals_l
	cmp PLAYER_SPRITE, OFFSET AlexE
	je fi_minerals_r

	; South
fi_minerals_d:
	dec PLAYERY
	mov PLAYERMOVOK, 0
	jmp fi_minerals_inc

	; North
fi_minerals_u:
	inc PLAYERY
	mov PLAYERMOVOK, 0
	jmp fi_minerals_inc

	; West
fi_minerals_l:
	inc PLAYERX
	mov PLAYERMOVOK, 0
	jmp fi_minerals_inc

	; East
fi_minerals_r:
	dec PLAYERX
	mov PLAYERMOVOK, 0
	jmp fi_minerals_inc

	; for increment
fi_minerals_inc:
	inc i_minerals
	add mem_pos, SIZEOF Mineral
fi_minerals_cond:
	mov ebx, NUM_MINERALS
	cmp i_minerals, ebx
	jl fi_minerals_body

	; Iterate through all enemies
	mov i_minerals, 0
	mov mem_pos, OFFSET ENEMIES
	jmp fi_enemies_cond
fi_enemies_body:
	mov ebx, mem_pos
	ASSUME ebx:PTR Enemy
	; If this enemy is dead, skip it
	cmp [ebx].health, 0
	jl fi_enemies_inc

	mov eax, [ebx].X
	mov ecx, [ebx].Y

	cmp PLAYERX, eax
	jne fi_enemies_inc

	cmp PLAYERY, ecx
	jne fi_enemies_inc

	; If this enemy intersects the player, find player direction and move opposite
	cmp PLAYER_SPRITE, OFFSET AlexS
	je fi_enemies_d
	cmp PLAYER_SPRITE, OFFSET AlexN
	je fi_enemies_u
	cmp	PLAYER_SPRITE, OFFSET AlexW
	je fi_enemies_l
	cmp PLAYER_SPRITE, OFFSET AlexE
	je fi_enemies_r

	; South
fi_enemies_d:
	dec PLAYERY
	mov PLAYERMOVOK, 0
	jmp fi_enemies_inc

	; North
fi_enemies_u:
	inc PLAYERY
	mov PLAYERMOVOK, 0
	jmp fi_enemies_inc

	; West
fi_enemies_l:
	inc PLAYERX
	mov PLAYERMOVOK, 0
	jmp fi_enemies_inc

	; East
fi_enemies_r:
	dec PLAYERX
	mov PLAYERMOVOK, 0
	jmp fi_enemies_inc
	
	ASSUME ebx:nothing
fi_enemies_inc:
	inc i_minerals
	add mem_pos, SIZEOF Enemy
fi_enemies_cond:
	mov ebx, NUM_ENEMIES
	cmp i_minerals, ebx
	jl fi_enemies_body

	ret
FixIntersections ENDP

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; DrawEnemies
;;;
;;; Draw all living enemies at their current positions. Called every tick.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
DrawEnemies PROC USES eax ebx ecx edx edi esi
	LOCAL m_len:DWORD, i:DWORD, mem_pos:DWORD

	; Iterate through all enemies
	mov ebx, NUM_ENEMIES
	mov m_len, ebx

	mov ebx, OFFSET ENEMIES
	mov mem_pos, ebx

	mov i, 0

	jmp de_cond
de_body:
	mov ebx, mem_pos
	ASSUME ebx:PTR Enemy
	; If this enemy is dead, skip it
	mov ecx, [ebx].health
	cmp ecx, 0
	jle de_inc

	mov edi, [ebx].X
	mov esi, [ebx].Y

	; Calculate coordinates from Grid coordinates
	invoke CalcScreenX, edi
	mov edi, eax

	invoke CalcScreenY, esi
	mov esi, eax

	mov ecx, [ebx].bmp

	; Draw the enemy
	invoke BasicBlit, ecx, edi, esi
	ASSUME ebx:nothing
de_inc:
	inc i
	add mem_pos, SIZEOF Enemy
de_cond:
	mov ebx, i
	cmp ebx, m_len
	jl de_body

	ret
DrawEnemies ENDP

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; DrawMinerals
;;;
;;; Draw all uncollected minerals at their current positions. Called every tick.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
DrawMinerals PROC USES eax ebx ecx edx edi esi
	LOCAL m_len:DWORD, i:DWORD, mem_pos:DWORD, mineral_x:DWORD, mineral_y:DWORD, mineral_rx:DWORD, mineral_ry:DWORD, mineral_bmp:DWORD

	; Iterate through all minerals
	mov ebx, NUM_MINERALS
	mov m_len, ebx

	mov ebx, OFFSET MINERALS
	mov mem_pos, ebx

	mov i, 0

	jmp dm_cond
dm_body:
	xor edx, edx

	mov ebx, mem_pos

	; If this mineral is collected, skip it
	mov edx, (Mineral PTR [ebx]).exist
	test edx, 01h
	jz dm_inc

	; Calculate the screen coords of this mineral from the grid coords
	mov edi, (Mineral PTR [ebx]).X
	mov mineral_x, edi
	invoke CalcScreenX, edi
	mov mineral_rx, eax

	mov esi, (Mineral PTR [ebx]).Y
	mov mineral_y, esi
	invoke CalcScreenY, esi
	mov mineral_ry, eax

	mov ecx, (Mineral PTR [ebx]).bmp
	mov mineral_bmp, ecx

	; Draw the mineral
	invoke BasicBlit, mineral_bmp, mineral_rx, mineral_ry
	
dm_inc:
	inc i
	add mem_pos, SIZEOF Mineral
dm_cond:
	mov ebx, m_len
	cmp i, ebx
	jl dm_body

	ret
DrawMinerals ENDP

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; InitEnemies
;;;
;;; Randomly generate enemies in game setup.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
InitEnemies PROC USES eax ebx ecx edx 
	LOCAL i:DWORD, mem_pos:DWORD, x:DWORD, y:DWORD, tp:DWORD

	; Iterate through all grid positions
	mov ebx, OFFSET ENEMIES
	mov mem_pos, ebx
	mov i, 0

	jmp ie_cond
ie_body:	
	; 1/100 chance for any grid position to spawn an enemy
	invoke nrandom, 10000
	cmp eax, 100
	jg ie_inc

	; Pick type of enemy at random (beetle or rockcrab)
	invoke nrandom, 2
	mov tp, eax

	mov eax, i
	mov ecx, 28

	xor edx, edx
	idiv ecx

	; Calc (x,y) from i
	mov x, edx
	mov y, eax

	mov ecx, mem_pos
	
	ASSUME ecx:PTR Enemy
	mov ebx, x
	mov [ecx].X, ebx
	mov ebx, y
	mov [ecx].Y, ebx

	; Pick bitmap from type
	cmp tp, 0
	je ie_else	
	mov edx, OFFSET RockCrabActive
	jmp ie_endif
ie_else:
	mov edx, OFFSET Beetle
ie_endif:
	mov [ecx].bmp, edx
	ASSUME ecx:nothing

	add mem_pos, SIZEOF Enemy
	inc NUM_ENEMIES
ie_inc:
	inc i	
ie_cond:
	mov ebx, LENGTHOF ENEMIES
	cmp i, ebx
	jl ie_body

	ret
InitEnemies ENDP

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; InitMinerals
;;;
;;; Randomly generate minerals in game setup.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
InitMinerals PROC USES eax ebx ecx edx edi
	LOCAL m_len:DWORD, i:DWORD, bmp_ptr:DWORD, mem_pos:DWORD, ptval:DWORD

	; Iterate through all grid positions
	mov ebx, OFFSET MINERALS
	mov mem_pos, ebx
	mov m_len, LENGTHOF MINERALS
	mov i, 0

	jmp im_cond
im_body:
		; Get a random integer in [0, 2499]
		invoke nrandom, PRB_VAL

		; Aquamarine: P = 1 / 2500
		; Aquamarine: 500 Points
	ch_aq:
		cmp eax, 0
		jg ch_r 
		;aq code
		mov bmp_ptr, OFFSET Aquamarine
		mov ptval, 500
		jmp m_present

		; Ruby: P = 1 / 250
		; Ruby: 50 points
	ch_r:
		cmp eax, 10
		jg ch_e
		;r code
		mov bmp_ptr, OFFSET Ruby
		mov ptval, 50
		jmp m_present

		; Emerald: P = 1 / 250
		; Emerald: 50 points
	ch_e:
		cmp eax, 20
		jg ch_am
		;e code
		mov bmp_ptr, OFFSET Emerald
		mov ptval, 50
		jmp m_present

		; Amethyst: P = 1 / 125
		; Amethyst: 25 points
	ch_am:
		cmp eax, 40
		jg ch_t
		;am code
		mov bmp_ptr, OFFSET Amethyst
		mov ptval, 25
		jmp m_present

		; Topaz: P = 1 / 125
		; Topaz: 10 points
	ch_t:
		cmp eax, 60
		jg im_none
		;t code
		mov bmp_ptr, OFFSET Topaz
		mov ptval, 10
		jmp m_present

		; If none apply, skip this position
	im_none:
		jmp im_inc

	; Now that it's picked, set it up
	m_present:
		mov ebx, mem_pos

		mov eax, i
		mov ecx, 28

		xor edx, edx
		idiv ecx
		mov ecx, bmp_ptr

		mov edi, ptval

		mov (Mineral PTR [ebx]).X, edx
		mov (Mineral PTR [ebx]).Y, eax

		mov (Mineral PTR [ebx]).bmp, ecx
		mov (Mineral PTR [ebx]).pts, edi

		inc NUM_MINERALS
		add mem_pos, SIZEOF Mineral
im_inc:
	inc i
im_cond:
	mov ebx, i
	cmp ebx, m_len
	jl im_body

	mov ebx, NUM_MINERALS
	mov MINERALS_TC, ebx

	ret
InitMinerals ENDP

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; MoveBackground
;;;
;;; Shift the background appropriately for the player's location and movements.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
MoveBackground PROC USES eax ecx
	mov eax, PLAYERMOVOK
	cmp eax, 0
	; If the player's last attempted move was REJECTED, DO NOTHING
	jne mbok
	ret	

mbok:
	mov ecx, KeyPress

key_up:
	cmp ecx, VK_UP
	jne key_down
	; Key up code
	dec SCREENY
	ret

key_down:
	cmp ecx, VK_DOWN
	jne key_left
	; Key down code
	inc SCREENY
	ret

key_left:
	cmp ecx, VK_LEFT
	jne key_right
	; Key left code
	dec SCREENX
	ret

key_right:
	cmp ecx, VK_RIGHT
	jne endmb
	; Key right code
	inc SCREENX
	
endmb:
	ret
MoveBackground ENDP

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; DrawBackground
;;;
;;; Calculate the background's screen coordinates from grid coordinates (with shifts), draw
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
DrawBackground PROC  USES eax
	LOCAL startx:DWORD, starty:DWORD
	
	; Equation:
	; (x_start - 32 * SCREENX + 32 * PLAYERX, y_start - 32 * SCREENY + 32 * PLAYERY)

	; 1/2 Bitmap size
	mov startx, 480
	mov starty, 368

	; Multiply grid X by 32
	mov eax, CSCREENX
	shl eax, 5

	sub startx, eax

	; Multiply grid Y by 32
	mov eax, CSCREENY
	shl eax, 5

	sub starty, eax

	; Draw the background
	invoke BasicBlit, OFFSET Level, startx, starty

	ret
DrawBackground ENDP

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; DrawPlayer
;;;
;;; Draw the player at screen coordinates (from Grid coordinates)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
DrawPlayer PROC
	; Set PLAYERX_REAL, PLAYERY_REAL
	invoke CalcPlayerPos

	invoke BasicBlit, PLAYER_SPRITE, PLAYERX_REAL, PLAYERY_REAL

	ret
DrawPlayer ENDP

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; CalcPlayerPos
;;;
;;; Find the screen coordinates of the player given the current Grid coordinates
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
CalcPlayerPos PROC USES eax
	invoke CalcScreenX, PLAYERX
	mov PLAYERX_REAL, eax

	invoke CalcScreenY, PLAYERY
	; Adjust for the fact that the player is the only 64-height sprite (rest are 32)
	sub eax, 16
	mov PLAYERY_REAL, eax

	ret
CalcPlayerPos ENDP

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; CalcScreenX
;;;
;;; Find the screen X coordinate of an object based on its Grid x position
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
CalcScreenX PROC USES ecx edi pos:DWORD
	; Calculate background shift
	mov eax, CSCREENX
	shl eax, 5

	; Calculate natural X coord of this object
	mov ecx, pos
	shl ecx, 5

	mov edi, PLAYER_X_START
	
	sub edi, eax
	add edi, ecx

	mov eax, edi

	ret
CalcScreenX ENDP

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; CalcScreenY
;;;
;;; Find the screen Y coordinate of an object based on its Grid y position
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
CalcScreenY PROC USES ebx edx esi pos:DWORD
	; Calculate background shift
	mov ebx, CSCREENY
	shl ebx, 5

	; Calculate natural Y coord of this object
	mov edx, pos
	shl edx, 5

	mov esi, PLAYER_Y_START
	add esi, 8

	sub esi, ebx
	add esi, edx

	mov eax, esi

	ret
CalcScreenY ENDP

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Move
;;;
;;; Move the player based on currently pressed keys
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
Move PROC USES eax ecx
	mov ecx, KeyPress

	; In each of the following blocks
		; Find the direction that the player should move based on the keys
		; Move the player there
		; Check to see if the player is out-of-bounds
		; If so, undo the last action AND
		; Note to other functions that the last movement the player made was rejected
key_up:
	cmp ecx, VK_UP
	jne key_down
	; Key up code
	mov PLAYER_SPRITE, OFFSET AlexN
	dec PLAYERY
	mov eax, PLAYER_Y_MIN
	cmp PLAYERY, eax
	jl fixpymin
	ret
fixpymin:
	mov PLAYERY, eax
	mov PLAYERMOVOK, 0
	ret

key_down:
	cmp ecx, VK_DOWN
	jne key_left
	; Key down code
	mov PLAYER_SPRITE, OFFSET AlexS
	inc PLAYERY
	mov eax, PLAYER_Y_MAX
	cmp PLAYERY, eax
	jg fixpymax
	ret
fixpymax:
	mov PLAYERY, eax
	mov PLAYERMOVOK, 0
	ret

key_left:
	cmp ecx, VK_LEFT
	jne key_right
	; Key left code
	mov PLAYER_SPRITE, OFFSET AlexW
	dec PLAYERX
	mov eax, PLAYER_X_MIN
	cmp PLAYERX, eax
	jl fixpxmin
	ret
fixpxmin:
	mov PLAYERX, eax	
	mov PLAYERMOVOK, 0
	ret

key_right:
	cmp ecx, VK_RIGHT
	jne end_move
	; Key right code
	mov PLAYER_SPRITE, OFFSET AlexE
	inc PLAYERX
	mov eax, PLAYER_X_MAX
	cmp PLAYERX, eax
	jg fixpxmax
	ret
fixpxmax:
	mov PLAYERX, eax
	mov PLAYERMOVOK, 0
	ret	

end_move:
	ret
Move ENDP

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; GetDistToPlayer
;;;
;;; Find the distance from a grid point to the player. Not Euclidean distance.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
GetDistToPlayer PROC USES ebx ecx edx x:DWORD, y:DWORD
	mov eax, x
	mov ebx, y
	mov ecx, PLAYERX
	mov edx, PLAYERY
	
	sub ecx, eax
	sub edx, ebx

	; Fix for absolute value errors
	cmp ecx, 0
	jge ecxcont
	neg ecx
ecxcont:

	cmp edx, 0
	jl edxcont
	neg edx
edxcont:
	
	; Add the x and y distance. NOT EUCLIDEAN DISTANCE
	mov eax, edx
	add eax, ecx
		
	ret
GetDistToPlayer ENDP

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; CheckIntersectPlayer
;;;
;;; Check to see if position (x,y) is the player's current position
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
CheckIntersectPlayer PROC USES ebx ecx edx x:DWORD, y:DWORD
	mov eax, x
	mov ebx, y
	mov ecx, PLAYERX
	mov edx, PLAYERY

	cmp eax, ecx
	jne fail
	cmp ebx, edx
	jne fail

	mov eax, 1
	ret
fail:
	mov eax, 0	
	ret
CheckIntersectPlayer ENDP

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; CheckIntersectAny
;;;
;;; Check to see if position (x,y) intersects ANY objects currently on screen
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
CheckIntersectAny PROC USES ebx ecx edx x:DWORD, y:DWORD
	LOCAL i:DWORD, mem_pos:DWORD

	; If the proposed position is out of level bounds, return an error
	cmp x, 0
	jl boundserr
	cmp y, 0
	jl boundserr
	cmp x, 27
	jg boundserr
	cmp y, 17
	jg boundserr
	jmp okstart
boundserr:
	mov eax, 1
	ret

	; Iterate through enemies
okstart:
	mov mem_pos, OFFSET ENEMIES
	mov i, 0
	jmp cia_e_cond
cia_e_body:
	mov ebx, mem_pos
	ASSUME ebx:PTR Enemy
	cmp [ebx].health, 0
	; Ignore enemy if dead
	jl cia_e_inc
	mov ecx, [ebx].X
	mov edx, [ebx].Y
	cmp x, ecx
	jne cia_e_inc
	cmp y, edx
	jne cia_e_inc
	; If intersecting, return 1
	mov eax, 1
	ret
	ASSUME ebx:nothing
cia_e_inc:
	inc i
	add mem_pos, SIZEOF Enemy
cia_e_cond:
	mov ebx, NUM_ENEMIES
	cmp i, ebx
	jl cia_e_body

	; Iterate through Minerals
	mov mem_pos, OFFSET MINERALS
	mov i, 0
	jmp cia_m_cond
cia_m_body:
	mov ebx, mem_pos
	ASSUME ebx:PTR Mineral
	cmp [ebx].exist, 0
	; Ignore mineral if collected
	je cia_m_inc
	mov ecx, [ebx].X
	mov edx, [ebx].Y
	cmp x, ecx
	jne cia_m_inc
	cmp y, edx
	jne cia_m_inc
	; If intersecting, return 1
	mov eax, 1
	ret
	ASSUME ebx:nothing
cia_m_inc:
	inc i
	add mem_pos, SIZEOF Mineral
cia_m_cond:
	mov ebx, NUM_MINERALS
	cmp i, ebx
	jl cia_m_body
	
	; Check to see if intersecting player
	invoke CheckIntersectPlayer, x, y
	cmp eax, 1
	jne nointersect
	ret

nointersect:
	mov eax, 0
	ret
CheckIntersectAny ENDP

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; MoveEnemies
;;;
;;; Enemy AI. Move randomly and move towards player if close enough.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
MoveEnemies PROC USES eax ebx ecx edx
	LOCAL i:DWORD, mem_pos:DWORD, dst:DWORD, dir:DWORD, amt:DWORD, newval:DWORD

	; Iterate through all enemies
	mov i, 0
	mov mem_pos, OFFSET ENEMIES
	jmp me_cond
me_body:
	; Check if we're going to move at all. 20% chance.
	; Prevents enemies from moving too fast.
	; Note that this also determines enemy hit rate.
	invoke nrandom, 6
	cmp eax, 0
	jne me_inc

	; If we're moving randomly (not close enough to player), set the amount to [-1,1]
	invoke nrandom, 3	
	dec eax
	mov amt, eax

	; Pick if we'll move in the Y or X direction (if moving randomly)
	invoke nrandom, 2
	mov dir, eax

	mov ebx, mem_pos
	ASSUME ebx:PTR Enemy
	; If this enemy is dead, skip it
	cmp [ebx].health, 0
	jle me_inc

	; Find the non-Euclidean distance from this enemy to the player
	invoke GetDistToPlayer, [ebx].X, [ebx].Y
	mov dst, eax

	; If the distance is between 0 and 2, move toward the player. Otherwise, move randomly.
	cmp dst, 2
	jle mov_player
mov_random:
	mov ecx, amt
	cmp dir, 1
	; Pick direction for random movement
	je mov_random_y
mov_random_x:	
	; Compute new position
	mov edx, [ebx].X
	mov newval, edx
	add newval, ecx
	; Check to make sure new position doesn't intersect existing entities
	; If intersecting player, strike the player and move on without moving INTO player
	invoke CheckIntersectPlayer, newval, [ebx].Y
	cmp eax, 1
	je random_x_ps
	invoke CheckIntersectAny, newval, [ebx].Y
	cmp eax, 1
	je me_inc
	jmp random_x_none
random_x_ps:
	invoke EnemyStrike
	jmp me_inc
random_x_none:
	mov edx, newval
	mov [ebx].X, edx
	jmp me_inc

mov_random_y:
	; Compute new position
	mov edx, [ebx].Y
	mov newval, edx
	add newval, ecx
	; Check to make sure new position doesn't intersect existing entities
	; If intersecting player, strike the player and move on without moving INTO player
	invoke CheckIntersectPlayer, [ebx].X, newval
	cmp eax, 1
	je random_y_ps
	invoke CheckIntersectAny, [ebx].X, newval
	cmp eax, 1
	je me_inc
	jmp random_y_none
random_y_ps:
	invoke EnemyStrike
	jmp me_inc
random_y_none:
	mov edx, newval
	mov [ebx].Y, edx
	jmp me_inc
	
	; If we're close enough to the player, move toward them
mov_player:
	cmp dir, 1
	; Pick direction
	je mov_player_y
	mov_player_x:
			mov ecx, PLAYERX
			mov edx, [ebx].X
			mov newval, edx
			cmp [ebx].X, ecx
			; If we're already at the same X as the player, skip this enemy
			jl mov_player_x_inc
			jg mov_player_x_dec
			jmp me_inc
			; Compute new value based on X coord of player (are we going left or right?)
		mov_player_x_dec:
			dec newval
			jmp mov_player_x_cont
		mov_player_x_inc:
			inc newval
		mov_player_x_cont:
			; Check to see if we're intersecting anything
			; If we're intersecting the player, attack them without moving INTO them
			invoke CheckIntersectPlayer, newval, [ebx].Y
			cmp eax, 1
			je mov_player_x_int_player
			invoke CheckIntersectAny, newval, [ebx].Y
			cmp eax, 1
			je me_inc
			jmp mov_player_x_int_none
		mov_player_x_int_player:
			invoke EnemyStrike
			jmp me_inc
		mov_player_x_int_none:
			mov ecx, newval
			mov [ebx].X, ecx
			jmp me_inc

	mov_player_y:
			mov ecx, PLAYERY
			mov edx, [ebx].Y
			mov newval, edx
			cmp [ebx].Y, ecx
			; If we're already at the same Y as the player, skip this enemy
			jl mov_player_y_inc
			jg mov_player_y_dec
			jmp me_inc
			; Compute new value based on Y coord of player (are we going up or down?)
		mov_player_y_dec:
			dec newval
			jmp mov_player_y_cont
		mov_player_y_inc:
			inc newval
		mov_player_y_cont:
			; Check to see if we're intersecting anything
			; If we're intersecting the player, attack them without moving INTO them
			invoke CheckIntersectPlayer, [ebx].X, newval
			cmp eax, 1
			je mov_player_y_int_player
			invoke CheckIntersectAny, [ebx].X, newval
			cmp eax, 1
			je me_inc
			jmp mov_player_y_int_none
		mov_player_y_int_player:
			invoke EnemyStrike
			jmp me_inc
		mov_player_y_int_none:
			mov ecx, newval
			mov [ebx].Y, ecx

	ASSUME ebx:nothing
me_inc:
	inc i
	add mem_pos, SIZEOF Enemy
me_cond:
	mov ebx, NUM_ENEMIES
	cmp i, ebx
	jl me_body
	
	ret
MoveEnemies ENDP

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; NormalizeScreenValues
;;;
;;; Keep track of the "real shift value" (allow negative), but clamp between 0 and max for disp
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
NormalizeScreenValues PROC USES eax ebx
	mov eax, LO_BG_X_SHIFT
	cmp SCREENX, eax
	jge sxmax
	mov CSCREENX, eax
	jmp startsy
sxmax:
	mov eax, HI_BG_X_SHIFT
	cmp SCREENX, eax
	jle sxok
	mov CSCREENX, eax
	jmp startsy
sxok:
	mov ebx, SCREENX
	mov CSCREENX, ebx

startsy:
	mov eax, LO_BG_Y_SHIFT
	cmp SCREENY, eax
	jge symax
	mov CSCREENY, eax
	ret
symax:
	mov eax, HI_BG_Y_SHIFT
	cmp SCREENY, eax
	jle syok
	mov CSCREENY, eax
	ret
syok:
	mov ebx, SCREENY
	mov CSCREENY, ebx
	ret
NormalizeScreenValues ENDP

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; ClearScreen
;;;
;;; Color the whole screen one color
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ClearScreen PROC USES eax ebx ecx edx color_c:BYTE
	mov ecx, 640 * 480
	mov ebx, 0
	mov edx, ScreenBitsPtr
st_f:
	mov al, color_c
	mov BYTE PTR [edx], al
	inc ebx
	inc edx
	cmp ebx, ecx
	jl st_f
	ret
ClearScreen ENDP

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; CheckIntersect
;;;
;;; Not used in favor of grid-specific intersection checks for this game
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
CheckIntersect PROC USES ebx ecx edx oneX:DWORD, oneY:DWORD, oneBitmap:PTR EECS205BITMAP, twoX:DWORD, twoY:DWORD, twoBitmap:PTR EECS205BITMAP 
	LOCAL x_1_low:DWORD, x_1_high:DWORD, y_1_low:DWORD, y_1_high:DWORD, x_2_low:DWORD, x_2_high:DWORD, y_2_low:DWORD, y_2_high:DWORD
      
	mov eax, oneBitmap
	ASSUME eax:PTR EECS205BITMAP

	mov ebx, [eax].dwWidth
	sar ebx, 1
	mov ecx, oneX
	mov edx, ecx
	add ecx, ebx
	sub edx, ebx
	mov x_1_low, edx
	mov x_1_high, ecx

	mov ebx, [eax].dwHeight
	sar ebx, 1
	mov ecx, oneY
	mov edx, ecx
	add ecx, ebx
	sub edx, ebx
	mov y_1_low, edx
	mov y_1_high, ecx

	mov eax, twoBitmap

	mov ebx, [eax].dwWidth
	sar ebx, 1
	mov ecx, twoX
	mov edx, ecx
	add ecx, ebx
	sub edx, ebx
	mov x_2_low, edx
	mov x_2_high, ecx

	mov ebx, [eax].dwHeight
	sar ebx, 1
	mov ecx, twoY
	mov edx, ecx
	add ecx, ebx
	sub edx, ebx
	mov y_2_low, edx
	mov y_2_high, ecx

	ASSUME eax:nothing

	; if (x_2_low < x_1_high && x_2_high > x_1_low) && (y_2_low < y_1_high && y_2_high > y_1_low)

	mov ecx, 0

	mov eax, x_2_low
	mov ebx, x_1_high
	cmp eax, ebx
	jge fail

	mov eax, x_2_high
	mov ebx, x_1_low
	cmp eax, ebx
	jle fail

	mov eax, y_2_low
	mov ebx, y_1_high
	cmp eax, ebx
	jge fail

	mov eax, y_2_high
	mov ebx, y_1_low
	cmp eax, ebx
	jle fail

	mov ecx, 1

	fail:
	mov eax, ecx
	ret
CheckIntersect ENDP

END
