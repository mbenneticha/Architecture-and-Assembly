TITLE Sorting Random Integers     (Project05.asm)

; Author: Mariam Ben-Neticha
; Course / Project ID : CS271 Program #5                Date: 02/28/16
; Description: Write and test a MASM program to perform the following tasks:
;	a. Display programmer name and program title on output screen.
;	b. Introduce the program.
;	c. Get a user REQUEST in the range of [min = 10 .. max = 200], and validate it. 
;	d. Generatre REQUEST random integers in the range [lo = 100 .. hi = 999],
;	   storing them in consectutive elements of an array.
;	e. Display the list of integers before sorting, 10 numbers per line.
;	f. Sort the list in descending order [i.e. largest first].
;	g. Calculate and display the median value, rounded to the nearest integer.
;	h. Display the sorted list, 10 numbers per line.


INCLUDE Irvine32.inc


.data
;statements
intro_1		BYTE	"Sorting Random Integers", 0
intro_2		BYTE	"Programmed by Mariam Ben-Neticha", 0
intro_3		BYTE	"This program generates random numbers in the range [100 .. 999],", 0
intro_4		BYTE	"displays the original list, sorts the list, and calculates the ", 0
intro_5		BYTE	"median value. Finally, it displays the list sorted in descending order.", 0
instruct_1	BYTE	"How many numbers should be generated? [10 .. 200]: ", 0
invalid		BYTE	"Invalid input.", 0
unsorted	BYTE	"The unsorted random numbers: ", 0
median		BYTE	"The median is ", 0
sorted		BYTE	"The sorted list: ", 0
spaces		BYTE	"     ", 0
end_1		BYTE	"Thanks for playing! Good-bye.", 0

;variables
request		DWORD	?			;integer to be entered by user



;constants
MIN			=		10			;min user-input value
MAX			=		200			;max user-input value 
LO			=		100			;min value randomly generated
HI			=		999			;max value randomly generated
MAX_SIZE	=		200			


;arrays
list		DWORD	MAX_SIZE DUP(?)


.code
main PROC

	call	changeTextColor
	call	introduction

	push	OFFSET request		;reference paramater: request
	call	getData				;includes validation

	call	Randomize

	push	OFFSET list			;reference param: array 'list'
	push	request				;value param: request
	call	fillArray

	push	OFFSET list			;reference param: list
	push	request				;value param: request
	push	OFFSET unsorted		;reference param: title 'unsorted'
	call	displayList
	call	CrLf

	push	OFFSET list			;reference param: list
	push	request				;value param: request
	call	sortList			;includes exchangeElements
	call	CrLf

	push	OFFSET list			;reference param: list
	push	request				;value param: request
	call	displayMedian
	call	CrLf

	push	OFFSET list			;reference param: list
	push	request				;value param: request
	push	OFFSET sorted		;reference param: title 'sorted'
	call	displayList
	call	CrLf
	call	CrLf

	call	farewell
	call	CrLf

	exit
main ENDP


;-------------------------------------------------------------------------------------------;
; Change Text Color Procedure:																;
; Description:		Procedure to change text color from white to cyan using SetTextColor.	; 
; Precondition:		Colors must be within the range supported by SetTextColor.				;
; Input:			None.																	;
; Output:			None. Text color changes from call of the procedure until end of program;
; Postcondition:	None.																	;
;-------------------------------------------------------------------------------------------;

changeTextColor PROC

	mov		eax, cyan+(black*16)
	call	SetTextColor
	ret

changeTextColor ENDP

;-------------------------------------------------------------------------------------------;
; Introduction Procedure:																	;
; Description:		Procedure to explain program function to the user.						; 
; Precondition:		intro_1, intro_2, intro_3, intro_4, and intro_5 must be set to strings	;
; Input:			None.																	;
; Output:			Pre-typed strings.														;
; Postcondition:	None.																	;
;-------------------------------------------------------------------------------------------;
introduction PROC

; Display Programmer Name and Program Title on output screen
	mov		edx, OFFSET intro_1
	call	WriteString
	call	CrLf
	mov		edx, OFFSET intro_2
	call	WriteString
	call	CrLf
	call	CrLf

;Display program introduction to the user.
	mov		edx, OFFSET intro_3
	call	WriteString
	call	CrLf
	mov		edx, OFFSET intro_4
	call	WriteString
	call	CrLf
	mov		edx, OFFSET intro_5
	call	WriteString
	call	CrLf
	call	CrLf
	ret

introduction ENDP

;-------------------------------------------------------------------------------------------;
; Get Data Procedure:																		;
; Description:		Procedure to receive and validate user input is in range [10 .. 200].	; 
; Precondition:		instruct_1, MIN, MAX, OFFSET of request variable, invalid				;
; Input:			User-input request integer												;
; Output:			Pre-typed strings if user-input invalid									;
; Postcondition:	None.																	;
;-------------------------------------------------------------------------------------------;
getData PROC

	push	ebp
	mov		ebp, esp
	mov		ebx, [ebp + 8]					;store address of request into ebx


promptUser:
	mov		edx, OFFSET instruct_1
	call	WriteString
	call	ReadInt
	mov		[ebx], eax						;store user-entered value into request variable
	call	CrLf

;Validate value in range	
	cmp		eax, MAX						;MAX = 200		
	jle		upperLimitOk					;if eax <= MAX, within upper limit range
	mov		edx, OFFSET invalid				;else, out of range ... invalid
	call	WriteString
	call	CrLf
	jmp		promptUser						;if value is above 200, re-prompt

upperLimitOk:								;userNum is below upperLimit
	cmp		eax, MIN						;MIN = 10
	jge		limitsOk						;if eax >= MIN, within lower limit range
	mov		edx, OFFSET invalid				;else, out of range ... invalid
	call	WriteString
	call	CrLf
	jmp		promptUser						;loop back to instruct and prompt user for new valid value

;user-input validated
limitsOk:
	pop		ebp
	ret		4								;clean the stack by removing the DWORD

getData ENDP

;-------------------------------------------------------------------------------------------;
; Fill Array Procedure:																		;
; Description:		Procedure to fill the array, list, with REQUEST # of random integers.	; 
; Precondition:		list, HI, LO, OFFSET of request variable								;
; Input:			None.																	;
; Output:			None.																	;
; Postcondition:	None.																	;
;-------------------------------------------------------------------------------------------;
fillArray PROC

	push	ebp
	mov		ebp, esp
	mov		esi, [ebp + 12]				; address of the array 'list'
	mov		ecx, [ebp + 8]				; loop control based on request ....?

fillArrayLoop:
	mov		eax, HI
	sub		eax, LO
	inc		eax
	call	RandomRange
	add		eax, LO
	mov		[esi], eax					;enter random-generated number into array
	add		esi, 4						;move to next element in array
	loop	fillArrayLoop

	pop		ebp
	ret		8

fillArray ENDP

;-------------------------------------------------------------------------------------------;
; Sort List Procedure:																		;
; Description:		Sorts the array, list, with largest integers firsrt.					; 
; Precondition:		list address, request								;
; Input:			None.																	;
; Output:			None.																	;
; Postcondition:	None.																	;
;-------------------------------------------------------------------------------------------;
sortList PROC

	push	ebp
	mov		ebp, esp
	mov		esi, [ebp + 12]				; address of list array
	mov		ecx, [ebp + 8]				; loop control based on request
	dec		ecx

outsideLoop:
	mov		eax, [esi]					;retrieve current element
	mov		edx, esi
	push	ecx							;save counter for outer loop
insideLoop:
	mov		ebx, [esi + 4]
	mov		eax, [edx]
	cmp		eax, ebx
	jge		dontSwap					;if current element is larger, leave it in place
	add		esi, 4
	push	esi
	push	edx
	push	ecx
	call	exchangeElements
	sub		esi, 4
dontSwap:
	add		esi, 4						;go to next element
	loop	insideLoop

	pop		ecx							;retrieve counter for outer loop
	mov		esi, edx					;reset esi
	add		esi, 4						;go to next element
	loop	outsideLoop
	
	pop		ebp
	ret		8

sortList ENDP

;-------------------------------------------------------------------------------------------;
; Exchange Elements Procedure:																		;
; Description:		Procedure to swap integers when called by Sort PROC.					; 
; Precondition:		list address, request													;
; Input:			None.																	;
; Output:			None.																	;
; Postcondition:	None.																	;
;-------------------------------------------------------------------------------------------;
exchangeElements PROC

	push	ebp
	mov		ebp, esp
	pushad
	mov		eax, [ebp + 16]						;address of first integer
	mov		ebx, [ebp + 12]						;address of second integer
	mov		edx, eax
	sub		edx, ebx							;difference of two integers

	;swap values if necessary
	mov		esi, ebx
	mov		ecx, [ebx]
	mov		eax, [eax]
	mov		[esi], eax							;place eax into array
	add		esi, edx
	mov		[esi], ecx

	popad
	pop		ebp
	ret		12

exchangeElements ENDP


;-------------------------------------------------------------------------------------------;
; Display Median Procedure:																	;
; Description:		Procedure to find median of the array, list.							; 
; Precondition:		list address, request													;
; Input:			None.																	;
; Output:			median value calculated as well as pre-written string																	;
; Postcondition:	None.																	;
;-------------------------------------------------------------------------------------------;
displayMedian PROC

	push	ebp
	mov		ebp, esp
	mov		esi, [ebp + 12]						;address of array, list
	mov		eax, [ebp + 8]						;loop control based on request, the number of values in the array
	mov		edx, 0
	mov		ebx, 2
	div		ebx
	mov		ecx, eax

findMedian:
	add		esi, 4
	loop	findMedian

	cmp		edx, 0
	jnz		oddRequest							;if edx != 0, then request value is odd
	mov		eax, [esi - 4]
	add		eax, [esi]
	mov		edx, 0
	mov		ebx, 2
	div		ebx
	mov		edx, OFFSET median
	call	WriteString
	call	WriteDec
	call	CrLf
	jmp		endMedian

oddRequest:
	mov		eax, [esi]
	mov		edx, OFFSET median
	call	WriteString
	call	WriteDec
	call	CrLf

endMedian:
	pop		ebp
	ret		8

displayMedian ENDP

;-------------------------------------------------------------------------------------------;
; Display List Procedure:																	;
; Description:		Procedure to print the array, list, to the screen.						; 
; Precondition:		list address, request values, title (sorted or unsorted)				;
; Input:			None.																	;
; Output:			None.																	;
; Postcondition:	None.																	;
;-------------------------------------------------------------------------------------------;
displayList PROC

	push	ebp
	mov		ebp, esp
	mov		ebx, 0						;display only 10 values per row
	mov		esi, [ebp + 16]				;address of list array
	mov		ecx, [ebp + 12]				;loop counter
	mov		edx, [ebp + 8]				;address of title

	call	WriteString
	call	CrLf


displayListLoop:
	mov		eax, [esi]
	call	WriteDec
	mov		edx, OFFSET spaces
	call	WriteString
	inc		ebx
	cmp		ebx, MIN
	jl		nextElement					;if ebx is less than 10, go to next element in array. if 10, [ENTER].
	call	CrLf
	mov		ebx, 0

nextElement:
	add		esi, 4						;move to next element in array
	loop	displayListLoop

	pop		ebp
	ret		8

displayList ENDP

;-------------------------------------------------------------------------------------------;
; Farewell Procedure:																		;
; Description:		Procedure to say goodbye.												; 
; Precondition:		end_1 is a pre-written string											;
; Input:			None.																	;
; Output:			None.																	;
; Postcondition:	None.																	;
;-------------------------------------------------------------------------------------------;
farewell PROC
;Say "Good-Bye"

	mov		edx, OFFSET end_1
	call	WriteString
	call	CrLf
	exit									; exit to operating system

farewell ENDP

END main
