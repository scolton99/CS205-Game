; #########################################################################
;
;   trig.asm - Assembly file for EECS205 Assignment 3
;
;
; #########################################################################

      .586
      .MODEL FLAT,STDCALL
      .STACK 4096
      option casemap :none  ; case sensitive

include trig.inc

.DATA

;;  These are some useful constants (fixed point values that correspond to important angles)
PI_HALF = 102943           	;;  PI / 2
PI =  205887	                ;;  PI 
TWO_PI	= 411774                ;;  2 * PI 
PI_INC_RECIP =  5340353        	;;  Use reciprocal to find the table entry for a given angle
	                        ;;              (It is easier to use than divison would be)


	;; If you need to, you can place global variables here
	
.CODE

FixedSin PROC angle:FXPT
	invoke GetIndexSin, angle

	movzx ebx, WORD PTR [SINTAB + eax * 2]	; get SINTAB value for angle

	invoke GetMulSin, angle	; get multiplier for angle
	imul ebx

	shl edx, 16
	shr eax, 16

	or eax, edx	; FXPT multiply steps
	
	ret
FixedSin ENDP 

;; gets the correct index in SINTAB for the sin of an angle
GetIndexSin PROC USES ebx angle:FXPT
	LOCAL n_angle, np_angle

	invoke Normalize, angle, PI_HALF
	mov n_angle, eax				; get angle % pi/2
	invoke Normalize, angle, PI
	mov np_angle, eax				; get angle % pi

	mov eax, n_angle
	
	mov ebx, PI_INC_RECIP
	imul ebx

	shl edx, 16
	shr eax, 16

	or eax, edx
	shr eax, 16						; (angle % pi / 2) & PI_INC_RECIP = index			

	mov ebx, PI_HALF
	cmp np_angle, ebx
	jl endsini						; if angle < pi / 2, this is the right index

	mov ebx, 127					; otherwise, FLIP the index
	sub ebx, eax
	mov eax, ebx					; index = 127 - index

endsini:
	ret
GetIndexSin ENDP

;; gets a multiplier value for the sin value of a given angle
GetMulSin PROC USES ebx angle:FXPT
	invoke Normalize, angle, TWO_PI

	cmp eax, PI
	jl less		; if angle % 2PI < pi, return 1
	jmp gequal	; else, return -1
	
less:
	mov eax, 10000h	; 1 (FXPT)
	jmp endmulsin
gequal:
	mov eax, 0FFFF0000h	; -1 (FXPT)

endmulsin:
	ret
GetMulSin ENDP

;; return angle % val
Normalize PROC USES ebx angle:FXPT, val:FXPT
	mov eax, angle
	mov ebx, val
	
	cmp eax, 0
	jl anglel	; angle < 0, add val to it until it's in range [0, val)
	cmp eax, ebx
	jl ok		; if the angle is already less than val, return it
angleg:
	sub eax, val
	cmp eax, ebx
	jge angleg
	jmp ok		; once angle is acceptable, return it
anglel:
	add eax, val
	cmp eax, 0
	jl anglel	; keep adding val to angle until it is in range [0, val)
ok:

	ret
Normalize ENDP
	
;; Defined in FixedSin since cos(a) = sin(a + pi/2) 
FixedCos PROC USES ebx angle:FXPT
	mov ebx, PI_HALF
	add angle, ebx

	invoke FixedSin, angle

	ret
FixedCos ENDP	
END
