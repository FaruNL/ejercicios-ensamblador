TITLE ''

.MODEL SMALL
INCLUDE C:\OK\general.lib

.STACK

.DATA
    str1 DB 25
         DB ?
         DB 25 DUP (?)

    str2 DB 25
         DB ?
         DB 25 DUP (?)

    str3 DB 25
         DB ?
         DB 25 DUP (?)
    
    str4 DB 25
         DB ?
         DB 25 DUP (?)

    posX DB ?
    posY DB ?

.CODE
.486

main PROC FAR
    MOV AX, @DATA
    MOV DS, AX

    CALL cls

    readS str1
    readS str2

;──────── Uso del mouse ────────┐
    MOV AX, 0h                  ; Inicialización del mouse
    INT 33h

    MOV AX, 01h                 ; Mostrar puntero
    INT 33h

mouseLoop:
; CX: Column position (X)
; DX: Row    position (Y)
    MOV AX, 3h                  ; Consulta de estado de botones y posición
    INT 33h

    ; CMP BX, 01h                 ; BX: Estado de botones [1h -> Left click, 2h -> Right click, 4h -> Middle click]
    ; JNE mouseLoop

    MOV AX, DX        ; Preparamos dividendo de la posición Y (DX)
    MOV BL, 08h       ; Preparamos divisor (8)
    DIV BL            ; Dividimos: AL == Cociente, AH == Residuo

    MOV posY, AL

    MOV AX, CX        ; Preparamos dividendo de la posición X (CX)
    MOV BL, 08h       ; Preparamos divisor (8)
    DIV BL            ; Dividimos: AL == Cociente, AH == Residuo

    MOV posX, AL

    CMP posY, 6h                ; Comparamos posición Y con donde inician las cadenas mostradas
    JNE mouseLoop

    ; CMP posX, 0h                ; Comparamos posición X con donde inician las cadenas mostradas
    ; JNE mouseLoop
    
    XOR CX, CX
    XOR DL, DL

str1Loop:
    CMP posX, DL                ; Comparamos posición X con la posición deseada
    JE continue

    INC CL
    INC DL
    CMP CL, [str1+1]
    JL str1Loop

    XOR CX, CX
    ADD DL, 02h

str2Loop:
    CMP posX, DL                ; Comparamos posición X con la posición deseada
    JE continue

    INC CL
    INC DL
    CMP CL, [str2+1]
    JL str2Loop

    JMP mouseLoop
;───────────────────────────────┘

continue:
    MOV AX, 4C00h
    INT 21h
main ENDP

END main
