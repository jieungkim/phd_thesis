void acq (uint b) {
  uint myt=<@$\intp$@>FAI_t(b);
  while(<@$\intp$@>get_n(b)!=myt){}
  <@$\intp$@>pull(b);//acts as hold()
}
void rel (uint b) {
  push(b);
  <@$\intp$@>inc_n(b); 
}
