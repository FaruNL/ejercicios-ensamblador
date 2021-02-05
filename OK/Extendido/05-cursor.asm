.286
TITLE 'Cursor en medio'

stak SEGMENT STACK
    DB 32 DUP('Stack__')
stak ENDS

code SEGMENT
ASSUME SS:stak, CS:code

main PROC FAR
    PUSH DS
    PUSH 0

;── Limpiar pantalla ─┐
    MOV AX, 0600h
    MOV BH, 07h
    MOV CX, 0000h
    MOV DX, 184Fh
    INT 10h
;─────────────────────┘

;──── Cursor mitad ───┐
    MOV AH, 02h
    MOV BH, 0h
    MOV DX, 0C27h     ; dh == 0Ch/12  (Fila) | dl = 27h/39 (Columna) , Todo desde esquina superior izquierda
    INT 10h
;─────────────────────┘

;─────── Pausa ───────┐
    MOV AH, 07h
    INT 21h
;─────────────────────┘
    
    RET
main ENDP

code ENDS

END main
