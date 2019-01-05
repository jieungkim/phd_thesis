#include "L.h"
void l_consumer () {
  i = 0;
  L_acq_lock();
  // consume resourse
  // if available
  while (L_getCnt() == 0){
    L_rel_lock();
    L_acq_lock();
  }
  L_dcr();
  i = L_getCnt();
  L_rel_lock();
  return i;
}
