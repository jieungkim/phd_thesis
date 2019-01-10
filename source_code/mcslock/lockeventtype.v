Inductive MCSLockEvent :=
  // Events for MCS-lock primitives
  | SWAP_TAIL (bound: nat) (IS_CPU_NUM: bool) | CAS_TAIL (success : bool)
  | GET_NEXT | SET_NEXT (old_tail: Z) | GET_BUSY (busy : bool) | SET_BUSY
  // Events for the high-level queue-lock
  | WAIT_LOCK (n: nat) | REL_LOCK.

Inductive SharedMemEvent := ... 
