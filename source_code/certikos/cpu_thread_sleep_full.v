Function big_thread_sleep_spec (adt: RData) (rs: KContext) (cv: Z): option (RData * KContext) :=
  let cpu := (CPU_ID adt) in
  let curid := (ZMap.get cpu (cid adt)) in
  let n := slp_q_id cv 0 in
  let abid := (n + ID_AT_range) in
  let sc_id := n + lock_TCB_range in
  match (pg adt, ikern adt, ihost adt, ipt adt) with
  | (true, true, true, true) =>
    if zlt_lt 0 curid num_proc then
      if zle_lt 0 cv num_cv then
        match big_log adt, ZMap.get abid (lock adt), ZMap.get sc_id (lock adt),
            cused (ZMap.get curid (AC adt)) with
        | BigDef l, LockFalse, LockOwn true, true =>
          let to := big_oracle adt in
          let l1 := (to cpu l) ++ l in
          let e := TBSHARED (BTDSLEEP curid cv (syncchpool adt)) in
          let l' := (TBEVENT cpu e) :: l1 in
          match B_CalTCB_log_real l', B_CalLock sc_id l, B_CalLock sc_id l1 with
          | Some (TCB_RID la), Some (S (S _), LHOLD, Some cpu'), Some _ =>
            if zle_lt 0 la num_proc then
              if zeq cpu cpu' then
                Some (adt {big_log: BigDef l'}
                          {kctxt: ZMap.set curid rs (kctxt adt)}
                          {cid: (ZMap.set (CPU_ID adt) la (cid adt))}
                          {lock: ZMap.set sc_id LockFalse (ZMap.set abid LockFalse (lock adt))}
                      , ZMap.get la (kctxt adt))
              else None
            else None
          | _,_,_ => None
          end
        | _,_,_,_ => None
        end
      else None
    else None
  | _ => None
  end.
