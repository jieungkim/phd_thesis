#include "PIPCIntro.h"
// get physical addr
extern int phy_addr (int, int);

int send (int l, int va, int s){
  int c = get_cid ();
  if (l < 0 || l > MAX_CHAN) 
    return ERROR;
  <@$\intp$@>fifoq_pre_insrt (l);
  int pa = phy_addr (c, va);
  send_data (l, pa, s);
  <@$\intp$@>fifoq_post_insrt (l);
  return s;
}

int recv (int l, int va, int s){
  int c = get_cid ();
  <@$\intp$@>fifoq_pre_rmv (l);
  int pa = phy_addr (c, va);
  int r = copy_data (l, pa, s);
  <@$\intp$@>fifoq_post_rmv (l);
  return r;
}
