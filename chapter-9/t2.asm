assume cs:code

data segment
    dd 12345678h
data ends

code segment

start:
    mov ax, data
    mov ds, ax
    mov bx, 0
    mov [bx], ____
    mov [bx + 2], ____
    jmp dword ptr, ds:[0]

code ends
end start