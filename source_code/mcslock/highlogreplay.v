Fixpoint H_CalLock (l: MultiLog) : option (nat * head_status * option Z) :=
  match l with
    | nil => Some (O, LEMPTY, None)
    | (TEVENT i e) :: l' =>
      match H_CalLock l' with
        | Some (S self_c', LHOLD, Some i0) =>
          match zeq i i0, e with
            | left _, TTICKET REL_LOCK => Some (O, LEMPTY, None)
            | left _, TSHARED _ => Some (self_c', LHOLD, Some i0)
            | _, _ => None end
        | Some (_, LEMPTY, None) =>
          match e with
            | TTICKET (WAIT_LOCK n) => Some (n, LHOLD, Some i)
            | _ => None end
        | _ => None end end.