.286
TITLE ''

;─────── Macros ──────┐
printS MACRO str
    MOV AH, 09h
    LEA DX, str
    INT 21h
ENDM

printChar MACRO regVal
    MOV AH, 02h
    MOV DL, regVal
    INT 21h
ENDM
;─────────────────────┘

.MODEL SMALL

.STACK

.DATA
    str1 DB 'Fierro','$'
    letreroN DB 'No se encuentra el caracter ','$'
    letreroE DB ' = Encontrado','$'

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

    LEA DI, str1      ; Dirección inicial de la cadena origen
    MOV AL, 'E'       ; Caracter a buscar, estará en AL (SCASB)
    MOV CX, 6         ; Numero de elementos de la cadena origen

    CLD               ; Establecemos SI y DI a auto-incrementar (Leer de izq a der)
    REPNE SCASB       ; Repetimos la funcion de buscar mientras no sea igual o CX = 0

    JNE not_found

    printChar AL

    printS letreroE

    JMP fin

not_found:
    printS letreroN

    printChar AL

fin:
    MOV AX, 4C00h
    INT 21h
main ENDP

END main