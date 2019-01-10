#include "PreInit.h"

extern ticket_lock *L;

void ticket_acq_lock (int i) {
  int my_t=<@$\intp\XADD$@>(L[i].ticket);
  while (<@$\intp$@>*L[i].now != my_t) {}
}

void ticket_rel_lock (int i) {
  <@$\intp$@>*L[i].now ++;
}

int ticket_try_lock (int i) {
  int my_n = <@$\intp$@>*L[i].now;
  return <@$\intp\CAS$@>(L[i].ticket,my_n,my_n+1);
}
