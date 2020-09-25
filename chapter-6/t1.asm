assume cs:code, ds:data, ss:stack

; 数据段
data segment

    dw 0123h, 0456h, 0789h, 0abch, 0defh, 0fedh, 0cbah, 0987h

data ends

; 栈段
stack segment

    dw 0, 0, 0, 0, 0, 0, 0, 0

stack ends

; 代码段
code segment

start:
    mov ax, stack
    mov ss, ax
    mov sp, 16      ; 设置栈指针
    
    mov ax, data
    mov ds, ax      ; 设置段前缀

    push ds:[0]
    push ds:[2]
    pop ds:[2]
    pop ds:[0]

    mov ax, 4c00h
    int 21h

code ends

end start