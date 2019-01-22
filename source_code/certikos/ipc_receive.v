  Function thread_tryreceive_chan_spec (chanid vaddr rcount : Z) (adt : RData) : option (RData * Z) :=
    let cpu := (CPU_ID adt) in
    let chid := slp_q_id chanid 0 in
    let sc_id := chid + lock_TCB_range in
    match (init adt, pg adt, ikern adt, ihost adt, ipt adt, 
           B_inLock cpu (big_log adt)) with
      | (true, true, true, true, true, true) =>
        if zle_lt 0 chanid num_cv then
          match ZMap.get chid (syncchpool adt) with
            | SyncChanValid _ _ _  c =>
              if Int.eq_dec c Int.zero then
                Some (adt, 0)
              else
                match thread_ipc_receive_body_spec chid vaddr rcount adt with
                  | Some (adt0, res0) =>
                    match big2_thread_wakeup_spec chanid adt0 with
                      | Some (adt1, res1) =>
                        if zeq res1 0 then
                          match ZMap.get chid (syncchpool adt1) with
                            | SyncChanValid t1 t2 t3 c' =>
                              Some (adt1 {syncchpool: ZMap.set chid (SyncChanValid t1 t2 t3 Int.zero) (syncchpool adt1)}, res0)
                            | _ => None
                          end
                        else
                          if zle_le 0 res1 Int.max_unsigned then
                            Some (adt1, res0)
                          else None
                      | _ => None
                    end
                  | _ => None
                end
            | _ => None
          end
        else None
      | _ => None
    end.
