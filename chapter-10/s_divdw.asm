; @subroutine
; 名称：math_divdw
; 代数X：被除数，范围[0, FFFFFFFF]
; 代数N：除数，范围[0, FFFF]
; 代数H：X高16位，范围[0, FFFF]
; 代数L：X低16位，范围[0, FFFF]
; int()：描述性运算符，取商，比如 int(38/10)=3
; rem()：描述性运算符，取余数，比如 rem(38/10)=8
; 公式：X/N = int(H/N) * 65536 + [rem(H/N) * 65536 + L] / N
; 思想：将一个多位数的除法运算分解为多个少位数的除法运算
; 功能：进行不会产生溢出的除法运算，被除数为dword型，除数为word型，结果为dword型
; 参数：(ax)=dword型数据的低16位，(dx)=dword型数据的高16位，(cx)=除数
; 返回：(ax)=结果的低16位，(dx)=结果的高16位，(cx)=余数
assume cs:math_divdw
math_divdw segment

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
        retf                           ; 返回并恢复父程序环境

math_divdw ends