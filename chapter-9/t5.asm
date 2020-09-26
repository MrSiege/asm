assume cs:code

code segment

    mov ax, 4c00h         ; 偏移地址 0h
    int 21h

start:
    mov ax, 0             

s:
    nop                   ; 偏移地址 8h，8位位移，0h - 10h = -10，补码表示为 F6h
    nop                   ; 偏移地址 10h，会被指令 jmp EBF6 覆盖，执行后跳转到 mov ax, 4c00h 处执行

    mov di, offset s
    mov si, offset s2
    mov ax, cs:[si]
    mov cs:[di], ax       ; 复制标号 s2 处的 2 个字节长度的代码到标号 s 处，即 jmp EBF6

s0:
    jmp short s           ; 跳转到 s 标号处执行复制过去的 jmp EBF6

s1: 
    mov ax, 0             ; 偏移地址 18h
    int 21h
    mov ax, 0

s2:
    jmp short s1          ; 8位位移，18h - 22h = -10，补码表示为 F6h
    nop                   ; 偏移地址 22h

code ends
end start