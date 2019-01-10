#include "PLock.h"
int palloc (uint tid) {
  if (cn[tid].quota < 1)
    return ERROR;
  <@$\intp$@>acq_lock (lock_AT);
  uint i=0,freei=nps;
  while(freei==nps &&i<nps){
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
  return freei; }
