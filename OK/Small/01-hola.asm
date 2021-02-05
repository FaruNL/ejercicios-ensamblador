.286
TITLE 'Hola mundo'
.MODEL SMALL

.STACK

.DATA
    msj DB 'Hola mundo!',13,10,'$'

.CODE

main PROC FAR
    MOV AX, @DATA
    MOV DS, AX

    MOV AH, 09h       ; 09 = Función para imprimir una cadena
    LEA DX, msj       ; Carga la dirección efectiva (Incluyendo el offset) de la variable <msj>
    INT 21h           ; Interrupción de DOS
    
    MOV AX, 4C00h
    INT 21h
main ENDP

END main
