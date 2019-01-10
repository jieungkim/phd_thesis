struct fifobbq {
  CQueue insrtQ, rmvQ; 
  int n_rmv, n_insrt;
  int front, next;
  lock l; ...
} q;

void pre_remove(){
  uint cv, pos;
  <@$\intp$@>acq_lock (q.l);
  pos = q.n_rmv ++;
  cv = my_cv ();
  enQ (q.rmvQ, cv);
  while(q.front < pos ||
      q.front == q.next)
    <@$\intp$@>wait (cv, q.l); 
}

void post_remove(){
  uint cv;
  q.front ++;
  cv=peekQ(q.insrtQ);
  if (cv != NULL)
    <@$\intp$@>signal(cv);
  deQ (q.rmvQ);
  cv = peekQ(q.rmvQ);
  if (cv != NULL)
    <@$\intp$@>signal(cv);
  <@$\intp$@>rel_lock (q.l);
}
