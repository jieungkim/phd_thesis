void acq_q(uint l) {
  <@$\intp$@> acq(ql_loc(l));
  if (ql_busy[l] != -1) {
    <@$\intp$@> sleep(l);
  } else {
    ql_busy[l] = get_tid();
    <@$\intp$@> rel(ql_loc(l));    
  }
}
void rel_q (uint l) {
  <@$\intp$@> acq(ql_loc(l));
  ql_busy[l] =<@$\intp$@> wakeup(l);
  <@$\intp$@> rel(ql_loc(l));    
}
