### 第8章-数据处理的两个基本问题
#### 实验七 寻址方式在结构化数据访问中的应用

`Power idea`公司从`1975`年成立一直到`1995`年的基本收入情况如下。

年份 | 收入(千美元) | 雇员(人) | 人均收入(千美元) |
:-: | :-: | :-: | :-:
1975 | 16 | 3 | ?
1976 | 22 | 7 | ?
1977 | 382 | 9 | ?
1978 | 1356 | 13 | ?
1979 | 2390 | 28 | ?
1980 | 8000 | 38 | ?
... |
1995 | 5937000 | 17800 | ?

<br/>
下面的程序中，已经定义好列这些数据：

```asm
assume cs:codesg

data segment
    ; 21年的字符串
    db '1975', '1976', '1977', '1978', '1979', '1980', '1981', '1982', '1983', '1984'
    db '1985', '1986', '1987', '1988', '1989', '1990', '1991', '1992', '1993', '1994'
    db '1995'

    ; 21年公司总收入的21个doword型数据
    dd 0000016, 000022, 000382, 001356, 002390, 0008000, 0016000, 0024486, 0050065, 0097479
    dd 0140417, 197514, 345980, 590827, 803530, 1183000, 1843000, 2759000, 3753000, 4649000
    dd 5937000

    ; 21年公司雇员人数的21个word型数据
    dw 00003, 0007, 0009, 0013, 0028, 0038, 0130, 00220, 00476, 00778
    dw 01001, 1442, 2258, 2793, 4037, 5635, 8226, 11542, 14430, 15257
    dw 17800
data ends

table segment
    db 21 dup ('year summ ne ?? ')
table ends
```

编程，将`data`段中的数据按如下格式写入到`table`段中，并计算`21`年中的人均收入（取整），结果也按照下面段格式保存在`table`中。

<table border=1>
  <tr style='background-color: gray'>
    <th></th>
    <th colspan='4'>年份(4字节)</th>
    <th>空格</th>
    <th colspan='4'>收入(4字节)</th>
    <th>空格</th>
    <th colspan='2'>雇员数(2字节)</th>
    <th>空格</th>
    <th colspan='2'>人均收入(2字节)</th>
    <th>空格</th>
  </tr>
  <tr>
    <td>一年占一行，每行的起始地址 \ 行内地址</td>
    <td>0</td>
    <td>1</td>
    <td>2</td>
    <td>3</td>
    <td>4</td>
    <td>5</td>
    <td>6</td>
    <td>7</td>
    <td>8</td>
    <td>9</td>
    <td>A</td>
    <td>B</td>
    <td>C</td>
    <td>D</td>
    <td>E</td>
    <td>F</td>
  </tr>
  <tr>
    <td>table:0</td>
    <td colspan='4'>1975</td>
    <td></td>
    <td colspan='4'>16</td>
    <td></td>
    <td colspan='2'>3</td>
    <td></td>
    <td colspan='2'>?</td>
    <td></td>
  </tr>
  <tr>
    <td>table:10H</td>
    <td colspan='4'>1976</td>
    <td></td>
    <td colspan='4'>22</td>
    <td></td>
    <td colspan='2'>7</td>
    <td></td>
    <td colspan='2'>?</td>
    <td></td>
  </tr>
  <tr>
    <td>table:20H</td>
    <td colspan='4'>1977</td>
    <td></td>
    <td colspan='4'>382</td>
    <td></td>
    <td colspan='2'>9</td>
    <td></td>
    <td colspan='2'>?</td>
    <td></td>
  </tr>
  <tr>
    <td>table:30H</td>
    <td colspan='4'>1978</td>
    <td></td>
    <td colspan='4'>1356</td>
    <td></td>
    <td colspan='2'>13</td>
    <td></td>
    <td colspan='2'>?</td>
    <td></td>
  </tr>
  <tr>
    <td>table:40H</td>
    <td colspan='4'>1979</td>
    <td></td>
    <td colspan='4'>2390</td>
    <td></td>
    <td colspan='2'>28</td>
    <td></td>
    <td colspan='2'>?</td>
    <td></td>
  </tr>
  <tr>
    <td>table:50H</td>
    <td colspan='4'>1980</td>
    <td></td>
    <td colspan='4'>8000</td>
    <td></td>
    <td colspan='2'>38</td>
    <td></td>
    <td colspan='2'>?</td>
    <td></td>
  </tr>
  <tr>
    <td colspan='17'>...</td>
  </tr>
  <tr>
    <td>table:140H</td>
    <td colspan='4'>1995</td>
    <td></td>
    <td colspan='4'>593700</td>
    <td></td>
    <td colspan='2'>17800</td>
    <td></td>
    <td colspan='2'>?</td>
    <td></td>
  </tr>
</table>
<br/>

提示，可将`data`段中的数据看做是多个数组，而将`table`中的数据看成是一个结构型数据的数组，每个结构型数据中包含多个数据项。可用`bx`定位每个结构型数据，用`idata`定位数据项，用`si`定位每个数组项中的每个元素，对于`table`中的数据的访问可采用`[bx].idata`和`[bx].idata[si]`的寻址方式。

注意，这个程序是到目前为止最复杂的程序，它几乎用到了我们以前学到的所有知识和编程技巧。所以，这个程序是对我们从前学习的最好的实践总结。请认真完成。