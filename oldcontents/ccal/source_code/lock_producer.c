#include "L.h"
void l_producer () {
  i = 0;
  L_acq_lock();
  // produce resourse
  // if not full
  while (L_getCnt() == N){
    L_rel_lock();
    L_acq_lock();
  }
  L_inc();
  i = L_getCnt();
  L_rel_lock();
  return i;
}
