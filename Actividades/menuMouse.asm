TITLE 'Menu de suma y resta'

.MODEL SMALL
INCLUDE C:\general.lib

.STACK

.DATA
    num1 DB ?
    num2 DB ?
    input DB ?

    strMenu DB 'MENU','$'
    strAdd DB '1) SUMA','$'
    strSub DB '2) RESTA','$'
    strExit DB '3) SALIR','$'
    strInput DB 'Ingresa opcion [ ]','$'
    
    inNum1 DB 'Primer valor: ','$'
    inNum2 DB 'Segundo valor: ','$'
    result DB 'Resultado: ','$'

    posX DB ?
    posY DB ?

    choose DW ?
    chosen DB ?

.CODE
.486

clearBlue PROC NEAR
    MOV AX, 0600h
    MOV BH, 1Fh
    MOV CX, 0000h
    MOV DX, 184Fh
    INT 10h
    RET
clearBlue ENDP

; ─────────────────────────────────────────────────┐
setPosY PROC NEAR;                                 │
;                                                  │
; Ajusta la posición Y del mouse y la guarda       │
; ARG:  DX == Posición del mouse (Y) [640 x 200]   │
; RET:  NADA                                       │
; ─────────────────────────────────────────────────┘
    MOV AX, DX        ; Preparamos dividendo de la posición Y (DX)
    MOV BL, 08h       ; Preparamos divisor (8)
    DIV BL            ; Dividimos: AL == Cociente, AH == Residuo

    MOV posY, AL
    RET
setPosY ENDP

; ─────────────────────────────────────────────────┐
setPosX PROC NEAR;                                 │
;                                                  │
; Ajusta la posición X del mouse y la guarda       │
; ARG:  CX == Posición del mouse (X) [640 x 200]   │
; RET:  NADA                                       │
; ─────────────────────────────────────────────────┘
    MOV AX, CX        ; Preparamos dividendo de la posición X (CX)
    MOV BL, 08h       ; Preparamos divisor (8)
    DIV BL            ; Dividimos: AL == Cociente, AH == Residuo

    MOV posX, AL
    RET
setPosX ENDP

inputs PROC NEAR
    CALL clearBlue

;───── 1er digito ────┐
    cursorPos 07h,15h
    printS inNum1
    CALL readChar
    SUB AL, '0'
;─────────────────────┘

    MOV num1, AL

;───── 2do digito ────┐
    cursorPos 08h,15h
    printS inNum2
    CALL readChar
    SUB AL, '0'

    MOV num2, AL
;─────────────────────┘
    RET
inputs ENDP

ocultarPuntero PROC NEAR
    MOV AX, 02h
    INT 33h
    RET
ocultarPuntero ENDP

soltarClick PROC NEAR
release:
    MOV AX, 03h                      ; Consulta de estado de botones y posición
    INT 33h

    CMP BX, 00h                      ; Revisamos si ha sido liberado el click izquierdo
    JNE release                      ; Aún no se libera? Cicla

    RET
soltarClick ENDP

main PROC FAR
    MOV AX, @DATA
    MOV DS, AX

menu:
    CALL clearBlue

;──────── Menu ───────┐
;─── Print: strMenu ──┤
    cursorPos 07h, 15h
    printS strMenu
;─── Print: strAdd ───┤
    cursorPos 08h,15h
    printS strAdd
;─── Print: strSub ───┤
    cursorPos 09h,15h
    printS strSub
;─── Print: strExit ──┤
    cursorPos 0Ah,15h
    printS strExit
;─────────────────────┘

;────────── Uso del mouse ──────────┐
    MOV AX, 0h                      ; Inicialización del mouse
    INT 33h

    MOV AX, 01h                     ; Mostrar puntero
    INT 33h

    XOR CX, CX                      ; Inicializamos contador
    MOV CX, 01h
    PUSH CX                         ; Guardamos contador

mouseLoop:
    MOV AX, 3h                      ; Consulta de estado de botones y posición
    INT 33h

    CMP BX, 01h                     ; Revisamos si ha sido presionado el click izquierdo
    JNE mouseLoop

    CALL setPosY
    CALL setPosX

    CMP posX, 15h                   ; Comparamos posición X con donde se ubican los numeros
    JNE mouseLoop

    CMP posY, 08h
    JE suma

    CMP posY, 09h
    JE resta

    CMP posY, 0Ah
    JE exit

    JMP mouseLoop
;────────────────────────────────────┘

exit:
    CALL ocultarPuntero
;──── Clear: Black ───┤
    MOV AX, 0600h
    MOV BH, 07h
    MOV CX, 0000h
    MOV DX, 184Fh
    INT 10h
;─── Cursor: Reset ───┤
    cursorPos 00h, 00h
;──────── Exit ───────┤
    MOV AX, 4C00h
    INT 21h
;─────────────────────┘

suma:
    CALL ocultarPuntero
    CALL soltarClick
    CALL inputs

    MOV AL, num1
    ADD AL, num2

;───── Conv ASCII ────┐
    AAM               ; Ajuste en ASCII, convierte el valor de AL a decimal, poniendo el LSD(Unidades) en AL y el MSD(Decenas) en AH
    MOV CX, AX        ; Copiamos temporalmente AX a CX: AH -> CH, AL -> CL
;─────────────────────┘

;───── Resultado ─────┐
    cursorPos 09h,15h
    printS result
    printCharPlus0 CH         ; Decenas
    printCharPlus0 CL         ; Unidades
;─────────────────────┘

    CALL pause

    JMP menu

resta:
    CALL ocultarPuntero
    CALL soltarClick
    CALL inputs

    MOV AL, num2

    CMP num1, AL
    JL negativo

    SUB num1, AL

;───── Resultado ─────┐
    cursorPos 09h,15h
    printS result
    printCharPlus0 num1
;─────────────────────┘

    CALL pause

    JMP menu

negativo:
    MOV CL, AL        ; El valor ingresado se guardó en AL, ahora lo pasamos a CL para manipularlo
    SUB CL, num1      ; RESTA

;───── Resultado ─────┐
    cursorPos 09h,15h
    printS result
    MOV AH, 02h
    MOV DL, '-'
    INT 21h
    printCharPlus0 CL
;─────────────────────┘

    CALL pause

    JMP menu

main ENDP

END main
