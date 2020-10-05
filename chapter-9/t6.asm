assume cs:code, ds:data

data segment
    db 'welcome to masm!'
data ends

code segment

    start:
        mov ax, data
        mov ds, ax                          ; 设置数据段段地址
        mov ax, 0b800h
        mov es, ax                          ; 设置显示缓冲区段地址



    clean:                                  ; 开始一轮清空屏幕
        mov cx, 7d0h
    clean_char:
        mov word ptr es:[bx], 0
        add bx, 2
        loop clean_char



    render:
        mov cx, 16
        mov bx, 0
        mov si, 40h                          ; 屏幕显示的第32列字符
    render_char:
        mov al, ds:[bx]                      ; 字符 ASCII 码

        mov ah, 00000010b                    ; 黑底绿色
        mov es:6e0h[si], ax                  ; 屏幕显示的第11行字符

        mov ah, 00100100b                    ; 绿底红色
        mov es:780h[si], ax                  ; 屏幕显示的第12行字符

        mov ah, 01110001b                    ; 白底蓝色
        mov es:820h[si], ax                  ; 屏幕显示的第13行字符

        inc bx
        add si, 2
        loop render_char
        jmp short render                     ; 开始一轮新的渲染

code ends
end start