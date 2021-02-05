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
    SUB AL, '0'       ; Restamos el valor ASCII de '0' == 48 a el valor ingresado, i.e: '5' - '0' -> 53 - 48 == 5
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
    SUB AL, '0'
;─────────────────────┘

;──────── Suma ───────┐
    ; Imprimir <msj3>
    MOV AH, 09h
    LEA DX, msj3
    INT 21h

    ; Operacion
    ADD AL, num1

    ; Conversión a ASCII
    AAM               ; Ajuste en ASCII, convierte el valor de AL a decimal, poniendo el LSD(Unidades) en AL y el MSD(Decenas) en AH
    MOV CX, AX        ; Copiamos temporalmente AX a CX: AH -> CH, AL -> CL

    ; Imprimimos caracter ASCII de decenas
    MOV AH, 02h
    MOV DL, CH        ; Se pasará el numero tal cual, pero aún no en ASCII
    ADD DL, '0'       ; Sumamos '0' (48) para poder imprimirlo como ASCII
    INT 21h

    ; Imprimimos caracter ASCII de unidades
    MOV DL, CL
    ADD DL, '0'
    INT 21h
;─────────────────────┘

    RET
main ENDP

code ENDS

END main
