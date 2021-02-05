.286
TITLE 'Suma 2 numeros, 1 digito'

stak SEGMENT STACK
    DB 32 DUP('Stack__')
stak ENDS

data SEGMENT
    num1 DB ?

    msj1 DB 13,10,'Ingresa el primer numero: ','$'
    msj2 DB 13,10,'Ingresa el segundo numero: ','$'
    msj3 DB 13,10,'La suma es: ','$'
data ENDS

code SEGMENT
ASSUME SS:stak, DS:data, CS:code

main PROC FAR
    PUSH DS
    PUSH 0

    MOV AX, data
    MOV DS, AX

;──── Print: msj1 ────┐
    MOV AH, 09h
    LEA DX, msj1
    INT 21h
;─────────────────────┘

;── Lectura: Numero ──┐
    MOV AH, 01h
    INT 21h
;─────────────────────┘

    MOV num1, AL      ; Copiamos el valor del número ingresado a nuestra variable num1

;──── Print: msj2 ────┐
    MOV AH, 09h
    LEA DX, msj2
    INT 21h
;─────────────────────┘

;── Lectura: Numero ──┐
    MOV AH, 01h
    INT 21h
;─────────────────────┘

;──────── Suma ───────┐
    ; Imprimir <msj3>
    MOV AH, 09h
    LEA DX, msj3
    INT 21h

    ; Operacion
    ADD AL, num1

    ; Imprimimos el resultado
    MOV AH, 02h
    MOV DL, AL        ; Copiamos el resultado de AL a DL, para su impresión
    INT 21h
;─────────────────────┘

    RET
main ENDP

code ENDS

END main
