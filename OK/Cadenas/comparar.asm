.286
TITLE ''

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
    str2 DB 'Fierra','$'
    letreroI DB 'Son iguales','$'
    letrero1 DB 'String 1 es mas pequeno','$'
    letrero2 DB 'String 2 es mas pequeno','$'

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

    LEA SI, str1      ; Dirección inicial de la cadena origen
    LEA DI, str2      ; Dirección inicial de la cadena destino
    MOV CX, 6         ; Numero de elementos de la cadena origen

    CLD               ; Establecemos SI y DI a auto-incrementar (Leer de izq a der)
    REPE CMPSB        ; Repetimos la funcion de comparar mientras sean iguales o CX = 0

    JB str1smaller
    JA str2smaller

    printS letreroI

    JMP fin

str1smaller:
    printS letrero1

    JMP fin

str2smaller:
    printS letrero2

fin:
    MOV AX, 4C00h
    INT 21h
main ENDP

END main