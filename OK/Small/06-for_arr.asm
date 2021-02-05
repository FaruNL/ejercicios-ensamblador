.286
TITLE ''
.MODEL SMALL

.STACK

.DATA
    array DB 5 DUP('a')

.CODE

main PROC FAR
    MOV AX, @DATA
    MOV DS, AX

    XOR CX, CX        ; El registro CX se pondrá en 0s
    LEA SI, array     ; Carga la dirección efectiva (Incluyendo el offset) del arreglo <array> al registro SI

;─── Insert: array ───┐
for:
    CMP CL, 4
    JA continue       ; Si CL > 4, saltamos a salir:

    MOV AH, 01h       ; Leemos caracter de STDIN
    INT 21h

    MOV [SI], AL      ; Movemos el char ingresado a la posición actual del arreglo

    INC	CL
    INC SI

    JMP for
;─────────────────────┘

continue:
;──── Print: "\n" ────┐
    MOV AH, 02h
    MOV DL, 10
    INT 21h
    
    MOV DL, 13
    INT 21h
;─────────────────────┘

    XOR CX, CX
    LEA SI, array     ; Reiniciamos la dirección efectiva del arreglo <array> al registro SI

;──── Print: array ───┐
imprimir:
    CMP CL, 4
    JA salir

    MOV AH, 02h
    MOV DL, [SI]
    INT 21h

    INC	CL
    INC SI

    JMP imprimir
;─────────────────────┘

salir:
    MOV AX, 4C00h
    INT 21h
main ENDP

END main
