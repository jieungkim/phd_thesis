#include "PThread.h"
fifobbq q[NUM_FIFOBBQS];
void 
fifoq_pre_rmv(uint i){
  uint p, l, s;
  p = get_pid ();
  l = lock_of (i);
  <@$\intp$@>acq_lock (l);
  enQ (q[i].rmvQ, p);
  s = slpQ_of (i, p);
  while(peekQ(q[i].rmvQ)!=p||q[i].size==0)
    <@$\intp$@>sleep (s, l); }
void 
fifoq_post_rmv(uint i){
  uint l, n;
  q[i].size --;
  n=peekQ(q[i].insrtQ);
  if (n != EMPTY)
 <@$\intp$@>wakeup(slpQ_of(i,n));
  deQ (q[i].rmvQ);
  n = peekQ(q[i].rmvQ);
  if (n != EMPTY)
 <@$\intp$@>wakeup(slpQ_of(i,n));
  l = lock_of (i);
  <@$\intp$@>rel_lock (l); }
