int counter = 0;
// lock index for counter
int lct;
// Code of thread <@$t_0$@>
void producer() {
  <@$\intp$@>acq_q(lct);
  counter += 2;
  <@$\intp$@>rel_q(lct);
}
// Code of thread <@$t_1$@> and <@$t_2$@>
void consumer() {
  <@$\intp$@>acq_q(lct);
  while (counter <= 0){
    <@$\intp$@>rel_q(lct);
    <@$\intp$@>yield();
    <@$\intp$@>acq_q(lct);
  }
  counter -= 1;
  <@$\intp$@>rel_q(lct);
}
