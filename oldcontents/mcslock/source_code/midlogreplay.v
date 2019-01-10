Fixpoint QS_CalLock (l: MultiLog) : option (nat * nat * head_status * list Z * ZSet.t * list nat) :=
  match l with
  | nil => Some (O, O, LEMPTY, nil, ZSet.empty, nil)
  | (TEVENT i e) :: l' =>
    match QS_CalLock l' with
    | Some (self_c, rel_c, b, q, slow, tq) =>
      match q,tq with
      | nil, nil => 
        match e with
        | TTICKET (SWAP_TAIL bound true) =>
          Some (S bound, S CalPassLockTime, LHOLD, (i::nil), ZSet.empty, (bound::nil))
        | _ => None
        end
      | i0 :: q', p0 :: tq' =>
        if zeq i i0 then
          match b, e with
          | LHOLD, TTICKET GET_NEXT => 
            match rel_c with 
            | O => None
            | S rel_c' => Some (self_c, rel_c', b, q, slow, tq)
            end
          | LHOLD, TTICKET SET_BUSY =>
            match rel_c with
            | O => None
            | S rel_c' =>
              if (negb (ZSet.mem i slow)) 
              then Some (O, O, LEMPTY, q', slow, tq')
              else None
            end
          | _, TTICKET (SET_NEXT _) => 
            if ZSet.mem i slow 
            then Some (self_c, rel_c, b, q, ZSet.remove i slow, tq)
            else None
          | LHOLD, TSHARED _ =>
            match self_c with
            | O => None
            | S self_c' => Some (self_c', rel_c, LHOLD, q, slow, tq)
            end
          | LEMPTY, TTICKET (GET_BUSY false) =>
            Some (S p0, S CalPassLockTime, LHOLD, q, slow, tq)
          | LHOLD, TTICKET (CAS_TAIL false) => 
            match rel_c with
            | O => None
            | S rel_c' => Some (self_c, rel_c', b, q, slow, tq)
            end
          | LHOLD, TTICKET (CAS_TAIL true) =>
          | nil => Some (O, O, LEMPTY, nil, ZSet.empty, nil)
          | _ => None
          end
        | _, _ => None
          end
        else
          match b, e with
          | _, TTICKET (GET_BUSY true) =>
            if ZSet.mem i slow 
            then None
            else Some (self_c, rel_c, b, q, slow, tq)
          | _, TTICKET (SET_NEXT _) => 
            if ZSet.mem i slow 
            then Some (self_c, rel_c, b, q, ZSet.remove i slow, tq)
            else None                        
          | _, TTICKET (SWAP_TAIL bound false) =>
            if in_dec zeq i q 
            then None
            else Some (self_c, rel_c, b, q ++ (i::nil), ZSet.add i slow, tq++(bound::nil))
          | _,_ => None
          end
      | _,_ => None
      end
    | _ => None
    end
  end.
