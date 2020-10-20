# assembly-language
《汇编语言第三版》清华大学出版社，2013年版，王爽著，ISBN 978-7-302-33314-2。本项目用来做该书的学习笔记，管理实验任务源码等。

> 实验系统：`linux`，实验环境：`dosbox` 模拟 `dos` 环境，编译环境：`masm5`。该项目包含学习汇编的三个基本软件， `masm` 编译器、`link` 链接器、`debug` 调试器。

<br/>
<br/>

基于 debian 的 linux 发行版安装 dosbox 可使用如下命令

```shell
sudo apt-get install dosbox
```

启动 dosbox 后，映射 linux 系统内的路径到 dosbox，并设置masm环境变量

```dos
MOUNT C: /path/to/asm
SET PATH=C:\MASM6.15\BIN
```

编译 asm 源程序

```shell
masm *.asm;
```

链接 obj 目标文件

```shell
link *.obj;
```

调试 exe 程序

```shell
debug *.exe
```