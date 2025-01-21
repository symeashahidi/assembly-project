TITLE String Primitives, Macros, and Entered Numbers Stats     (Proj6_shahidis.asm)

; Author: Syme Shahidi
; Last Modified: 6/11/2023
; OSU email address: shahidis@oregonstate.edu
; Course number/section:   CS271 Section 400
; Project Number: Project 6         Due Date: 06/11/2023
; Description: This project utilizes string primitives and macros to get 10 
;              numbers in the form of strings, converts them into numbers, 
;              and saves them into an array. Then, the sum and average of the
;			   the numbers is calculated. Then, each entered number from the array
;              is converted back into a string and displayed. Lastly, the sum and average
;              of the entered numbers is converted back to strings and displayed.

INCLUDE Irvine32.inc

; -----------------------------------------------------------------------------------------
; Name: mDisplayString
;
; Displays a string
;
; Preconditions: needs to receive a prompt
;
; Postconditions: Registers preserved and restored with pushad/popad
; 
; Receives:
;	prompt = string 
;
; Returns: none
; -----------------------------------------------------------------------------------------
mDisplayString    MACRO  prompt
	; displays the string in prompt
	pushad
	mov           edx, prompt
	call          WriteString
	popad

ENDM

; -----------------------------------------------------------------------------------------
; Name: mGetString
;
; Displays a prompt for the user and then records the input in userInput
;
; Preconditions: needs to receive a prompt, userInput, sizeOfInput, bytesRead parameters
; 
; Postconditions: Registers preserved and restored with pushad/popad
;
; Receives:
;	prompt = string 
;	userInput = records and holds the user's input
;	sizeOfInput = size of the sizeOfInput
;	bytesRead = amount of bytes read
;
; Returns: userInput with input, sizeOfInput with the length of the input, and bytesRead
; -----------------------------------------------------------------------------------------
mGetString        MACRO  prompt, userInput, sizeOfInput, bytesRead
	; displays a prompt and records the user's input
	pushad
	mov           edx, prompt
	call          WriteString
	mov           edx, userInput
	mov           ecx, sizeOfInput
	call          ReadString
	call          CrLf
	mov           bytesRead, eax
	popad

ENDM

.data

programIntro1               BYTE                     "String Primitives, Macros, and Entered Numbers Stats                   by Syme Shahidi", 0
programIntro2               BYTE					 "You will be asked to enter 10 signed decimal numbers that can fit inside a 32 bit register.", 0
programIntro3               BYTE                     "After 10 numbers have been entered, the program will display the entered numbers in a list and their sum and average.", 0
promptUserForNumber         BYTE                     "Please enter a signed number: ", 0
userInput                   BYTE                     12 DUP (?)
bytesRead                   DWORD                    ?
negativeNumber				SDWORD                   ?
errorPrompt                 BYTE                     "Error: Either you did not enter a signed number or the number you entered was too big", 0
runningTotal                SDWORD                   ?
counter                     DWORD                    ?
enteredNumbersPrompt        BYTE                     "The numbers you entered are: ", 0 
convertedNumber             SDWORD                   ?
convertToString             SDWORD                   ?
stringBuffer                BYTE                     ?
arrayOfNumbers              SDWORD                   10 DUP(?)
sumPrompt                   BYTE                     "Sum of the numbers: ", 0
sum                         SDWORD                   ?
averagePrompt               BYTE                     "Truncated average: ", 0 
average                     SDWORD                   ?
commaAndSpace               BYTE                     ", ", 0


.code
main PROC

	; displays program intro
	mDisplayString         offset programIntro1
	call                   CrLf
	call                   CrLf

	; displays description of program
	mDisplayString         offset programIntro2
	call                   CrLf
	mDisplayString         offset programIntro3
	call                   CrLf
	call                   CrLf

; ------------------------------------------------------
; Gets 10 numbers from the user by calling ReadVal and 
;	using a loop. ECX decrements each time a valid 
;	number has been read
;
; ------------------------------------------------------
	; set loop and move array into register
	mov                    ecx, 10
	mov                    edi, offset arrayOfNumbers

_callProcAndAddNumber:
	; push variables and call ReadVal
	push                   offset errorPrompt
	push				   offset promptUserForNumber
	push				   offset userInput
	push                   sizeof userInput
	push                   bytesRead
	push                   offset convertedNumber
	push                   runningTotal
	push                   negativeNumber
	call                   ReadVal

	; add number to array and then loop
	mov                    eax, convertedNumber
	mov                    [edi], eax
	add                    edi, 4
	loop _callProcAndAddNumber

; ------------------------------------------------------
; Calculates the sum and stores it in the sum variable
;
; ------------------------------------------------------
_calculateSum:
	; calculates sum
	mov                    esi, offset arrayOfNumbers                        ; movs offset of array into esi for sum calculations
	lodsd
	add                    sum, eax
	lodsd
	add                    sum, eax
	lodsd
	add                    sum, eax
	lodsd
	add                    sum, eax
	lodsd
	add                    sum, eax
	lodsd
	add                    sum, eax
	lodsd
	add                    sum, eax
	lodsd
	add                    sum, eax
	lodsd
	add                    sum, eax
	lodsd
	add                    sum, eax

; ------------------------------------------------------
; Calculates the average using idiv and stores the 
;	quotient in the average variable
;
; ------------------------------------------------------
_calculateAverage:
	; calculates average and stores it inside average
	mov                    eax, sum
	cdq																		 ; sign extends 
	mov                    ebx, 10
	idiv                   ebx
	mov                    average, eax

; ------------------------------------------------------
; Displays all of the 10 numbers by using a loop. ECX
;	is decremented each time a number is displayed
;
; ------------------------------------------------------
	; displays enteredNumbers Prompt
	mDisplayString         offset enteredNumbersPrompt
	call                   CrLf

	; sets loop and moves array into esi
	mov                    ecx, 10
	mov                    esi, offset arrayOfNumbers

_displayNumber:
	; moves array value into edx and move edx value into convertToString
	mov                    edx, [esi]
	mov                    convertToString, edx

	; pushes necessary addresses and calls WriteVal
	push                   offset stringBuffer
	push                   counter
	push                   convertToString
	call                   WriteVal

	; moves to next array element and loops
	add                    esi, 4
	mDisplayString         offset commaAndSpace								 ; adds a comma and space after each number
	loop                   _displayNumber

; ------------------------------------------------------
; Displays the sum
;
; ------------------------------------------------------
_displaySum:
	; displays sum prompt
	call                   CrLf
	call                   CrLf
	mDisplayString         offset sumPrompt
	call                   CrLf

	; pushes necessary addresses and calls WriteVal
	push                   offset stringBuffer
	push                   counter
	push                   sum
	call                   WriteVal

; ------------------------------------------------------
; Displays the average
;
; ------------------------------------------------------
_displayAverage:
	; displays the average prompt
	call                   CrLf
	call                   CrLf
	mDisplayString         offset averagePrompt
	call                   CrLf

	; pushes necessary addresses and calls WriteVal
	push                   offset stringBuffer
	push                   counter
	push                   average
	call                   WriteVal
	call                   CrLf

	Invoke ExitProcess,0	; exit to operating system
main ENDP

; -----------------------------------------------------------------------------------------
; Name: ReadVal
;
; Obtains a number in the form of a string entered by the user and converts it to an actual
; number
;
; Preconditions: The entered number must be in the form of a string
; 
; Postconditions: Registers preserved and restored with pushad/popad
;
; Receives:
;	[ebp + 36]		= offset of errorPrompt
;	[ebp + 32]		= offset of promptUserForNumber
;	[ebp + 28]		= offset of userInput
;	[ebp + 24]		= size of userInput
;	[ebp + 20]		= bytesRead
;	[ebp + 16]		= offset of convertedNumber
;	[ebp + 12]		= runningTotal
;	[ebp + 8]		= negativeNumber
;	
; Returns: former string in userInput converted to actual number in convertedNumber
; -----------------------------------------------------------------------------------------
ReadVal PROC
	; push ebp and pushad to preserve all registers
	push                   ebp
	mov					   ebp, esp
    pushad

_start:
	; gets number from mGetString macro and sets loop and moves string into esi
	mGetString             [ebp + 32], [ebp + 28], [ebp + 24], [ebp + 20]
	mov                    ecx, [ebp + 20]
	mov                    esi, [ebp + 28]

_moveAlToEax:
	; moves al value into eax
	xor                    eax, eax

_checkNumber:
	; validates the value in eax
	lodsb
	cmp                    al, 0											 ; empty input validation
	je                     _emptyInput
	cmp                    al, 42											 ; other symbols validation
	jle                    _incorrectInput
	cmp                    al, 43											 ; positive sign validation
	je                     _positiveSignCheck
	cmp                    al, 44											 ; other symbol validation
	je                     _incorrectInput									 
	cmp                    al, 45											 ; negative sign validation
	je                     _negativeSignCheck
	cmp                    al, 48											 ; other symbols validation
	jl                     _incorrectInput
	cmp                    al, 58											 ; other symbols validation
	jge                    _incorrectInput
	jmp                    _convertToNumber

_convertToNumber: 
	; converts string to number
	mov                    edx, [ebp + 12]
	sub                    eax, 48
	mov                    ebx, 10
	imul                   edx, ebx
	jo                     _incorrectInput									 ; overflow check 1
	add                    edx, eax
	jo                     _incorrectInput									 ; overflow check 2
	mov                    [ebp + 12], edx
	mov                    ebx, edx
	loop                   _moveAlToEax

	; check if negative number, otherwise, go to main
	mov                    edx, -1
	cmp                    [ebp + 8], edx									 ; negative number check
	je					   _makeNegative
	jmp                    _goToMain

_emptyInput:
	; displays an error and jumps back to start if input was empty
	mov                    edx, [ebp + 36]
	call                   WriteString
	call                   CrLf
	jmp                    _start
	
_incorrectInput:
	; displays an error and jumps back to start if input is invalid
	mov                    edx, [ebp + 36]
	call                   WriteString
	call                   CrLf

	; resets edx and runningTotal
	mov                    edx, 0
	mov                    [ebp + 12], edx
	jmp                    _start

_negativeSignCheck: 
	; moves -1 into negativeNumber if negative sign present
	mov                    ebx, -1
	mov                    [ebp + 8], ebx
	loop                   _checkNumber

_positiveSignCheck:
	; loops back to checkNumber if positive sign present
	loop                   _checkNumber

_makeNegative:
	; makes number negative
	neg                    ebx

_goToMain:
	; moves converted number into edi and makes value of edi equal to ebx
	; and pops all registers and ebp and returns to main
	mov                    edi, [ebp + 16]
	mov                    [edi], ebx
	popad
	pop                    ebp
	ret                    36

ReadVal ENDP

; -----------------------------------------------------------------------------------------
; Name: WriteVal
;
; Converts a number back to a string and displays the string
;
; Preconditions: convertToString must be in the form of an actual number
; 
; Postconditions: Registers preserved and restored with pushad/popad
;
; Receives:
;	[ebp + 16]		= offset of stringBuffer
;	[ebp + 12]		= counter
;	[ebp + 8]		= convertToString
;
; Returns: former number in convertToString converted to string in stringBuffer
; -----------------------------------------------------------------------------------------
WriteVal PROC
	; push ebp and pushad to preserve all registers
	push				   ebp
	mov                    ebp, esp
	pushad

	; move convertToString into eax and offset of stringBuffer into edi
	mov                    eax, [ebp + 8]
	mov                    edi, [ebp + 16]

	; move 0 into edx for the null terminator and push it
	mov                    edx, 0
	push                   edx

	; checks if number is negative
	cmp                    eax, 0
	jl                     _negativeNumber

_divisionLoop:
	; division loop keeps going until quotient is 0
	mov                    ebx, 10
	cdq
	idiv                   ebx
	add                    edx, 48
	push                   edx												 ; push remainder
	mov                    ebx, 1
	add                    [ebp + 12], ebx									 ; counter for each push
	cmp                    eax, 0
	jne                    _divisionLoop

	; sets loop for converting the number
	mov                    ecx, [ebp + 12]
	jmp                    _convert

_negativeNumber:
	; negates the number if number is negative
	mov                    eax, 45
	stosb
	mov                    eax, [ebp + 8]
	neg                    eax
	jmp                    _divisionLoop

_convert:
	; converts the number to a string
	pop                    eax
	stosb
	loop                   _convert											 ; loops for amount of times edx pushed in divisionLoop
	pop                    eax
	stosb
	jmp                    _displayAndReturnToMain

_displayAndReturnToMain: 
	; displays string and pops all registers and ebp and returns to main
	mDisplayString         [ebp + 16]
	popad
	pop                    ebp
	ret                    16

WriteVal ENDP

END main
