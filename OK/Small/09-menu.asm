.286
TITLE 'Menu de suma y resta'
.MODEL SMALL

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

main PROC FAR
    MOV AX, @DATA
    MOV DS, AX

menu:
;──── Clear: Blue ────┐
    MOV AX, 0600h
    MOV BH, 1Fh
    MOV CX, 0000h
    MOV DX, 184Fh
    INT 10h
;─────────────────────┘

;──────── Menu ───────┐
;─── Print: strMenu ──┤
    MOV AH, 02h       ; Cursor
    MOV BH, 0h
    MOV DH, 07h       ; Fila
    MOV DL, 15h       ; Columna
    INT 10h

    MOV AH, 09h       ; Print String
    LEA DX, strMenu
    INT 21h
;─── Print: strAdd ───┤
    MOV AH, 02h       ; Cursor
    MOV BH, 0h
    MOV DH, 08h       ; Fila
    MOV DL, 15h       ; Columna
    INT 10h

    MOV AH, 09h       ; Print String
    LEA DX, strAdd
    INT 21h
;─── Print: strSub ───┤
    MOV AH, 02h       ; Cursor
    MOV BH, 0h
    MOV DH, 09h       ; Fila
    MOV DL, 15h       ; Columna
    INT 10h

    MOV AH, 09h       ; Print String
    LEA DX, strSub
    INT 21h
;─── Print: strExit ──┤
    MOV AH, 02h       ; Cursor
    MOV BH, 0h
    MOV DH, 0Ah       ; Fila
    MOV DL, 15h       ; Columna
    INT 10h

    MOV AH, 09h       ; Print String
    LEA DX, strExit
    INT 21h
;── Print: strInput ──┤
    MOV AH, 02h       ; Cursor
    MOV BH, 0h
    MOV DH, 0Bh       ; Fila
    MOV DL, 15h       ; Columna
    INT 10h

    MOV AH, 09h       ; Print String
    LEA DX, strInput
    INT 21h
;───── Cursor [_] ────┤
    MOV AH, 02h       ; Cursor
    MOV BH, 0h
    MOV DH, 0Bh       ; Fila
    MOV DL, 25h       ; Columna: Iniciamos en 15h y consideramos el string "Ingresa opcion [ ]". Para llegar al primer corchete hay 16 espacios, o 10h espacios: 15h + 10h = 25h
    INT 10h
;─────────────────────┘

;──────── Input ──────┐
    MOV AH, 01h
    INT 21h
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
    MOV AH, 02h
    MOV BH, 0h
    MOV DX, 0000h
    INT 10h
;──────── Exit ───────┤
    MOV AX, 4C00h
    INT 21h
;─────────────────────┘

operaciones:
;──── Clear: Blue ────┐
    MOV AX, 0600h
    MOV BH, 1Fh
    MOV CX, 0000h
    MOV DX, 184Fh
    INT 10h
;─────────────────────┘

;───── 1er digito ────┐
;───── Cursor Pos ────┤
    MOV AH, 02h
    MOV BH, 0h
    MOV DH, 07h
    MOV DL, 15h
    INT 10h
;──── Print String ───┤
    MOV AH, 09h
    LEA DX, inNum1
    INT 21h
;──────── Input ──────┤
    MOV AH, 01h
    INT 21h
;─────────────────────┤
    SUB AL, '0'
;─────────────────────┘

    MOV num1, AL

;───── 2do digito ────┐
;───── Cursor Pos ────┤
    MOV AH, 02h
    MOV BH, 0h
    MOV DH, 08h
    MOV DL, 15h
    INT 10h
;──── Print String ───┤
    MOV AH, 09h
    LEA DX, inNum2
    INT 21h
;──────── Input ──────┤
    MOV AH, 01h
    INT 21h
;─────────────────────┤
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
;───── Cursor Pos ────┤
    MOV AH, 02h
    MOV BH, 0h
    MOV DH, 09h
    MOV DL, 15h
    INT 10h
;──── Print String ───┤
    MOV AH, 09h
    LEA DX, result
    INT 21h
;───── Print Char ────┤
    MOV AH, 02h
    MOV DL, CH        ; Se pasará el numero correspondiente a decenas
    ADD DL, '0'
    INT 21h
;───── Print Char ────┤
    MOV AH, 02h
    MOV DL, CL        ; Se pasará el numero correspondiente a unidades
    ADD DL, '0'
    INT 21h
;─────────────────────┘

;─────── Pausa ───────┐
    MOV AH, 07h
    INT 21h
;─────────────────────┘

    JMP menu

resta:
    CMP num1, AL
    JL negativo

    SUB num1, AL

;───── Resultado ─────┐
;───── Cursor Pos ────┤
    MOV AH, 02h
    MOV BH, 0h
    MOV DH, 09h
    MOV DL, 15h
    INT 10h
;──── Print String ───┤
    MOV AH, 09h
    LEA DX, result
    INT 21h
;───── Print Char ────┤
    MOV AH, 02h
    MOV DL, num1      ; Se pasará el numero correspondiente a unidades
    ADD DL, '0'
    INT 21h
;─────────────────────┘

;─────── Pausa ───────┐
    MOV AH, 07h
    INT 21h
;─────────────────────┘

    JMP menu

negativo:
    MOV CL, AL        ; El valor ingresado se guardó en AL, ahora lo pasamos a CL para manipularlo
    SUB CL, num1      ; RESTA

;───── Resultado ─────┐
;───── Cursor Pos ────┤
    MOV AH, 02h
    MOV BH, 0h
    MOV DH, 09h
    MOV DL, 15h
    INT 10h
;──── Print String ───┤
    MOV AH, 09h
    LEA DX, result
    INT 21h
;───── Print '-' ────┤
    MOV AH, 02h
    MOV DL, '-'
    INT 21h
;───── Print Char ────┤
    MOV AH, 02h
    MOV DL, CL        ; Se pasará el numero correspondiente a unidades
    ADD DL, '0'
    INT 21h
;─────────────────────┘

;─────── Pausa ───────┐
    MOV AH, 07h
    INT 21h
;─────────────────────┘

    JMP menu

main ENDP

END main
