int palloc (uint tid) {
  if (cn[tid].quota < 1)
    return ERROR;
  <@$\intp$@>acq_lock (lock_AT);
  uint i=0,fp=nps;
  while(fp==nps&&i<nps){
    if (!AT[i].free) 
      fp = i;
    i++; }
  if (fp != nps) {
    AT[i].free = 0;
    AT[i].ref = 1;
    cn[tid].quota --;
  }
  else fp = ERROR;
  <@$\intp$@>rel_lock (lock_AT);
  return fp;
}
