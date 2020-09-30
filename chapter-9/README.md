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

#### 根据材料编程

<p>这个编程任务必须在进行下面的课程之前独立完成，因为后面的课程中，需要通过这个实验而获得的编程经验。</p>
<p>编程：在屏幕中间分别显示绿色、绿底红色、白底蓝色的字符串“welcome to masm!”。</p>
<p>编程所需的知识通过阅读、分析下面的材料获得。</p>
<p>80×25 彩色字符模式显示缓冲区（以下简写为显示缓冲区）的结构：</p>
<p>内存地址空间中，B8000H ~ BFFFFH 共 32KB 的空间，为 80 × 25 彩色字符模式的显示缓冲区。向这个地址空间写入数据，写入的内容将立即出现在显示器上。</p>
<p>在 80 × 25 彩色字符模式下，显示器可以显示 25 行，每行 80 个字符，每个字符可以有 256 种属性（背景色、前景色、闪烁、高亮等组合信息）。</p>
<p>这样，一个字符在显示缓冲区就要占两个字节，分别存放字符的ASCII码和属性。80 × 25 模式下，一屏的内容在显示缓冲区中共占 4000 个字节。</p>
<p>显示缓冲区分为 4 页，每页 4KB(≈4000B)，显示器可以显示任意一页的内容，一般情况下，显示第 0 页的内容。也就是说通常情况下，B8000H ~ B8F9FH 中 4000 个字节的内容将会出现在显示器上。</p>
<p>在一页显示缓冲区中：</p>
<p style='font-size: 12px; margin-left: 8px;'>偏移 000 ~ 09F 对应显示器上的第 1 行（80 个字符占 160 字节）；</p>
<p style='font-size: 12px; margin-left: 8px;'>偏移 0A0 ~ 13F 对应显示器上的第 2 行；</p>
<p style='font-size: 12px; margin-left: 8px;'>偏移 140 ~ 1DF 对应显示器上的第 3 行;</p>
<p>依此类推，可知，偏移 F00 ~ F9F 对应显示器的第 25 行。</p>
<p>在一行中，一个字符占两个字节的存储空间（一个字），低位字节存储字符的 ASCII 码，高位字节存储字符的属性。一行共有 80 个字符，占 160 个字节。</p>
<p>即在一行中：</p>
<p style='font-size: 12px; margin-left: 8px;'>00 ~ 01 单元对应显示器上的第 1 列；</p>
<p style='font-size: 12px; margin-left: 8px;'>02 ~ 03 单元对应显示器上的第 2 列；</p>
<p style='font-size: 12px; margin-left: 8px;'>04 ~ 05 单元对应显示器上的第 3 列；</p>
<p>依此类推，可知，偏移 9E ~ 9F 对应显示器的第 80 列。</p>
<p>依此类推，可知，偏移 9E ~ 9F 对应显示器的第 80 列。</p>
<p>....更多请查阅 ref-book.pdf 第 188 页</p>

- 解：见源程序 `t6.asm`。