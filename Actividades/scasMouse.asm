TITLE ''

; ───────────────────── Macros ────────────────────┐
;                                                  │
; ─────────────────────────────────────────────────┤
strPosX MACRO str, lblLoop, lblOut;                │
;                                                  │
; Revisa si la posición X del mouse se encuentra   │
; dentro de las letras de la palabra a buscar      │
; ARG:  str     == String a buscar                 │
;       lblLoop == Etiqueta de loop                │
;       lblOut  == Etiqueta para salir del loop    │
;       CL      == Contador (Siempre inicia en 0)  │
;       DL      == Apuntador de la pos. actual     │
; RET:  NADA                                       │
; ─────────────────────────────────────────────────┘
    JMP lblLoop
save:
    MOV posScan, DL
    JMP lblOut

lblLoop:
    CMP posX, DL
    JE save

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
    heading DB 'BUSQUEDA DE CHAR','$'
    input DB 'Ingresa string: ','$'
    show DB 'Elige el caracter a buscar','$'
    resultC1 DB 'Se encontro el caracter (','$'
    resultC2 DB ') ','$'
    resultC3 DB ' veces.',10,13,'$'
    resultP DB 'Se encontro el caracter en las siguentes posiciones:',10,13,'$'
    showPos DB 'Posicion: ','$'

    nl DB 10,13,'$'

    str1 DB 25
         DB ?
         DB 25 DUP (?)

    allPos DB 10 DUP (?)

    posX DB ?
    posY DB ?

    chosen DB ?
    posScan DB ?
    count DB 0

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
    printS input
    readS str1
    CALL printNL
    CALL printNL
;─────────────────────┘

    PUSH DS
    POP ES

;─── Muestra string ──┐
    printS show
    CALL printNL

    printS [str1+2]
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

mouseLoop:
    MOV AX, 3h                      ; Consulta de estado de botones y posición
    INT 33h

    CMP BX, 01h                     ; Revisamos si ha sido presionado el click izquierdo
    JNE mouseLoop

    CALL setPosY
    CALL setPosX

    CMP posY, 4h                    ; Comparamos posición Y con donde inician las cadenas mostradas
    JNE mouseLoop
    
    XOR CX, CX
    XOR DL, DL
    strPosX str1 str1Loop release   ; Comparamos posición X con el largo de la cadena str1

    JMP mouseLoop

release:
    MOV AX, 03h                      ; Consulta de estado de botones y posición
    INT 33h

    CMP BX, 00h                      ; Revisamos si ha sido liberado el click izquierdo
    JNE release                      ; Aún no se libera? Cicla
;────────────────────────────────────┘

    ; Ocultamos el puntero
    MOV AX, 02h
    INT 33h

    ; Mostramos de nuevo el cursor
    MOV AH, 01h
    MOV CX, 0607h
    INT 10h

    XOR CX, CX                       ; Inicializamos el contador
    LEA SI, [str1+2]                 ; Cargamos dir. efectiva de str1

chosenLoop:
    MOV DL, [SI]                     ; Triangulamos el valor de la pos. actual
    MOV chosen, DL                   ; Guardamos valor de la pos. actual en chosen

    CMP CL, posScan                  ; Comparamos el contador (Pos. actual) con la pos. elegida
    JE scan                          ; Paramos si coinciden

    INC SI                           ; Apuntador a la cadena +1
    INC CL                           ; Contador +1

    JMP chosenLoop

scan:
    PUSH DS
    POP ES

    ; Escaneamos
    MOV AL, chosen
    
    LEA DI, [str1+2]                  ; Dirección inicial de la cadena origen
    XOR CX, CX                        ; Inicializamos contador
    CLD                               ; Se recorre de izquierda a derecha

    LEA SI, allPos                    ; Apuntador al arreglo de posiciones
    
scanning:
    SCASB                             ; Comparamos
    JE adding                         ; Si coincide...
    continue:                        ; Regresamos...
    INC CL                            ; Contador + 1
    CMP CL, [str1+1]                  ; Compara contador con el numero de caracteres de str1
    JB scanning                       ; Si contador es menor a el num. de carac., cicla
    JE printing                       ; De otra manera pasa a imprimir los resultados


adding:
    MOV [SI], CL                      ; Guardamos el contador (pos. actual) en el arreglo
    INC SI                            ; Nos movemos al sig. elemento en el arreglo
    INC count                         ; count (numero de veces que aparece el char) + 1
    JMP continue                      ; Volvemos a el resto de scanning
    
printing:
    ADD count, '0'

    printS resultC1
    printChar chosen
    printS resultC2
    printChar count
    printS resultC3

    CALL printNL
    printS resultP

    SUB count, '0'
    LEA SI, allPos

positions:
    printS showPos
    MOV AX, [SI]

    AAM                   ; Pone el LSD(Unidades) en AL y el MSD(Decenas) en AH
    MOV BX, AX
    ADD BH, '0'
    ADD BL, '0'

    CMP BH, '0'
    JE printUnits

    printChar BH

printUnits:
    printChar BL
    CALL printNL

    DEC count
    INC SI

    CMP count, 0
    JA positions

    MOV AX, 4C00h
    INT 21h
main ENDP

END main
