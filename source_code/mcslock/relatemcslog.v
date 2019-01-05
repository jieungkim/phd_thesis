Fixpoint relate_mcs_log (l: MultiLog): option(MultiLog * list nat) :=
  match l with
  | nil => Some (nil, nil)
  | (TEVENT i e) :: l' =>
    match relate_mcs_log l' with
    | Some (ll, tq) =>
      match e with
        | TTICKET e' =>
          match e' with
            | SWAP_TAIL p true => Some ((TEVENT i (TTICKET (WAIT_LOCK p)))::ll, tq ++ (p::nil))
            | SWAP_TAIL p false => Some (ll, tq ++ (p::nil))
            | GET_NEXT => Some (ll,tq)
            | SET_NEXT _ => Some (ll,tq)
            | SET_BUSY => 
              match tq with
                | _::tq' => 
                  Some ((TEVENT i (TTICKET REL_LOCK))::ll, tq')
                | _ => None
              end
            | GET_BUSY true => Some (ll,tq)
            | GET_BUSY false =>
              match tq with
                | p:: tq' =>
                  Some ((TEVENT i (TTICKET (WAIT_LOCK p))) :: ll, tq)
                | _ => None
              end
            | CAS_TAIL false => Some (ll,tq)
            | CAS_TAIL true =>  Some ((TEVENT i (TTICKET REL_LOCK))::ll, nil)
            | _ => None
          end
        | TSHARED _ =>
          Some ((TEVENT i e) :: ll, tq)
      end
     | _ => None
  end
 end.