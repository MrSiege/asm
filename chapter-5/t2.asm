assume cs:codesg

codesg segment

    mov ax, 20h
    mov ds, ax          ; 设置段前缀为20h, 0:200h ~ 0:23fh = 20:0h ~ 20:3fh
    mov cx, 40h         ; 初始化循环计数器
    mov bx, 0h          ; 初始化数据累加器和偏移地址

s:  mov ds:[bx], bx     ; 送入数据到指定内存中
    add bx, 1h          ; (bx) = (bx) + 1h
    loop s

    mov ax, 4c00h
    int 21h

codesg ends

end