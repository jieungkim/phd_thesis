#include "PLock.h"
extern int nps;
extern AllocTable AT;
extern int lock_AT;
extern Container cn;

int palloc (int tid) {
  if (cn[tid].quota < 1)
    return ERROR;
  <@$\intp$@>acq_lock (lock_AT);
  int i = 0, freei = nps;
  while(freei==nps && i<nps){
    if (!AT[i].is_alloc)
      freei = i;
    i ++;
  }
  if (freei != nps) {
    AT[i].is_alloc = 1;
    AT[i].ref = 1;
    AT[i].owner = tid;
    cn[tid].quota --;
  } else
    freei = ERROR;
  <@$\intp$@>rel_lock (lock_AT);
  return freei;
}

void pfree (int tid, int i) {
  <@$\intp$@>acq_lock (lock_AT);
  if (AT[i].is_alloc && AT[i].owner == tid && AT[i].ref == 1)
    AT[i].is_alloc = 0;
    AT[i].ref = 0;
    AT[i].owner = -1;
    cn[tid].quota --;
  }
  <@$\intp$@>rel_lock (lock_AT);
}
