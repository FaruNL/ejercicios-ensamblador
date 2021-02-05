.286
TITLE ''

stak SEGMENT STACK
    DB 32 DUP('Stack__')
stak ENDS

data SEGMENT
    num DB ?, '$'
data ENDS

code SEGMENT
ASSUME SS:stak, DS:data, CS:code

main PROC FAR
    PUSH DS
    PUSH 0

    MOV AX, data
    MOV DS, AX

    MOV CL, 6
    MOV num, 2
    ADD num, CL

    ADD num, 30h

    MOV AH, 09h
    LEA DX, num
    INT 21h

    RET
main ENDP

code ENDS

END main
