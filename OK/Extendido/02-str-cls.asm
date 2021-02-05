.286
TITLE 'Hola mundo'

stak SEGMENT STACK
    DB 32 DUP('Stack__')
stak ENDS

data SEGMENT
    msj DB 'Hola mundo!',13,10,'$'
data ENDS

code SEGMENT
ASSUME SS:stak, DS:data, CS:code

main PROC FAR
    PUSH DS
    PUSH 0

    MOV AX, data
    MOV DS, AX

;── Limpiar pantalla ─┐
    MOV AX, 0600h     ; ah = 06 (Desplazar ventana hacia arriba) y al = 00 (Lineas a recorrer, 00 = limpiar)
    MOV BH, 07h       ; 0 = Negro (Fondo), 7 = Gris suave (Letras)
    MOV CX, 0000h     ; 00 = Fila ventana esquina superior izquierda | 00 = Columna ventana esquina superior izquierda
    MOV DX, 184Fh     ; 18 = Fila ventana esquina inferior derecha | 4F = Columna ventana esquina inferior derecha
    INT 10h
;─────────────────────┘

;──── Imprimir msj ───┐
    MOV AH, 09h       ; 09 = Función para imprimir una cadena
    LEA DX, msj       ; Carga la dirección efectiva (Incluyendo el offset) de la variable <msj>
    INT 21h
;─────────────────────┘
    
    RET
main ENDP

code ENDS

END main
