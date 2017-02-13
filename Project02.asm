TITLE Fibonacci Numbers     (Project02.asm)

; Author: Mariam Ben-Neticha
; Course / Project ID : CS271 Program #2                Date: 01/21/16
; Description: Write a MASM program that calculates Fibonnaci Numbers.
;	a. Display programmer name and program title on output screen.
;	b. Get user's name and greet user (i.e. "Hello, user-name").
;	c. Prompt user to enter the number of Fibonacci terms to be displayed within the range of [1 .. 46]. 
;	d. Get and validate user input (n).
;	e. Calculate and display all of the Fibonnaci numbers up to and including the nth term.
;		-> Results: Display 5 terms/line with at least 5 spaces between terms.
;	f. Display a terminating message (i.e. - "Good-bye").

INCLUDE Irvine32.inc


.data
;statements
intro_1		BYTE	"FIBONACCI NUMBERS", 0
intro_2		BYTE	"Programmed by:    Mariam Ben-Neticha", 0
getUserName	BYTE	"What is your name? ", 0
greeting_1	BYTE	"Hello, ", 0
greeting_2	BYTE	", let's calculate Fibonnaci numbers!", 0
instruct_1	BYTE	"Enter the number of Fibonacci terms to be displayed.", 0
instruct_2	BYTE	"Give the number as an integer in the range of [1 .. 46].", 0
prompt_1	BYTE	"How many Fibonacci terms do you want to view? ", 0
outOfRange	BYTE	"Out of range. Enter a number in [1 .. 46].", 0
spaces		BYTE	"          ", 0
end_1		BYTE	"Impressed, ", 0
end_2		BYTE	"? Bye!", 0

;variables
userName	BYTE	33 DUP(0)	;string to be entered by user
userNum		DWORD	?			; integer to be entered by user
upperLimit	DWORD	46
lowerLimit	DWORD	1
total		DWORD	0


.code
main PROC


; Introduction
; Display Programmer Name and Program Title on output screen 
	mov		edx, OFFSET intro_1
	call	WriteString
	call	CrLf
	mov		edx, OFFSET intro_2
	call	WriteString
	call	CrLf
	call	CrLf

;Display instructions to the user.
;Get user name
	mov		edx, OFFSET getUserName
	call	WriteString
	mov		edx, OFFSET userName
	mov		ecx, 32
	call	ReadString

;Greet User
	mov		edx, OFFSET greeting_1
	call	WriteString
	mov		edx, OFFSET userName
	call	Writestring
	mov		edx, OFFSET greeting_2
	call	WriteString
	call	CrLf
	call	CrLf
		
;Get user value
	mov		edx, OFFSET instruct_1
	call	WriteString
	call	CrLf
	mov		edx, OFFSET instruct_2
	call	WriteString
	call	CrLf
	call	CrLf
	jmp		promptUser
promptUser:
	mov		edx, OFFSET prompt_1
	call	WriteString
	call	ReadInt
	mov		userNum, eax
	call	CrLf

;Validate value in range
	mov		ebx, upperLimit					;ebx = 46
	cmp		ebx, eax						
	jge		upperLimitOk					;if ebx >= eax, within upper limit range
	mov		edx, OFFSET outOfRange			;else, out of range
	call	WriteString
	call	CrLf
	jmp		promptUser						;loop back to re-prompt user for new value

upperLimitOk:								;userNum is below upperLimit
	mov		ebx, lowerLimit					;ebx = 1
	cmp		ebx, eax
	jle		limitsOk						;if ebx <= eax, within lower limit range
	mov		edx, OFFSET outOfRange			;else, out of range
	call	WriteString
	jmp		promptUser						;loop back to prompt user for new value


;Calculate Fibonacci terms
limitsOk:
	mov		eax, 0						;set accumulator = 0
	mov		ebx, lowerLimit				;lower limit (1) in ebx
	mov		ecx, userNum				;number times to execute loop = user-input
	mov		esi, 5						;number of terms to print per line

calcFib:
	mov		total, eax
	add		eax, ebx					;stores sum in eax 
	call	WriteDec
	mov		ebx, total
	dec		esi
	jnz		fiveSpaces
	cmp		ecx, 1
	je		endFib

endLine:
	call	CrLf
	mov		esi, 5					;replenishes for next line
	cmp		ecx, 1
	je		endFib
	loop	calcFib					;subtracts 1 from ecx & repeats until ecx = 0

fiveSpaces:
	cmp		ecx, 1
	je		endLine
	mov		edx, OFFSET spaces
	call	WriteString
	loop	calcFib


endFib:	
	call	CrLf
	call	CrLf

;Say "Good-Bye"
	mov		edx, OFFSET end_1
	call	WriteString
	mov		edx, OFFSET userName
	call	WriteString
	mov		edx, OFFSET end_2
	call	WriteString
	call	CrLf


	exit	; exit to operating system
main ENDP

; (insert additional procedures here)

END main
