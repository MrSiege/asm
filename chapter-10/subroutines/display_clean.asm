; @main-segment
; 名称：display_clean
; 功能：清除显示缓冲区第一页的数据
; 参数：无
; 返回：无
assume cs:display_clean
display_clean segment

        push ax
        push bx
        push cx
        push es                        ; 保存父程序环境

        mov ax, 0b800h
        mov es, ax                     ; 设置显示缓冲区段地址
        mov bx, 0
        mov cx, 2000                   ; 显示缓冲区分为 4 页，每页 4KB(≈4000B)，清除第一页的数据，循环2000次，每次清除2个字节的数据

    display_clean_s:
        mov word ptr es:[bx], 0
        add bx, 2
        loop display_clean_s

        pop es
        pop cx
        pop bx
        pop ax                        
        retf                           ; 恢复父程序环境

display_clean ends