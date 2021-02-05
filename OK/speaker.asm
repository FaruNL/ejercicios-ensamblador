.286
TITLE ''
.MODEL SMALL

.STACK

.DATA

.CODE

main PROC FAR
    MOV AX, @DATA
    MOV DS, AX

;── Enviamos el valor 182 al puerto 43h ──┐
    MOV    AL, 182;                       │
    OUT    43h, AL;                       │
;─────────────────────────────────────────┘
;── Frecuencia en decimal ──┐
    MOV    AX, 4560;        │11=AH=17 D0=AL=208
;───────────────────────────┘
;── Frecuencia en decimal ──┐
    OUT    42h, AL;         │
    MOV    AL, AH;          │
    OUT    42h, AL;         │
;───────────────────────────┘
;── Enciende la bocina ──┐
    IN     AL, 61h;      │ Obtenemos el valor del puerto 61h en AL
    OR     AL, 11b;      │ Establecemos en 1 los bits 0 y 1 (00000000)
    OUT    61h, AL;      │ Enviamos el valor al puerto             ▲▲
;────────────────────────┘
;── Tiempo del sonido ──┐
    MOV    BX, 25 ;;;;

.pause1:
    MOV    CX, 65535

.pause2:
    DEC    CX
    JNE    .pause2
    DEC    BX
    JNE    .pause1
;────────────────────────┘

;──── Apaga la bocina ────┐
    IN     AL, 61h
    AND    AL, 11111100b
    OUT    61h, AL
;─────────────────────────┘

    MOV AX, 4C00h
    INT 21h
main ENDP

END main
