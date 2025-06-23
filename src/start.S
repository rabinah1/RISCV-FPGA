.section .text.startup
.global _start

_start:
    la sp, _stack_top    # Initialize stack pointer
    call main            # Call main
    j .                  # Infinite loop to halt
