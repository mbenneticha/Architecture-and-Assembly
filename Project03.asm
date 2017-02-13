TITLE Integer Accumulator     (Project03.asm)

; Author: Mariam Ben-Neticha
; Course / Project ID : CS271 Program #3                Date: 02/07/16
; Description: Write a MASM program to perform the following tasks:
;	a. Display programmer name and program title on output screen.
;	b. Get user's name and greet user (i.e. "Hello, user-name").
;	c. Display instructions for the user. 
;	d. Repeatedly prompt the user to enter a number. Validate the user input to be in [-100 .. -1] (inclusive)
;	   Count and accumulate the valid user numbers until a non-negative number is entered. (discard non-negative number)
;	e. Calculate the (rounded integer) average of the negative numbers.
;	f. Display:
;		 a. the number of negative numbers entered (Note: if no negative numbers were entered,
;			display a special message and skip to d.)
;		 b. the sum of the negative numbers entered
;		 c. the average, rounded to the nearest integer (e.g. -20.5 rounds to -20)
;		 d. terminating message with the user's name (i.e. - "Good-bye, user-name").

;**EC: 1. Number the lines during user input.
;	   3. Do something astoundingly creative -- change the text color on screen

INCLUDE Irvine32.inc


.data
;statements
intro_1		BYTE	"Ready to Play Integer Accumulator?!", 0
intro_2		BYTE	"Programmed by Mariam Ben-Neticha", 0
ec_1		BYTE	"**EC: Number the lines during user input.", 0
ec_2		BYTE	"**EC: Do something astoundingly creative: Change text color", 0
getUserName	BYTE	"What is your name? ", 0
greeting_1	BYTE	"Hello, ", 0
instruct_1	BYTE	"Please enter numbers in [-100, -1].", 0
instruct_2	BYTE	"Enter a non-negative number when you are finished to see results.", 0
prompt_1	BYTE	". Enter number: ", 0
outOfRange	BYTE	"This value is out of range.", 0
non_valid	BYTE	"No valid numbers have been entered.", 0
valid_1		BYTE	"You entered ", 0
valid_2		BYTE	" valid numbers.", 0
sum			BYTE	"The sum of your valid numbers is ", 0
round_avg	BYTE	"The rounded average is ", 0
end_1		BYTE	"Thanks for playing Integer Accumulator! It's been a pleasure to meet you, ", 0

;variables
userName	BYTE	33 DUP(0)	;string to be entered by user
userNum		SDWORD	?			; integer to be entered by user
upperLimit	SDWORD	-1
lowerLimit	SDWORD	-100		;lower limit is a CONSTANT 
num_valid	DWORD	0			;keeps track of number of valid inputs
tenxnm_val	DWORD	10			;stores num_valid times 10
hf_num_val	DWORD	2			;to divide tenxnm_val by two; determines rounding
total_sum	SDWORD	0			;records the sum of the valid inputs
average		SDWORD	0			;records the average of the valid inputs
remainder	DWORD	0			;records avg remainder
input_num	DWORD	1			;tracks number of valid inputs


.code
main PROC


; Change Text Color
; EC_3: do something amazing
	mov		eax, green+(black*16)
	call	SetTextColor

; Introduction
; Display Programmer Name and Program Title on output screen
; Display Extra Credit Descriptions
	mov		edx, OFFSET intro_1
	call	WriteString
	call	CrLf
	mov		edx, OFFSET intro_2
	call	WriteString
	call	CrLf
	call	CrLf
	mov		edx, OFFSET ec_1
	call	WriteString
	call	CrLf
	mov		edx, OFFSET ec_2
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
	call	CrLf
	call	CrLf
		
;Give instructions
instruct:
	mov		edx, OFFSET instruct_1
	call	WriteString
	call	CrLf
	mov		edx, OFFSET instruct_2
	call	WriteString
	call	CrLf
	call	CrLf
	jmp		promptUser
promptUser:
	mov		eax, input_num
	call	WriteDec
	mov		edx, OFFSET prompt_1
	call	WriteString
	call	ReadInt
	mov		userNum, eax
	call	CrLf

;Validate value in range
	mov		ebx, upperLimit					;ebx = -1
	cmp		ebx, eax						
	jge		upperLimitOk					;if ebx >= eax, within upper limit range
	mov		eax, num_valid
	cmp		eax, 0
	jg		non_neg_end
	mov		edx, OFFSET non_valid
	call	WriteString
	call	CrLf
	jmp		goodbye
non_neg_end:
	mov		edx, OFFSET valid_1				;else, non-negative number, end 
	call	WriteString
	mov		eax, num_valid
	call	WriteDec
	mov		edx, OFFSET valid_2
	call	WriteString
	call	CrLf
	jmp		calcAverage						;jump to calcAverage

upperLimitOk:								;userNum is below upperLimit
	mov		ebx, lowerLimit					;ebx = -100
	mov		eax, userNum
	cmp		ebx, eax
	jle		limitsOk						;if ebx <= eax, within lower limit range
	mov		edx, OFFSET outOfRange			;else, out of range
	call	WriteString
	call	CrLf
	jmp		instruct						;loop back to instruct and prompt user for new valid value


;Calculate Sum and Average
limitsOk:
	inc		input_num					;increments user-viewed number of valid inputs
	inc		num_valid					;increments the number of valid inputs
	add		total_sum, eax				;add new user num to accumulated total
	jmp		promptUser

calcAverage:
	mov		eax, total_sum
	mov		ebx, num_valid
	cdq
	idiv	ebx							;stores quotient in eax 
	mov		average, eax
	mov		remainder, edx				;remainder stored in edx
	neg		remainder
	mov		eax, remainder				;to multiply remainder by 10
	mul		tenxnm_val
	mov		remainder, eax				;store remainder times 10
	mov		eax, num_valid				;mult num_valid by 10
	mul		tenxnm_val
	mov		tenxnm_val, eax				;store in tenxnm_val
	div		hf_num_val
	;mov		eax, hf_num_val
	cmp		remainder, eax
	jge		roundUp						;if remainder >= eax(hf_num_val), round avg up
	call	CrLf
	call	CrLf
	jmp		results

roundUp:
	dec		average	

;Display Results
results:
	mov		edx, OFFSET sum
	call	WriteString
	mov		eax, total_sum
	call	WriteInt
	call	CrLf
	mov		edx, OFFSET round_avg
	call	WriteString
	mov		eax, average
	call	WriteInt
	call	CrLf

;Say "Good-Bye"
goodbye:
	mov		edx, OFFSET end_1
	call	WriteString
	mov		edx, OFFSET userName
	call	WriteString
	call	CrLf


	exit	; exit to operating system
main ENDP

; (insert additional procedures here)

END main
