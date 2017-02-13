TITLE Composite Numbers     (Project04.asm)

; Author: Mariam Ben-Neticha
; Course / Project ID : CS271 Program #4                Date: 02/14/16
; Description: Write a MASM program to calculate composite numbers:
;	a. Display programmer name and program title on output screen.
;	b. Instruct user to enter number of composites to be displayed.
;	c. Prompt user to enter an integer, n, in the range of [1 .. 400]. 
;	d. Verify that the integer, n, is within the range [1 .. 400].
;	   If out-of-range, user is re-prompted until valid value is input.
;	e. Calculate all the composite numbers (inclusive of the nth composite).
;	f. Display:
;		 a. all the composite numbers (inclusive of the nth composite)
;		 b. 10 composites per line with at least three spaces between numbers
;		 c. terminating message with the user's name (i.e. - "Good-bye, user-name").


INCLUDE Irvine32.inc


.data
;statements
intro_1		BYTE	"Welcome to Composite Numbers!", 0
intro_2		BYTE	"Programmed by Mariam Ben-Neticha", 0
instruct_1	BYTE	"Enter the number of composite numbers you would like to see.", 0
instruct_2	BYTE	"I'll accept orders for up to 400 composites.", 0
prompt_1	BYTE	"Enter the number of composites to display [1 .. 400]: ", 0
outOfRange	BYTE	"Out of range. Try again.", 0
spaces		BYTE	"     ", 0
end_1		BYTE	"Thanks for playing! Good-bye.", 0

;variables
userNum		DWORD	?			; integer to be entered by user
cur_num		DWORD	1			;starting number to check
;cur_num_temp DWORD	?			;holds cur_num value for safe-keeping
is_comp		DWORD	0			;keeps track of how many divisors value has



;constants
UPPERLIMIT		=		400		;upper limit is a CONSTANT
LOWERLIMIT		=		1		;lower limit is a CONSTANT 

.code
main PROC

	call	changeTextColor
	call	introduction
	call	getUserData			;includes validate
	call	showComposites		;includes isComposite
	call	farewell

	exit
main ENDP


;Change Text Color
changeTextColor PROC

	mov		eax, cyan+(black*16)
	call	SetTextColor
	ret

changeTextColor ENDP

; Introduction
introduction PROC

; Display Programmer Name and Program Title on output screen
	mov		edx, OFFSET intro_1
	call	WriteString
	call	CrLf
	mov		edx, OFFSET intro_2
	call	WriteString
	call	CrLf
	call	CrLf

;Display instructions to the user.
	mov		edx, OFFSET instruct_1
	call	WriteString
	call	CrLf
	mov		edx, OFFSET instruct_2
	call	WriteString
	call	CrLf
	call	CrLf
	ret

introduction ENDP

getUserData PROC

promptUser:
	mov		edx, OFFSET prompt_1
	call	WriteString
	call	ReadInt
	mov		userNum, eax
	call	CrLf

;Validate value in range
	mov		ebx, UPPERLIMIT					;ebx = 400
	cmp		ebx, eax						
	jge		upperLimitOk					;if ebx >= eax, within upper limit range
	mov		edx, OFFSET outOfRange			;else, out of range
	call	WriteString
	call	CrLf
	jmp		promptUser						;if value is above 400, re-prompt

upperLimitOk:								;userNum is below upperLimit
	mov		ebx, LOWERLIMIT					;ebx = 1
	mov		eax, userNum
	cmp		ebx, eax
	jle		limitsOk						;if ebx <= eax, within lower limit range
	mov		edx, OFFSET outOfRange			;else, out of range
	call	WriteString
	call	CrLf
	jmp		promptUser						;loop back to instruct and prompt user for new valid value


;user-input validated
limitsOk:
	ret

getUserData ENDP

showComposites PROC

	mov		eax, 0						;set accumulator = 0
	mov		ebx, LOWERLIMIT				;lower limit (1) in ebx
	mov		ecx, userNum				;number times to execute loop = user-input
	mov		esi, 10						;number of terms to print per line

isComposite:
	mov		eax, cur_num
	sub		edx, edx					;set edx to zero
	div		ebx							;divides eax by ebx = cur_num
	cmp		edx, 0
	je		increment					;if remainder = 0, go to increment
	jmp		nextNum						;else go to next num to divide by
	
increment:
	inc		is_comp						;increment number of divisors
	jmp		nextNum

nextNum:
	dec		ebx							;cur_num--
	mov		eax, ebx
	cmp		eax, 0
	je		checkIsComp					;if cur_num-- = 0, check is val is composite
	jmp		isComposite

checkIsComp:
	mov		eax, is_comp
	cmp		eax, 2
	jg		printComposite
	jmp		nextComposite				;cur_num is not composite; go to next potential composite

nextComposite:							;go to next potential composite if last value is not composite
	mov		is_comp, 0
	inc		cur_num
	mov		eax, cur_num
	mov		ebx, eax
	jmp		isComposite

printComposite:
	mov		is_comp, 0
	mov		eax, cur_num
	inc		cur_num
	mov		ebx, cur_num
	call	WriteDec
	dec		esi
	jnz		fiveSpaces
	cmp		ecx, 1
	je		endComposite

endLine:
	call	CrLf
	mov		esi, 10						;replenishes for next line
	cmp		ecx, 1
	je		endComposite
	loop	isComposite					;subtracts 1 from ecx & repeats until ecx = 0

fiveSpaces:
	cmp		ecx, 1
	je		endLine
	mov		edx, OFFSET spaces
	call	WriteString
	mov		eax, cur_num
	mov		ebx, eax
	dec		ecx
	jmp		isComposite

endComposite:	
	call	CrLf
	call	CrLf
	ret
showComposites ENDP

farewell PROC
;Say "Good-Bye"

	mov		edx, OFFSET end_1
	call	WriteString
	call	CrLf
	exit									; exit to operating system

farewell ENDP

END main
