.286
TITLE ''
.MODEL SMALL

.STACK

.DATA
    str1 DB 4 
         DB 4
         DB 'hola',10,13,'$'

    str2 DB 4 
         DB 4
         DB 'moco',10,13,'$'

    save DW ?

.CODE

main PROC FAR
    MOV AX, @DATA
    MOV DS, AX

    XOR BX, BX
    LEA BX, [str1]
    MOV SI, BX

    MOV AH, 09h
    LEA DX, [SI+2]
    INT 21h

    XOR BX, BX
    LEA BX, [str2]
    MOV SI, BX

    MOV AH, 09h
    LEA DX, [SI+2]
    INT 21h

    MOV save, OFFSET [str1+2]

    MOV AH, 09h
    MOV DX, save
    INT 21h

    MOV AX, 4C00h
    INT 21h
main ENDP

END main
