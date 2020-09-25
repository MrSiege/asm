; 将数据段中每个单词的前4个字母改为大写字母
assume cs:codesg, ds:datasg

; 栈段
stacksg segment
    dw 0, 0, 0, 0, 0, 0, 0, 0
stacksg ends

; 数据段，以ascii码的形式定义数据
datasg segment
    db '1. display      '
    db '2. brows        '
    db '3. replace      '
    db '4. modify       '
datasg ends


; 代码段
codesg segment

start:
    mov ax, stacksg
    mov ss, ax
    mov sp, 16                  ; 初始化栈段地址，栈指针
    mov ax, datasg
    mov ds, ax                  ; 初始化数据段地址
    mov bx, 0                   ; 行指针
    mov cx, 4                   ; 外层循环按行进行

down: 
    push cx                     ; 保存外层循环次数
    mov si, 0                   ; 列指针
    mov cx, 4                   ; 前4个字母改为大写字母

next:
    mov al, ds: [3 + bx + si]   ; 读取数据段的数据
    and al, 11011111b           ; 改变字母为大写
    mov ds: [3 + bx + si], al   ; 存回数据到数据段
    inc si                      
    loop next                   ; 下一列

    add bx, 16
    pop cx                      ; 恢复外层循环次数
    loop down                   ; 下一行

    mov ax, 4c00h
    int 21h

codesg ends

end start