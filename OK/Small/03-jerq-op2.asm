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
TITLE 'Operaciones jerarquicas 2'
.MODEL SMALL

.STACK

.DATA
    a DB 5
    b DB 3
    c DB 6
    d DB 4
    z DB 3

.CODE

main PROC FAR
    MOV AX, @DATA
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

    MOV AX, 4C00h
    INT 21h
main ENDP

END main
