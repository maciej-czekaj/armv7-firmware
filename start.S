.global _start

_start:


  /* Zablokuj przerwania 
   * ustaw tryb na SVC */
  mrs  r0, cpsr
  bic  r0, r0, #0x1f    @ wyczyść bity trybu CPSR[0-4]
  orr  r0, r0, #0xd3    @ maskuj FIQ i IRQ, ustaw tryb na SVC
  msr  cpsr,r0

  /* Zachowaj rejestr sp */
  mov r0, sp

  /* Ustaw nowy stos dla
   * funkcji main() */ 
  ldr  sp, =stack_top
  /* Zachowaj na stosie rejestry sp, lr */
  push  {r0, lr}

  /* Daj znak przed wejściem do main() */
  ldr r1,=debug
  ldr  r0, =0x33333333
  str  r0,[r1]

  bl  main

  /* Przyrwóć ze stosu sp, lr */
  pop  {r0, lr}
  mov  sp, r0

  /* Daj znak że wszystko OK */
  ldr r1,=debug
  ldr  r0, =0x77777777
  str  r0, [r1]

  /* Wróć do trybu FEL */
  bx  lr

end:  b  end
