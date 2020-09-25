assume cs:codesg

codesg segment

    mov ax, 0h
    mov ds, ax          ; 设置段前缀为 0
    mov cx, 40h         ; 初始化循环计数器
    mov ax, 0h          ; 初始化数据累加器
    mov bx, 200h        ; 初始化偏移地址累加器

s:  mov ds:[bx], ax     ; 送入数据到指定内存中
    add ax, 1h          ; 数据累加
    add bx, 1h          ; 偏移地址累加
    loop s

    mov ax, 4c00h
    int 21h

codesg ends

end