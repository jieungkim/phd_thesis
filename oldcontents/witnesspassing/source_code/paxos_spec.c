Local state: (rnd, vrnd, val, (*\bfseries wit*))
Assumptions:
1. Node identifiers are disjoint
2. Generated round numbers are unique
3. 2F + 1 acceptors

Phase 1 (Prepare):
a. Proposer:
 // Value client wants to write
 c_val := get_client_val() 
 // new_rnd(rnd) > rnd
 rnd := new_rnd(rnd)
 // broadcast to acceptors
 send(PREPARE, rnd) 
b. Acceptor:
 from, p_rnd := recv()
 if p_rnd > rnd
  rnd := p_rnd
  send(PROMISE, from, vrnd, val, (*\bfseries wit*))

Phase 2 (Write):
a. Proposer:
 promises = {}
 for i=1 to 2F + 1
  promises = promises $\bigcup$ recv()
 if count(promises) >= F + 1 
  if $\forall{}$ promises.val = null
   val, (*\bfseries wit*) := c_val, (*\bfseries nil*)
  else
   val, (*\bfseries wit*) := promise.val, (*\bfseries promise.wit*) 
    such that
     promise.vrnd = max(promises.vrnd)
   // construct a new witness
   (*\bfseries wit := (rnd, val, promises) ++ wit*)
   send(WRITE, rnd, val, (*\bfseries wit*))

b. Acceptor:
 from, p_rnd, p_val, (*\bfseries p\_wit*) := recv()
 if p_rnd >= rnd
  vrnd, val, (*\bfseries wit*) := p_rnd, p_val, (*\bfseries p\_wit*)
  send(WRITTEN, from, vrnd, val)
