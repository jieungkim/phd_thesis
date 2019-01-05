Fixpoint CalMCSLock (l: MultiLog):=
  match l with
  | nil => Some init_MCSLock
  | (TEVENT i e) :: l' =>
    match CalMCSLock l' with
    | Some mcs =>
      match e, mcs with
      | TTICKET e', MCSLOCK tail0 la bounds =>
        match e' with
        | SWAP_TAIL p _ =>
          Some (MCSLOCK i (ZMap.set i (true, NULL) la) 
               (bounds ++ (p::nil)))
        | GET_NEXT => Some mcs
        | SET_NEXT old =>
          match ZMap.get old la with
          | (b, t) =>
            Some (MCSLOCK tail0 (ZMap.set old (b, i) la) bounds)
          end
        | GET_BUSY _ => Some mcs
        | SET_BUSY =>
          match ZMap.get i la with
          | (b, t) =>
             match ZMap.get t la with
             | (b', t') =>
               Some (MCSLOCK tail0 (ZMap.set t (false, t') la)
                    (tl bounds))
             end
          end
        | CAS_TAIL false => Some mcs
        | CAS_TAIL true =>
          if zeq tail0 i then
          Some (MCSLOCK NULL la nil)
          else None
        | _ => None
        end
      | _, _ => Some mcs
      end
    | _ => None
    end
  end.
