; Multiboot data
MBALIGN   equ 1
MEMINFO   equ 2
FLAGS     equ MBALIGN | MEMINFO
MAGIC     equ 0x1BADB002
CHECKSUM  equ -(MAGIC + FLAGS)

section .multiboot
align 4
    dd MAGIC
    dd FLAGS
    dd CHECKSUM

section .bootstrap_stack, nobits
align 4
stack_bottom:
resb 4096
stack_top:

section .text
align 4

; NASM implies GCC for us?
extern __cxa_finalize

extern OS216_Main

global _OS216_AsmMain
_OS216_AsmMain:
    cli
    mov esp, stack_top
    call OS216_Main
    
    mov eax, 0
    ud2
    
    ; We don't really need to clean up here, but we might as well.
    push dword 0
    call __cxa_finalize
    ; It probably doesn't matter if the stack is balanced, but...
    add esp, 4
    
.hang:
    cli
    hlt
    jmp .hang