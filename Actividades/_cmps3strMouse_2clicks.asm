.286
TITLE ''
.MODEL SMALL

.STACK

.DATA
    clickR DB 'Click derecho',10,13,'$'
    released DB 'Click liberado',10,13,'$'

.CODE

rightC PROC NEAR
    MOV AH, 09h
    LEA DX, clickR
    INT 21h
    RET
rightC ENDP

releaseStr PROC NEAR
    MOV AH, 09h
    LEA DX, released
    INT 21h
    RET
releaseStr ENDP


main PROC FAR
    MOV AX, @DATA
    MOV DS, AX

    MOV AX, 0h       ; Inicializar mouse
    INT 33h

    MOV AX, 01h      ; Mostrar cursor
    INT 33h

    XOR CX, CX       ; Inicializar contador
    PUSH CX          ; Save counter

mouse:
    MOV AX, 03h      ; Consultar posición / estado de botones
    INT 33h

    CMP BX, 01h      ; Revisar estado de botón izquierdo
    JNE mouse        ; No ha sido presionado? vuelve al ciclo
    CALL rightC      ; Imprime que ha sido presionado

release:
    MOV AX, 03h      ; Consultar posición / estado de botones
    INT 33h

    CMP BX, 00h      ; Revisar estado de los botones (Ninguno presionado)
    JNE release      ; No se ha liberado el click? vuelve al ciclo
    CALL releaseStr  ; Imprime que ha sido liberado

    POP CX           ; Devuelve el estado del contador
    INC CX           ; Counter + 1 = click derecho ha sido presionado y liberado una vez
    CMP CX, 02h      ; Revisa si esto ha sucedido 2 veces
    JAE quit         ; Si? sale
    PUSH CX          ; No? Guarda el contador

    JMP mouse        ; Vuelve al ciclo del mouse

quit:
    MOV AX, 4C00h
    INT 21h
main ENDP

END main
