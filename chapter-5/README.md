### 第5章－[BX]和 loop 指令
#### 实验4 [BX]和 loop 的使用
1. 编程，向内存 `0:200~0:23F` 依次传送数据 `0~63(3FH)`。
- 解：见源程序 `t1.asm`
2. 编程，向内存 `0:200~0:23F` 依次传送数据 `0~63(3FH)`，程序中只能使用 `9` 条指令，`9` 条指令中包括 `“mov ax,4cooh”` 和 `“int 21h”`。
- 解：见源程序 `t2.asm`
3. 下面程序的功能是将 `“mov ax,4cooh”` 之前的指令复制到内存 `0:200` 处，补全程序。上机调试，跟踪运行结果。
  - 复制的是什么？从哪里到哪里？
  - 复制的是什么？有多少字节？如何知道要复制的字节的数量？

``` asm
  assume cs:code
  code segment
    mob ax,____
    mov ds,ax
    mov ax,0200h
    mov es,ax
    mov bx,0
    mov cx,____

  s:mov al,[bx]
    mov es:[bx],al
    inc bx
    loop s
    mov ax,4c00h
    int 21h
    code ends
  end
```