#include "PThreadSched.h"
// pending queue
extern tdqueue * pendq;
// ready queue
extern tdqueue * rdq;
// sleeping queue for channel
extern tdqueue ** slpq;
extern TCB * tcb;

void thread_poll_pending () {
  if (no_sleeper()) return;
  int cpu = get_cpu_id ();
  pid =<@$\intp$@>deQ_try(pendq[cpu]);
  if (pid != INVALID_TID) {
    tcb[pid].state = READY;
    enQ(rdq[cpu], pid);
    sleeper_dec (cpu);
  }
}

void thread_sched (int ocid) {
  int cpu = get_cpu_id ();
  int ncid = deQ(rdq[cpu]);
  tcb[ncid] = RUN;
  set_cid (ncid);
  if (ocid != ncid) {
    kctx_switch (ocid, ncid);
  }
}

void thread_yield () {
  <@$\intp$@>thread_poll_pending ();
  int cpu = get_cpu_id ();
  int c = get_cid ();
  tcb[c].state = READY;
  enQ (rdq[cpu], c);
  thread_sched (c);
}

void thread_sleep(int l){
  int cpu = get_cpu_id ();
  int c = get_cid ();
  tcb[c] = SLEEP;
  <@$\intp$@>enQ_atom(slpq[l][c],c);
  sleeper_inc (cpu);
  <@$\intp$@>rel_lock (l);
  thread_sched (c);
  <@$\intp$@>acq_lock (l);
}

void thread_wakeup(int l,int c){
  int me = get_cpu_id ();
  int t =<@$\intp$@>deQ_atom(slpq[l][c]);
  int tcpu = pget_cpu_id (t);
  if (tcpu == me) {
    tcb[t] = READY;
    enQ (rdq[tcpu], t);
    sleeper_dec (tcpu);
  } else {
    <@$\intp$@>enQ_atom(pendq[tcpu]);
  }
}
