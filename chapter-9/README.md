### 第9章-转移指令的原理
#### 检测点 9.1

1. 程序如下

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
若要使程序中的`jmp`执行后，`CS:IP`指向程序的第一条指令，在`data`段中应该定义哪些数据？

2. 程序如下

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
    jmp dword ptr, ds:[0]

code ends
end start
```
补全程序，使`jmp`执行后，`CS:IP`指向程序的第一条指令。

3. 用`Debug`查看内存，结果如下：

```asm
2000:1000 BE 00 06 00 00 00 ......
```

则此时，CPU执行指令：

```asm
mov ax, 2000h
mov es, ax
jmp dword ptr es:[1000h]
```
后，`(CS)=?`，`(IP)=?`