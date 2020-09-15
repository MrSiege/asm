assume cs:codesg

; 数组型数据段
data segment
    ; 21年的字符串，每行16byte
    db '1975', '1976', '1977', '1978' 
    db '1979', '1980', '1981', '1982' 
    db '1983', '1984', '1985', '1986'
    db '1987', '1988', '1989', '1990' 
    db '1991', '1992', '1993', '1994'
    db '1995'

    ; 21年公司总收入，每行16byte
    dd 16, 22, 382, 1356
    dd 2390, 8000, 16000, 24486 
    dd 50065, 97479, 140417, 197514
    dd 345980, 590827, 803530, 1183000 
    dd 1843000, 2759000, 3753000, 4649000
    dd 5937000

    ; 21年公司雇员人数, 每行16byte
    dw 3, 7, 9, 13, 28, 38, 130, 220, 
    dw 476, 778, 1001, 1442, 2258, 2793, 4037, 5635, 
    dw 8226, 11542, 14430, 15257, 17800
data ends

; 结构型数据段
table segment
    db 21 dup ('year summ ne ?? ')
table ends


; 代码段
codesg segment

start:
    mov ax, data
    mov ds, ax              
    mov ax, table
    mov es, ax              ; 初始化数据段地址

    mov bx, 0
    mov si, 0
    mov cx, 21              ; 按年份写入数据到table中

next:
    mov ax, ds:[si].0
    

    add si, 2
    add bx, 16
    loop next                ; 继续写入下一年的数据

    mov ax, 4c00h
    int 21h

codesg ends

end start