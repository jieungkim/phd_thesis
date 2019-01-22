  .globl cswitch
  cswitch:

  // save the old kernel context
  leal  (%eax,%eax,2), %eax
  leal  KCtxtPool_LOC(,%eax,8), %eax
  movl  %esp, (%eax)
  movl  %edi, 4(%eax)
  movl  %esi, 8(%eax)
  movl  %ebx, 12(%eax)
  movl  %ebp, 16(%eax)

  popl  %ecx
  movl  %ecx, 20(%eax)

  // load the new kernel context
  leal  (%edx,%edx,2), %edx
  leal  KCtxtPool_LOC(,%edx,8), %edx
  movl  (%edx), %esp
  movl  4(%edx), %edi
  movl  8(%edx), %esi
  movl  12(%edx), %ebx
  movl  16(%edx), %ebp
  movl  20(%edx), %ecx
  pushl %ecx
  xorl  %eax, %eax
  ret