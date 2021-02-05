.286
TITLE ''
.MODEL SMALL

.EXTRA

.STACK

.DATA
    arr DB 5 DUP(?), '$'
    msj1 DB 13, 10,'Ingresa un valor a ingresar en el arreglo:  ','$'
    nl DB 13, 10, '$'
    msj2 DB 13, 10,'Arreglo impreso:  ','$'

.CODE

main PROC FAR
    MOV AX, @DATA
    MOV DS, AX

;── Limpiar pantalla ─┐
    MOV AX, 0600h
    MOV BH, 07h
    MOV CX, 0000h
    MOV DX, 184Fh
    INT 10h
;─────────────────────┘

    MOV SI, 0

;─── Insert: array ───┐
for:
    MOV AH, 09h
    LEA DX, msj1
    INT 21h

    MOV AH, 01h       ; Leemos caracter de STDIN
    INT 21h

    MOV arr[SI], AL   ; Movemos el char ingresado a la posición actual del arreglo

    INC SI

    CMP SI, 5

    JB for
;─────────────────────┘

    MOV AH, 09h
    LEA DX, nl
    INT 21h

    LEA DX, msj2
    INT 21h

    LEA DX, arr
    INT 21h

    MOV AX, 4C00h
    INT 21h
main ENDP

END main