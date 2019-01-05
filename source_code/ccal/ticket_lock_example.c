struct ticket_lock {
  volatile uint n, t;
};
//Methods provided by <@$L_0$@>
extern uint get_n();
extern void inc_n();
extern uint FAI_t();
extern void f();
extern void g();
extern void hold();
//<@$M_1$@> module
void acq () {
  uint my_t = FAI_t();
  while(get_n()!=my_t){};
  hold();
}
void rel () { inc_n(); }
//Methods provided by <@$L_1$@>
extern void acq();
extern void rel();
extern void f();
extern void g();
//<@$M_2$@> module
void foo () {
  acq();
  f(); g();
  rel();
}
//Methods provided by <@$L_2$@>
extern void foo();

//Client program <@$P$@>
//Thread running on CPU 1
void T1 () { foo(); }
//Thread running on CPU 2
void T2 () { foo(); }
