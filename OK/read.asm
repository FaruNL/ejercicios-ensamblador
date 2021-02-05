TITLE ''
.MODEL SMALL

.STACK

.DATA
    str1 DB 25 (?)

.CODE
.486

main PROC FAR
    MOV AX, @DATA
    MOV DS, AX

    LEA SI, str1

input:
    MOV AH, 01h
    INT 21H
    CMP AL, 0Dh
    JE show
    MOV [SI], AL
    INC SI
    JMP input

show:
    MOV DX, '$'
    MOV [SI], DX

    MOV AH, 09h
    LEA DX, str1
    INT 21h

    MOV AX, 4C00h
    INT 21h
main ENDP

END main
