Function big_thread_yield_spec (adt: RData) (rs: KContext) : option (RData * KContext) :=
  let cpu := CPU_ID adt in
  let curid := (ZMap.get (CPU_ID adt) (cid adt)) in
  match (pg adt, ikern adt, ihost adt, ipt adt) with
  | (true, true, true, true) =>
    match big_log adt, ZMap.get (msg_q_id cpu + ID_AT_range) (lock adt), cused (ZMap.get curid (AC adt)) with
    | BigDef l, LockFalse, true =>
      let to := big_oracle adt in
      let l1 := (to cpu l) ++ l in
      let e := TBSHARED (BTDYIELD curid) in
      let l' := (TBEVENT cpu e) :: l1 in
      match B_CalTCB_log_real l' with
      | Some (TCB_YIELD la t) =>
        if zle_lt 0 la num_proc then
          if IsCused t (AC adt) then
            Some (adt {big_log: BigDef l'}
                      {kctxt: ZMap.set curid rs (kctxt adt)}
                      {cid: (ZMap.set (CPU_ID adt) la (cid adt))}
                  , ZMap.get la (kctxt adt))
          else None
        else None
      | _ => None
      end
    | _, _, _ => None
    end
  | _ => None
  end.
