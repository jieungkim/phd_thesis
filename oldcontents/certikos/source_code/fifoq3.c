struct fifobbq {
  Queue insrtQ, rmvQ; 
  int n_rmv, n_insrt;
  int front, next;
  int T[MAX]; lock l;
} q;

void remove(){
  uint cv, pos, t;
  <@$\intp$@>acq_lock (q.l);
  pos = q.n_rmv ++;
  cv = my_cv ();
  <@$\intp$@>enQ (q.rmvQ, cv);
  while(q.front < pos ||
      q.front == q.next)
    <@$\intp$@>wait (cv, q.l); 

  t = q.T[q.front % MAX]
  q.front ++;
  
  cv=<@$\intp$@>peekQ (q.insrtQ);
  if (cv != NULL)
      <@$\intp$@>signal (cv);
  <@$\intp$@>deQ (q.rmvQ);
  cv = <@$\intp$@>peekQ (q.rmvQ);
  if (cv != NULL)
      <@$\intp$@>signal (cv);
  <@$\intp$@>rel_lock (q.l);
  return t; 
}
