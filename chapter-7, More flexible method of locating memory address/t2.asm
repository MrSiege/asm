; 第 7.4 小节，大小写转换的问题
assume cs:codesg, ds:datasg

; 数据段
datasg segment
    db 'BaSiC'
    db 'iNfOrMaTiOn'
datasg ends

; 代码段
codesg segment

start:
    mov ax, datasg
    mov ds, ax
    mov bx, 0
    mov cx, 5

s:
    mov al, [bx]
    and al, 11011111b
    mov [bx], al
    inc bx
    loop s

    mov bx, 5
    mov cx, 11

s0:
    mov al, [bx]
    or al, 00100000b
    mov [bx], al
    inc bx
    loop s0
    
    mov ax, 4c00h
    int 21h

codesg ends

end start