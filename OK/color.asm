TITLE ''
.MODEL SMALL

.STACK

.DATA
    palabra DB 'holaperra','$'

.CODE
.486

main PROC FAR
    MOV AX, @DATA
    MOV DS, AX

    LEA SI, palabra
ciclo:
    MOV AL, [SI]
    CMP AL, '$'
    JE outi

    CMP AL, 'a'
    JE color
sigue:

    MOV AH, 02h
    MOV DL, [SI]
    INT 21h
    INC SI
    JMP ciclo

color:
    MOV AH, 09h
    MOV AL, [SI]
    MOV BH, 00h
    MOV BL, 04h
    MOV CX, 1
    INT 10h
    JMP sigue

outi:
    MOV AX, 4C00h
    INT 21h
main ENDP

END main
