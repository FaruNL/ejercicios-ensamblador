TITLE ''
.MODEL SMALL
INCLUDE C:\general.lib

crearFichero MACRO nombre
    MOV AH, 3Ch
    MOV CX, 00h       ; 00h == Normal, 01h == Sólo lectura
    LEA DX, nombre
    INT 21h
ENDM

abrirFichero MACRO nombre, acceso
    MOV AH, 3Dh
    MOV AL, acceso       ; Modo de acceso: 00h == Sólo lectura, 01h == Sólo escritura, 02h == Lectura/Escritura
    LEA DX, filename
    INT 21h
ENDM

cerrarFichero MACRO handle
    MOV AH, 3Eh
    MOV BX, handle
    INT 21h
ENDM

leerFichero MACRO handle, b, guardado
    MOV AH, 3Fh
    MOV BX, handle
    MOV CX, b
    LEA DX, guardado
    INT 21h
ENDM

escribirFichero MACRO handle, b, escrito
    MOV AH, 40h
    MOV BX, handle
    MOV CX, b
    LEA DX, escrito
    INT 21h
ENDM

.STACK

.DATA
    ; filename DB '▓.txt',0
    filename DB 'notas.txt',0
    handle DW ?
    msg DB 'YES ITS TIME TO WORK HARD '
    buffer DB 25 DUP (?)
    count DB 10

    noCr DB 'Archivo no creado',10,13,'$'
    noAb DB 'Archivo no abierto',10,13,'$'
    noCe DB 'Archivo no cerrado',10,13,'$'
    noLe DB 'Archivo no leido',10,13,'$'
    noEs DB 'Archivo no escrito',10,13,'$'

    crd DB 'Archivo creado',10,13,'$'
    abd DB 'Archivo abierto',10,13,'$'
    ced DB 'Archivo cerrado',10,13,'$'
    led DB 'Archivo leido',10,13,'$'
    esd DB 'Archivo escrito',10,13,'$'

.CODE
.486

main PROC FAR
    MOV AX, @DATA
    MOV DS, AX

    MOV AX, 0600h
    MOV BH, 07h
    MOV CX, 0000h
    MOV DX, 184Fh
    INT 10h

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    crearFichero filename
    JC noCreado
    MOV handle, AX

    cerrarFichero handle
    JC noCerrado
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    abrirFichero filename 01h
    JC noAbierto
    MOV handle, AX

    escribirFichero handle 25 msg
    JC noEscrito
    
    cerrarFichero handle
    JC noCerrado
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    abrirFichero filename 00h
    JC noAbierto
    MOV handle, AX

    leerFichero handle 10 buffer
    JC noLeido

    cerrarFichero handle
    JC noCerrado
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    LEA SI, buffer
L1:
    printChar [SI]
    INC SI
    DEC count
    JNZ L1

    JMP exit

noCreado:
    printS noCr
    JMP exit

noAbierto:
    printS noAb
    JMP exit

noCerrado:
    printS noCe
    JMP exit

noLeido:
    printS noLe
    JMP exit

noEscrito:
    printS noEs
    JMP exit

exit:
    MOV AX, 4C00h
    INT 21h
main ENDP

END main
