ENTRY(_start)

MEMORY
{
    /* The length of DMEM is set as 32-bit words instead of bytes because
    it's used to initialize the stack pointer which is set in words */
    DMEM (rwx) : ORIGIN = 0x00000000, LENGTH = 0x6D6
    PMEM (rx)  : ORIGIN = 0x00000000, LENGTH = 0x85C
}

STACK_SIZE = LENGTH(DMEM) - 32;

__stack_top = ORIGIN(DMEM) + LENGTH(DMEM);
__stack_top = (__stack_top + 15) & ~0xF;

PROVIDE(__stack_top = __stack_top);
PROVIDE(__stack_bottom = ORIGIN(DMEM));

SECTIONS
{
    . = 0x00000000;
    .text : {
        KEEP(*(.text.startup))
        KEEP(*(.text.main))
        *(.text*)
    } > PMEM

    /DISCARD/ :
    {
        *(.rodata*)
        *(.data*)
        *(.bss*)
        *(.init*)
        *(.fini*)
        *(.comment*)
        *(.note*)
        *(.eh_frame*)
        *(.riscv*)
        *(COMMON)
    }
}
