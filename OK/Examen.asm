.286
TITLE 'Examen unidad 2'
.MODEL SMALL

.STACK

.DATA
    num1 DB ?

    input1 DB 'Ingrese un numero: ','$'
    input2 DB 'Ingrese otro numero: ', '$'
    letreroMa DB 'El numero mayor es: ', '$'
    letreroIg DB 'Los numeros son iguales', '$'
    letreroSa DB "Salir = Presione la tecla 's'",13,10,"Reiniciar = Presione cualquier otra tecla",13,10,'Que desea hacer?: ', "$"
    letreroNu DB "Ingresa solo numeros", "$"

    saltoLinea DB 13,10,'$'

.CODE

main PROC FAR
    MOV AX, @DATA
    MOV DS, AX

ciclo:
;── Limpiar pantalla ─┐
    MOV AH, 06h
	MOV AL, 00h
	MOV BH, 07h
	MOV CX, 0000h
	MOV DX, 184Fh
	INT 10h
;─────────────────────┘

;─ Print: saltoLinea ─┐
    MOV AH, 09h
    LEA DX, saltoLinea
    INT 21h
;─── Print: input1 ───┤
    LEA DX, input1
    INT 21h
;─────────────────────┘

;───── Read: num1 ────┐
    MOV AH, 01h
	INT 21h
;─────────────────────┘

    MOV num1, AL

;─ Print: saltoLinea ─┐
    MOV AH, 09h
    LEA DX, saltoLinea
    INT 21h
;─── Print: input2 ───┤
    LEA DX, input2
    INT 21h
;─────────────────────┘

;───── Read: num2 ────┐
    MOV AH, 01h
    INT 21h
;─────────────────────┘

;─ Print: saltoLinea ─┐
    MOV AH, 09h
    LEA DX, saltoLinea
    INT 21h
;─────────────────────┘

;──── Cond: Letras ───┐
    CMP num1, '0'
    JB letras

    CMP num1, '9'
    JA letras

    CMP AL, '0'
    JB letras

    CMP AL, '9'
    JA letras

    JMP condicion
;─────────────────────┘

;────── ¿Letras? ─────┐
letras:
    LEA DX, letreroNu
    INT 21h

    JMP seguir
;─────────────────────┘

;───── Condición ─────┐
condicion:
    CMP num1, AL
    JA mayor
    JB menor

;─────── ELSE ────────┐
    LEA DX, letreroIg
    INT 21h

    JMP seguir

;─────── IF [>]───────┤
mayor:
    LEA DX, letreroMa
    INT 21h

    MOV AH, 02h
    MOV DL, num1
    INT 21h

    JMP seguir

;─────── IF [<]───────┤
menor:
    LEA DX, letreroMa
    INT 21h

    MOV AH, 02h
    MOV DL, AL
    INT 21h
;─────────────────────┘

seguir:
    MOV AH, 09h
    LEA DX, saltoLinea
    INT 21h

    LEA DX, saltoLinea
    INT 21h

    LEA DX, letreroSa
    INT 21h

    MOV AH, 01h
    INT 21h

    CMP AL, 's'
    JNE jmpciclo

    MOV AX, 4C00h
    INT 21h

jmpciclo: JMP ciclo
main ENDP

END main
