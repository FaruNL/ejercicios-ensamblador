.286
TITLE 'if-else'

stak SEGMENT STACK
    DB 32 DUP('Stack__')
stak ENDS

data SEGMENT
    num DB ?

    aviso DB 'Ingresa un numero >= 5: ','$'
    mayor DB ' >= 5!',13,10,'$'
    menor DB ' <= 5!',13,10,'$'
data ENDS

code SEGMENT
ASSUME SS:stak, DS:data, CS:code

main PROC FAR
    PUSH DS
    PUSH 0

    MOV AX, data
    MOV DS, AX


;── Lectura  numero ──┐
    ; Imprimir <aviso>
    MOV AH, 09h
    LEA DX, aviso
    INT 21h

    ; Leemos caracter de STDIN
    MOV AH, 01h
    INT 21h
    SUB AL, '0'       ; Restamos el valor ASCII de '0' == 48 a el valor ingresado, i.e: '5' - '0' -> 53 - 48 == 5
    MOV num, AL       ; Guardamos el valor a num
;─────────────────────┘

;─── Salto de linea ──┐
    MOV AH, 02h
    MOV DL, 13
    INT 21h
    
    MOV DL, 10
    INT 21h
;─────────────────────┘

;───── CONDICIÓN ─────┐
    CMP num, 5
    JAE great         ; Si num > 5, ve a etiqueta great
;──────── ELSE ───────┤
    ; Imprimimos caracter ASCII
    MOV AH, 02h
    MOV DL, num
    ADD DL, '0'       ; Sumamos '0' (48) para poder imprimirlo como ASCII
    INT 21h

    MOV AH, 09h
    LEA DX, menor
    INT 21h

    JMP fin
;───────── IF ────────┤
great:
    ; Imprimimos caracter ASCII
    MOV AH, 02h
    MOV DL, num
    ADD DL, '0'
    INT 21h

    MOV AH, 09h
    LEA DX, mayor
    INT 21h
;─────────────────────┘

fin:
    RET

main ENDP

code ENDS

END main
