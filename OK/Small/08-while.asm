; Contar la cantidad total de chars ingresados, parar cuando sea ingresado <enter>
.286
TITLE 'while'
.MODEL SMALL

.STACK

.DATA
    count DB 0
    aviso DB 'Ingresa el numero maximo de iteraciones: ', '$'

.CODE

main PROC FAR
    MOV AX, @DATA
    MOV DS, AX

;──── Print: aviso ───┐
    MOV AH, 09h
    LEA DX, aviso
    INT 21h
;─────────────────────┘

;── Lectura: Numero ──┐
    MOV AH, 01h
    INT 21h
    SUB AL, '0'
;─────────────────────┘

    MOV BL, AL        ; Copiamos AL a BL, pues el valor de AL será sobrescrito al imprimir un char

;─── Salto de linea ──┐
    MOV AH, 02h
    MOV DL, 13
    INT 21h
    
    MOV DL, 10
    INT 21h
;─────────────────────┘

    XOR CX, CX        ; El registro CX se pondrá en 0s

whileL:
    CMP CL, BL
    JAE fin

    MOV DL, CL
    ADD DL, '0'
    INT 21h

;─── Salto de linea ──┐
    MOV DL, 13
    INT 21h
    
    MOV DL, 10
    INT 21h
;─────────────────────┘

    INC CL

    JMP whileL
    
fin:
    MOV AX, 4C00h
    INT 21h

main ENDP

END main
