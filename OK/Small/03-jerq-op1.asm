; X == (A + B) - (B + A)
.286
TITLE 'Operaciones Jerarquicas 1'
.MODEL SMALL

.STACK

.DATA
    x DB ?
    a DB 5
    b DB 2

.CODE

main PROC FAR

    MOV AX, @DATA
    MOV DS, AX

;─── Valores a regs ──┐
    MOV AH, a
    MOV AL, b
;─────────────────────┘

;──── Operaciones ────┐
    ADD AH, b         ; (A + B)
    MOV x, AH         ; X == A + B
    ADD AL, a         ; (B + A)
    SUB x, AL         ; X == (A + B) - (B + A)
;─────────────────────┘
    
    MOV AX, 4C00h
    INT 21h
main ENDP

END main
