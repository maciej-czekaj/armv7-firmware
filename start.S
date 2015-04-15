.global _start
_start: b	reset
	ldr	pc, _undefined_instruction
	ldr	pc, _software_interrupt
	ldr	pc, _prefetch_abort
	ldr	pc, _data_abort
	ldr	pc, _not_used
	ldr	pc, _irq
	ldr	pc, _fiq

_undefined_instruction: .word _undefined_instruction
_software_interrupt:	.word _software_interrupt
_prefetch_abort:	.word _prefetch_abort
_data_abort:		.word _data_abort
_not_used:		.word _not_used
_irq:			.word _irq
_fiq:			.word _fiq
_pad:			.word 0x12345678 /* now 16*4=64 */


reset:
	ldr	r1, =0x3000
	mrs	r0, cpsr
	str	r0,[r1,#0]
	bic	r0, r0, #0x1f		@ clear all mode bits
	orr	r0, r0, #0xd3		@ disable FIQ and IRQ, set SVC mode
	msr	cpsr,r0
	
	add	r1,r1,#16
	stm	r1,{r0, r1, r2, r3, r4, r5, r6, r7, r8, r9, r10, fp, ip, sp, lr}
	sub	r1,r1,#16
	ldr	sp, =stack_top
	ldr	r0, =0x33333333
	str	r0,[r1,#4]

#	and	r1, r0, #0x1f		@ mask mode bits
#	teq	r1, #0x1a		@ test for HYP mode
#	bicne	r0, r0, #0x1f		@ clear all mode bits
#	orrne	r0, r0, #0x13		@ set SVC mode
#	orr	r0, r0, #0xc0		@ disable FIQ and IRQ
#	msr	cpsr,r0

#	ldr	r0, =0xffff0020
	bl	main
end:
	ldr	r1, =0x3000
	add	r1,r1,#16
	ldm	r1,{r0, r1, r2, r3, r4, r5, r6, r7, r8, r9, r10, fp, ip, sp, lr}
	sub	r1,r1,#16
	str	pc, [r1,#4]
	bx	lr

undefined_instruction:
	b .
software_interrupt:
	b .
prefetch_abort:
	b .
data_abort:
	b .
not_used:
	b .
irq:
	b .
fiq:
	b .
pad:
	b .

