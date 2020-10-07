; include display_str.asm
; include display_clean.asm
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

        ; ; @display_clean
        ; mov ax, display_clean
        ; mov ds:[19], ax
        ; mov word ptr ds:[17], 0
        ; call dword ptr ds:[17]                 ; 调用子程序display_clean

        ; ; @display_str
        ; mov cl, 01110001b                      ; 白底蓝色
        ; mov dl, 32
        ; mov dh, 13                             ; 显示的行与列，从13行32列开始显示
        ; mov ax, data
        ; mov ds, ax                             
        ; mov si, 0                              ; 设置数据段指针

        ; mov ax, display_str
        ; mov ds:[19], ax
        ; mov word ptr ds:[17], 0
        ; call dword ptr ds:[17]                 ; 调用子程序display_str

        ; @display_str
        ; mov cl, 01110001b                      ; 白底蓝色
        ; mov dl, 32
        ; mov dh, 13                             ; 显示的行与列，从13行32列开始显示
        ; mov ax, data
        ; mov ds, ax                             
        ; mov si, 0                              ; 设置数据段指针
        ; call display_str

        ; @divdw
        mov ax, 1000h
        mov dx, 1
        mov cx, 1
        call divdw

        mov ax, 4c00h
        int 21h

    ; @subroutine
    ; 名称：display_str
    ; 功能：在指定的位置，用指定的颜色，显示一个用0结束的字符串
    ; 参数：(dh)=行号(取值范围0-24)，(dl)=列号(取值范围0-79)，(cl)=颜色，ds:si指向字符串的首地址
    ; 返回：无
    display_str:
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

    display_str_s:
        mov al, ds:[si]                ; 读取一个字符数据
        mov es:[bx], ax                ; 写入字符数据到显存
        inc si                         ; 累加字符串指针
        add bx, 2                      ; 累加显存指针，一个字符在显存中占2字节(字符, 属性)

        mov cl, al
        mov ch, 0
        inc cx
        loop display_str_s             ; 判断是否渲染到结尾(数据为0则是结尾)

        pop si
        pop es
        pop ds
        pop dx
        pop cx
        pop bx
        pop ax                        
        ret                            ; 恢复父程序环境

    ; @subroutine
    ; 名称：divdw
    ; 代数X：被除数，范围[0, FFFFFFFF]
    ; 代数N：除数，范围[0, FFFF]
    ; 代数H：X高16位，范围[0, FFFF]
    ; 代数L：X低16位，范围[0, FFFF]
    ; int()：描述性运算符，取商，比如 int(38/10)=3
    ; rem()：描述性运算符，取余数，比如 rem(38/10)=8
    ; 公式：X/N = int(H/N) * 65536 + [rem(H/N) * 65536 + L] / N
    ; 功能：进行不会产生溢出的除法运算，被除数为dword型，除数为word型，结果为dword型
    ; 参数：(ax)=dword型数据的低16位，(dx)=dword型数据的高16位，(cx)=除数
    ; 返回：(dx)=结果的高16位，(ax)=结果的低16位，(cx)=余数
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

code ends
end start