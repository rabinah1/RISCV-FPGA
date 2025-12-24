ENTRY(_start)

MEMORY
{
    /* DMEM (rwx) : ORIGIN = 0x00000000, LENGTH = 0x4B0 */
    PMEM (rx)  : ORIGIN = 0x00000000, LENGTH = 0x85C
}

/* STACK_SIZE = LENGTH(DMEM) - 32; Leave some room, just in case */

__stack_top = 0x1000;

PROVIDE(__stack_top = __stack_top);
PROVIDE(__stack_bottom = 0x00000000);

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
