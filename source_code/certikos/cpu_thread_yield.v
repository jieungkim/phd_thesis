Function big_thread_yield_spec (adt: RData) (rs: KCtxt) : option (RData * KCtxt) :=
  let cpu := CPU_ID adt in
  let curid := (ZMap.get (CPU_ID adt) (cid adt)) in
  <@$\cdots$@>
    match big_log adt, ZMap.get (msg_q_id cpu + ID_AT_range) (lock adt), 
          cused (ZMap.get curid (AC adt)) with
    | BigDef l, LockFalse, true =>
      let to := big_oracle adt in
      let l1 := (to cpu l) ++ l in
      // record the yield event in the global log
      let e := TBSHARED (BTDYIELD curid) in
      let l_res := (TBEVENT cpu e) :: l1 in
      // replay the log to find out the thread to be scheduled
      match B_CalTCB_log_real l_res with
      | Some (TCB_YIELD la t) =>
        <@$\cdots$@>
        // update the log, save the kernel context,
        // update the current thread ID information, and
        // return the kernel context to be restored for the thread
        // that will run (la)
        Some (adt {big_log: BigDef l_res}
                  {kctxt: ZMap.set curid rs (kctxt adt)}
                  {cid: (ZMap.set (CPU_ID adt) la (cid adt))}
                  , ZMap.get la (kctxt adt))
        <@$\cdots$@>
