.286
TITLE 'Limpiar pantalla'
.MODEL SMALL

.STACK

.CODE

main PROC FAR

;── Limpiar pantalla ─┐
    MOV AX, 0600h     ; ah = 06 (Desplazar ventana hacia arriba) y al = 00 (Lineas a recorrer, 00 = limpiar)
    MOV BH, 07h       ; 0 = Negro (Fondo), 7 = Gris suave (Letras)
    MOV CX, 0000h     ; 00 = Fila ventana esquina superior izquierda | 00 = Columna ventana esquina superior izquierda
    MOV DX, 184Fh     ; 18 = Fila ventana esquina inferior derecha | 4F = Columna ventana esquina inferior derecha
    INT 10h           ; Interrupción de BIOS (Servicios de video y pantalla)
;─────────────────────┘

;── Reiniciar cursor ─┐
    MOV AH, 02h       ; 02 = Establecer posición del cursor
    MOV BH, 0h        ; Pagina 0
    MOV DX, 0000h     ; dh = 00 (Fila) | dl = 00 (Columna) , Todo desde esquina superior izquierda
    INT 10h           ; Interrupción de BIOS (Servicios de video y pantalla)
;─────────────────────┘

    MOV AX, 4C00h
    INT 21h
main ENDP

END main

