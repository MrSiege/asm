; 将数据段中每个单词的字母改为大写
assume cs:codesg, ds:datasg

; 数据段
datasg segment
    db 'ibm             '
    db 'dec             '
    db 'dos             '
    db 'vax             '
datasg ends

; 代码段
codesg segment

start:
    mov ax, datasg
    mov ds, ax
    mov bx, 0
    mov cx, 4                ; 4行

s0:
    mov si, 0
    mov cx, 3                ; 每个单词只有3个字母

s:
    mov al, ds: [bx + si]
    and al, 11011111b
    mov ds: [bx + si], al
    inc si                   ; 定位到下一列
    loop s0

    add bx, 16               ; 定位到下一行
    loop s

    mov ax, 4c00h
    int 21h

codesg ends

end start