; X == (A + B) - (B + A)
.286
TITLE ''

stak SEGMENT STACK
    DB 32 DUP('Stack__')
stak ENDS

data SEGMENT
    x DB ?
    a DB 5
    b DB 2
data ENDS

code SEGMENT
ASSUME SS:stak, DS:data, CS:code

main PROC FAR
    PUSH DS
    PUSH 0

    MOV AX, data
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
    
    RET
main ENDP

code ENDS

END main
