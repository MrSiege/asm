; @subroutine
; 名称：transf_dtoc
; 功能：将dword型数据转变为表示十进制数的字符串，字符串以0为结尾符
; 参数：(ax)=dword型数据的低16位，(dx)=dword型数据的高16位，ds:si指向字符串的首地址
; 返回：无
assume cs:transf_dtoc
transf_dtoc segment

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
        mov ds:[si], al                ;  字符串以0结尾，添加结束标识

        pop si
        pop dx
        pop cx
        pop bx
        pop ax
        ret                            ; 恢复父程序环境并返回

transf_dtoc ends