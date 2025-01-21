TITLE Program Template     (Proj6_shahidis.asm)

; Author: Syme Shahidi
; Last Modified:
; OSU email address: shahidis@oregonstate.edu
; Course number/section:   CS271 Section 400
; Project Number: Project 6         Due Date: 06/11/2023
; Description: This file is provided as a template from which you may work
;              when developing assembly projects in CS271.

INCLUDE Irvine32.inc

mDisplayString    MACRO  prompt
	push          edx
	mov           edx, prompt
	call          WriteString
	pop           edx
ENDM

mGetString        MACRO  prompt, userInput, sizeOfInput, bytesRead
	push          edx
	mov           edx, prompt
	call          WriteString
	mov           edx, userInput
	mov           ecx, lengthof sizeOfInput
	call          ReadString
	pop           edx
ENDM

; (insert constant definitions here)

.data

programIntro1               BYTE                     "String Primitives, Macros, and Entered Number Stats                   by Syme Shahidi", 0
programIntro2               BYTE					 "You will be asked to enter 10 signed decimal numbers that can fit inside a 32 bit register.", 0
programIntro3               BYTE                     "After 10 numbers have been entered, the program will display the entered numbers in a list and their sum and average.", 0
promptUserForNumber         BYTE                     "Please enter a signed number: ", 0
userInput                   DWORD                    ?
sizeOfInput                 DWORD                    ?
bytesRead                   DWORD                    ?
errorPrompt                 BYTE                     "Error: Either you did not enter a signed number or the number you entered was too big", 0
enteredNumbersPrompt        BYTE                     "The numbers you entered are: ", 0 
arrayOfNumbers              DWORD                    10 DUP(?)
sumPrompt                   BYTE                     "Sum of the numbers: ", 0
sum                         DWORD                    ?
averagePrompt               BYTE                     "Average: ", 0 
average                     DWORD                    ?


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

	; get 10 numbers
	push                   offset errorPrompt
	push				   offset promptUserForNumber
	push				   offset userInput
	push                   sizeOfInput
	push                   offset bytesRead
	push                   offset arrayOfNumbers
	mov                    ecx, 10

_addNumber:
	call                   ReadVal
	loop _addNumber



	Invoke ExitProcess,0	; exit to operating system
main ENDP

ReadVal PROC
	push                   ebp
	mov					   ebp, esp
	
	push                   ecx
	push                   esi
	push                   edi

	mGetString             [ebp + 24], [ebp + 20], [ebp + 16], [ebp + 12]

	mov                    ecx, [ebp + 16]
	mov                    esi, [ebp + 20]
	mov                    edi, [ebp + 8]

_checkNumber:
	lodsd
	cmp                    al, 0
	jmp                    _emptyInput
	cmp                    al, 42
	jle                    _incorrectInput
	cmp                    al, 43
	je                     _positiveSignCheck
	cmp                    al, 44
	je                     _incorrectInput
	cmp                    al, 45
	je                     _negativeSignCheck
	cmp                    al, 48
	jl                     _incorrectInput
	cmp                    al, 58
	jge                    _incorrectInput
	jmp                    _convertNumber

_convertNumber: 


_emptyInput:
	mov                    edx, [ebp + 28]
	call                   WriteString
	mGetString             [ebp + 24], [ebp + 20], [ebp + 16], [ebp + 12]
	jmp                    _checkNumber
	
_incorrectInput:
	mov                    edx, [ebp + 28]
	call                   WriteString
	mGetString             [ebp + 24], [ebp + 20], [ebp + 16], [ebp + 12]
	jmp                    _checkNumber

_positiveSignCheck:
	stosb
	add                    esi, 1
	jmp					   _checkNumber

_negativeSignCheck: 
	stosb
	add                    esi, 1
	jmp                    _checkNumber

	
ReadVal ENDP

WriteVal PROC

WriteVal ENDP

END main
