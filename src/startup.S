	.text
	.section	.text.startup,"ax",@progbits
	.align  2
	.global _start
	.extern __stack_top
_start:
	la sp, __stack_top
	call main
	j .
