assume cs:code

data segment

data ends

code segment

start:
    mov ax, data
    mov ds, ax
    mov bx, 0
    jmp word ptr [bx + 1]

code ends
end start