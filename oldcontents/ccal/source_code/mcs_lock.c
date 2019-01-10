#include "PreInit.h"
extern mcs_lock *L;

void acq_lock (int i, mcs *n) {
  n->busy = 1;
  n->next = NULL;
  mcs *t = <@$\intp\XCHL$@>(L[i].tail,n);
  if (t == NULL) return;
  <@$\intp$@>tail->next = n;
  while (<@$\intp$@>n->busy) {}
}

void rel_lock (int i, mcs *n) {
  if (<@$\intp$@>n->next == NULL) {
    if (<@$\intp\CAS$@>(L[i].tail,n,NULL))
      return;
    while (<@$\intp$@>n->next == NULL) {}
  }
  <@$\intp$@>n->next->busy = 0;
}
