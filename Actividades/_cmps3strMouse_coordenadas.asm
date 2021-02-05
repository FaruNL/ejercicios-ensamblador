.286
TITLE ''
.MODEL SMALL

.STACK

.DATA
    posX DB ?
    posY DB ?

.CODE

main PROC FAR
    MOV AX, @DATA
    MOV DS, AX

    ; Limpiamos pantalla y acomodamos cursor
    MOV AX, 0600h
    MOV BH, 07h
    MOV CX, 0000h
    MOV DX, 184Fh
    INT 10h

    MOV AH, 02h
    MOV BH, 0h
    MOV DX, 0000h
    INT 10h


    ; Mouse...
    MOV AX, 0h       ; Inicializar mouse
    INT 33h

    MOV AX, 01h      ; Mostrar puntero
    INT 33h

mouseLoop:
    MOV AX, 03h      ; Consultar posición / estado de botones
    INT 33h

    CMP BX, 01h      ; Revisar estado de botón izquierdo
    JNE mouseLoop    ; No ha sido presionado? vuelve al ciclo
    
    ; Guardamos la posición Y (Registrada en DX al invocar la función 03h del vector 33h)
    MOV AX, DX       ; Preparamos dividendo de la posición Y (DX)
    MOV BL, 08h      ; Preparamos divisor (8)
    DIV BL           ; Dividimos: AL == Cociente, AH == Residuo

    MOV posY, AL     ; Guardamos cociente a la variable correspondiente

    ; Guardamos la posición X (Registrada en CX al invocar la función 03h del vector 33h)
    MOV AX, CX       ; Preparamos dividendo de la posición X (CX)
    MOV BL, 08h      ; Preparamos divisor (8)
    DIV BL           ; Dividimos: AL == Cociente, AH == Residuo

    MOV posX, AL     ; Guardamos cociente a la variable correspondiente

    ; Comparamos posición Y
    CMP posY, 03h    ; Comparamos posición Y
    JNE mouseLoop    ; No? Vuelve al ciclo

    CMP posX, 02h    ; Comparamos posición X
    JE release       ; En este punto, ya las 2 cooredenadas coinciden con lo que queremos...

    JNE mouseLoop

release:
    MOV AX, 03h      ; Consulta de estado de botones y posición
    INT 33h

    CMP BX, 00h      ; Revisamos si ha sido liberado el click izquierdo
    JNE release      ; Aún no se libera? Cicla

quit:
    MOV AX, 4C00h
    INT 21h
main ENDP

END main