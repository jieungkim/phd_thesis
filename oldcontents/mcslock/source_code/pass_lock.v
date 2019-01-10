Definition mcs_pass_lock_spec (index ofs:Z) (adt: RData) : option RData :=
  match (ikern adt, ihost adt, index2Z index ofs) with
    | (true, true, Some abid) =>
      match ZMap.get abid (multi_log adt) with
        | MultiDef l =>
          (* cas operation from here *)
          let cpu := CPU_ID adt in
          let to := ZMap.get abid (multi_oracle adt) in
          let l1 := (to cpu l) ++ l in
          match CalMCSLock l1 with
            | Some (MCSLOCK old_tail _ tq) =>
              if zeq old_tail cpu
              then (* We can release the lock without waiting *)
                let l' := (TEVENT cpu (TTICKET (CAS_TAIL true))) :: l1 in
                Some (adt {multi_log: ZMap.set abid (MultiDef l') (multi_log adt)})
              else (* We need to wait until someone sets our next pointer, then assign the busy field. *)
                let l2 := (TEVENT cpu (TTICKET (CAS_TAIL false))) :: l1 in
                match CalMCS_RelWait CalPassLockLoopTime cpu l2 to with
                  | Some l3 =>
                    match CalMCSLock l3 with
                      | Some _ => Some (adt {multi_log: ZMap.set abid (MultiDef l3) (multi_log adt)})
                      | _ => None
                    end
                  | _ => None
                end
            | _ => None
          end
        | _ => None
      end
    | _ => None
  end.