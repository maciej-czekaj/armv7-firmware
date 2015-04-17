.global _start

_start: 
	ldr	r1, =0x3000
	mrs	r0, cpsr	@ debug
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

	bl	main

	ldr	r1, =0x3000
	add	r1,r1,#16
	ldm	r1,{r0, r1, r2, r3, r4, r5, r6, r7, r8, r9, r10, fp, ip, sp, lr}
	sub	r1,r1,#16
	ldr	r0, =0x77777777
	str	r0, [r1,#4]
	bx	lr
end:
	b	.
