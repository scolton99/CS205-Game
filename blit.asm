; #########################################################################
;
;   blit.asm - Assembly file for EECS205 Assignment 3
;
;
; #########################################################################

      .586
      .MODEL FLAT,STDCALL
      .STACK 4096
      option casemap :none  ; case sensitive

include stars.inc
include lines.inc
include trig.inc
include blit.inc


.DATA

	;; If you need to, you can place global variables here
	
.CODE

DrawPixel PROC USES eax ebx ecx edx x:DWORD, y:DWORD, color:DWORD
	mov eax, y
	mov ebx, 640

	imul ebx				; multiply y value by screen width to get appropriate address

	add eax, x

	mov ebx, color

	mov ecx, ScreenBitsPtr			; get start of screen bits
	add ecx, eax					; add found address to starting address
	mov BYTE PTR [ecx], bl			; move color value into this address

	ret 			; Don't delete this line!!!
DrawPixel ENDP

GridBlit PROC USES eax ebx ecx edx ptrBitmap:PTR EECS205BITMAP, gridx:DWORD, gridy:DWORD
	mov eax, 16
	cmp gridx, eax
	jge arg_fail

	sub eax, 5
	cmp gridy, eax
	jge arg_fail

	mov eax, gridx
	mov ebx, 40
	imul ebx

	mov ecx, eax
	mov eax, gridy
	imul ebx

	mov edx, eax

	add edx, 20
	add ecx, 20

	invoke BasicBlit, ptrBitmap, ecx, edx
arg_fail:
	ret
GridBlit ENDP

BasicBlit PROC USES eax ebx ecx edx edi esi ptrBitmap:PTR EECS205BITMAP, xcenter:DWORD, ycenter:DWORD
	LOCAL wd:DWORD, ht:DWORD, memStart:DWORD, trans:BYTE, tmp_eax:DWORD, tmp_edx:DWORD

	mov eax, ptrBitmap

	; get bitmap values into variables for easy access
	ASSUME eax:PTR EECS205BITMAP
	mov ebx, [eax].dwWidth
	mov wd, ebx
	
	mov ebx, [eax].dwHeight
	mov ht, ebx

	mov ebx, [eax].lpBytes
	mov memStart, ebx

	mov bl, [eax].bTransparent
	mov trans, bl
	ASSUME eax:nothing

	mov edi, xcenter
	mov esi, ycenter

	mov edx, ht
	shr edx, 1			; create height / 2

	mov ecx, wd
	shr ecx, 1			; create width / 2

	sub edi, ecx		; screen x = center - (bmp_width / 2) to start
	sub esi, edx		; screen y = center - (bmp_height / 2) to start

	mov eax, edi		; x reset value

	mov ecx, 0			; bitmap x
	mov edx, 0			; bitmap y

	jmp cond_y

begin_y:
	cmp esi, 0						; ensure screen y is not off screen
	jl step_y

	cmp esi, 480
	jge end_all

	mov ecx, 0						; reset x to 0 for each new line
	mov edi, eax

	jmp cond_x						; begin inner for loop
begin_x:
	cmp edi, 0						; ensure screen x is not off screen
	jl step_x

	cmp edi, 640
	jge step_x

	mov tmp_eax, eax				; need to use registers already in use; declare var
	mov tmp_edx, edx

	mov eax, edx
	mov ebx, wd						; get correct address by multiplying y by width, adding to x and start ptr
	imul ebx

	add eax, ecx
	add eax, memStart

	mov al, BYTE PTR [eax]			; get color value
	mov bl, trans
	
	cmp al, bl						; if color == transparent, skip
	je past

	invoke DrawPixel, edi, esi, al
	
past:								; reset registers appropriately
	mov eax, tmp_eax
	mov edx, tmp_edx
step_x:
	inc edi							
	inc ecx
cond_x:
	cmp ecx, wd						; bitmap x < bitmap width
	jl begin_x
step_y:
	inc esi
	inc edx
cond_y:
	cmp edx, ht						; bitmap y < bitmap height
	jl begin_y

end_all:
	ret 			
BasicBlit ENDP


RotateBlit PROC USES eax ebx ecx edx edi esi lpBmp:PTR EECS205BITMAP, xcenter:DWORD, ycenter:DWORD, angle:FXPT
	LOCAL cosa:DWORD, sina:DWORD, shiftX:DWORD, shiftY:DWORD, dstWidth:DWORD, dstHeight:DWORD, dstX:DWORD, dstY:DWORD, srcX:DWORD, srcY:DWORD, srcw:DWORD

	invoke FixedCos, angle	; get cos of angle for use later
	mov cosa, eax

	invoke FixedSin, angle	; get sin of angle for use later
	mov sina, eax

	mov esi, lpBmp

	; Shift X
	mov ebx, cosa
	shr ebx, 1			; divide by 2
	mov ecx, sina
	shr ecx, 1			; divide by 2
	
	;; begin FXPT multiply width by cosa / 2
	mov eax, (EECS205BITMAP PTR [esi]).dwWidth
	mov srcw, eax
	shl eax, 16
	imul ebx

	shl edx, 16
	shr eax, 16

	or eax, edx
	sar eax, 16

	mov edi, eax
	;; end FXPT multiply width by cosa / 2

	;; begin FXPT multiply height by sina / 2
	mov eax, (EECS205BITMAP PTR [esi]).dwHeight
	shl eax, 16
	imul ecx

	shl edx, 16
	shr eax, 16

	or eax, edx
	sar eax, 16

	sub edi, eax
	;; end FXPT multiply height by sina / 2
	
	mov shiftX, edi ; shiftX = width * cosa / 2 - height * sina / 2

	; Shift Y
	mov ebx, cosa
	shr ebx, 1
	mov ecx, sina
	shr ecx, 1

	;; begin FXPT multiply height by cosa / 2
	mov eax, (EECS205BITMAP PTR [esi]).dwHeight
	shl eax, 16
	imul ebx

	shl edx, 16
	shr eax, 16

	or eax, edx
	sar eax, 16

	mov edi, eax
	;; end FXPT multiply height by cosa / 2

	;; begin FXPT multiply width by sina / 2
	mov eax, (EECS205BITMAP PTR [esi]).dwWidth
	shl eax, 16
	imul ecx

	shl edx, 16
	shr eax, 16

	or eax, edx
	sar eax, 16
	;; end FXPT multiply width by sina / 2
	
	add edi, eax
	mov shiftY, edi		; shiftY = height * cosa / 2 + width * sina / 2

	; dstWidth
	mov eax, (EECS205BITMAP PTR [esi]).dwWidth
	mov ebx, (EECS205BITMAP PTR [esi]).dwHeight
	add eax, ebx ; = width + height

	mov dstWidth, eax
	mov dstHeight, eax ; dstHeight = dstWidth

	; outer for loop setup
	mov eax, dstWidth	; dstX = -dstWidth
	neg eax
	mov dstX, eax
	jmp outer_cond

outer_start:
	; inner loop setup
	mov eax, dstHeight	; dstY = -dstHeight
	neg eax
	mov dstY, eax
	jmp inner_cond

inner_start:
	; srcX
	;; begin FXPT multiply dstX by cosa
	mov eax, dstX
	shl eax, 16
	mov ebx, cosa
	imul ebx

	shl edx, 16
	shr eax, 16

	or eax, edx
	sar eax, 16
	mov edi, eax
	;; end FXPT multiply dstX by cosa

	;; begin FXPT multiply dstY by sina
	mov eax, dstY
	shl eax, 16
	mov ebx, sina
	imul ebx

	shl edx, 16
	shr eax, 16

	or eax, edx
	sar eax, 16
	mov esi, eax
	;; end FXPT multiply dstY by sina

	add edi, esi
	mov srcX, edi	; srcX = dstX * cosa + dstY * sina

	; srcY
	;; begin FXPT multiply dstY by cosa
	mov eax, dstY
	shl eax, 16
	mov ebx, cosa
	imul ebx

	shl edx, 16
	shr eax, 16

	or eax, edx
	sar eax, 16
	mov edi, eax
	;; end FXPT multiply dstY by cosa

	;; begin FXPT multiply dstX by sina
	mov eax, dstX
	shl eax, 16
	mov ebx, sina
	imul ebx

	shl edx, 16
	shr eax, 16

	or eax, edx
	sar eax, 16
	mov esi, eax
	;; end FXPT multiply dstX by sina

	sub edi, esi
	mov srcY, edi	; srcY = dstY * cosa - dstX * sina

	; begin if conditions
	cmp srcX, 0		; srcX >= 0
	jl inner_inc
	
	mov esi, lpBmp
	mov eax, (EECS205BITMAP PTR [esi]).dwWidth
	cmp srcX, eax	; srcX < bitmap.dwWidth	
	jge inner_inc

	cmp srcY, 0		; srcY >= 0
	jl inner_inc

	mov eax, (EECS205BITMAP PTR [esi]).dwHeight
	cmp srcY, eax	; srcY < bitmap.dwHeight
	jge inner_inc

	mov eax, xcenter
	add eax, dstX
	sub eax, shiftX
	cmp eax, 0		; xcenter + dstX - shiftX >= 0
	jl inner_inc
	
	cmp eax, 639	; xcenter + dstX - shiftX < 639
	jg inner_inc

	mov eax, ycenter
	add eax, dstY
	sub eax, shiftY
	cmp eax, 0		; ycenter + dstY - shiftY >= 0
	jl inner_inc

	cmp eax, 479	; ycenter + dstY - shiftY < 479
	jg inner_inc

	mov bl, (EECS205BITMAP PTR [esi]).bTransparent	; get transparent value
	mov ecx, (EECS205BITMAP PTR [esi]).lpBytes	; get start of pixel bytes
	mov edi, srcX
	mov eax, srcY
	mov esi, srcw
	imul esi		; multiply y by bitmap width
	add edi, eax	; add x value to get correct address
	add ecx, edi	; add starting value
	movzx ecx, BYTE PTR [ecx]	; get color at this pixel
	cmp cl, bl	; if color is not transparent
	je inner_inc

	mov eax, xcenter	
	add eax, dstX
	sub eax, shiftX

	mov ebx, ycenter
	add ebx, dstY
	sub ebx, shiftY

	invoke DrawPixel, eax, ebx, ecx

inner_inc:
	inc dstY			; dstY++
inner_cond:
	mov eax, dstHeight
	cmp dstY, eax		; dstY < dstHeight
	jl inner_start

outer_inc:
	inc dstX			; dstX++
outer_cond:
	mov eax, dstWidth
	cmp dstX, eax		; dstX < dstWidth
	jl outer_start


	ret 			; Don't delete this line!!!		
RotateBlit ENDP



END
