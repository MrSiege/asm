; 第 7.3 小节， 以字符形式给出数据
assume cs:code, ds:data

; 数据段，以ascii码的形式定义数据
data segment
    db 'unIX'
    db 'foRK'
data ends

; 代码段
code segment
start:
    mov al, 'a'
    mov bl, 'b'
    mov ax, 4c00h
    int 21h
code ends

end start