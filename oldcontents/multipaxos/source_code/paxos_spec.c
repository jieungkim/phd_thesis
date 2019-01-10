The local state definition: (rnd, vrnd, val)
Asusmptions:
1. Node identifiers are disjoint
2. The generated round numbers are disjoint
   if their node identifiers are not same

Phase 1 (Prepare):
a. Proposer - state: (crndp, _, _)
   1. Selects a unique proposal number n > crndp
      set cval to none and crndp to n
   2. Send a prepare (n) to all acceptors
b. Acceptor - state: (rnda, vrand, aval)
   Acceptor a receives prepare(n) from p:
   1. If n > rnda then set rnda to n
      send promise(rnda, vrnda, vala) to p
   2. else, ignore request
Phase 2 (Write):
a. Proposer - state: (crndp, _, _)
   Proposer c receives promise(rnda, vrnda, vala)
   from a majority of acceptors with rnda = crndp 
   1. If all reply with vrnda = 0, then set cvalc
      to any proposed value
      Else set cvalc to vala associated with
      largest received value of vrnda
   2. Send accept(crndc, cvalc) to all acceptors
b. Acceptor - state: (rnda, vrand, _)
   Acceptor a revives accept(n,v) from p
   1. If n >= rnda then set vrnda and rnda
      to n and vala to v
      send written(n, n, v) to p
   2. Else ignore request

