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