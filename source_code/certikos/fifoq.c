typedef struct {
  CQueue insrtQ, rmvQ; 
  lock l;
  int n_rmv, n_insrt;
  int front, next;
} fifobbq;
fifobbq q[NUM_FIFOBBQS];

void 
fifoq_pre_rmv(uint i){
  uint cv, pos;
  <@$\intp$@>acq_lock (q[i].l);
  pos = q[i].n_rmv ++;
  cv = my_cv (i);
  enQ (q[i].rmvQ, cv);
  while(q[i].front < pos||q[i].front == q[i].next)
    <@$\intp$@>wait (cv, q[i].l); 
}

void 
fifoq_post_rmv(uint i){
  uint l, cv;
  q[i].front ++;
  cv=peekQ(q[i].insrtQ);
  if (cv != NULL)
    <@$\intp$@>signal(cv);
  deQ (q[i].rmvQ);
  cv = peekQ(q[i].rmvQ);
  if (cv != NULL)
    <@$\intp$@>signal(cv);
  <@$\intp$@>rel_lock (q[i].l);
}
