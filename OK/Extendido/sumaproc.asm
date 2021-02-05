; Macro para imprimir
prints macro string
    mov ah, 09h
    lea dx, string    
    int 21h
endm

; Macro para leer numeros
read macro
    mov ah, 01h       ; Función leer caracter, se lee según ASCII. El valor ingresado se guarda en AL
    int 21h
    sub al, '0'       ; Restamos el valor ASCII de '0' == 52 a el valor ingresado, i.e: '5' - '0' -> 57 - 52 == 5
endm

printc macro reg
    mov ah, 02h       ; Función imprimir caracter, el caracter lo lee del registro DL
    mov dl, reg       ; Se pasará el numero tal cual, pero aún no en ASCII
    add dl, '0'       ; Sumamos '0' (52) para poder imprimirlo como ASCII
    int 21h           ; Interrupción de DOS
endm

.model small
.stack 100h

data SEGMENT
    num1 db 0
    num2 db 0

    msj1 db 13,10,'Ingresa el primer numero: ','$'
    msj2 db 13,10,'Ingresa el segundo numero: ','$'
    msj3 db 13,10,'La suma es: ','$'
data ENDS

code SEGMENT
ASSUME cs:code, ds:data

main:
    mov ax, data      ; Pasamos la dirección de memoria del segmento de datos al registro AX, temporalmente
    mov ds, ax        ; Ahora pasamos el valor de AX a DS = El registro apuntador particular para el segmento de datos
    
    prints msj1       ; Usamos macro con variable msj1
    read              ; Leemos el caracter ingresado y lo convetimos en número
    mov num1, al      ; Copiamos el valor del número ingresado a nuestra variable num1

    prints msj2       ; Usamos macro con variable msj2
    read              ; Leemos el caracter ingresado y lo convetimos en número
    mov num2, al      ; Copiamos el valor del número ingresado a nuestra variable num2

    prints msj3       ; Usamos macro con variable msj3
    mov dl, num1      ; Copiamos el valor de num1 a DL
    add dl, num2      ; Sumamos el valor de num2 a DL (num1)

    mov al, dl        ; Copiamos la suma al reg AL para su ajuste en ASCII
    aam               ; Ajuste en ASCII, convierte el valor de AL a decimal, poniendo el LSD(Unidades) en AL y el MSD(Decenas) en AH
    mov cx, ax        ; Copiamos temporalmente AX a CX: AH -> CH, AL -> CL
    printc ch         ; Imprimimos caracter ASCII de decenas
    printc cl         ; Imprimimos caracter ASCII de unidades

    mov ax, 4C00h     ; ax = ah y al, ah = 4C (Terminar proceso, EXIT), al = 00 (EXIT CODE)
    int 21h           ; Interrupción de DOS

code ENDS

end main

