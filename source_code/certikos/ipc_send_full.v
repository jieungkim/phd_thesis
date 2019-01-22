  Function thread_syncsendto_chan_pre_spec (cv : Z) (adt : RData) : option RData :=
    let cpu := (CPU_ID adt) in
    let curid := (ZMap.get cpu (cid adt)) in
    let chid := slp_q_id cv 0 in
    match (pg adt, ikern adt, ihost adt, ipt adt) with
      | (true, true, true, true) =>
        if zle_lt 0 cv num_cv then
          match big2_acquire_lock_SC_spec chid adt with
            | Some adt0 =>
              match ZMap.get chid (syncchpool adt0) with
                | SyncChanValid t1 t2 t3 c =>
                  if Int.eq_dec c Int.zero then
                    Some (adt0 {syncchpool: ZMap.set chid (SyncChanValid t1 t2 t3 Int.one) (syncchpool adt0)})
                  else
                    match big2_thread_sleep_spec cv adt0 with
                      | Some adt1 =>
                        big2_acquire_lock_SC_spec chid adt1
                      | _ => None
                    end
                | _ => None
              end
            | _ => None
          end
        else None
      | _ => None
    end.