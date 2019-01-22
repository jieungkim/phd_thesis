Function big_thread_wakeup_spec (cv: Z) (adt: RData) :=
  let me := CPU_ID adt in
  match (ikern adt, pg adt, ihost adt, ipt adt) with
  | (true, true, true, true) =>
    let n := slp_q_id cv 0 in
    if zle_lt 0 cv num_cv then
      match big_log adt, ZMap.get (n + ID_AT_range) (lock adt) with
      | BigDef l, LockFalse =>
        let to := big_oracle adt in
        let l1 := (to me l) ++ l in
        let e := TBSHARED (BTDWAKE (ZMap.get (CPU_ID adt) (cid adt)) cv) in
        let l' := (TBEVENT me e) :: l1 in
        match B_CalTCB_log_real l' with
        | Some (TCBWAKE_F) =>
          Some (adt {big_log: BigDef l'}, 0)
        | Some (TCBWAKE_T tid) =>
          match cused (ZMap.get tid (AC adt)) with
          | true =>
            Some (adt {big_log: BigDef l'}, 1)
          | _ => None
          end
        | Some (TCBWAKE tid cpu') =>
          let e' := TBSHARED (BTDWAKE_DIFF (ZMap.get (CPU_ID adt) (cid adt)) cv tid cpu') in
          let l'' := (TBEVENT me e') :: l' in
          match B_CalTCB_log_real l'',
              ZMap.get (msg_q_id cpu' + ID_AT_range) (lock adt),
              cused (ZMap.get tid (AC adt)) with
          | Some _, LockFalse, true =>
            Some (adt {big_log: BigDef l''}, 1)
          | _,_,_ => None
          end
        | _ => None
        end
      | _, _ => None
      end
    else None
  | _ => None
  end.
