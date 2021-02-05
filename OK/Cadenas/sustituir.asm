.286
TITLE 'Sustituir cadenas'

;─────── Macros ──────┐
printS MACRO str
    MOV AH, 09h
    LEA DX, str
    INT 21h
ENDM
;─────────────────────┘

.MODEL SMALL

.STACK

.DATA
    str1 DB 'Fierro','$'
    str2 DB 'Man','$'
    nl DB 13,10,'$'

.CODE

main PROC FAR
    MOV AX, @DATA
    MOV DS, AX
    MOV ES, AX        ; Pasamos la dirección del segmento de datos al segmento extra

;── Limpiar pantalla ─┐
    MOV AX, 0600h
    MOV BH, 07h
    MOV CX, 0000h
    MOV DX, 184Fh
    INT 10h
;─────────────────────┘

    printS str1

    LEA DI, str1      ; Dirección inicial de la cadena destino
    LEA SI, str2      ; Dirección inicial de la cadena origen
    MOV CX, 3         ; Numero de elementos de la cadena origen

    CLD               ; Establecemos SI y DI a auto-incrementar (Leer de izq a der)
    REP MOVSB         ; Repetimos la funcion de mover hasta que CX sea 0

    printS nl
    printS str1

    MOV AX, 4C00h
    INT 21h
main ENDP

END main