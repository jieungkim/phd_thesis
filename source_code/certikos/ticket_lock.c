typedef struct {
  volatile uint ticket;
  volatile uint now;
} ticket_lock;
ticket_lock L[NUM_LOCK];

void acq_lock (uint i) {
  uint t;
  t=<@$\intp\FAI$@>(&L[i].ticket);
  while(<@$\intp$@>L[i].now!=t){}
  <@$\intp$@>pull (i); 
}
void rel_lock (uint i) {
  <@$\intp$@>push (i);
  <@$\intp$@>L[i].now ++;
}
