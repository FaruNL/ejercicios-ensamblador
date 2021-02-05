;               MULTIPLICACIÓN
; ┌───────────────┬───────────────┬──────────┐
; │ Multiplicando │ Multiplicador │ Producto │
; ├───────────────┼───────────────┼──────────┤
; │       AL      │      r/m8     │    AX    │
; │       AX      │     r/m16     │   DX:AX  │
; │      EAX      │     r/m32     │  EDX:EAX │
; │      RAX      │     r/m64     │  RDX:RAX │
; └───────────────┴───────────────┴──────────┘
;
;                  DIVISIÓN
; ┌───────────┬─────────┬──────────┬─────────┐
; │ Dividendo │ Divisor │ Cociente │ Divisor │
; ├───────────┼─────────┼──────────┼─────────┤
; │   AX      │  r/m8   │    AL    │    AH   │
; │  DX:AX    │  r/m16  │    AX    │    DX   │
; │ EDX:EAX   │  r/m32  │   EAX    │   EDX   │
; │ RDX:RAX   │  r/m64  │   RAX    │   RDX   │
; └───────────┴─────────┴──────────┴─────────┘

; X = (A + B) / (C - D) * Z
.286
TITLE ''

stak SEGMENT STACK
    DB 32 DUP('Stack__')
stak ENDS

data SEGMENT
    a DB 5
    b DB 3
    c DB 6
    d DB 4
    z DB 3
data ENDS

code SEGMENT
ASSUME SS:stak, DS:data, CS:code

 

main PROC FAR
    PUSH DS
    PUSH 0

    MOV AX, data
    MOV DS, AX

    XOR AX, AX        ; Limpiamos el registro AX
    XOR CX, CX        ; Limpiamos el registro AX

;─── Valores a regs ──┐
    MOV AL, a
    MOV CL, c
;─────────────────────┘

;──── Operaciones ────┐
    ADD AL, b         ; (A + B)
    SUB CL, d         ; (C - D)
    DIV CL            ; (A + B) / (C - D)
    MUL z             ; (A + B) / (C - D) * Z
;─────────────────────┘

    RET
main ENDP

code ENDS

END main
