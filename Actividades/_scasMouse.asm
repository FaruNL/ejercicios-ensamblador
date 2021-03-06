.286
TITLE ''

;─────── Macros ──────┐
printS MACRO str
    MOV AH, 09h
    LEA DX, str
    INT 21h
ENDM

readS MACRO mem
; mem: 
;     [mem]:   1er byte == Tamaño max. de string
;     [mem+1]: 2do byte == Tamaño actual
;     [mem+2]: 3er byte == Donde inicia String
    MOV AH, 0Ah
    LEA DX, mem
    INT 21h

; Remplazamos el char 0D por centinela "$"
    XOR BX, BX            ; Limpiamos registro BX
    MOV BL, [mem+1]       ; BL == Tamaño actual
    MOV [mem+2+BX], "$"   ; Inicio de String + BX(BL): 1 byte después del String == $
ENDM

printChar MACRO regVal
    MOV AH, 02h
    MOV DL, regVal
    INT 21h
ENDM
;─────────────────────┘

.MODEL SMALL

.STACK

.DATA
    charI DB 'SI se encuentra el caracter: ','$'
    charD DB 'NO se encuentra el caracter: ','$'
    quest1 DB "Ingresa una cadena (Max. 25 chars) y presiona enter cuando termines: ", '$'
    quest2 DB "Ingresa el caracter a buscar: ", '$'
    nl DB 10,13,'$'

    str1 DB 25
         DB ?
         DB 25 DUP (?)

.CODE

;───── Procedures ────┐
readChar PROC NEAR
    MOV AH, 01h
    INT 21h
    RET
readChar ENDP


;─────────────────────┘

main PROC FAR
    MOV AX, @DATA
    MOV DS, AX

;── Limpiar pantalla ─┐
    MOV AX, 0600h
    MOV BH, 07h
    MOV CX, 0000h
    MOV DX, 184Fh
    INT 10h
;─────────────────────┘

    printS quest1
    readS str1
    printS nl

    printS quest2

;─── Leer caracter ───┐
    MOV AH, 01h
    INT 21h
;─────────────────────┘

    PUSH DS
    POP ES

    LEA DI, [str1+2]     ; Dirección inicial de la cadena origen

    XOR CX, CX
    MOV CL, [str1+1]     ; Numero de elementos ingresados en la cadena

    CLD
    REPNE SCASB

    JNE not_found

    printS nl
    printS nl
    printS charI
    printChar AL

    JMP fin

not_found:
    printS nl
    printS nl
    printS charD
    printChar AL

fin:
    MOV AX, 4C00h
    INT 21h
main ENDP

END main
