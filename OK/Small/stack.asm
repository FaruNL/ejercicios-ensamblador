.286
TITLE 'STACK'
.MODEL SMALL

printStr MACRO str
    MOV AH, 09h
    LEA DX, str
    INT 21h
ENDM

.STACK

.DATA
    inChar DB 'Ingrese char: ','$'
    newline DB 13,10,'$'
    outChar DB 'Char ingresado: ','$'
    orgChar DB 'Char original: ','$'

.CODE

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
    MOV AX, @DATA
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

    MOV AX, 4C00h
    INT 21h

main ENDP

END main
