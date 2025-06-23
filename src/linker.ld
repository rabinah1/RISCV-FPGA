ENTRY(_start)

MEMORY
{
  RAM (rwx) : ORIGIN = 0x80000000, LENGTH = 64K
}

SECTIONS
{
  . = ORIGIN(RAM);

  .text : {
    KEEP(*(.text.startup))
    *(.text*)
  }

  . = ALIGN(4);
  _stack_top = . + 0x200;  /* Define stack top */

  /DISCARD/ : {
    *(.eh_frame*)
    *(.comment*)
  }
}
