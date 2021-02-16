assume cs:codesg

; @data-segment
data segment
    ; 21年的字符串，每行16byte，idata=0h
    db '1975', '1976', '1977', '1978'
    db '1979', '1980', '1981', '1982'
    db '1983', '1984', '1985', '1986'
    db '1987', '1988', '1989', '1990'
    db '1991', '1992', '1993', '1994'
    db '1995'

    ; 21年公司总收入，每行16byte，idata=54h
    dd 16, 22, 382, 1356
    dd 2390, 8000, 16000, 24486
    dd 50065, 97479, 140417, 197514
    dd 345980, 590827, 803530, 1183000
    dd 1843000, 2759000, 3753000, 4649000
    dd 5937000

    ; 21年公司雇员人数，每行16byte，idata=0a8h
    dw 3, 7, 9, 13, 28, 38, 130, 220
    dw 476, 778, 1001, 1442, 2258, 2793, 4037, 5635
    dw 8226, 11542, 14430, 15257, 17800
data ends

; @data-segment
table segment
    ; year=0h，income=5h，employee=0ah，average=0dh
    dd 21 dup (0, 0, 0, 0)
table ends

; @data-segment
buffer segment
    ; year=0h，income=5h，employee=0ah，average=0dh
    db 64 dup (0)
buffer ends

; @stack-segment
stack segment
    db 1024 dup (0)
stack ends

; 代码段
codesg segment

    start:
        mov ax, data
        mov ds, ax
        mov ax, table
        mov es, ax                   ; 初始化数据段地址

        mov ax, stack
        mov ss, ax
        mov sp, 1024                 ; 栈指针

        mov bx, 0
        mov bp, 0
        mov cx, 21                   ; 按年份写入数据到table段中

    wirte_year_and_income:
        mov si, 0
        mov ax, ds:0h[bp][si]
        mov es:[bx].0h[si], ax       ; 写入年份数据的前两个字节

        mov ax, ds:54h[bp][si]
        mov es:[bx].5h[si], ax       ; 写入收入数据的前两个字节

        add si, 2
        mov ax, ds:0h[bp][si]
        mov es:[bx].0h[si], ax       ; 写入年份数据的后两个字节

        mov ax, ds:54h[bp][si]
        mov es:[bx].5h[si], ax       ; 写入收入数据的后两个字节

        add bp, 4
        add bx, 16
        loop wirte_year_and_income   ; 继续写入下个年份的数据

        mov bx, 0
        mov bp, 0
        mov cx, 21                   ; 按年份写入数据到table段中

    wirte_employee_num:
        mov ax, ds:0a8h[bp]          ; 读取data段中当前年份的雇员数
        mov es:[bx].0ah, ax          ; 写入雇员数到table段中

        mov si, 0
        mov ax, es:[bx].5h[si]       ; 读取收入的低16位数据
        mov si, 2
        mov dx, es:[bx].5h[si]       ; 读取收入的高16位数据

        div word ptr es:[bx].0ah     ; 求人均收入
        mov es:[bx].0dh, ax          ; 写入人均收入到table段中

        add bp, 2
        add bx, 16
        loop wirte_employee_num      ; 继续写入下个年份的数据


        call clean                   ; 清空屏幕
        mov dh, 1                    ; 从第一行开始显示
        mov bx, 0
        mov cx, 21
        mov ax, buffer
        mov ds, ax

        push cx
        mov cl, 2                    ; 黑底绿字
        mov dl, 0                   ; 显示在第0列
        call show_str                ; 显示年份

sa:     mov si, 0                    ; buffer:0 -> ds:si
        mov ax, es:[bx + 5]
        mov dx, es:[bx + 7]          ; (ax)=Low 16 bits, (dx)=Low 16 bits
        call dtoc                    ; 转换收入为字符串

        push cx
        mov cl, 2                    ; 黑底绿字
        mov dl, 20                   ; 显示在第20列
        call show_str                ; 显示收入

        add si, 0                    ; buffer:0 -> ds:si
        mov ax, es:[bx + 0ah]
        mov dx, 0                    ; (ax)=Low 16 bits, (dx)=Low 16 bits
        call dtoc                    ; 转换收入为字符串

        mov cl, 2                    ; 黑底绿字
        mov dl, 40                   ; 显示在第40列
        call show_str                ; 显示雇员数

        add si, 0                    ; buffer:0 -> ds:si
        mov ax, es:[bx + 0dh]
        mov dx, 0                    ; (ax)=Low 16 bits, (dx)=Low 16 bits
        call dtoc                    ; 转换人均收入为字符串

        mov cl, 2                    ; 黑底绿字
        mov dl, 60                   ; 显示在第60列
        call show_str                ; 显示人均收入

        pop cx
        inc dh
        add bx, 16
        loop sa

    ;     call clean                   ; 清空屏幕
    ;     mov cx, 21                   ; 循环21次显示1975~1995年的数据
    ;     mov dh, 1                    ; 从第一行开始显示
    ;     mov bx, 0
    ;     mov ax, es
    ;     mov ds, ax
    ;     mov si, bx                   ;　table:0000 -> ds:si

    ; s:
    ;     push cx
    ;     mov si, bx
    ;     mov cl, 2                    ; 白底蓝字
    ;     mov dl, 0
    ;     call show_str                ; 显示年份

    ;     mov si, bx
    ;     add si, 5
    ;     mov dl, 20
    ;     call show_str                ; 显示收入

    ;     mov si, bx
    ;     add si, 10                
    ;     mov dl, 40
    ;     call show_str                ; 显示雇员数

    ;     mov si, bx
    ;     add si, 13
    ;     mov dl, 60
    ;     call show_str                ; 显示人均收入

    ;     inc dh
    ;     add bx, 16
    ;     pop cx
    ;     loop s

        mov ax, 4c00h
        int 21h

    ; @subroutines
    clean:
        push ax
        push bx
        push cx
        push es

        mov ax, 0b800h
        mov es, ax
        mov bx, 0
        mov cx, 2000

    s0:
        mov word ptr es:[bx], 0
        add bx, 2
        loop s0

        pop es
        pop cx
        pop bx
        pop ax
        ret

    ; @subroutines
    divdw:
        push bx
        push si                        ; 保存父程序环境

        mov bx, dx                     ; 暂存除数高16位
        mov si, ax                     ; 暂存除数低16位

        mov dx, 0
        mov ax, bx
        div cx                         ; 求 int(H/N)
        push ax                        ; 暂存 int(H/N)的值

        mov ax, si
        div cx                         ; 求 [rem(H/N) * 65536 + L] / N

        mov cx, dx                     ; 余数
        pop dx                         ; 结果的高16位,低16在ax中保持不变

        pop si
        pop bx
        ret                            ; 返回并恢复父程序环境

    ; @subroutines
    dtoc:
        push ax
        push bx
        push cx
        push dx
        push si                        ; 保存父程序环境
        mov bx, 0

    transf_dtoc_s:
        mov cx, 10
        call divdw
        inc bx                         ; 记录求值的次数
        push cx                        ; 保存余数

    transf_dtoc_high_bit:
        mov cx, dx
        jcxz transf_dtoc_low_bit       ; 检查商的高位是否为0，为零则跳转检查商的低位
        jmp transf_dtoc_s              ; 继续求值
        
    transf_dtoc_low_bit:
        mov cx, ax
        jcxz transf_dtoc_ok            ; 检查商的低位是否为0，如果高位和低位都为零，则表示以除尽
        jmp transf_dtoc_s              ; 继续求值
        
    transf_dtoc_ok:
        mov cx, bx                     ; 字符串长度
    transf_dtoc_s1:
        pop ax
        add ax, 30h                    ; 求值的ASCII码
        mov ds:[si], al                ; 保存值的ASCII码到内存中
        inc si                         ; 指针加1
        loop transf_dtoc_s1            ; 继续转换十进制值为ASCII码

        mov ax, 0
        mov ds:[si], al

        pop si
        pop dx
        pop cx
        pop bx
        pop ax
        ret
    
    ; @subroutines
    show_str:
        push ax
        push bx
        push cx
        push dx
        push ds
        push es
        push si

        mov ax, 0b800h
        mov es, ax
        mov al, 0a0h
        mul dh
        mov bx, ax
        mov al, 2h
        mul dl
        add bx, ax
        mov ah, cl

    s5:
        mov al, ds:[si]
        mov es:[bx], ax
        inc si
        add bx, 2

        mov cl, al
        mov ch, 0
        inc cx
        loop s5

        pop si
        pop es
        pop ds
        pop dx
        pop cx
        pop bx
        pop ax                        
        ret

codesg ends

end start