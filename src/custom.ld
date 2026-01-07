MEMORY
{
    PMEM (rx)  : ORIGIN = 0x00000000, LENGTH = 0x85C
}

__stack_top = 0x1000;

PROVIDE(__stack_top = __stack_top);
PROVIDE(__stack_bottom = 0x00000000);

SECTIONS
{
    . = 0x00000000;
    .text : {
        KEEP(*(.text.startup))
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
