struct ticket_lock {
  volatile unsigned int 
    now, ticket;
};

// Primitives provided by layer <@$L_0$@>
extern unsigned int get_now();
extern void increase_now();
extern unsigned int FAI_ticket(); 
extern void foo();
extern void goo();
extern void hold_lock();

// Module <@$M_1$@> - ticket lock
void acquire () {
  unsigned int my_ticket;
  my_ticket = FAI_ticket();

  while(get_now()!=my_ticket);

  hold_lock();
}
void release () {
 increase_now(); 
}

// Primitives provided by layer <@$L_1$@>
extern void acquire();
extern void release();
extern void foo();
extern void goo();

// Module <@$M_2$@> - client code with locking
void lockclient () {
  acquire();
  foo();
  goo();
  release();
}

// Primitives provided by <@$L_2$@>
extern void lkclient();

// Client program <@$P$@>
// Thread 1 running on CPU 1
void T1 () { 
  lockclient(); 
}
// Thread 2 running on CPU 2
void T2 () { 
  lockclient(); 
}