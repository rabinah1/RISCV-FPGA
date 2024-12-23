	.file	"app.c"
	.option nopic
	.attribute arch, "rv32i2p1_m2p0_a2p1_f2p2_d2p2_c2p0_zicsr2p0_zifencei2p0"
	.attribute unaligned_access, 0
	.attribute stack_align, 16
	.text
	.align	1
	.globl	main
	.type	main, @function
main:
.LFB0:
	.cfi_startproc
	addi	sp,sp,-32 // sp = sp + (-32) = sp - 32
	.cfi_def_cfa_offset 32
	sw	ra,28(sp) // store register ra to data memory address sp + 28
	                  // dmem[sp + 28] = ra
	sw	s0,24(sp) // store register s0 to data memory address sp + 24
	                  // dmem[sp + 24] = s0
	.cfi_offset 1, -4
	.cfi_offset 8, -8
	addi	s0,sp,32 // s0 = sp + 32
	.cfi_def_cfa 8, 0
	li	a5,1 // Load value 1 to register a5
	sw	a5,-20(s0) // store register a5 to data memory address s0 - 20
	                   // dmem[s0 - 20] = dmem[sp + 12] = a5 = 1
	li	a5,2 // Load value 2 to register a5
	sw	a5,-24(s0) // Store register a5 to memory address s0 - 24
	                   // dmem[s0 - 24] = dmem[sp + 8] = a5 = 2
	lw	a4,-20(s0) // Load value dmem[s0 - 20] to register a4
	                   // a4 = dmem[s0 - 20]
	lw	a5,-24(s0) // Load value dmem[s0 - 24] to register a5
	                   // a5 = dmem[s0 - 24]
	add	a5,a4,a5   // a5 = a4 + a5 = 1 + 2 = 3
	sw	a5,-28(s0) // Store register a5 to memory address s0 - 28
	                   // dmem[s0 - 28] = dmem[sp + 4] = a5 = 3
	lw	a5,-28(s0) // Load value dmem[s0 - 28] to register a5
	                   // a5 = dmem[s0 - 28] = 3
	mv	a0,a5 // Move value in a5 register to a0 register
	              // a0 = a5 = 3
	lw	ra,28(sp) // Load value dmem[sp + 28] to register ra
	                  // ra = dmem[sp + 28]
	.cfi_restore 1
	lw	s0,24(sp) // Load value dmem[sp + 24] to register s0
	                  // s0 = dmem[sp + 24]
	.cfi_restore 8
	.cfi_def_cfa 2, 32
	addi	sp,sp,32 // sp = sp + 32
	.cfi_def_cfa_offset 0
	jr	ra // Jump to return value
	.cfi_endproc
.LFE0:
	.size	main, .-main
	.ident	"GCC: () 14.2.0"
	.section	.note.GNU-stack,"",@progbits
