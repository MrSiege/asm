; 第 7.5 - 7.6 小节，[bx+idata]的寻址方式，[bx+idata]的寻址方式处理数组数据
assume cs:codesg, ds:datasg

; 数据段
datasg segment
    db 'BaSiC'
    db 'MinIX'
datasg ends

; 代码段
codesg segment

start:
    mov ax, datasg
    mov ds, ax
    mov bx, 0
    mov cx, 5

s:
    mov al, [bx]        ; 第一个数组
    and al, 11011111b
    mov [bx], al

    mov al, 5[bx]       ; 第二个数组
    or al, 00100000b
    mov 5[bx], al

    inc bx
    loop s
    
    mov ax, 4c00h
    int 21h

codesg ends

end start