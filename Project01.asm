TITLE Elementary Arithmetic     (Project01.asm)

; Author: Mariam Ben-Neticha
; Course / Project ID : Program #1                Date: 01/11/16
; Description: Write a MASM program that does the following:
;	a. Display your name and program title on output screen.
;	b. Display instructions for the user.
;	c. Prompt user to enter two numbers.
;	d. Calculate the sum, difference, product, integer quotient and remainder of the numbers.
;	e. Display a terminating message (i.e. - "Good-bye").

INCLUDE Irvine32.inc


.data

intro		BYTE	"   Elementary Arithmetic    by    Mariam Ben-Neticha", 0
instruction	BYTE	"Enter two numbers and I'll show you the sum, difference, product, quotient and remainder.", 0
prompt_1	BYTE	"Enter First Number:", 0
value_1		DWORD	?			; integer to be entered by user
prompt_2	BYTE	"Enter Second Number:", 0
value_2		DWORD	?			; integer to be entered by user
calcSum		DWORD	?			; store calculated sum
calcDiff	DWORD	?			; store calculated difference
calcProd	DWORD	?			; store calculated product
calcQuot	DWORD	?			; store calculated quotient (integer)
calcRemd	DWORD	?			; store calculated remainder
equal		BYTE	' = ', 0
plus		BYTE	' + ', 0
minus		BYTE	" - ", 0
times		BYTE	" x ", 0
divide		BYTE	" / ", 0
remainder	BYTE	" remainder ", 0
terminate	BYTE	"Good-Bye!", 0

.code
main PROC


; Introduction
; Display your name and Program Title on output screen 
	mov		edx, OFFSET intro
	call	WriteString
	call	CrLf

;Display instructions to the user.
	mov		edx, OFFSET instruction
	call	WriteString
	call	CrLf

;Get user value 1
	mov		edx, OFFSET prompt_1
	call	WriteString
	call	ReadInt
	mov		value_1, eax
	call	CrLf


;Get user value 2
	mov		edx, OFFSET prompt_2
	call	WriteString
	call	ReadInt
	mov	value_2, eax
	call	CrLf

;Calculate sum of value 1 + value 2
	mov		eax, value_1
	mov		ebx, value_2
	add		eax, ebx
	mov		calcSum, eax

;Calculate difference...
	mov		eax, value_1
	mov		ebx, value_2
	sub		eax, ebx
	mov		calcDiff, eax

;Calculate product...
	mov		eax, value_1
	mov		ebx, value_2
	mul		ebx
	mov		calcProd, eax

;Calculate integer quotient and remainder...
	mov		edx, 0
	mov		eax, value_1
	mov		ebx, value_2
	div		ebx
	mov		calcQuot, eax
	mov		calcRemd, edx
	 
;Report results
;Print Sum
	mov		eax, value_1
	call	WriteDec
	mov		edx, OFFSET plus
	call	WriteString
	mov		eax, value_2
	call	WriteDec
	mov		edx, OFFSET equal
	call	WriteString
	mov		eax, calcSum
	call	WriteDec
	call	CrLf

;Print Difference
	mov		eax, value_1
	call	WriteDec
	mov		edx, OFFSET minus
	call	WriteString
	mov		eax, value_2
	call	WriteDec
	mov		edx, OFFSET equal
	call	WriteString
	mov		eax, calcDiff
	call	WriteDec
	call	CrLf

;Print Product
	mov		eax, value_1
	call	WriteDec
	mov		edx, OFFSET times
	call	WriteString
	mov		eax, value_2
	call	WriteDec
	mov		edx, OFFSET equal
	call	WriteString
	mov		eax, calcProd
	call	WriteDec
	call	CrLf

;Print Quotient and Remainder
	mov		eax, value_1
	call	WriteDec
	mov		edx, OFFSET divide
	call	WriteString
	mov		eax, value_2
	call	WriteDec
	mov		edx, OFFSET equal
	call	WriteString
	mov		eax, calcQuot
	call	WriteDec
	mov		edx, OFFSET remainder
	call	WriteString
	mov		eax, calcRemd
	call	WriteDec
	call	CrLf

;Say "Good-Bye"
	mov		edx, OFFSET terminate
	call	WriteString
	call	CrLf


	exit	; exit to operating system
main ENDP

; (insert additional procedures here)

END main
