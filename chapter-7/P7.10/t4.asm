; 将数据段中每个单词的字母改为大写，使用栈段完成外层循环次数管理
assume cs:codesg, ds:datasg

; 数据段，以ascii码的形式定义数据
datasg segment
    db 'ibm             '
    db 'dec             '
    db 'dos             '
    db 'vax             '
datasg ends

; 栈段
stacksg segment
    dw 0, 0, 0, 0, 0, 0, 0, 0
stacksg ends

; 代码段
codesg segment

start:
    mov ax, stacksg
    mov ss, ax
    mov sp, 16               ; 初始化栈指针
    mov ax, datasg           
    mov ds, ax               ; 初始化数据段地址
    mov bx, 0                
    mov cx, 4                ; 4行

s0:
    push cx                  ; 保存外层循环次数，防止被内层循环次数覆盖
    mov si, 0
    mov cx, 3                ; 每个单词只有3个字母

s:
    mov al, ds: [bx + si]
    and al, 11011111b
    mov ds: [bx + si], al
    inc si                   ; 定位到下一列
    loop s0

    add bx, 16               ; 定位到下一行
    pop cx                   ; 恢复外层循环次数
    loop s

    mov ax, 4c00h
    int 21h

codesg ends

end start