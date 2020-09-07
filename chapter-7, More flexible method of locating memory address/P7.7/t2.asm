; 用更少的代码实现 t1 的程序
assume cs:codesg, ds:datasg

; 数据段
datasg segment
    db 'welcome to masm!'
    db '................'
datasg ends

; 代码段
codesg segment

start:
    mov ax, datasg
    mov ds, ax
    mov si, 0
    mov cs, 8

s:
    mov ax, [si + 0]
    mov [si + 16], ax
    add si, 2               ; 每次复制16位，即两个ascii码
    loop s
    
    mov ax, 4c00h
    int 21h

codesg ends

end start