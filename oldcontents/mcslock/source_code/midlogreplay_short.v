Fixpoint QS_CalLock (l: MultiLog)  :=
  match l with | (TEVENT i e) :: l' =>
    match QS_CalLock l' with
    | Some (c1, c2, b, q, slow, t) =>
      | i0 :: q', p0 :: tq' =>
        if zeq i i0 
        then match b, e with
             | LHOLD, TTICKET SET_BUSY =>
               match c2 with
               | O => None
               | S c2' => if (negb (ZSet.mem i slow)) 
                          then Some (O, O, LEMPTY, q', slow, t') else None
               end
             | LHOLD, TSHARED _ =>
               match c1 with
               | O => None
               | S c1' => Some (c1', c2,LHOLD,q,slow,t)
               end
               ...
        else match b, e with
             | _, TTICKET (GET_BUSY true) => 
                  if ZSet.mem i slow 
                  then None else Some (self_c, rel_c, b, q, slow, t)
      ...
