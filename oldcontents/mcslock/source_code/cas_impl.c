void inline compare_and_swap (volatile int * p, int oldval, int newval)
{
int fail;
__asm__ __volatile__ (
   "0: lwarx %0, 0, %1\n\t"
         "      xor. %0, %3, %0\n\t"
      " bne 1f\n\t"
    " stwcx. %2, 0, %1\n\t"
         "      bne- 0b\n\t"
    " isync\n\t"
"1: "
: "=&r"(fail)
: "r"(p), "r"(newval), "r"(oldval)
: "cr0");
}
