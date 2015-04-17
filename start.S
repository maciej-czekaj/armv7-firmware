.global _start

_start:

  /* saved_regs[15] = CPSR */
  ldr  r1, =saved_regs
  mrs  r0, cpsr
  str  r0,[r1,#15*4]

  /* Zablokuj przerwania 
   * ustaw tryb na SVC */
  bic  r0, r0, #0x1f    @ wyczyść bity trybu CPSR[0-4]
  orr  r0, r0, #0xd3    @ maskuj FIQ i IRQ, ustaw tryb na SVC
  msr  cpsr,r0

  /* Zachowaj wszystkie rejestry
   * do saved_regs[0-11] */
  stm  r1,{r2, r3, r4, r5, r6, r7, r8, r9, r10, fp, ip, sp, lr}

  /* Załaduj rejestr stosu */
  ldr  sp, =stack_top
 
  /* Daj znak przed wejściem do main() */
  ldr r1,=debug
  ldr  r0, =0x33333333
  str  r0,[r1]

  bl  main

  /* Przyrwóć wartości rejestrów */
  ldr  r1, =saved_regs
  ldm  r1,{r2, r3, r4, r5, r6, r7, r8, r9, r10, fp, ip, sp, lr}

  /* Daj znak że wszystko OK */
  ldr r1,=debug
  ldr  r0, =0x77777777
  str  r0, [r1]

  /* Wróć do trybu FEL */
  bx  lr

end:  b  end
