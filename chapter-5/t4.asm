assume cs:codesg

codesg segment

    mov ax, cs
    mov ds, ax          ; 设置 ds 为程序代码起始地址
    mov ax, 020h         
    mov es, ax          ; 200:0
    mov bx, 0           
    mov ax, cx          
    sub ax, 5           ; 减去 “mov ax, 4c00h”, “int 21h” 两条指令的长度
    mov cx, ax          ; “mov ax, 4c00h” 之前的指令长度，通过计算得出

s:  mov al, [bx]
    mov es:[bx], al
    inc bx
    loop s
    mov ax, 4c00h
    int 21h

codesg ends

end