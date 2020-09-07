assume cs:codesg

codesg segment

    mov ax, cs
    mov ds, ax          ; 设置 ds 为程序代码起始地址
    mov ax, 020h         
    mov es, ax          ; 200:0
    mov bx, 0
    mov cx, 17h         ; “mov ax, 4c00h” 之前的指令长度

s:  mov al, [bx]
    mov es:[bx], al
    inc bx
    loop s
    mov ax, 4c00h
    int 21h

codesg ends

end