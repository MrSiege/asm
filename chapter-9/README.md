### 第9章-转移指令的原理
#### 检测点 9.1

1. 程序如下，若要使程序中的`jmp`执行后，`CS:IP`指向程序的第一条指令，在`data`段中应该定义哪些数据？
    - 解：见源程序 `t1.asm`。

```asm
assume cs:code

data segment
    ?
data ends

code segment

start:
    mov ax, data
    mov ds, ax
    mov bx, 0
    jmp word ptr [bx + 1]

code ends
end start
```

    

2. 程序如下，补全程序，使`jmp`执行后，`CS:IP`指向程序的第一条指令。
    - 解：见源程序 `t2.asm`。

```asm
assume cs:code

data segment
    dd 12345678h
data ends

code segment

start:
    mov ax, data
    mov ds, ax
    mov bx, 0
    mov [bx], ____
    mov [bx + 2], ____
    jmp dword ptr ds:[0]

code ends
end start
```


3. 用`Debug`查看内存，结果如下，则此时，CPU执行如下指令后，`(CS)=?`，`(IP)=?`
    - 解：`(CS)=OOO6`，`(IP)=00BE`

```asm
2000:1000 BE 00 06 00 00 00 ......
```

```asm
mov ax, 2000h
mov es, ax
jmp dword ptr es:[1000h]
```

#### 检测点 9.2

补全程序，使用 jcxz 指令，实现在内存 2000H 段中查找第一个值为 0 的字节，找到后，将它的偏移地址存储在 dx 中。
- 解：见源程序 `t3.asm`。

```asm
assume cs:code

code segment

start:
    mov ax, 2000h
    mov ds, ax
    mov bx, 0

s:
    _____
    _____
    _____
    _____
    jmp short s

ok: 
    mov dx, bx
    mov ax, 4c00h
    int 21h

code ends
end start
```

#### 检测点 9.3

补全源程序，使用 loop 指令，实现在内存 2000H 段中查找第一个值为 0 的字节，找到后，将它的偏移地址存储在 dx 中。
- 解：见源程序 `t4.asm`。

```asm
assume cs:code

code segment

start:
    mov ax, 2000h
    mov ds, ax
    mov bx, 0

s:
    mov cl, [bx]
    mov ch, 0
    _____
    inc bx
    loop s

ok: 
    dec bx
    mov dx, bx
    mov ax, 4c00h
    int 21h

code ends
end start
```

#### 实验 8，分析一个奇怪的程序

分析下面的程序，在运行前思考：这个程序可以正常返回吗？
运行后再思考：为什么是这种结果？
通过这个程序加深对相关内容的理解。
- 解：见源程序 `t5.asm` 或下面源代码中的注释信息。

```asm
assume cs:code

code segment

    mov ax, 4c00h         ; 偏移地址 0h
    int 21h

start:
    mov ax, 0             

s:
    nop                   ; 偏移地址 8h，8位位移，0h - 10h = -10，补码表示为 F6h
    nop                   ; 偏移地址 10h，会被指令 jmp EBF6 覆盖，执行后跳转到 mov ax, 4c00h 处执行

    mov di, offset s
    mov si, offset s2
    mov ax, cs:[si]
    mov cs:[di], ax       ; 复制标号 s2 处的 2 个字节长度的代码到标号 s 处，即 jmp EBF6

s0:
    jmp short s           ; 跳转到 s 标号处执行复制过去的 jmp EBF6

s1: 
    mov ax, 0             ; 偏移地址 18h
    int 21h
    mov ax, 0

s2:
    jmp short s1          ; 8位位移，18h - 22h = -10，补码表示为 F6h
    nop                   ; 偏移地址 22h

code ends
end start
```