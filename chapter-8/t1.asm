assume cs:codesg

; 数组型数据段
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

; 结构型数据段
table segment
    ; year=0h，income=5h，employee=0ah，average=0dh
    db 21 dup ('year summ ne ?? ')
table ends


; 代码段
codesg segment

start:
    mov ax, data
    mov ds, ax              
    mov ax, table
    mov es, ax                   ; 初始化数据段地址

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
    mov es:[bx].5h[si], ax       ; 写入收入数据的前两个字节

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


    ; mov ax, ds:0h[si]        ; 年份
    ; mov ax, ds:54h[si]       ; 总收入
    ; mov ax, ds:0a8h[di]      ; 雇员人数

    ; mov es:[bx].0h, ax       ; 年份项
    ; mov es:[bx].5h, ax       ; 收入项
    ; mov es:[bx].0ah, ax      ; 雇员数项
    ; mov es:[bx].0dh, ax      ; 人均收入项

    mov ax, 4c00h
    int 21h

codesg ends

end start