; #########################################################################
;
;   stars.asm - Assembly file for EECS205 Assignment 1
;
;
; #########################################################################

      .586
      .MODEL FLAT,STDCALL
      .STACK 4096
      option casemap :none  ; case sensitive


include stars.inc

.DATA

	;; If you need to, you can place global variables here

.CODE

DrawStarField proc USES EAX EBX EDI ESI
	;; Place your code here
	mov eax, 128	; Our increment x value
	mov ebx, 96		; Our increment y value
	xor edi, edi
stdrs:
	add edi, eax	; Add 128 to x
	xor esi, esi
inner:
	add esi, ebx	; Add 96 to y
	
	invoke DrawStar, edi, esi
	
	cmp esi, 384	; max y location
	jne inner		; If we haven't done 4 different y values for this x value, do another
	cmp edi, 512	; max x location
	jne stdrs		; If we haven't done all 4 different x values, do another
	
	ret  			; Careful! Don't remove this line
DrawStarField endp



END
