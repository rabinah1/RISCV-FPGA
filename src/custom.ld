ENTRY(main)

SECTIONS
{
    . = 0x00000000;
    .text : {
        KEEP(*(.text.startup))
        *(.text*)
    }

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
