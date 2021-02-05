.286
TITLE ''

stak SEGMENT STACK
    DB 32 DUP('Stack__')
stak ENDS

data SEGMENT
    num DB ?
    msj1 DB 'Ingresa primer valor: ', '$'
    msj2 DB 'Ingresa segundo valor: ', '$'
    msj3 DB 'Resultado: ', '$'
    newline DB 13, 10, '$'
data ENDS

code SEGMENT
ASSUME SS:stak, DS:data, CS:code

main PROC FAR
    PUSH DS
    PUSH 0

    MOV AX, data
    MOV DS, AX

;── Limpiar pantalla ─┐
    MOV AX, 0600h
    MOV BH, 07h
    MOV CX, 0000h
    MOV DX, 184Fh
    INT 10h
;─────────────────────┘

;──── Print: msj1 ────┐
    MOV AH, 09h
    LEA DX, msj1
    INT 21h
;─────────────────────┘

;── Lectura: Numero ──┐
    MOV AH, 01h
    INT 21h
    SUB AL, '0'
;─────────────────────┘

    MOV num, AL

    MOV AH, 09h
    LEA DX, newline
    INT 21h

;──── Print: msj2 ────┐
    LEA DX, msj2
    INT 21h
;─────────────────────┘

;── Lectura: Numero ──┐
    MOV AH, 01h
    INT 21h
    SUB AL, '0'
;─────────────────────┘

;───── CONDICIÓN ─────┐
    CMP num, AL
    Jl menor
;──── IF: num > AL ───┤
    SUB num, AL

    MOV AH, 09h
    LEA DX, newline
    INT 21h

    MOV AH, 09h
    LEA DX, msj3
    INT 21h
    
    ; Imprimimos número en ASCII
    MOV AH, 02h
    MOV DL, num       ; Se pasará el numero tal cual, pero aún no en ASCII
    ADD DL, '0'       ; Sumamos '0' (48) para poder imprimirlo como ASCII
    INT 21h

    JMP fin
;──────── ELSE ───────┤
menor:
    SUB AL, num

    MOV AH, 09h
    LEA DX, newline
    INT 21h

    MOV AH, 09h
    LEA DX, msj3
    INT 21h

    ; Imprimimos número en ASCII
    MOV AH, 02h
    MOV DL, AL        ; Se pasará el numero tal cual, pero aún no en ASCII
    ADD DL, '0'       ; Sumamos '0' (48) para poder imprimirlo como ASCII
    INT 21h
;─────────────────────┘

fin: 
    RET

main ENDP

code ENDS

END main
