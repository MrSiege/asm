assume cs:code

a segment

    dw 1, 2, 3, 4, 5, 6, 7, 8, 9, 0ah, 0bh, 0ch, 0dh, 0eh, 0fh, 0ffh

a ends

b segment

    dw 0, 0, 0, 0, 0, 0, 0, 0

b ends

code segment

start:
    mov ax, a
    mov ds, ax    ; 设置数据段 a 的段地址
    mov bx, 0h    ; 设置数据段 a 的偏移地址

    mov ax, b
    mov ss, ax    ; 设置数据段 b 的段地址
    mov sp, 10h   ; 设置栈的偏移地址

    mov cx, 8h    ; 设置循环次数

s:  push ds: [bx]
    add bx, 2h 
    loop s

    mov ax, 4c00h
    int 21h

code ends

end start