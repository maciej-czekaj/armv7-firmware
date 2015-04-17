.global _start

_start:

  /* Zapisz CPSR pod 0x3000 
   * przydatne przy debugowaniu */
  ldr  r1, =0x3000
  mrs  r0, cpsr
  str  r0,[r1,#0]

  /* Zablokuj przerwania 
   * ustaw tryb na SVC */
  bic  r0, r0, #0x1f    @ wyczyść bity trybu CPSR[0-4]
  orr  r0, r0, #0xd3    @ maskuj FIQ i IRQ, ustaw tryb na SVC
  msr  cpsr,r0

  /* Zachowaj wszystkie rejestry
   * pod 0x3010 */
  add  r1,r1,#16
  stm  r1,{r2, r3, r4, r5, r6, r7, r8, r9, r10, fp, ip, sp, lr}
  sub  r1,r1,#16

  /* Załaduj rejestr stosu */
  ldr  sp, =stack_top
 
  /* Daj znak przed wejściem do main() */
  ldr  r0, =0x33333333
  str  r0,[r1,#4]

  bl  main

  /* Przyrwóć wartości rejestrów */
  ldr  r1, =0x3000
  add  r1,r1,#16
  ldm  r1,{r2, r3, r4, r5, r6, r7, r8, r9, r10, fp, ip, sp, lr}

  /* Daj znak że wszystko OK */
  sub  r1,r1,#16
  ldr  r0, =0x77777777
  str  r0, [r1,#4]

  /* Wróć do trybu FEL */
  bx  lr

end:  b  end
