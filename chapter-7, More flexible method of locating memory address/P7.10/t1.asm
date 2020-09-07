; 将数据段中每个单词的头一个字母改为大写
assume cs:codesg, ds:datasg

; 数据段
datasg segment
    db '1. file         '
    db '2. edit         '
    db '3. search       '
    db '4. view         '
    db '5. options      '
    db '6. help         '
datasg ends

; 代码段
codesg segment

start:
    mov ax, datasg
    mov ds, ax
    mov bx, 0
    mov cx, 6               ; 6行

s:
    mov al, [bx + 3]
    and al, 11011111b
    mov [bx + 3], al
    add bx, 16              ; 定位到下一行
    loop s
    
    mov ax, 4c00h
    int 21h

codesg ends

end start