assume cs:code

data segment
    dw 8 dup (0)
data ends

code segment

    start:
        mov ax, data                               ; cs:0000h
        mov ss, ax                                 ; cs:0003h
        mov sp, 16                                 ; cs:0005h
        mov word ptr ss:[0], offset s              ; cs:0009h 执行后 (ss:0000h) = 001ah
        mov ss:[2], cs                             ; cs:0010h 执行后 (ss:0002h) = (cs)
        call dword ptr ss:[0]                      ; cs:0015h 执行后 (ss:0eh) = 0015h，(ss:0ch) = (cs)，(ip) = 001ah，(cs) = (cs)
        nop                                        ; cs:0019h

    s:
        mov ax, offset s                           ; cs:001ah 执行后 (ax) = 001ah
        sub ax, ss:[0ch]                           ; 执行后(ax) = 001ah - (cs)
        mov bx, cs                                 ; 执行后(bx) = (cs)
        sub bx, ss:[0eh]                           ; 执行后(bx) = (cs) - 0015h
        mov ax, 4c00h
        int 21h

code ends
end start