TITLE Designing Low Level I/O Procedures     (Project06A.asm)

; Author: Mariam Ben-Neticha
; Course / Project ID : CS271 Program #6A                Date: 03/09/16
; Description: Write and test a MASM program to perform the following tasks:
;	a. Display programmer name and program title on output screen.
;	b. Introduce the program.
;	c. Prompt and get 10 valid integers from the user using getString macro. 
;	d. Use readVal procedure to get user's string of digits [using getString macro] then convert digit string to numeric values while validating values.
;	e. Store numeric values in an array.
;	f. Display the list of integers using procedure writeVal [converts numeric value to string of digits then calls displayString].
;	g. Calculate and display the sum and average value of the integers, rounded down to the nearest integer.

;	EC3. Make readval and writeVal procedures RECURSIVE


INCLUDE Irvine32.inc



; MACRO Definitions
;-------------------------------------------------------------------------------------------;
; displayString Macro:																		;
; Description:		Display a string stored at specified memory location.					; 
; Parameters:		stringLocation															;
;-------------------------------------------------------------------------------------------;
displayString MACRO stringLocation
	push 	edx
	mov 	edx, stringLocation
	call 	WriteString
	pop 	edx
ENDM


;-------------------------------------------------------------------------------------------;
; getString Macro:																			;
; Description:		Get user's keyboard input and store into memory location.				; 
; Parameters:		memAddress, stringMessage												;
;-------------------------------------------------------------------------------------------;
getString MACRO stringMessage, memAddress
	push	edx
	push 	ecx
	push	eax
	mov		edx, stringMessage
	call	WriteString
	mov 	edx, memAddress									; address to store user input in mem
	mov 	ecx, MAX_STRING									; limit of string length to be read-in
	call 	ReadString						
	pop		eax
	pop 	ecx
	pop		edx
ENDM

.data
;statements
intro_1			BYTE	"Designing Low-Level I/O Procedures", 0
intro_2			BYTE	"Written by: Mariam Ben-Neticha", 0
intro_3			BYTE	"EC3: Make writeVal procedure RECURSIVE."
instruct_1		BYTE	"Please provide 10 unsigned decimal integers.", 0
instruct_2		BYTE	"Each number needs to be small enough to fit inside a 32 bit register.", 0
instruct_3		BYTE	"After you have finished inputting the raw numbers I will display a list", 0
instruct_4		BYTE	"of the integers, their sum, and their average value.", 0
input			BYTE	"Please enter an unsigned number: ", 0
invalid			BYTE	"ERROR: You did not enter an unsigned number or your number was too big.", 0
retry			BYTE	"Please try again: ", 0
print_comma		BYTE 	", ", 0	
print_array		BYTE	"You entered the following numbers: ", 0
print_sum		BYTE	"The sum of these numbers is: ", 0
print_avg		BYTE	"The average is: ", 0
end_1			BYTE	"Thanks for playing!", 0

;constants
MAX_STRING	= 100												;max length of string user can enter
MAX_NUM		= 10												;number of user-input values

;variables
user_input		BYTE 	MAX_STRING + 1 DUP(?)					;stores user-input
input_valid		BYTE 	MAX_STRING + 1 DUP(?)					;stores validated input
input_length	DWORD	LENGTHOF user_input
input_type_size	DWORD	TYPE input_valid
num_result		DWORD	0										;stores numeric value after conversion FROM string
recursive_val	BYTE 	2 DUP(?)								;stores a character
list_sum		DWORD 	0										;stores the sum of all elements within list[] array

;arrays
list			DWORD	MAX_NUM DUP(0)

 .code
main PROC

;changeTextColor
	call	changeTextColor

;intro
	push 	OFFSET intro_1
	push 	OFFSET intro_2
	push	OFFSET intro_3
	call	introduction

;instructions
	push 	OFFSET instruct_1 
	push 	OFFSET instruct_2
	push 	OFFSET instruct_3
	push 	OFFSET instruct_4
	call	instructions

;getData
	push	OFFSET num_result
	push	OFFSET input_valid
	push	OFFSET user_input
	push	input_type_size 
	push	input_length
	push	OFFSET invalid 
	push	OFFSET retry 
	push	OFFSET input
	push	MAX_NUM
	push 	OFFSET list
	call	getData

;displayList
	call 			CrLf
	displayString	OFFSET print_array
	call 			CrLf

	push	OFFSET recursive_val 
	push	MAX_NUM
	push 	OFFSET list
	call 	displayList

;displaySum
	push	OFFSET print_sum
	push	OFFSET recursive_val
	push	OFFSET list_sum
	push	MAX_NUM
	push 	OFFSET list
	call 	displaySum

;displayAverage
	push	OFFSET print_avg 
	push	OFFSET recursive_val
	push	list_sum
	push	MAX_NUM
	call 	displayAverage

;farewell
	push 	OFFSET end_1
	call	farewell

	exit
main ENDP


;-----------------------------------------------------------------------------------------------;
; Change Text Color Procedure:																	;
; Description:		Procedure to change text color from white to cyan using SetTextColor.		;
; Recieve:			None.																		;
; Return:			None.																		;
;-----------------------------------------------------------------------------------------------;
changeTextColor PROC

	mov		eax, magenta+(black*16)
	call	SetTextColor
	ret

changeTextColor ENDP

;-----------------------------------------------------------------------------------------------;
; Introduction Procedure:																		;
; Description:		Procedure to display title and programmer name.								; 
; Recieve:		intro_1, intro_2, intro_3																;
; Return:			None.																		;
;-----------------------------------------------------------------------------------------------;
introduction PROC
	pushad
	mov 	ebp, esp
	displayString [ebp+44]								;intro_1 = program title
	call	CrLf
	displayString [ebp+40]								;intro_2 = programmer name
	call	CrLf
	displayString [ebp+36]								;intro_3 = extra credit
	call	CrLf

	popad
	ret 12
introduction ENDP

;-----------------------------------------------------------------------------------------------;
; Instruction Procedure:																		;
; Description:		Procedure to explain program function to the user.							; 
; Recieve:			instruct_1, instruct_2, instruct_3, instruct_4								;
; Return:			None.																		;
;-----------------------------------------------------------------------------------------------;
instructions PROC
	pushad
	mov		ebp, esp
	call	CrLf
	displayString [ebp+48]						;instruct_1
	call	CrLf
	displayString [ebp+44]						;instruct_2
	call	CrLf
	displayString [ebp+40]						;instruct_3
	call	CrLf
	displayString [ebp+36]						;instruct_4
	call	CrLf
	call	CrLf
	call	CrLf

	popad
	ret 16
instructions ENDP


;-----------------------------------------------------------------------------------------------;
; Get Data Procedure:																			;
; Description:		Procedure to get user input.												; 
; Recieve:			OFFSET list, MAX_NUM, OFFSET input, OFFSET retry, OFFSET invalid,			;
;					input_length, input_type_size, OFFSET user_input, OFFSET input_valid,		;
;					OFFSET num_result															;
; Return:			None.																		;
;-----------------------------------------------------------------------------------------------;
getData PROC
	pushad
	mov 	ebp, esp
	mov 	ecx, [ebp+40]						;MAX_NUM
	mov 	esi, [ebp+36]						;@list

getInput:
;Get number from user
	push 	[ebp+44]						; Param: input
	push 	[ebp+48]						; Param: retry
	push 	[ebp+52]						; Param: invalid
	push 	[ebp+56]						; Param: input_length
	push 	[ebp+60]						; Param: input_type_size
	push	[ebp+64]						; Param: user_input 
	push	[ebp+68]						; Param: input_valid 
	push	[ebp+72]						; Param: num_result
	call	readVal

;store 10 unsigned integers in list[]
	mov 	ebx, num_result
	mov 	[esi], ebx
	add 	esi, 4

;reset num_result
	mov		eax, 0
	mov		num_result, eax
	loop	getInput

	popad
	ret	40	
getData ENDP


;-----------------------------------------------------------------------------------------------;
; Read Val Procedure:																			;
; Description:		Procedure to get string input and convert it to a numeric value.			; 
; Recieve:			OFFSET num_result, OFFSET input_valid, OFFSET user_input, input_type_size,	;
;					input_length, OFFSET invalid, OFFSET retry, OFFSET input  					;
; Return:			Value stored in input_valid.												;
;-----------------------------------------------------------------------------------------------;
readVal PROC
;save registers
	push	eax
	push	ebx
	push	ecx
	push	edx
	push	esp
	push	esi
	push	edi
	push	ebp

	mov		ebp, esp
	sub 	esp, 8								;save space for 2 local variables. 

;store length of string array in local variable
	mov		eax, [ebp+52]						;input_length
	mov		DWORD PTR [ebp-8], eax				;save to local variable
 	mov		eax, 0								;clear eax

	getString [ebp+64], [ebp+44]				;get user string using macro [param: input, user_input]
	jmp		begin

invalidNum:										;if user input is not valid
	mov 	eax, 0								;clear registers
	mov		ebx, 0
	mov		ecx, 0
	mov		edx, 0

;clear source array
	push 	[ebp+48]							;input_type_size
	push 	[ebp-8]								;number elements in the source array: user_input
	push 	[ebp+44]							;user_input
	call 	clearArray
		
;make a call to clear destination array
	push 	[ebp+48]							;input_type_size
	push 	[ebp-8]								;number elements in the destination array: input_valid
	push 	[ebp+40]							;@input_valid
	call 	clearArray

;display invalid and retry
	displayString	[ebp+56]					;print invalid message
	call	CrLf
	getString		[ebp+60], [ebp+44]			;print retry and reprompt

;continue
begin:
 	mov 	esi, [ebp+44]						;user_input
 	mov 	edi, [ebp+40]						;input_valid 
 	mov 	ecx, [ebp+52]						;input_length = sets loop counter
 	mov 	edx, 0								;clear edx to track number of values added
 	cld											;validate each string number in the source array, user_input

readValLoop: 
	lodsb										;moves byte at [esi] into al 
	cmp		al, 0
	je		readValLoopEnd						;if al == 0, then exit loop
;Validate
	sub 	al, 48								;subtract the ascii byte by 48 to get the integer
	cmp		al, 0
	jl		invalidNum							;if al < 0, jmp to invalidNum
	cmp		al, 9
	jg		invalidNum							;if al > 9, jmp invalidNum

;Numbers are valid and have been converted
	inc 	edx									;tracks number of digits added
	stosb										;moves byte in the AL register to memory at [edi]
	loop 	readValLoop							;move to next position in string array

readValLoopEnd:
 	cmp 	edx, 0
 	je 		invalidNum							;if edx == 0, no digits were added and there is an error; go back to invalidNum
	mov 	ecx, 0								;reset ecx register
	dec 	edx									;decrement number of elements to convert by 1
	mov		DWORD PTR [ebp-4], edx				;store edx into a local variable [edx = number of elements]
	mov 	esi, [ebp+40]						;esi holds input_valid array
	mov 	edi, [ebp+36]						;edi holds num_result
	mov		eax, 0								;clear eax register
	cld
convertToInt:
	lodsb
	mov 	ebx, 10								;multiplication factor	
	mov 	ecx, edx							;set ecx to the exponent of 10 
	mov		DWORD PTR [ebp-4], edx				;store edx into a local variable

;exit if on the ones digit
	cmp		ecx, 0
	je		storeNewDigit						;if ecx == 0, jmp to storeNewDigit

multiplyByTen:
	mul 	ebx	
	jo		invalidNum							;if overflow, jump to invalidNum
	loop 	multiplyByTen

storeNewDigit:
	mov		ebx, [edi]
	add		eax, ebx
	mov		[edi], eax
	jc		invalidNum							;if overflow, jump to invalidNum
	mov 	edx, [ebp-4]						;restore edx to the number of elements to convert
	cmp		edx, 0 
	je		exitReadVal							;if saved the last digit, jump to exitreadVal
	dec		edx	
	mov		eax, 0
	loop 	convertToInt

exitReadVal:
	mov		esp, ebp
	pop 	ebp
	pop	 	edi
	pop 	esi
	pop 	esp
	pop 	edx
	pop 	ecx
	pop 	ebx
	pop 	eax
	ret 32 
readVal ENDP


;-----------------------------------------------------------------------------------------------;
; Clear Array Procedure:																		;
; Description:		Procedure to fill array with null-terminating characters.					; 
; Recieve:			address of array to clear, input_type_size, input_length					;
; Return:			None.																		;
;-----------------------------------------------------------------------------------------------;
clearArray PROC
	pushad
	mov 	ebp, esp
	mov 	esi, [ebp+36]						;OFFSET of array
	mov 	ecx, [ebp+40]						;input_length ... sets loop counter
	mov 	ebx, [ebp+44]						;input_type_size
	mov 	eax, 0								;0 to put into each position
	cmp		ecx, 0
	jle		endArrayClearLoop					;if ecx = 0, exit loop

startArrayClearLoop:							;loop to clear all elements in the array
	mov 	[esi], eax							;replace current element with zero
	add 	esi, ebx							;increment to next element
	loop 	startArrayClearLoop 

endArrayClearLoop:
	popad
	ret 12 
clearArray ENDP 


;-----------------------------------------------------------------------------------------------;
; Display List Procedure:																		;
; Description:		Procedure to display an array												; 
; Recieve:			address of array to display, address of string array, input_length			;
; Return:			None.																		;
;-----------------------------------------------------------------------------------------------;
displayList PROC
	pushad
	mov 	ebp, esp
	mov 	ecx, [ebp+40]						;input_length
	mov 	esi, [ebp+36]						;@ of the array

displayNextElement:
	push 	[ebp+44]							;param: @ to hold the recursive value 
	push 	[esi]								;param: the numeric value to display
	call 	writeVal
	add 	esi, 4								;increment to next element
	mov 	ebx, 1
	cmp 	ebx, ecx							;if ebx == ecx, we are at last element in array
	je 		skipLastCommaAdd					
	mov		edx, OFFSET print_comma 
	call 	WriteString							;add 3 spaces after the displayed number

skipLastCommaAdd:
	loop 	displayNextElement					;restart loop if ecx != 0
	call	CrLf

	popad
	ret 12
displayList ENDP


;-----------------------------------------------------------------------------------------------;
; Write Val Procedure:																			;
; Description:		Procedure to convert numeric value to a string and display it.				; 
; Recieve:			numeric value to display, OFFSET of string array							;
; Return:			None.																		;
;-----------------------------------------------------------------------------------------------;
writeVal PROC
	pushad
	mov 	ebp, esp

	mov 	eax, [ebp+36]							;numeric value
	mov 	ebx, 10									;save the divisor (10)
	cdq												;clear edx on preparation for division
	div 	ebx
	cmp 	eax, 0									; Check if we hit the base case
	jne 	recursive								;if eax != 0 (if not base case), jmp to recursvie
	jmp		endRecurse								;if eax = 0, jmp to base case

recursive:											;recursive case
	push	[ebp+40]								;param: the single-character string array
	push 	eax										;param: the numeric value
	call 	writeVal								;recursive call
endRecurse:											;base case
	add		dl, 48									;gets the ascii integer value
	mov		edi, [ebp+40]							;store string array in edi register
	mov 	[edi], dl								;save integer character to destination address
	displayString	[ebp+40]

	popad
	ret 8 
writeVal ENDP 


;-----------------------------------------------------------------------------------------------;
; Display Sum Procedure:																		;
; Description:		Procedure to calculate and display the sum of all elements in the array.	; 
; Recieve:			@list, input_length, list_sum, @input_valid, @print_sum						;
; Return:			None.																		;
;-----------------------------------------------------------------------------------------------;
displaySum PROC
	pushad
	mov 	ebp, esp
	mov 	eax, 0								
	mov 	ecx, [ebp+40]						;set loop counter
	mov 	esi, [ebp+36]						;store @ of the array
	mov 	edi, [ebp+44]						;store @ of num_result

displayNextElement:
	add 	eax, [esi]							
	add 	esi, 4								;increment to next element
	loop 	displayNextElement
	mov 	[edi], eax							;store final sum into list_sum 
	displayString	[ebp+52]

	; Display the sum
	push 	[ebp+48]							;param: @ to hold the recursive value 
	push 	[edi]								;param: numeric value
	call 	writeVal	
	call	CrLf

	popad
	ret 20 
displaySum ENDP 


;-----------------------------------------------------------------------------------------------;
; Display Average Procedure:																	;
; Description:		Procedure to calculate and display the average of all elements in the array.; 
; Recieve:			list_sum, input_length, @input_valid, @print_avg							;
; Return:			None.																		;
;-----------------------------------------------------------------------------------------------;
displayAverage PROC
	pushad
	mov 	ebp, esp
	mov 	eax, 0
	mov 	ebx, [ebp+36]								;divisor
	mov 	eax, [ebp+40]								;dividend
	cdq
	div 	ebx
	displayString	[ebp+48]

;Display average
	push 	[ebp+44]									;param: recursive_num 
	push 	eax											;param: numeric value to print on screen
	call 	writeVal
	call	CrLf

	popad
	ret 16
displayAverage ENDP 


;-----------------------------------------------------------------------------------------------;
; Farewell Procedure:																			;
; Description:		Procedure to say good-bye and end the program								; 
; Recieve:			end_1																		;
; Return:			None.																		;
;-----------------------------------------------------------------------------------------------;
farewell PROC
	pushad
	mov 	ebp, esp
	call	CrLf
	call	CrLf
	displayString [ebp+36] 
	call	CrLf

	popad
	ret 4
farewell ENDP
END main