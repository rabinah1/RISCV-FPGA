	.text
	.section	.text.startup,"ax",@progbits
	.global _start
	.extern __stack_top
_start:
	la sp, __stack_top
	call main
	j .
