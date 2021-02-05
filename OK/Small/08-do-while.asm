; Ingresa un char hasta que sea ingresado <enter>, entonces parar.
.286
TITLE 'while'
.MODEL SMALL

.STACK

.DATA
    aviso DB 'Ingresa un un caracter (<enter> para salir del programa)',13, 10, '$'

.CODE

main PROC FAR
    MOV AX, @DATA
    MOV DS, AX

;──── Print: aviso ───┐
    MOV AH, 09h
    LEA DX, aviso
    INT 21h
;─────────────────────┘

doWhile:
;── Lectura: Numero ──┐
    MOV AH, 01h
    INT 21h
;─────────────────────┘
    
    CMP AL, 13        ; Comparamos el char ingresado (AL) con el ASCII del enter (13)
    JE fin

;─── Salto de linea ──┐
    MOV AH, 02h
    MOV DL, 13
    INT 21h
    
    MOV DL, 10
    INT 21h
;─────────────────────┘

    JMP doWhile
    
fin:
    MOV AX, 4C00h
    INT 21h

main ENDP

END main
