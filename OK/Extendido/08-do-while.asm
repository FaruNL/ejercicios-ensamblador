; Ingresa un char hasta que sea ingresado <enter>, entonces parar.
.286
TITLE 'while'

stak SEGMENT STACK
    DB 32 DUP('Stack__')
stak ENDS

data SEGMENT
    aviso DB 'Ingresa un un caracter (<enter> para salir del programa)',13, 10, '$'
data ENDS

code SEGMENT
ASSUME SS:stak, DS:data, CS:code

main PROC FAR
    PUSH DS
    PUSH 0
    
    MOV AX, data
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
    RET

main ENDP

code ENDS

END main
