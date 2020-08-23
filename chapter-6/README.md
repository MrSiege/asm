### 第6章－包含多个段的程序
#### 实验5 编写、调试具有多个段的程序
1. 将下面的程序编译、连接，用 Debug 加载 、跟踪，然后回答问题。
    1. `CPU` 执行程序，程序返回前，`data` 段中的数据为多少？
    - 解：由试验结果得出，程序返回前，`data` 段中的数据为 `0123h, 0456h, 0789h, 0abch, 0defh, 0fedh, 0cbah, 0987h`（数据没有变化）。
    2. `CPU` 执行程序，程序返回前，`cs`=______，`ss`=______，`ds`=______。
    - 解：由试验结果得出，程序返回前，`cs=07e4`，`ss=07e3`，`ds=07e2`。
    3. 设程序加载后，`code` 段的段地址为 `X`，则 `data` 段的段地址为______，`stack` 段的段地址为______。
    - 解：通过观察试验结果得出，假设该程序加载后，`code` 段的段地址为 `X`，则 `data` 段的段地址为 `X - 2`，`stack` 段的段地址为 `X - 1`。
``` asm
assume cs:code, ds:data, ss:stack

data segment
    dw 0123h, 0456h, 0789h, 0abch, 0defh, 0fedh, 0cbah, 0987h
data ends

stack segment
    dw 0, 0, 0, 0, 0, 0, 0, 0
stack ends


code segment

start:
    mov ax, stack
    mov ss, ax
    mov sp, 16
    
    mov ax, data
    mov ds, ax

    push ds:[0]
    push ds:[2]
    pop ds:[2]
    pop ds:[0]

    mov ax, 4c00h
    int 21h

code ends

end start
```

2. 将下面的程序编译、连接，用 Debug 加载 、跟踪，然后回答问题。
    1. `CPU` 执行程序，程序返回前，`data` 段中的数据为多少？
    - 解：由试验结果得出，程序返回前，`data` 段中的数据为 `0123h, 0456h`（数据没有变化）。
    2. `CPU` 执行程序，程序返回前，`cs`=______，`ss`=______，`ds`=______。
    - 解：由试验结果得出，程序返回前，`cs=07e4`，`ss=07e3`，`ds=07e2`。
    3. 设程序加载后，`code` 段的段地址为 `X`，则 `data` 段的段地址为______，`stack` 段的段地址为______。
    - 解：通过观察试验结果得出，假设该程序加载后，`code` 段的段地址为 `X`，则 `data` 段的段地址为 `X - 2`，`stack` 段的段地址为 `X - 1`。
    4. 对于如下定义的段, 如果段中的数据占 `N` 个字节，则程序加载后，该段实际占有的空间为______。
    ```asm 
        name segment
            ...
        name ends
    ```
    - 解：在 `8086 CPU` 的架构上一个段的最大容量为 `65536 byte（64kb）`，该题有三种结果:
        1. 如果 `N >= 65536 byte` 则该段实际占有的空间为 `65536 byte`。
        2. 如果 `N <= 16 byte` 则该段实际占有的空间为 `16 byte`。
        3. 如果 `N > 16 byte` 且 `N < 65536 byte` 则该段实际占有的空间为 `(N - N mod 16 + 16) byte`。
``` asm
assume cs:code, ds:data, ss:stack

data segment
    dw 0123h, 0456h
data ends

stack segment
    dw 0, 0
stack ends

code segment

start:
    mov ax, stack
    mov ss, ax
    mov sp, 16
    
    mov ax, data
    mov ds, ax

    push ds:[0]
    push ds:[2]
    pop ds:[2]
    pop ds:[0]

    mov ax, 4c00h
    int 21h

code ends

end start
```

3. 将下面的程序编译、连接，用 Debug 加载 、跟踪，然后回答问题。
    1. `CPU` 执行程序，程序返回前，`data` 段中的数据为多少？
    - 解：由试验结果得出，程序返回前，`data` 段中的数据为 `0123h, 0456h`（数据没有变化）。
    2. `CPU` 执行程序，程序返回前，`cs`=______，`ss`=______，`ds`=______。
    - 解：由试验结果得出，程序返回前，`cs=07e2`，`ss=07e6`，`ds=07e5`。
    3. 设程序加载后，`code` 段的段地址为 `X`，则 `data` 段的段地址为______，`stack` 段的段地址为______。
    - 解：通过观察试验结果得出，假设该程序加载后，`code` 段的段地址为 `X`，则 `data` 段的段地址为 `X + 3`，`stack` 段的段地址为 `X + 4`。
``` asm
assume cs:code, ds:data, ss:stack

code segment

start:
    mov ax, stack
    mov ss, ax
    mov sp, 16      ; 设置栈指针
    
    mov ax, data
    mov ds, ax      ; 设置段前缀

    push ds:[0]
    push ds:[2]
    pop ds:[2]
    pop ds:[0]

    mov ax, 4c00h
    int 21h

code ends

data segment
    dw 0123h, 0456h
data ends

stack segment
    dw 0, 0
stack ends

end start
```

4. 如果将 `1`，`2`，`3` 题中的最后一条伪指令 `“end start”` 改为 `“end”`（也就是说，不指明程序的入口），则哪个程序仍然可以正确执行？请说明原因。
    - 解：如果去将 `1`，`2`，`3` 题中的最后一条伪指令 `“end start”` 改为 `“end”` 后，只有 `3` 题中的程序可以正确执行，`3` 题中的 `code` 段在 `data` 段和 `stack` 段之前，程序加载后 `cs:ip` 会正确指向程序的入口。 

5. 程序如下，编写 `code` 段中的代码，将 `a` 段和 `b` 段中的数据依次相加，将结果存到 `c` 段中。
    - 解：见源程序 `t4.asm`。

```asm
assume cs:code

a segment

    db 1, 2, 3, 4, 5, 6, 7, 8 

a ends

b segment

    db 1, 2, 3, 4, 5, 6, 7, 8

b ends

c segment

    db 0, 0, 0, 0, 0, 0, 0, 0

c ends

code segment

start:
      ?

code ends

end start
```

6. 程序如下，编写 `code` 段中的代码，用 `push` 指令将 `a` 段中的前 `8` 个字型数据，逆序存储到 `b` 段中。
    - 解：见源程序 `t5.asm`。

``` asm
assume cs:code

a segment

    dw 1, 2, 3, 4, 5, 6, 7, 8, 9, 0ah, 0bh, 0ch, 0dh, 0eh, 0fh, 0ffh

a ends

b segment

    dw 1, 2, 3, 4, 5, 6, 7, 8

b ends

code segment

start:
      ?

code ends

end start
```