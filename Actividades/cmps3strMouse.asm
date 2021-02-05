TITLE ''

; ───────────────────── Macros ────────────────────┐
;                                                  │
; ─────────────────────────────────────────────────┤
strPosX MACRO str, lblLoop, lblOut;                │
;                                                  │
; Revisa si la posición X del mouse se encuentra   │
; dentro de las letras de la palabra a comparar    │
; ARG:  str     == String a comparar               │
;       lblLoop == Etiqueta de loop                │
;       lblOut  == Etiqueta para salir del loop    │
;       CL      == Contador (Siempre inicia en 0)  │
;       DL      == Apuntador de la pos. actual     │
; RET:  NADA                                       │
; ─────────────────────────────────────────────────┘
MOV choose, OFFSET [str+2]    ; Guardamos la dir. de memoria del string seleccionado más reciente

lblLoop:
    CMP posX, DL
    JE lblOut

    INC CL
    INC DL
    CMP CL, [str+1]
    JB lblLoop
ENDM
; ─────────────────────────────────────────────────┘

.MODEL SMALL
INCLUDE C:\OK\general.lib

.STACK

.DATA
    heading DB 'COMPARACION DE CADENAS','$'
    input1 DB 'Ingresa primer string: ','$'
    input2 DB 'Ingresa segundo string: ','$'
    input3 DB 'Ingresa tercer string: ','$'
    show DB 'Elige las 2 cadenas a comparar','$'
    compare1 DB 'Comparando: ','$'
    compare2 DB ' y ','$'
    resultI DB 'Las cadenas son iguales',10,13,'$'
    resultD DB 'Las cadenas son diferentes',10,13,'$'

    nl DB 10,13,'$'

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

    choose DW ?

.CODE
.486
; ─────────────────────────────────────────────────┐
printNL PROC NEAR;                                 │
;                                                  │
; Imprime un salto de linea                        │
; ARG:  NADA                                       │
; RET:  AL == '$'                                  │
; ─────────────────────────────────────────────────┘
    MOV AH, 09h
    LEA DX, nl
    INT 21h
    RET
printNL ENDP

; ─────────────────────────────────────────────────┐
getCursor PROC NEAR;                               │
;                                                  │
; Obtiene la pos. del cursor                       │
; ARG:  NADA                                       │
; RET:  CH == Cursor start line                    │
;       CL == Cursor end line                      │
;       DH == Fila (Y)                             │
;       DL == Columna (X)                          │
; ─────────────────────────────────────────────────┘
    MOV AH, 03h
    MOV BH, 0h
    INT 10h
    RET
getCursor ENDP

; ─────────────────────────────────────────────────┐
cursorPlus PROC NEAR;                              │
;                                                  │
; Mueve el cursor 2 espacios a la derecha          │
; ARG:  DH == Fila (Y)                             │
;       DL == Columna (X)                          │
; RET:  NADA                                       │
; ─────────────────────────────────────────────────┘
    MOV AH, 02h
    MOV BH, 0h
    ADD DL, 02h
    INT 10h
    RET
cursorPlus ENDP

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

main PROC FAR
    MOV AX, @DATA
    MOV DS, AX

    CALL cls

    printS heading
    CALL printNL

;─────── Inputs ──────┐
    printS input1
    readS str1
    CALL printNL

    printS input2
    readS str2
    CALL printNL

    printS input3
    readS str3
    CALL printNL
    CALL printNL
;─────────────────────┘

    PUSH DS
    POP ES

;── Muestra strings ──┐
    printS show
    CALL printNL

    printS [str1+2]
    CALL getCursor
    CALL cursorPlus

    printS [str2+2]
    CALL getCursor
    CALL cursorPlus

    printS [str3+2]
    CALL printNL
;─────────────────────┘

    ; Oculta cursor
    MOV AH, 01h
    MOV CX, 2607h
    INT 10h

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

    CMP posY, 6h                    ; Comparamos posición Y con donde inician las cadenas mostradas
    JNE mouseLoop
    
    XOR CX, CX
    XOR DL, DL
    strPosX str1 str1Loop release   ; Comparamos posición X el largo de la cadena str1

    XOR CX, CX
    ADD DL, 02h
    strPosX str2 str2Loop release   ; Comparamos posición X el largo de la cadena str2

    XOR CX, CX
    ADD DL, 02h
    strPosX str3 str3Loop release   ; Comparamos posición X el largo de la cadena str3

    JMP mouseLoop

release:
    MOV AX, 03h                      ; Consulta de estado de botones y posición
    INT 33h

    CMP BX, 00h                      ; Revisamos si ha sido liberado el click izquierdo
    JNE release                      ; Aún no se libera? Cicla

    POP CX                           ; Regresamos el contador

    CMP CX, 01h
    JE setSI

continue1:
    CMP CX, 02h
    JE setDI

continue2:
    CMP CX, 02h                      ; Revisa si esto ha sucedido 2 veces
    JNB compare                          ; Si? Sale del programa
    INC CX                           ; Contador + 1 = ClickD a sido presionado y liberado una vez
    PUSH CX                          ; No? Guarda el contador

    JMP mouseLoop

setSI:
    MOV SI, choose
    JMP continue1

setDI:
    MOV DI, choose
    JMP continue2
;────────────────────────────────────┘

compare:
    ; Ocultamos el puntero
    MOV AX, 02h
    INT 33h

    ; Mostramos de nuevo el cursor
    MOV AH, 01h
    MOV CX, 0607h
    INT 10h

    ; Imprimimos que se comparará
    CALL printNL
    printS compare1
    MOV DX, SI
    INT 21h
    printS compare2
    MOV DX, DI
    INT 21h

    ; Comparamos
    XOR CX, CX
    MOV CL, [str1]
    CLD
    REPE CMPSB
    JB strDiff
    JA strDiff

    CALL printNL
    printS resultI     ; Cadenas iguales

    JMP exit

strDiff:
    CALL printNL
    printS resultD     ; Cadenas Diferentes

exit:
    MOV AX, 4C00h
    INT 21h
main ENDP

END main
