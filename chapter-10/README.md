### 第10章-CALL和RET指令
#### 检测点 10.1

1. 补全程序，实现从内存`1000:0000`处开始执行指令。
    - 解：见源程序 `t1.asm`。

```asm
assume cs:code

stack segment
    db 16 dup (0)
stack ends

code segment

    start:
        mov ax, stack
        mov ss, ax
        mov sp, 16
        mov ax, ______
        push ax
        mov ax, ______
        push ax
        retf

code ends

end start
```

#### 检测点 10.2

1. 下面的程序执行后，`ax`中的数值为少？
 - 解：`(ax) = 3`，即执行`call s`时下个指令的`(IP)`值。

内存地址 | 机器码    | 汇编指令
:-:     | :-:      | :-:
1000:0  | b8 00 00 | mov ax, 0
1000:3  | e8 01 00 | call s
1000:6  | 40       | inc ax
1000:7  | 58       | s:pop ax

#### 检测点 10.3

1. 下面的程序执行后，`ax`中的数值为少？
 - 解：`(ax) = 1010h`，即执行`call far ptr s`时下个指令的`(IP) * 2 + (CS)`的值。

内存地址 | 机器码    | 汇编指令
:-:     | :-:      | :-:
1000:0  | b8 00 00 | mov ax, 0
1000:3  | 9a 09 00 00 10 | call far ptr s
1000:8  | 40       | inc ax
1000:7  | 58       | s:pop ax
. | . | add ax, ax
. | . | pop bx
. | . | add ax, bx

#### 检测点 10.4

1. 下面的程序执行后，`ax`中的数值为少？

内存地址 | 机器码    | 汇编指令
:-:     | :-:      | :-:
1000:0  | b8 06 00 | mov ax, 6
1000:3  | ff d0    | call ax
1000:5  | 40       | inc ax
1000:6  | .        | mov bp, sp
.       | .        | add ax, [bp]


#### 检测点 10.5

1. 下面的程序执行后，`ax`中的数值为少？（注意：用 `call` 指令的原理来分析，不要在`Debug`中单步跟踪来验证你的结论。对于此程序，在`Debug`中单步跟踪的结果，不能代表`CPU`的实际执行结果。）
- 解：执行`call word ptr ds:[0EH]`时。会将下一条指令`inc ax`的`IP`值入栈到`SS:[0EH]`处。然后IP转移到`DS:[0EH]`处，执行 `inc ax`，最后`ax`的值为`3`。执行步骤见`t2.asm`中的注释。

```asm
assume cs:code

stack segment
    dw 8 dup (0)
stack ends

code segment

    start:
        mov ax, stack
        mov ss, ax
        mov sp, 16
        mov ds, ax
        mov ax, 0
        call word ptr ds:[0EH]
        inc ax
        inc ax
        inc ax
        mov ax, 4c00h
        int 21h

code ends
end start
```

2. 下面的指令执行，ax和bx中的数值为多少？
- 解：见源程序`t3.asm`。
```asm
assume cs:code

data segment
    dw 8 dup (0)
data ends

code segment

    start:
        mov ax, data
        mov ss, ax
        mov sp, 16
        mov word ptr ss:[0], offset s
        mov ss:[2], cs
        call dword ptr ss:[0]
        nop

    s:
        mov ax, offset s
        sub ax, ss:[0ch]
        mov bx, cs
        sub bx, ss:[0eh]
        mov ax, 4c00h
        int 21h

code ends
end start
```

#### 实验 10，编写子程序
1. 显示字符串，显示字符串是现实工作中经常要用到的功能，应该编写一个通用的子程序来实现这个功能。我们应该提供灵活的调用接口，使调用者可以决定显示的位置（行，列）、内容和颜色。