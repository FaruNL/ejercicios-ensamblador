.286
TITLE 'MENU'

INCLUDE menu.lib

stak SEGMENT STACK
    DB 32 DUP('Stack__')
stak ENDS

data SEGMENT
    num1 DB ?
    num2 DB ?
    input DB ?

    strMenu DB 'Que operacion deseas realizar?','$'
    strAdd DB '1) SUMA','$'
    strSub DB '2) RESTA','$'
    strExit DB '?) SALIR (Cualquier tecla)','$'
    strInput DB 'Ingresa opcion: ','$'
    
    inNum1 DB 'Primer valor: ','$'
    inNum2 DB 'Segundo valor: ','$'
    result DB 'Resultado: ','$'
data ENDS

code SEGMENT
ASSUME SS:stak, DS:data, CS:code

main PROC FAR
    PUSH DS
    PUSH 0
    
    MOV AX, data
    MOV DS, AX

menu:
;------- Menu --------;
    CALL clear        ; Limpieza y pantalla en azul

    cursor 07h,15h
    printS strMenu    ; "Que operacion deseas realizar?""

    cursor 08h,15h
    printS strAdd     ; "1) SUMA"

    cursor 09h,15h
    printS strSub     ; "2) RESTA"

    cursor 0Ah,15h
    printS strExit    ; "?) SALIR"

    cursor 0Bh,15h
    printS strInput   ; "Ingresa opcion:""

    CALL readChar
;---------<>----------;

    MOV input, AL     ; Copiamos el caracter ingresado de AL a <input>

;----- Cond:Suma -----;
    CMP input, '1'
    JE suma
;---------<>----------;

;----- Cond:Resta ----;
    CMP input, '2'
    JE resta
;---------<>----------;

;---- Screen reset ---;
    MOV AX, 0600h
    MOV BH, 07h
    MOV CX, 0000h
    MOV DX, 184Fh
    INT 10h
    CALL cursorInit
;---------<>----------;

    RET

suma:
    CALL clear

; ---- 1er digito ----;
    cursor 07h,15h
    printS inNum1     ; "Primer valor:"
    CALL readChar
    SUB AL, '0'       ; Restamos el valor ASCII de '0' == 48 a el valor ingresado
;---------<>----------;

    MOV num1, AL      ; Guardamos el valor en la variable

; ---- 2do digito ----;
    cursor 08h,15h
    printS inNum2     ; "Segundo valor:"
    CALL readChar
    SUB AL, '0'
;---------<>----------;

    ADD AL, num1      ; SUMA

;----- Conv ASCII ----;
    AAM               ; Ajuste en ASCII, convierte el valor de AL a decimal, poniendo el LSD(Unidades) en AL y el MSD(Decenas) en AH
    MOV CX, AX        ; Copiamos temporalmente AX a CX: AH -> CH, AL -> CL
;---------<>----------;

;----- Resultado -----;
    cursor 09h,15h
    printS result
    printC CH         ; Decenas
    printC CL         ; Unidades
;---------<>----------;

    CALL pausa

    JMP menu

resta:
    CALL clear

; ---- 1er digito ----;
    cursor 07h,15h
    printS inNum1     ; "Primer valor:"
    CALL readChar
    SUB AL, '0'       ; Restamos el valor ASCII de '0' == 48 a el valor ingresado
;---------<>----------;

    MOV num1, AL      ; Guardamos el valor en la variable

; ---- 2do digito ----;
    cursor 08h,15h
    printS inNum2     ; "Segundo valor:"
    CALL readChar
    SUB AL, '0'
;---------<>----------;

    CMP num1, AL
    JL negativo

    SUB num1, AL      ; RESTA

;----- Resultado -----;
    cursor 09h,15h
    printS result
    printC num1
;---------<>----------;

    CALL pausa

    JMP menu

negativo:
    MOV CL, AL        ; El valor ingresado se guardó en AL, ahora lo pasamos a CL para manipularlo
    SUB CL, num1      ; RESTA

    cursor 09h,15h
    printS result
    MOV AH, 02h
    MOV DL, '-'
    INT 21H
    printC CL

    CALL pausa

    JMP menu

main ENDP

code ENDS

END main
