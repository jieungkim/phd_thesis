typedef enum {
  READY,RUN,SLEEP,DEAD
} td_state;
typedef struct tcb {
  td_state tds;
  uint CPU_ID;
  int prev, next;
} tcb;
typedef struct tdq {
  int head, tail;
} tdq;
tcb tcbp[64];
tdq tdqp[256];
int deQ_t(uint i){
  int res = -1;
  int head = tdqp[i].head;
  if (head==-1) return res;
  res = head;
  int next=tcbp[head].next;
  if (next == -1) {
    tdqp[i].head = -1;
    tdqp[i].tail = -1;
  }else {
    tcbp[next].prev = -1;
    tdqp[i].head = next;
  }
  return res;
}
int deQ(uint i) {
  <@$\intp\acq$@>(q_loc(i));
  int res = deQ_t(i);
  <@$\intp\rel$@>(q_loc(i));
  return res;
}
