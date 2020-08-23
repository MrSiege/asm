assume cs:code

a segment

    db 1, 2, 3, 4, 5, 6, 7, 8 

a ends

b segment

    db 1, 2, 3, 4, 5, 6, 7, 8

b ends

c segment

    db 0, 0, 0, 0, 0, 0, 0, 0

c ends

code segment

start:
    mov ax, a
    mov ds, ax    ; 设置数据段 a 的段地址

    mov ax, b
    mov es, ax    ; 设置数据段 b 的段地址

    mov ax, c     ; 设置数据段 c 的段地址
    mov ss, ax

    mov bx, 0     ; 初始化偏移地址
    mov cx, 8h    ; 设置循环次数，8 字节，循环 8 次

s:  mov al, ds: [bx]
    mov ah, es: [bx]
    add al, ah          ; 8 + 8 会溢出
    mov ss: [bx], al

    add bx, 1
    loop s

    mov ax, 4c00h
    int 21h

code ends

end start