include display_str.asm
include display_clean.asm
assume cs:code, ss:stack, ds:data

; @data-segment
data segment
    db 'Welcome to masm!', 0
    db 16 dup (0)
data ends

; @stack-segment
stack segment
    db 128 dup (0)
stack ends

; @main-segment
code segment

    start:
        mov ax, stack
        mov ss, ax
        mov sp, 128                            ; 设置栈指针
        
        ; @display_clean
        mov ax, display_clean
        mov ds:[19], ax
        mov word ptr ds:[17], 0
        call dword ptr ds:[17]                 ; 调用子程序display_clean

        ; @display_str
        mov cl, 01110001b                      ; 白底蓝色
        mov dl, 32
        mov dh, 13                             ; 显示的行与列，从13行32列开始显示
        mov ax, data
        mov ds, ax                             
        mov si, 0                              ; 设置数据段指针

        mov ax, display_str
        mov ds:[19], ax
        mov word ptr ds:[17], 0
        call dword ptr ds:[17]                 ; 调用子程序display_str

        mov ax, 4c00h
        int 21h

code ends
end start