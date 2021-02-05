.286
TITLE ''

printStr MACRO str
    MOV AH, 09h
    LEA DX, str
    INT 21h
ENDM

stak SEGMENT STACK
    DB 32 DUP('Stack__')
stak ENDS

data SEGMENT
    inChar DB 'Ingrese char: ','$'
    newline DB 13,10,'$'
    outChar DB 'Char ingresado: ','$'
    orgChar DB 'Char original: ','$'
data ENDS

code SEGMENT
ASSUME SS:stak, DS:data, CS:code

readChar PROC
    MOV AH, 01h
    INT 21h
    RET
readChar ENDP

printChar PROC
    MOV AH, 02h
    MOV DL, AL
    INT 21h
    RET
printChar ENDP

main PROC FAR
    PUSH DS
    PUSH 0
    
    MOV AX, data
    MOV DS, AX

;--- Lectura  char ---;
    printStr inChar
    CALL readChar
    printStr newline
    printStr outChar
    CALL printChar
;---------<>----------;

    printStr newline
    printStr newline

    PUSH AX

;--- Lectura  char ---;
    printStr inChar
    CALL readChar
    printStr newline
    printStr outChar
    CALL printChar
;---------<>----------;

    POP AX

    printStr newline
    printStr newline

    printStr orgChar
    CALL printChar

    RET

main ENDP

code ENDS

END main
