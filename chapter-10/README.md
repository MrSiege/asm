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
1. 在指定的位置显示字符串，……略。
    - 解：见源程序`display_str.asm`。
2. 解决除法溢出的问题，……略。
    - 解：见源程序`t4.asm`中的`divdw`。
3. 将`dword`型数据转变为十进制数的字符串，……略。
    - 解：见源程序`t4.asm`中的`dtoc`。


#### 课程设计1
在整个课程中，我们一共有两个课程设计，编写两个比较综合的程序，这是第一个。
任务：将实验 7 中的 Power idea 公司的数据按照如下表格的形式（书中给的是图片，这里用表格代替）在屏幕上显示出来。

年份 | 收入(千美元) | 雇员(人) | 人均收入(千美元)
:-: | :-: | :-: | :-:
1975 | 16 | 3 | 5
1976 | 22 | 7 | 3
1977 | 382 | 9 | 42
1978 | 1356 | 13 | 104
1979 | 2390 | 28 | 85
1980 | 8000 | 38 | 210
... |
1995 | 5937000 | 17800 | 333