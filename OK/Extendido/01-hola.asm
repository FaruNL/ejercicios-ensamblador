.286
TITLE 'Hola mundo'

stak SEGMENT STACK
    DB 32 DUP('Stack__')
stak ENDS

data SEGMENT
    msj DB 'Hola mundo!',13,10,'$'
data ENDS

code SEGMENT
ASSUME SS:stak, DS:data, CS:code

main PROC FAR
    PUSH DS           ; DS tiene la dirección de retorno del SO, la ponemos en el stack
    PUSH 0            ; Evitamos que la dirección anterior se corrompa poniendole un cero enseguida

    MOV AX, data      ; Pasamos la dirección de memoria del segmento de datos al registro AX, temporalmente
    MOV DS, AX        ; Ahora pasamos el valor de AX a DS = El registro apuntador particular para el segmento de datos

    MOV AH, 09h       ; 09 = Función para imprimir una cadena
    LEA DX, msj       ; Carga la dirección efectiva (Incluyendo el offset) de la variable <msj>
    INT 21h           ; Interrupción de DOS
    
    RET
main ENDP

code ENDS

END main
