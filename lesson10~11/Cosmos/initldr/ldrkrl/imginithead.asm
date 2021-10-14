MBT_HDR_FLAGS EQU 0x00010003
MBT_HDR_MAGIC EQU 0x1BADB002
MBT2_MAGIC EQU 0xe85250d6
global _start
extern inithead_entry
[section .text]
[bits 32]
_start:
    jmp _entry
align 4
mbt_hdr:
    dd MBT_HDR_MAGIC
    dd MBT_HDR_FLAGS
    dd -(MBT_HDR_MAGIC+MBT_HDR_FLAGS)
    dd mbt_hdr
    dd _start
    dd 0
    dd 0
    dd _entry
    ;
    ; multiboot header
    ;
ALIGN 8
mbhdr:
    DD	0xE85250D6
    DD	0
    DD	mhdrend - mbhdr
    DD	-(0xE85250D6 + 0 + (mhdrend - mbhdr))
    DW	2, 0
    DD	24
    DD	mbhdr
    DD	_start
    DD	0
    DD	0
    DW	3, 0
    DD	12
    DD	_entry
    DD      0
    DW	0, 0
    DD	8
mhdrend:

_entry:
    cli  ; 关中断

    in al, 0x70
    or al, 0x80
    out 0x70,al  ; 关掉不可屏蔽中断

    lgdt [GDT_PTR]  ; 加载 GDT 地址到 GDTR 寄存器
    jmp dword 0x8 :_32bits_mode  ; 长跳转刷新 CS 影子寄存器

_32bits_mode:
    mov ax, 0x10
    mov ds, ax
    mov ss, ax
    mov es, ax
    mov fs, ax
    mov gs, ax
    xor eax,eax
    xor ebx,ebx
    xor ecx,ecx
    xor edx,edx
    xor edi,edi
    xor esi,esi
    xor ebp,ebp
    xor esp,esp
    mov esp,0x7c00  ; 设置栈顶为 0x7c00
    call inithead_entry  ; 调用 inithead_entry 函数。在 inithead.c 中实现
    jmp 0x200000  ; 跳转到 0x200000 地址


; GDT 全局段描述符表
GDT_START:
knull_dsc: dq 0
kcode_dsc: dq 0x00cf9e000000ffff
kdata_dsc: dq 0x00cf92000000ffff
k16cd_dsc: dq 0x00009e000000ffff  ; 16 位代码段描述符
k16da_dsc: dq 0x000092000000ffff  ; 16 位数据段描述符
GDT_END:
GDT_PTR:
GDTLEN	dw GDT_END-GDT_START-1  ; GDT 界限
GDTBASE	dd GDT_START
