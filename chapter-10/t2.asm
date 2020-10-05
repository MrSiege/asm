assume cs:code

stack segment
    dw 8 dup (0)
stack ends

code segment

    start:
        mov ax, stack                   ; cs:0000h
        mov ss, ax                      ; cs:0003h
        mov sp, 16                      ; cs:0005h
        mov ds, ax                      ; cs:0008h
        mov ax, 0                       ; cs:000ah
        call word ptr ds:[0EH]          ; cs:000dh 执行时，先将下条指令的IP值入栈(SS:[0eh])，然后设置IP为指定的地址（DS:[0eh]）
        inc ax                          ; cs:0011h
        inc ax
        inc ax
        mov ax, 4c00h
        int 21h

code ends
end start