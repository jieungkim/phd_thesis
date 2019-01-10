void acq (uint b) {
  uint myt=<@$\intp$@>FAI_t(b);
  while(<@$\intp$@>get_n(b)!=myt){}
  <@$\intp$@>pull(b); 
}
void rel (uint b) {
  <@$\intp$@>push(b);
  <@$\intp$@>inc_n(b); 
}
