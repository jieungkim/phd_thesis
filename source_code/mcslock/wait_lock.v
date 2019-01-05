Definition mcs_wait_lock_spec (bound index ofs :Z) (adt: RData) : option RData :=
  match (ikern adt, ihost adt, index2Z index ofs) with
    | (true, true, Some abid) =>
      match ZMap.get abid (multi_log adt) with
        | MultiDef l =>
          let cpu := (CPU_ID adt) in
          let to := ZMap.get abid (multi_oracle adt) in
          let l1 := (to cpu l) ++ l in
          match CalMCSLock l1 with
            | Some (MCSLOCK prev_tail la tq) =>
              if zeq prev_tail NULL
              then let l2 := (TEVENT cpu (TTICKET (SWAP_TAIL (nat_of_Z bound) true))) :: l1 in
                   Some adt {multi_log: ZMap.set abid (MultiDef l2) (multi_log adt)}
              else
                let l2 := (TEVENT cpu (TTICKET (SWAP_TAIL (nat_of_Z bound) false))) :: l1 in
                let l3 := (to cpu l2) ++ l2 in
                let l4 := (TEVENT cpu (TTICKET (SET_NEXT prev_tail)))::l3 in
                match CalMCS_AcqWait (CalWaitLockTime tq) cpu l4 to with
                  | Some l5 => Some adt {multi_log: ZMap.set abid (MultiDef l5) (multi_log adt)}
                  | _ => None
                end
            | _ => None
          end
        | _ => None
      end
    | _ => None
  end.