# assembly-language
《汇编语言第三版》－王爽著，实验任务源码，本项目用做学习笔记。

> 实验系统：`linux`，实验环境：`dosbox` 模拟 `dos` 环境，编译环境：`masm5`。该项目包含学习汇编的三个基本软件， `masm` 编译器、`link` 链接器、`debug` 调试器。

<br/>
<br/>

基于 debian 的发行版安装 dosbox 可使用如下命令：

```shell
sudo apt-get install dosbox
```

启动 dosbox 后，映射 linux 系统内的路径到 dosbox：

```shell
mount c ~/projects/asm
```

编译 asm 源程序

```shell
masm *.asm
```

链接 obj 目标文件

```shell
link *.obj
```

调试 exe 程序

```shell
debug *.exe
```