; @main_segment
; 名称：display_str
; 功能：在指定的位置，用指定的颜色，显示一个用0结束的字符串
; 参数：(dh)=行号(取值范围0-24)，(dl)=列号(取值范围0-79)，(cl)=颜色，ds:si指向字符串的首地址
; 返回：无
assume cs:display_str
display_str segment

        push ax
        push bx
        push cx
        push dx
        push ds
        push es
        push si                        ; 保存父程序环境

        mov ax, 0b800h
        mov es, ax                     ; 设置显存段地址
        mov al, 0a0h
        mul dh                         ; 求行地址
        mov bx, ax                     ; 暂存行地址 
        mov al, 2h
        mul dl                         ; 求列地址
        add bx, ax                     ; 累加行地址与列地址
        mov ah, cl                     ; 设置字符的颜色属性，这里设置一次，后续的字符全部生效

    display_str_render:
        mov al, ds:[si]                ; 读取一个字符数据
        mov es:[bx], ax                ; 写入字符数据到显存
        inc si                         ; 累加字符串指针
        add bx, 2                      ; 累加显存指针，一个字符在显存中占2字节(字符, 属性)

        mov cl, al
        mov ch, 0
        inc cx
        loop display_str_render        ; 判断是否渲染到结尾(数据为0则是结尾)

        pop si
        pop es
        pop ds
        pop dx
        pop cx
        pop bx
        pop ax                        
        retf                           ; 恢复父程序环境

display_str ends