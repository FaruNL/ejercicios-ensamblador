.286
TITLE 'Menu de suma y resta'
.MODEL SMALL

;─────── Macros ──────┐
printS MACRO str
    MOV AH, 09h
    LEA DX, str
    INT 21h
ENDM

cursor MACRO fila, columna
    MOV AH, 02h
    MOV BH, 0h
    MOV DH, fila
    MOV DL, columna
    INT 10h
ENDM

printC MACRO regVal
    MOV AH, 02h
    MOV DL, regVal    ; Se pasará el numero tal cual, pero aún no en ASCII
    ADD DL, '0'       ; Sumamos '0' (48) para poder imprimirlo como ASCII
    INT 21h
ENDM
;─────────────────────┘

.STACK

.DATA
    num1 DB ?
    input DB ?

    strMenu DB 'MENU','$'
    strAdd DB '1) SUMA','$'
    strSub DB '2) RESTA','$'
    strExit DB '3) SALIR','$'
    strInput DB 'Ingresa opcion [ ]','$'
    
    inNum1 DB 'Primer valor: ','$'
    inNum2 DB 'Segundo valor: ','$'
    result DB 'Resultado: ','$'

.CODE

;───── Procedures ────┐
clearBlue PROC NEAR
    MOV AX, 0600h
    MOV BH, 1Fh
    MOV CX, 0000h
    MOV DX, 184Fh
    INT 10h
    RET
clearBlue ENDP

readChar PROC NEAR
    MOV AH, 01h
    INT 21h
    RET
readChar ENDP

pause PROC NEAR
    MOV AH, 07h
    INT 21h
    RET
pause ENDP
;─────────────────────┘

main PROC FAR
    MOV AX, @DATA
    MOV DS, AX

menu:
    CALL clearBlue

;──────── Menu ───────┐
;─── Print: strMenu ──┤
    cursor 07h, 15h
    printS strMenu
;─── Print: strAdd ───┤
    cursor 08h,15h
    printS strAdd
;─── Print: strSub ───┤
    cursor 09h,15h
    printS strSub
;─── Print: strExit ──┤
    cursor 0Ah,15h
    printS strExit
;── Print: strInput ──┤
    cursor 0Bh,15h
    printS strInput
;───── Cursor [_] ────┤
    cursor 0Bh,25h
;─────────────────────┘

;──────── Input ──────┐
    CALL readChar
;─────────────────────┘

    MOV input, AL

;──── Condiciones ────┐
    CMP AL, '1'
    JE operaciones

    CMP AL, '2'
    JE operaciones

    CMP AL, '3'
    JNE menu
;─────────────────────┘

;─────── Salida ──────┐
;──── Clear: Black ───┤
    MOV AX, 0600h
    MOV BH, 07h
    MOV CX, 0000h
    MOV DX, 184Fh
    INT 10h
;─── Cursor: Reset ───┤
    cursor 00h, 00h
;──────── Exit ───────┤
    MOV AX, 4C00h
    INT 21h
;─────────────────────┘

operaciones:
    CALL clearBlue

;───── 1er digito ────┐
    cursor 07h,15h
    printS inNum1
    CALL readChar
    SUB AL, '0'
;─────────────────────┘

    MOV num1, AL

;───── 2do digito ────┐
    cursor 08h,15h
    printS inNum2
    CALL readChar
    SUB AL, '0'
;─────────────────────┘

;───── Condicion ─────┐
;──────── Suma ───────┤
    CMP input, '1'
    JE suma
;─────── Resta ───────┤
    CMP input, '2'
    JE resta
;─────────────────────┘

suma:
    ADD AL, num1

;───── Conv ASCII ────┐
    AAM               ; Ajuste en ASCII, convierte el valor de AL a decimal, poniendo el LSD(Unidades) en AL y el MSD(Decenas) en AH
    MOV CX, AX        ; Copiamos temporalmente AX a CX: AH -> CH, AL -> CL
;─────────────────────┘

;───── Resultado ─────┐
    cursor 09h,15h
    printS result
    printC CH         ; Decenas
    printC CL         ; Unidades
;─────────────────────┘

    CALL pause

    JMP menu

resta:
    CMP num1, AL
    JL negativo

    SUB num1, AL

;───── Resultado ─────┐
    cursor 09h,15h
    printS result
    printC num1
;─────────────────────┘

    CALL pause

    JMP menu

negativo:
    MOV CL, AL        ; El valor ingresado se guardó en AL, ahora lo pasamos a CL para manipularlo
    SUB CL, num1      ; RESTA

;───── Resultado ─────┐
    cursor 09h,15h
    printS result
    MOV AH, 02h
    MOV DL, '-'
    INT 21h
    printC CL
;─────────────────────┘

    CALL pause

    JMP menu

main ENDP

END main
