; #########################################################################
;
;   lines.asm - Assembly file for EECS205 Assignment 2
;	Spencer Colton (sdc2637)
;
; #########################################################################

      .586
      .MODEL FLAT,STDCALL
      .STACK 4096
      option casemap :none  ; case sensitive

include stars.inc
include lines.inc

.DATA

	;; If you need to, you can place global variables here
	
.CODE
	

;; Don't forget to add the USES the directive here
;;   Place any registers that you modify (either explicitly or implicitly)
;;   into the USES list so that caller's values can be preserved
	
;;   For example, if your procedure uses only the eax and ebx registers
;;      DrawLine PROC USES eax ebx x0:DWORD, y0:DWORD, x1:DWORD, y1:DWORD, color:DWORD
DrawLine PROC USES eax ebx ecx edx x0:DWORD, y0:DWORD, x1:DWORD, y1:DWORD, color:DWORD 
	;; Feel free to use local variables...declare them here
	;; For example:
	;; 	LOCAL foo:DWORD, bar:DWORD
	LOCAL dex:DWORD, dey:DWORD, ix:DWORD, iy:DWORD, pe:DWORD, err:DWORD, cux:DWORD, cuy:DWORD
	;; Place your code here
	
	;; delta_x = abs(x1-x0)
	mov ebx, x1
	mov ecx, x0
	sub ebx, ecx
	cmp ebx, 0
	jge dexgz
	neg	ebx
dexgz:
	mov dex, ebx
	
	;; delta_y = abs(y1-y0)
	mov ebx, y1
	mov ecx, y0
	sub ebx, ecx
	cmp ebx, 0
	jge deygz
	neg ebx
deygz:
	mov dey, ebx
	
	;; if (x0 < x1)
	mov ebx, x0
	mov ecx, x1
	cmp ebx, ecx
	jge xelse
	
	;; inc_x = 1
	mov ix, 1
	jmp xxend
	
xelse: ;; else
	
	;; inc_x = -1
	mov ix, -1
xxend:

	;; if (y0 < y1)
	mov ebx, y0
	mov ecx, y1
	cmp ebx, ecx
	jge yelse
	
	;; inc_y = 1
	mov iy, 1
	jmp yend
	
yelse: ;; else

	;; inc_y = -1
	mov iy, -1
yend:

	;; if (delta_x > delta_y)
	mov ebx, dex
	mov ecx, dey
	cmp ebx, ecx
	jle deelse
	
	;; error = delta_x / 2
	xor edx, edx	;; Clear out EDX so division works
	mov eax, dex
	mov ebx, 2
	div ebx
	mov err, eax
	jmp deend
	
deelse: ;; else

	;; error = - delta_y / 2
	xor edx, edx	;; Clear out EDX so division works
	mov eax, dey
	mov ebx, 2
	idiv ebx
	neg eax
	mov err, eax
deend:

	;; curr_x = x0
	mov ebx, x0
	mov cux, ebx
	
	;; curr_y = y0
	mov ebx, y0
	mov cuy, ebx
	
	;; DrawPixel(curr_x, curr_y, color)
	invoke DrawPixel, cux, cuy, color
	
	;; while (curr_x != x1 OR curr_y != y1)
	mov eax, cux
	mov ebx, x1
	mov ecx, cuy
	mov edx, y1
	cmp eax, ebx
	jne whilestart
	cmp ecx, edx
	jne whilestart
	jmp whileend
whilestart:

	;; DrawPixel(curr_x, curr_y, color)
	invoke DrawPixel, cux, cuy, color

	;; prev_error = error
	mov ebx, err
	mov pe, ebx
	
	;; if (prev_error > - delta_x)
	mov ebx, dex
	neg ebx
	mov ecx, pe
	cmp ecx, ebx
	jle pexend
	
	;; error = error - delta_y
	mov ebx, err
	mov ecx, dey
	sub ebx, ecx
	mov err, ebx
	
	;; curr_x = curr_x + inc_x
	mov ebx, cux
	mov ecx, ix
	add ebx, ecx
	mov cux, ebx
pexend:
	
	;; if (previous_error < delta_y)
	mov ebx, dey
	mov ecx, pe
	cmp ecx, ebx
	jge peyend
	
	;; error = error + delta_x
	mov ebx, err
	mov ecx, dex
	add ebx, ecx
	mov err, ebx
	
	;; curr_y = curr_y + inc_y
	mov ebx, cuy
	mov ecx, iy
	add ebx, ecx
	mov cuy, ebx
peyend:
	
	;; while (curr_x != x1 OR curr_y != y1)
	mov eax, cux
	mov ebx, x1
	mov ecx, cuy
	mov edx, y1
	cmp eax, ebx
	jne whilestart
	cmp ecx, edx
	jne whilestart
whileend:
	
	ret  	;;  Don't delete this line...you need it
DrawLine ENDP




END
