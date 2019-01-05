void resched(uint otid) {
  uint ntid = deQ_t(rdq());
  tcb[ntid].tds = RUN;
  set_tid(ntid);
  cswitch(&kctxt[otid],
          &kctxt[ntid]);
}
void poll_pending() {
  uint pid =<@$\intp$@>deQ(pendq());
  if (pid != -1) {
    tcb[pid].state = READY;
    <@$\intp$@>enQ(rdq(), pid);
  }
}
void yield() {
  uint t = get_tid();
  tcb[t].state = READY;
  <@$\intp$@>poll_pending();
  enQ_t(rdq(), t);
  resched (t);
}
void sleep (uint q, uint l){
  uint t = get_tid();
  tcb[t].tds = SLEEP;
  <@$\intp$@>enQ(slpq(q),t);
  <@$\intp$@>rel(l);
  resched (t);
}
